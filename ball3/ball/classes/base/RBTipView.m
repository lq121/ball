#import "RBTipView.h"
#import "RBToast.h"

@interface RBTipView()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation RBTipView

- (instancetype)initWithTitle:(NSString *)title andExp:(int)exp andCoin:(int)coin {
    if (self = [super init]) {
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = title;
        label1.font = [UIFont systemFontOfSize:16];
        label1.textColor = [UIColor whiteColor];
        label1.textAlignment = NSTextAlignmentCenter;

        UILabel *label2 = [[UILabel alloc]init];
        label2.numberOfLines = 0;

        label2.text = [NSString stringWithFormat:@"经验+%d", exp];
        label2.font = [UIFont systemFontOfSize:16];
        label2.textColor = [UIColor whiteColor];
        label2.textAlignment = NSTextAlignmentCenter;

        self.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;

        self.label1 = label1;
        [self addSubview:label1];
        self.label2 = label2;
        [self addSubview:label2];
    }
    return self;
}

+ (void)tipWithTitle:(NSString *)title andExp:(int)exp andCoin:(int)coin {
    [self tipWithTitle:title andExp:exp andCoin:coin andY:RBScreenHeight * 0.5];
}

+ (void)tipWithTitle:(NSString *)title andExp:(int)exp andCoin:(int)coin andY:(CGFloat)y {
    if (exp <= 0 && coin <= 0) {
        [RBToast showWithTitle:title andY:y];
        return;
    }
    RBTipView *view = [[RBTipView alloc] initWithTitle:title andExp:exp andCoin:coin];
    CGSize size1 = [title getLineSizeWithFontSize:16];
    CGSize size2 = [[NSString stringWithFormat:@"金币+%d", exp] getLineSizeWithFontSize:16];
    CGFloat width = MAX(size1.width, size2.width);
    view.label1.frame = CGRectMake(11, 16, width, size1.height);
    view.label2.frame = CGRectMake(11, CGRectGetMaxY(view.label1.frame) + 7, width, size2.height);
    view.frame = CGRectMake((RBScreenWidth - width - 22) * 0.5, y - (size1.height + 27 + size2.height) * 0.5, width + 22, size1.height + 32 + 7 + size2.height);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [UIView animateWithDuration:myDelayTime * 3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });
}

@end
