#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBToast : UIView
+ (void)showWithTitle:(NSString *)title;
+ (void)showWithTitle:(NSString *)title andY:(CGFloat)y;
@end

NS_ASSUME_NONNULL_END
