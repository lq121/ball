#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (RBExtension)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showLoading:(NSString *)title toView:(UIView *)view;
+ (void)hidHUDFromView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
