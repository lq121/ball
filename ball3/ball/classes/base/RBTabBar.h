#import <UIKit/UIKit.h>
#import "RBAnimationBtn.h"

NS_ASSUME_NONNULL_BEGIN

@class RBTabBar;
@protocol RBTabBarDelegate <NSObject>
- (void)clickCenterBtn:(RBTabBar *)tabBar;
@end

@interface RBTabBar : UITabBar
@property (nonatomic, weak) id<RBTabBarDelegate> tabBarDelegate;
@property (nonatomic, weak) UILabel *centerLabel;
//指向中间按钮
@property (nonatomic, weak) RBAnimationBtn *centerButton;
@end

NS_ASSUME_NONNULL_END
