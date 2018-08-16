//
//  ReceiptCellCollectionViewCell.h
//  JavaMall
//
//  Created by LDD on 17/7/7.
//  Copyright © 2017年 Enation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESLabel.h"

@interface ReceiptCellCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ESLabel *nameLabel;

-(void) initData:(NSString *)addressTitle;

@end
