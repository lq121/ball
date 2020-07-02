#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBTipView : UIView
+ (void)tipWithTitle:(NSString *)title andExp:(int)exp andCoin:(int)coin;
+ (void)tipWithTitle:(NSString *)title andExp:(int)exp andCoin:(int)coin andY:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END
