//
// Created by Dawei on 5/15/16.
// Copyright (c) 2016 Enation. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"
#import "ScanerView.h"
#import "HeaderView.h"
#import "ESButton.h"
#import "ControllerHelper.h"
#import "GoodsApi.h"
#import "GoodsDetailViewController.h"//TM这是个假详情界面
#import "GoodsViewController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

//! 扫码区域动画视图
@property(strong, nonatomic) ScanerView *scanerView;

//AVFoundation
//! AV协调器
@property(strong, nonatomic) AVCaptureSession *session;
//! 取景视图
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property(assign, nonatomic) NSInteger sn;

@end

@implementation ScanViewController {
    HeaderView *headerView;
    GoodsApi *goodsApi;
    BOOL initCompleted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    self.scanerView = [[ScanerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self.view addSubview:self.scanerView];

    headerView = [[HeaderView alloc] initWithTitle:@"条形码/二维码"];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.titleLbl.textColor = [UIColor whiteColor];
    headerView.lineLayer.backgroundColor = [UIColor clearColor].CGColor;

    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 18, 44, 44)];
    [cancelBtn setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
    [cancelBtn setContentMode:UIViewContentModeCenter];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelBtn];

    [self.view addSubview:headerView];

    self.scanerView.alpha = 0;
    //设置扫描区域边长
    self.scanerView.scanAreaEdgeLength = [[UIScreen mainScreen] bounds].size.width - 2 * 50;

    if (!self.session) {

        //添加镜头盖开启动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.type = @"cameraIrisHollowOpen";
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        animation.delegate = self;
        [self.view.layer addAnimation:animation forKey:@"animation"];

        //初始化扫码
        [self setupAVFoundation];

        self.scanerView.alpha = 1;

        //调整摄像头取景区域
        CGRect rect = self.view.bounds;
        rect.origin.y = 0;
        self.previewLayer.frame = rect;
    }
}

/**
 * 设置StatusBar颜色为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.session != nil && ![self.session isRunning] && initCompleted){
        [self.session startRunning];
    }
}

//! 动画结束回调
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.scanerView.alpha = 1;
                     }];
}

//! 初始化扫码
- (void)setupAVFoundation {
    //创建会话
    self.session = [[AVCaptureSession alloc] init];

    //获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;

    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

    if (input) {
        [self.session addInput:input];
    } else {
        //出错处理
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"请在手机【设置】-【隐私】-【相机】选项中，允许【%@】访问您的相机", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
        initCompleted = NO;
        return;
    }

    initCompleted = YES;

    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:output];

    //设置扫码类型
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,//二维码
            AVMetadataObjectTypeEAN13Code,//条形码
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode128Code];
  //  output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    //设置代理，在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    //创建摄像头取景区域
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    if ([self.previewLayer connection].isVideoOrientationSupported)
        [self.previewLayer connection].videoOrientation = AVCaptureVideoOrientationPortrait;

    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *_Nonnull note) {
                                                      if (weakSelf) {
                                                          //调整扫描区域
                                                          AVCaptureMetadataOutput *output = weakSelf.session.outputs.firstObject;
                                                          output.rectOfInterest = [weakSelf.previewLayer metadataOutputRectOfInterestForRect:weakSelf.scanerView.scanAreaRect];
                                                      }
                                                  }];
    //开始扫码
    [self.session startRunning];
    
    
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataMachineReadableCodeObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self.session stopRunning];

            if(metadata.stringValue != nil && [metadata.stringValue hasPrefix:QRCODE_PREFIX]){
                NSString *idString = [metadata.stringValue stringByReplacingOccurrencesOfString:@"javashop://" withString:@""];
                if(idString != nil && idString.length > 0){
                    NSInteger goodsId = [idString intValue];
                    if(goodsId > 0){
                        [self.navigationController pushViewController:[ControllerHelper createGoodsViewControllerWithId:goodsId] animated:YES];
                        return;
                    }
                }
            }

            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"二维码"
                                                         message:@"二维码错误,请扫描网站上的二维码!"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];

            break;
        } else {
            [self.session stopRunning];

            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"条形码"
                                                         message:@"是否查看商品详情"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定",nil];
            [av show];
            
            self.sn = [metadata.stringValue integerValue];

            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqualToString:@"提醒"]){
        [self cancel];
        return;
    }
    if(self.session != nil && ![self.session isRunning]){
        [self.session startRunning];
    }
    
    if([alertView.title isEqualToString:@"条形码"]){
        if (buttonIndex == 0) {
            [self cancel];
            return;
        }
        if (buttonIndex == 1) {
            [self bySNgetGoodid:self.sn];
            return;
        }
    }
}

- (void)bySNgetGoodid:(NSInteger)sn {

    goodsApi = [GoodsApi new];
    [goodsApi bySNgetGoodid:sn success:^(Goods *goods) {
        GoodsViewController *goodsViewController = [GoodsViewController new];
        goodsViewController.goods = goods;
        [self.navigationController pushViewController:goodsViewController animated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
