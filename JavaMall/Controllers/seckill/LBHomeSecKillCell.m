//
//  LBHomeSecKillCell.m
//  yingXiongReNv
//
//  Created by 斌  李 on 2016/10/19.
//  Copyright © 2016年 李斌. All rights reserved.
//

#import "LBHomeSecKillCell.h"
#import "GoodsViewController.h"
#import "AudioToolbox/AudioToolbox.h"
#import <EventKit/EventKit.h>
#import "LBSecLineLable.h"
#import "AdaptationKit.h"
#import "View+MASAdditions.h"
#import "UIImageView+EMWebCache.h"
#import "Goods.h"

@interface LBHomeSecKillCell ()<UIAlertViewDelegate>
@property(nonatomic,weak) UIImageView * iconImage;
@property(nonatomic,weak) UIImageView * timeBackImage;
@property(nonatomic,weak) UILabel * timeLab;
@property(nonatomic,weak) UILabel *dayNameLab;
@property(nonatomic,weak) UILabel *colonLab;
@property(nonatomic,weak) UILabel *colon1Lab;
@property(nonatomic,weak) UILabel * dayLab;
@property(nonatomic,weak) UILabel * hourLab;
@property(nonatomic,weak) UILabel * minuteLab;
@property(nonatomic,weak) UILabel * secondLab;
@property(nonatomic,weak) UILabel * nameLab;
@property(nonatomic,weak) UILabel * priceLab;
@property(nonatomic,strong) LBSecLineLable * grayPriceLab;
@property(nonatomic,weak) UILabel * numBuyLab;
@property(nonatomic,weak) UIButton * stateBtn;
@property(nonatomic,weak) UIView *grayView;
@property(nonatomic,weak) NSDate *beginDate;
@property(nonatomic,weak) NSDate *endDate;

@property(nonatomic,assign) NSInteger day;
@property(nonatomic,assign) NSInteger hour;
@property(nonatomic,assign) NSInteger minute;
@property(nonatomic,assign) NSInteger second;

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,copy) NSString *idf;
@property(nonatomic,copy) NSString *productId;
@property(nonatomic,copy) NSString *productID;
@property(nonatomic,copy) NSString *firstImageStr;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) EKEventStore *eventStore;
/*通过NSDateComponents可以快速而简单地获取某个时间点对应的“年”，“月”，“日”，“时”，“分”，“秒”，“周”等信息*/
@property(nonatomic,strong) NSDateComponents *beginAndEnd;//开始结束之间的间距


@end
#define KMargin [AdaptationKit getHorizontalSpace:10]
#define KWidthHeight [AdaptationKit getHorizontalSpace:40]
@implementation LBHomeSecKillCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.setRemindStatus = 1;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.iconImage=image;
        
        
        //倒计时背景
        UIImageView *timeBackImage = [[UIImageView alloc] init];
        timeBackImage.backgroundColor = LBColor(32, 32, 32);
        timeBackImage.layer.borderWidth=0.5;
        timeBackImage.layer.borderColor=[UIColor whiteColor].CGColor;
        timeBackImage.layer.cornerRadius=2.5;
        timeBackImage.layer.masksToBounds=YES;
        [self.contentView addSubview:timeBackImage];
        self.timeBackImage=timeBackImage;
        //距开始
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.font = LBFont(25);
        timeLab.textColor = [UIColor whiteColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        [timeBackImage addSubview:timeLab];
        self.timeLab=timeLab;
        //天字
        UILabel *dayNameLab = [[UILabel alloc] init];
        dayNameLab.font = LBFont(20);
        dayNameLab.text = @"天";
        dayNameLab.textColor = [UIColor whiteColor];
        dayNameLab.textAlignment = NSTextAlignmentCenter;
        [timeBackImage addSubview:dayNameLab];
        self.dayNameLab=dayNameLab;
        //冒号
        UILabel *colonLab = [[UILabel alloc] init];
        colonLab.font = LBFont(25);
        colonLab.text = @":";
        colonLab.textColor = [UIColor whiteColor];
        colonLab.textAlignment = NSTextAlignmentCenter;
        [timeBackImage addSubview:colonLab];
        self.colonLab=colonLab;
        //冒号
        UILabel *colon1Lab = [[UILabel alloc] init];
        colon1Lab.font = LBFont(25);
        colon1Lab.text = @":";
        colon1Lab.textColor = [UIColor whiteColor];
        colon1Lab.textAlignment = NSTextAlignmentCenter;
        [timeBackImage addSubview:colon1Lab];
        self.colon1Lab=colon1Lab;
        //天
        UILabel *dayLab = [[UILabel alloc] init];
        dayLab.font = LBFont(22);
        dayLab.textColor = [UIColor blackColor];
        dayLab.backgroundColor = [UIColor whiteColor];
        dayLab.textAlignment=NSTextAlignmentCenter;
        dayLab.layer.cornerRadius=2.5;
        dayLab.layer.masksToBounds=YES;
        [timeBackImage addSubview:dayLab];
        self.dayLab=dayLab;
        //时
        UILabel *hourLab = [[UILabel alloc] init];
        hourLab.font = LBFont(22);
        hourLab.textColor = [UIColor blackColor];
        hourLab.backgroundColor = [UIColor whiteColor];
        hourLab.textAlignment=NSTextAlignmentCenter;
        hourLab.layer.cornerRadius=2.5;
        hourLab.layer.masksToBounds=YES;
        [timeBackImage addSubview:hourLab];
        self.hourLab=hourLab;
        //分
        UILabel *minuteLab = [[UILabel alloc] init];
        minuteLab.font = LBFont(22);
        minuteLab.textColor = [UIColor blackColor];
        minuteLab.backgroundColor = [UIColor whiteColor];
        minuteLab.textAlignment=NSTextAlignmentCenter;
        minuteLab.layer.cornerRadius=2.5;
        minuteLab.layer.masksToBounds=YES;
        [timeBackImage addSubview:minuteLab];
        self.minuteLab=minuteLab;
        //秒
        UILabel *secondLab = [[UILabel alloc] init];
        secondLab.font = LBFont(22);
        secondLab.textColor = [UIColor blackColor];
        secondLab.backgroundColor = [UIColor whiteColor];
        secondLab.textAlignment=NSTextAlignmentCenter;
        secondLab.layer.cornerRadius=2.5;
        secondLab.layer.masksToBounds=YES;
        [timeBackImage addSubview:secondLab];
        self.secondLab=secondLab;
        
        // 标题
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.font = LBFont(30);
        nameLab.numberOfLines=2;
        [self.contentView addSubview:nameLab];
        self.nameLab=nameLab;
        
        // 价格
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.font = LBFont(36);
        priceLab.textColor=LBColor(219, 34, 35);
        [self.contentView addSubview:priceLab];
        self.priceLab=priceLab;
        
        // 灰价
        self.grayPriceLab = [[LBSecLineLable alloc] init];
        self.grayPriceLab.font = LBFont(24);
        self.grayPriceLab.textColor=[UIColor grayColor];
        [self.contentView addSubview:self.grayPriceLab];
        
        // 去秒杀
        UIButton *stateBtn = [[UIButton alloc] init];
        stateBtn.hidden = YES;
        [stateBtn setBackgroundColor:LBColor(32, 32, 32)];
        stateBtn.titleLabel.font=LBFont(24);
        stateBtn.layer.cornerRadius=2.5;
        stateBtn.layer.masksToBounds=YES;
        stateBtn.layer.borderWidth = 1;
        stateBtn.layer.borderColor = LBColor(32, 32, 32).CGColor;
        [stateBtn setTitle:@"去查看" forState:UIControlStateNormal];
        [stateBtn setBackgroundColor:LBColor(32, 32, 32)];
        self.stateBtn=stateBtn;
        [stateBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:stateBtn];
    
        // 已秒件数
        UILabel *numBuyLab = [[UILabel alloc] init];
        numBuyLab.font =LBFont(24);
        numBuyLab.textAlignment=NSTextAlignmentRight;
        numBuyLab.textColor=LBColor(153, 153, 153);
        [self.contentView addSubview:numBuyLab];
        self.numBuyLab=numBuyLab;
        
        UIView *grayView = [[UIView alloc]init];
        grayView.backgroundColor = LBColor(240, 240, 240);
        [self.contentView addSubview:grayView];
        _grayView = grayView;
        
        
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeSound |  UIUserNotificationTypeAlert  categories:nil];
        
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
        
        [self layout];
    }

    return self;
}

- (void)layout{

    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.equalTo(self.contentView);
        make.height.mas_equalTo([AdaptationKit getVerticalSpace:400]);
    }];
    
    [self.timeBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage).offset(KMargin);
        make.bottom.equalTo(self.iconImage.mas_bottom).offset( -KMargin);
        make.height.equalTo(@([AdaptationKit getVerticalSpace:60]));
        make.width.equalTo(@([AdaptationKit getHorizontalSpace:315]));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeBackImage.mas_centerY);
        make.left.equalTo(self.timeBackImage.mas_left).offset(KMargin);
        make.width.mas_equalTo([AdaptationKit getHorizontalSpace:80]);
    }];
    
    [self.dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab.mas_right).offset(KMargin);
        make.centerY.equalTo(self.timeLab.mas_centerY);
        make.width.height.equalTo(@(KWidthHeight));
    }];
    
    [self.hourLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(KWidthHeight);
        make.centerY.equalTo(self.timeBackImage.mas_centerY);
        make.left.equalTo(self.dayLab.mas_right).offset(KMargin * 2 + [AdaptationKit getHorizontalSpace:5]);
    }];
    
    //天字
    [self.dayNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLab.mas_right);
        make.centerY.equalTo(self.dayLab.mas_centerY);
        make.right.equalTo(self.hourLab.mas_left);
    }];
    
    [self.minuteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(KWidthHeight);
        make.centerY.equalTo(self.timeBackImage.mas_centerY);
        make.left.equalTo(self.hourLab.mas_right).offset(KMargin);
    }];
    //冒号
    [self.colonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLab.mas_right);
        make.right.equalTo(self.minuteLab.mas_left);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(KWidthHeight);
        make.centerY.equalTo(self.timeBackImage.mas_centerY);
        make.left.equalTo(self.minuteLab.mas_right).offset(KMargin);
    }];
    //冒号
    [self.colon1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLab.mas_right);
        make.right.equalTo(self.secondLab.mas_left);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];

   [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView.mas_left).offset([AdaptationKit getHorizontalSpace:30]);
       make.top.equalTo(self.iconImage.mas_bottom).offset([AdaptationKit getHorizontalSpace:20]);
       make.width.mas_equalTo([AdaptationKit getHorizontalSpace:480]);
       
   }];
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset([AdaptationKit getHorizontalSpace:-30]);
        make.width.mas_equalTo([AdaptationKit getHorizontalSpace:136]);
        make.height.mas_equalTo([AdaptationKit getVerticalSpace:56]);
        make.top.equalTo(self.iconImage.mas_bottom).offset([AdaptationKit getVerticalSpace:50]);
    }];
    
    [self.numBuyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset([AdaptationKit getHorizontalSpace:-30]);
        make.top.equalTo(self.stateBtn.mas_bottom).offset([AdaptationKit getVerticalSpace:15]);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.bottom.equalTo(self.numBuyLab.mas_bottom).offset([AdaptationKit getVerticalSpace:10]);
    }];
    
    [self.grayPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab.mas_right).offset(KMargin);
        make.bottom.equalTo(self.priceLab.mas_bottom).offset([AdaptationKit getVerticalSpace:-3.5]);
    }];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@([AdaptationKit getVerticalSpace:20]));
    }];
    
}

#pragma mark - 创建定时器
-(void)setUPTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timekeeper) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

#pragma mark - 关闭定时器
-(void)stopTimer{
    [self.timer invalidate];
    self.timer=nil;
}

#pragma mark - 定时器运行机制
-(void)timekeeper{

    //还剩几秒
    if (self.second>0) {
        
        self.second--;
        self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
        
    }else{
        
        //还剩几分
        if (self.minute>0) {//当秒数变为00执行
            self.minute--;
            self.second=59;
            self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
            self.minuteLab.text=[NSString stringWithFormat:@"%02zd",self.minute];
            
        }else{
            
            //还剩几个小时
            if (self.hour>0) {//当分钟数变为00执行
                self.hour--;
                self.second=59;
                self.minute=59;
                self.hourLab.text=[NSString stringWithFormat:@"%02zd",self.hour];
                self.minuteLab.text=[NSString stringWithFormat:@"%02zd",self.minute];
                self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
     
            }else{
                
                if (self.day>0) {
                    self.day--;
                    self.hour = 23;
                    self.second = 59;
                    self.minute = 59;
                    self.dayLab.text = [NSString stringWithFormat:@"%02zd",self.day];
                    self.hourLab.text=[NSString stringWithFormat:@"%02zd",self.hour];
                    self.minuteLab.text=[NSString stringWithFormat:@"%02zd",self.minute];
                    self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
                }else {
                    
                    if ([self.timeLab.text isEqualToString:@"距开始"]) {
//                        [self.stateBtn setTitle:@"去秒杀" forState:UIControlStateNormal];
//                        self.stateBtn.backgroundColor = LBColor(32, 32, 32);
                        self.timeLab.text=@"距结束";
                        
                        self.day = self.beginAndEnd.day;
                        self.hour=self.beginAndEnd.hour;
                        self.minute=self.beginAndEnd.minute;
                        self.second = self.beginAndEnd.second;
                        
                        self.dayLab.text = [NSString stringWithFormat:@"%02zd",self.day];
                        self.hourLab.text=[NSString stringWithFormat:@"%02zd",self.hour];
                        self.minuteLab.text=[NSString stringWithFormat:@"%02zd",self.minute];
                        self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
                        
                    }else{
                        
                        [self stopTimer];
//                        [self.stateBtn setTitle:@"去查看" forState:UIControlStateNormal];
//                        [self.stateBtn setBackgroundColor:LBColor(32, 32, 32)];
                        self.timeLab.text=@"已结束";
                        
                    }
                
                }
                
            }
        
        }

    }

}

#pragma mark - 提醒推送
- (void)getNetDataAdd {
    
//    SingleTon *sing = [SingleTon shareInstance];
//    NSString *tuisongToken=[[NSUserDefaults standardUserDefaults]objectForKey:@"gettoken"];
//    NSDictionary *dic = @{
//                          @"device_Token" : tuisongToken,
//                          @"equipment" : @"app",
//                          @"type" : @"ios",
//                          @"goodsid" : self.goodsId,
//                          @"username" : sing.member
//                          };
//    NSLog(@"%@",dic);
//    [[NetworkSingleton sharedManager] getResultWithParameter:dic url:@"http://weixin.gknetmall.com/api/pushMessage/save.jhtml" successBlock:^(id responseBody) {
//        NSLog(@"请求成功--%@",responseBody);
//
//        self.setRemindStatus = [responseBody[@"num"] integerValue];
//        if (self.refreshTableVlewFromLBHomeSecKillCell) {
//            self.refreshTableVlewFromLBHomeSecKillCell();
//        }
//
//    } failureBlock:^(NSString *error) {
//
//    }];

}

- (void)getNetDataCancel {
    
//    SingleTon *sing = [SingleTon shareInstance];
//    NSDictionary *dic = @{
//                          @"goodsid" : self.goodsId,
//                          @"username" : sing.member
//                          };
//    [[NetworkSingleton sharedManager] getResultWithParameter:dic url:@"http://weixin.gknetmall.com/api/pushMessage/delete.jhtml" successBlock:^(id responseBody) {
//        NSLog(@"请求成功--%@",responseBody);
//
//        self.setRemindStatus = [responseBody[@"num"] integerValue];
//        if (self.refreshTableVlewFromLBHomeSecKillCell) {
//            self.refreshTableVlewFromLBHomeSecKillCell();
//        }
//
//    } failureBlock:^(NSString *error) {
//        NSLog(@"请求失败--%@",error);
//
//    }];
}

#pragma mark - 赋值
- (void)configData:(Goods *)model{
    
    [self stopTimer];
    
    self.goodsId = [NSString stringWithFormat:@"%zd",model.goods_id];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
    
//    _firstImageStr = dic[@"image"];
    
    self.nameLab.text=model.name;
    
    // 设置lab的行距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.nameLab.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[AdaptationKit getVerticalSpace:10]];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.nameLab.text length])];
    self.nameLab.attributedText = attributedString;
    
    
    NSString *priceStr =[NSString stringWithFormat:@"¥%.02f",model.price];
    NSMutableAttributedString *priceLabAttributM = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [priceLabAttributM addAttributes:@{
                                       NSFontAttributeName:[UIFont systemFontOfSize:14]
                                       } range:NSMakeRange(0, 1)];
    
    self.priceLab.attributedText=priceLabAttributM;
    
    NSString *grayPriceStr =[NSString stringWithFormat:@"¥%.02f",model.seckill_price];
    self.grayPriceLab.text=grayPriceStr;
    [self.grayPriceLab sizeToFit];
    
    self.numBuyLab.text=[NSString stringWithFormat:@"剩余%zd件",model.enable_store];
    
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSDate *beginDate=[NSDate dateWithTimeIntervalSince1970:model.start_time];
    _beginDate =beginDate;
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:model.end_time];
    _endDate =endDate;
    
    NSString *beginDateStr=[dateFor stringFromDate:beginDate];
    NSString *endDateStr=[dateFor stringFromDate:endDate];
    NSString *currentDateStr = [self getCurrentTimeStr:dateFor];
    
//    NSString *currentDateStr = @"2017-11-26 18:12:00";
//    NSString *beginDateStr=@"2017-11-26 18:00:00";
//    NSString *endDateStr=@"2017-11-26 20:00:00";
    
    NSDate *currentDate = [dateFor dateFromString:currentDateStr];
    NSComparisonResult beginResult = [currentDate compare:beginDate];
    NSComparisonResult endResult = [currentDate compare:endDate];
    
    NSDate *fromDate =[[NSDate alloc] init];
    NSDate *toDate =[[NSDate alloc] init];
    if (beginResult==NSOrderedAscending) {
        
        self.timeLab.text=@"距开始";
        fromDate=currentDate;
        toDate=beginDate;
    }else{
        
        if (endResult==NSOrderedAscending) {
            self.timeLab.text=@"距结束";
            fromDate=currentDate;
            toDate=endDate;
            
        } else {
            self.timeLab.text=@"已结束";
            _dayLab.text = @"00";
            self.hourLab.text=@"00";
            self.minuteLab.text=@"00";
            self.secondLab.text=@"00";
        }
    }
    
    //获取时间的某个元素
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    self.day = cmps.day;
    self.hour=cmps.hour;
    self.minute=cmps.minute;
    self.second = cmps.second;
    for (int i = 0; i < 12; i++) {
        if (cmps.month == i) {
            self.day = self.day + 30 * i;
            self.dayLab.text=[NSString stringWithFormat:@"%02zd",self.day];
        }
    }
    if (cmps.month == 0 && cmps.day == 0) {
        self.dayLab.hidden = YES;
        self.dayNameLab.hidden = YES;
        [self.timeBackImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([AdaptationKit getHorizontalSpace:250]));
        }];
        [self.hourLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLab.mas_right).offset(KMargin);
        }];
    }else {
        self.dayLab.hidden = NO;
        self.dayNameLab.hidden = NO;
        [self.timeBackImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([AdaptationKit getHorizontalSpace:315]));
        }];
        [self.hourLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLab.mas_right).offset(KMargin * 2 + [AdaptationKit getHorizontalSpace:5]);
        }];
    }
    self.hourLab.text=[NSString stringWithFormat:@"%02zd",self.hour];
    self.minuteLab.text=[NSString stringWithFormat:@"%02zd",self.minute];
    self.secondLab.text=[NSString stringWithFormat:@"%02zd",self.second];
    
    self.beginAndEnd = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
    
    [self setUPTimer];
}

- (NSString *)getCurrentTimeStr:(NSDateFormatter *)formatter {
    NSDate *dateNow = [NSDate date];
    return [formatter stringFromDate:dateNow];
}

#pragma mark - target事件
- (void)btnClicked:(UIButton *)sender {
//    if ([sender.titleLabel.text isEqualToString:@"去秒杀"]) {
//        [self pushSureOrderVC];
//    }
    
    if ([sender.titleLabel.text isEqualToString:@"去查看"]) {
//        LBShopingDetailVC *detailVC = [[LBShopingDetailVC alloc]init];
//        detailVC.goodsId = self.goodsId;
//        detailVC.imageStr = _firstImageStr;
//        detailVC.btnTitle = sender.titleLabel.text;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        [self.obj.navigationController pushViewController:detailVC animated:YES];
    }
    
//    if ([sender.titleLabel.text isEqualToString:@"设置提醒"]) {
//        SingleTon *sing = [SingleTon shareInstance];
//        if (![sing.isLoginStr isEqualToString:@"1"]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先确认登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//
//        [self getNetDataAdd];
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"将在开抢前3分钟提醒" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//
//    }else if ([sender.titleLabel.text isEqualToString:@"取消提醒"]) {
//
//        [self getNetDataCancel];
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"秒杀提醒已取消,您可能抢不到吆~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//
//    }
}

#pragma mark - 立即秒杀
- (void)pushSureOrderVC {
    
//        // 1先将秒杀产品添加到购物车
//        SingleTon *sing = [SingleTon shareInstance];
//        if (![sing.isLoginStr isEqualToString:@"1"]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            [alertView show];
//            return;
//        }
//
//
//        // 清空购物车秒杀商品
//        NSDictionary *dict = @{
//                               @"username" : sing.member
//                               };
//        NSString * urlStr=@"http://weixin.gknetmall.com/api/seckill/cleanCat.jhtml";
//        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        [manager GET:urlStr parameters: dict progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
//            [self getCarListData];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",[error localizedDescription]);
//        }];
    
    
}

- (void)getCarListData {
//    SingleTon *sing = [SingleTon shareInstance];
//    NSDictionary *dic = @{
//                          @"token" : sing.tokenStr,
//                          @"username" : sing.member,
//                          @"quantity" : @"1",
//                          @"productId" : self.productId
//                          };
//    // 转菊花
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [[NetworkSingleton sharedManager] postResultWithParameter:dic url:@"http://weixin.gknetmall.com/api/seckill/goospurchase.jhtml" successBlock:^(id responseBody) {
//        NSLog(@"请求成功--%@",responseBody);
//        NSDictionary *dic = (NSDictionary *)responseBody;
//        _productID = dic[@"cartid"];
//
//        if ([dic[@"num"] isEqualToString:@"1"]) {
//            [WKProgressHUD popMessage:dic[@"smg"] inView:LBKeyWindow duration:1.0 animated:YES];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            return ;
//        }else {
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            // 2再跳到确认订单
//            LBSureOrderVC *sureOrderVC = [[LBSureOrderVC alloc]init];
//            sureOrderVC.pidStr = _productID;
//            sureOrderVC.whereGoodsid = @"1";
//            sureOrderVC.hidesBottomBarWhenPushed = YES;
//            [self.obj.navigationController pushViewController:sureOrderVC animated:YES];
//        }
//
//    } failureBlock:^(NSString *error) {
//        [WKProgressHUD popMessage:@"加入购物车失败" inView:LBKeyWindow duration:1.0 animated:YES];
//        NSLog(@"请求失败--%@",error);
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    }];

}

#pragma mark -  添加事件到日历
-(void)saveEvent
{
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])//请求使用用户的日历数据库
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else if (!granted)//!granted:!允许
                {
                    //被用户拒绝，不允许访问日历
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"被用户拒绝，不允许访问日历" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else
                {
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title  = @"秒杀:订阅商品即将抢购";//在系统日历显示的标题
                    //                    event.location = @"北京海淀";//当前位置
                    
                    //06.07 时间格式
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setAMSymbol:@"AM"];
                    [dateFormatter setPMSymbol:@"PM"];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mmaaa"];//2016/10/26 04:46PM
                    NSDate *date = [NSDate date];//是你希望跳到的日期
                    NSString * s = [dateFormatter stringFromDate:date];
                    NSLog(@"%@",s);
                    
                    //开抢时间
                    event.startDate = [self.beginDate dateByAddingTimeInterval:0];
                    //结束时间
                    event.endDate   = [self.endDate dateByAddingTimeInterval:0];
                    //提醒时间
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -3.0f]];
                    //06.07 add 事件类容备注
                    
                    
                    NSString * str = @"接受信息类容备注";
                    event.notes = [NSString stringWithFormat:@"%@",str];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    //直接杀死进程
                    //                    exit(2);
                    
                }
            });
        }];
    }

    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"calshow:"]];//跳进日历
}

#pragma mark - alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
//        LoginViewController *loginVC = [[LoginViewController alloc]init];
//        [self.obj presentViewController:loginVC animated:YES completion:nil];
    }
}

@end



