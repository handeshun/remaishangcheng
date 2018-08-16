//
//  AdViewController.m
//  JavaMall
//
//  Created by Dawei on 7/20/15.
//  Copyright (c) 2015 Enation. All rights reserved.
//

#import "AdViewController.h"
#import "UIImageView+WebCache.h"
#import "AdApi.h"
#import "Ad.h"
#import "RootTabViewController.h"
#import "BaseNavigationController.h"
@interface AdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *adImage;
- (IBAction)skip:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipbtn;
@property (weak, nonatomic) IBOutlet UIView *skip;
@property (weak, nonatomic) IBOutlet UIButton *skipbtns;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAd];
    _skip.layer.cornerRadius = 5;
    
}

/**
 *  载入广告信息
 */
- (void) loadAd{
    AdApi *adApi = [AdApi new];
    [adApi detail:1 success:^(Ad *ad) {
        [self loadImage:ad.image];
       
    } failure:^(NSError *error) {
        [self skip:nil];
    }];
   
}

/**
 *  载入图片
 *
 *  @param url 图片网址
 */
- (void) loadImage:(NSString *) url{
    [self.adImage sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:nil
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               [self performSelector:@selector(skip:) withObject:nil afterDelay:3];
                           }];
    self.adImage.frame =self.view.bounds;
    self.adImage.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)skip:(id)sender {
//    [self presentViewController:[super controllerFromMainStroryBoard:@"Main"] animated:YES completion:nil];
       RootTabViewController *rootTabViewController = [[RootTabViewController alloc] init];
    UINavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:rootTabViewController];
//    [self.window setRootViewController:navigationController];
    [UIApplication sharedApplication].keyWindow.rootViewController =navigationController;
  //  [self presentViewController:rootTabViewController animated:YES completion:nil];
}
@end
