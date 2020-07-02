#import "MBProgressHUD+RBExtension.h"

@implementation MBProgressHUD (RBExtension)
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;

    hud.label.font = [UIFont systemFontOfSize:14];
    //背景颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    if ([icon  isEqualToString:@"choose pay-selected"]) {
        hud.label.textColor = [UIColor whiteColor];
        hud.bezelView.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
    }else{
        hud.label.textColor = [UIColor colorWithSexadeString:@"#9D9D9D"];
        hud.bezelView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    }
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error" view:view];
}

+ (void)showLoading:(NSString *)title toView:(UIView *)view {
    [self show:title icon:@"loading" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"choose pay-selected" view:view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(myDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidHUDFromView:view];
    });
}

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundColor = [UIColor blackColor]; //设置遮罩背景色,默认为透明
    return hud;
}

+ (void)hidHUDFromView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    [self hideHUDForView:view animated:YES];
}
@end
