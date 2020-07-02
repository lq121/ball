#import "UIViewController+RBExtension.h"

@implementation UIViewController (RBExtension)
+ (UIViewController *)getCurrentVC {
    UIViewController *currentViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL hasFind = YES;
    while (hasFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController *)currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}

@end
