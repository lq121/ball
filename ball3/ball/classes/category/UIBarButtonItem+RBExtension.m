#import "UIBarButtonItem+RBExtension.h"

@implementation UIBarButtonItem (RBExtension)
+ (instancetype)itemWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andTarget:(id)target andAction:(SEL)action {
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, 30, 50, 20);
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    return [[self alloc]initWithCustomView:btn];
}

@end
