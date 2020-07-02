#import "RBToast.h"

@interface RBToast()
@property (nonatomic, strong) UILabel *label;
@end

@implementation RBToast

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.label = label;
        [self addSubview:label];
    }
    return self;
}

+ (void)showWithTitle:(NSString *)title {
    [self showWithTitle:title andY:RBScreenHeight * 0.5];
}

+ (void)showWithTitle:(NSString *)title andY:(CGFloat)y {
    NSArray *array = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *view  in array) {
        if ([view isKindOfClass:[RBToast class]]) {
            return;
        }
    }
    RBToast *view = [[RBToast alloc] initWithTitle:title];
    CGSize size = [title getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32];
    view.label.frame = CGRectMake(0, 10, size.width + 20, size.height);
    view.frame = CGRectMake((RBScreenWidth - size.width - 20) * 0.5, y, size.width + 20, size.height + 20);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [UIView animateWithDuration:myDelayTime animations:^{
            view.y -= 30;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:myDelayTime animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    });
}


@end
