#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define Screen320Scale SCREEN_WIDTH/320.0f

@class DropMenuView;
@protocol  DropMenuViewDelegate<NSObject>

/**
 *  选择行回调
 *
 *  @param dropmenuView
 *  @param index        选中行
 */
- (void)dropmenuView:(DropMenuView*)dropmenuView didSelectedRow:(NSInteger)index;

@optional
/**
 *  下拉菜单数据源
 *
 *  @return
 */
- (NSArray*)dropmenuDataSource;

@end

@interface DropMenuView : UIView

@property(nonatomic,strong) id<DropMenuViewDelegate> delegate;

- (void)showViewInView:(UIView*)view;

- (void)hideView:(void(^)(void))block;

@end