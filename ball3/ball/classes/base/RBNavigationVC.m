#import "RBNavigationVC.h"

@interface RBNavigationVC ()

@end

@implementation RBNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = (id)self;
    self.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        self.tabBarController.tabBar.hidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back_black" andHeighImage:@"back_black" andTarget:self andAction:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    Class c = NSClassFromString(@"RBSendTopicVC");
    if ([[self.childViewControllers lastObject] isKindOfClass:c]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tishi message:quedingtuichu  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:quxiao style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:queding style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self popViewControllerAnimated:YES];
        }];
        [alertVC addAction:cancelBtn];
        [alertVC addAction:sureBtn];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

@end
