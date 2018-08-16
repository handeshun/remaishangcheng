//
//  LeftTimeTableViewCell.m
//  JavaMall
//
//  Created by Cheerue on 2017/11/26.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import "LeftTimeTableViewCell.h"
#import "Activity.h"
#import "ActivityGift.h"
#import "ESLabel.h"
#import "Masonry.h"
#import "Goods.h"
#import "UIView+Common.h"
#import "AdaptationKit.h"
#define KMargin [AdaptationKit getHorizontalSpace:10]
#define KWidthHeight [AdaptationKit getHorizontalSpace:40]

@interface LeftTimeTableViewCell()
@end

@implementation LeftTimeTableViewCell

{
    ESLabel *titleLabel;
    UILabel  *timeLab;
    
    
    UILabel * dayLab;
    UILabel * hourLab;
    UILabel * minuteLab;
    UILabel * secondLab;
    
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
    NSTimer *timer;
    NSDate *beginDate;
    NSDate *endDate;
    NSDateComponents *beginAndEnd;//开始结束之间的间距
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        titleLabel = [[ESLabel alloc] initWithText:@"剩余时间" textColor:[UIColor darkGrayColor] fontSize:15];
        [self addSubview:titleLabel];
        
        timeLab = [[UILabel alloc]init];
        timeLab.textAlignment = NSTextAlignmentRight;
        timeLab.textColor = [UIColor blackColor];
        timeLab.font = LBFont(30);
        [self addSubview:timeLab];
        
       
  
     
        //天
        dayLab = [[UILabel alloc] init];
        dayLab.font = LBFont(30);
        dayLab.textColor = [UIColor blackColor];
        dayLab.backgroundColor = [UIColor whiteColor];
        dayLab.textAlignment=NSTextAlignmentCenter;
        dayLab.layer.cornerRadius=2.5;
       
        dayLab.layer.masksToBounds=YES;
        [self addSubview:dayLab];
       
        //时
       hourLab = [[UILabel alloc] init];
        hourLab.font = LBFont(30);
        hourLab.textColor = [UIColor blackColor];
        hourLab.backgroundColor = [UIColor whiteColor];
        hourLab.textAlignment=NSTextAlignmentCenter;
        hourLab.layer.cornerRadius=2.5;
        hourLab.layer.masksToBounds=YES;
        [self.contentView addSubview:hourLab];
       
        //分
       minuteLab = [[UILabel alloc] init];
        minuteLab.font = LBFont(30);
        minuteLab.textColor = [UIColor blackColor];
        minuteLab.backgroundColor = [UIColor whiteColor];
        minuteLab.textAlignment=NSTextAlignmentCenter;
        minuteLab.layer.cornerRadius=2.5;
        minuteLab.layer.masksToBounds=YES;
        [self.contentView addSubview:minuteLab];
       
        //秒
       secondLab = [[UILabel alloc] init];
        secondLab.font = LBFont(30);
        secondLab.textColor = [UIColor blackColor];
        secondLab.backgroundColor = [UIColor whiteColor];
        secondLab.textAlignment=NSTextAlignmentCenter;
        secondLab.layer.cornerRadius=2.5;
        secondLab.layer.masksToBounds=YES;
        [self.contentView addSubview:secondLab];
       
        
       
      
        
      
        
        [secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
         //   make.width.height.mas_equalTo(KWidthHeight);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-KMargin);
        }];
        
        [minuteLab mas_makeConstraints:^(MASConstraintMaker *make) {
          //  make.width.height.mas_equalTo(KWidthHeight);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(secondLab.mas_left).offset(-KMargin);
        }];
        
        [hourLab mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.width.height.mas_equalTo(KWidthHeight);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(minuteLab.mas_left).offset(-KMargin );
        }];
        [dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(hourLab.mas_left).offset(-KMargin);
            make.centerY.equalTo(self.mas_centerY);
          //  make.width.height.equalTo(@(KWidthHeight));
        }];
        
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(dayLab.mas_left).offset(-KMargin);
            make.centerY.equalTo(self);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:kBorderLineColor];
        [self addSubview:line];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
           
        }];
        
      
      
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5f);
            make.left.right.bottom.equalTo(self);
        }];
        
      
    }
    return self;
}

- (void)configData:(Goods *)goods{
    
    [self stopTimer];
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    
    NSDate *beginDates=[NSDate dateWithTimeIntervalSince1970:goods.start_time];
    beginDate =beginDates;
    NSDate *endDates=[NSDate dateWithTimeIntervalSince1970:goods.end_time];
    endDate =endDates;
    
    NSString *beginDateStr=[dateFor stringFromDate:beginDate];
    NSString *endDateStr=[dateFor stringFromDate:endDate];
    NSString *currentDateStr = [self getCurrentTimeStr:dateFor];
    
    
    
    NSDate *currentDate = [dateFor dateFromString:currentDateStr];
    NSComparisonResult beginResult = [currentDate compare:beginDate];
    NSComparisonResult endResult = [currentDate compare:endDate];
    
    NSDate *fromDate =[[NSDate alloc] init];
    NSDate *toDate =[[NSDate alloc] init];
    if (beginResult==NSOrderedAscending) {
        
        timeLab.text=@"距开始";
        fromDate=currentDate;
        toDate=beginDate;
    }else{
        
        if (endResult==NSOrderedAscending) {
            timeLab.text=@"距结束";
            fromDate=currentDate;
            toDate=endDate;
            
        } else {
            timeLab.text=@"已结束";
            dayLab.text = @"00天";
            hourLab.text=@"00时";
            minuteLab.text=@"00分";
            secondLab.text=@"00秒";
        }
    }
    
    //获取时间的某个元素
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    day = cmps.day;
    hour=cmps.hour;
    minute=cmps.minute;
    second = cmps.second;
    for (int i = 0; i < 12; i++) {
        if (cmps.month == i) {
            day = day + 30 * i;
            dayLab.text=[NSString stringWithFormat:@"%02zd天",day];
        }
    }
   
    hourLab.text=[NSString stringWithFormat:@"%02zd时",hour];
    minuteLab.text=[NSString stringWithFormat:@"%02zd分",minute];
    secondLab.text=[NSString stringWithFormat:@"%02zd秒",second];

    beginAndEnd = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
    
    [self setUPTimer];
    
}

+ (CGFloat)cellHeightWithObj:(Activity *)activity{
    
    return 50;
}



#pragma mark - 创建定时器
-(void)setUPTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timekeeper) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

#pragma mark - 关闭定时器
-(void)stopTimer{
    [timer invalidate];
    timer=nil;
}

#pragma mark - 定时器运行机制
-(void)timekeeper{
    
    //还剩几秒
    if (second>0) {
        
        second--;
        secondLab.text=[NSString stringWithFormat:@"%02zd秒",second];
        
    }else{
        
        //还剩几分
        if (minute>0) {//当秒数变为00执行
            minute--;
            second=59;
            secondLab.text=[NSString stringWithFormat:@"%02zd分",second];
            minuteLab.text=[NSString stringWithFormat:@"%02zd秒",minute];
            
        }else{
            
            //还剩几个小时
            if (hour>0) {//当分钟数变为00执行
                hour--;
                second=59;
                minute=59;
                hourLab.text=[NSString stringWithFormat:@"%02zd时",hour];
                minuteLab.text=[NSString stringWithFormat:@"%02zd分",minute];
                secondLab.text=[NSString stringWithFormat:@"%02zd秒",second];
                
            }else{
                
                if (day>0) {
                    day--;
                    hour = 23;
                    second = 59;
                    minute = 59;
                    dayLab.text = [NSString stringWithFormat:@"%02zd日",day];
                    hourLab.text=[NSString stringWithFormat:@"%02zd时",hour];
                    minuteLab.text=[NSString stringWithFormat:@"%02zd分",minute];
                    secondLab.text=[NSString stringWithFormat:@"%02zd秒",second];
                }else {
                    
                    if ([timeLab.text isEqualToString:@"距开始"]) {
                        //                        [self.stateBtn setTitle:@"去秒杀" forState:UIControlStateNormal];
                        //                        self.stateBtn.backgroundColor = LBColor(32, 32, 32);
                        timeLab.text=@"距结束";
                        
                       day = beginAndEnd.day;
                        hour=beginAndEnd.hour;
                        minute=beginAndEnd.minute;
                        second = beginAndEnd.second;
                        
                        dayLab.text = [NSString stringWithFormat:@"%02zd日",day];
                        hourLab.text=[NSString stringWithFormat:@"%02zd时",hour];
                        minuteLab.text=[NSString stringWithFormat:@"%02zd分",minute];
                        secondLab.text=[NSString stringWithFormat:@"%02zd秒",second];
                        
                    }else{
                        
                        [self stopTimer];
                        //                        [self.stateBtn setTitle:@"去查看" forState:UIControlStateNormal];
                        //                        [self.stateBtn setBackgroundColor:LBColor(32, 32, 32)];
                        timeLab.text=@"已结束";
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

- (NSString *)getCurrentTimeStr:(NSDateFormatter *)formatter {
    NSDate *dateNow = [NSDate date];
    return [formatter stringFromDate:dateNow];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
