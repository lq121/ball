#import "RBTabBar.h"

#define centerButtonMargin 40

@implementation RBTabBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        RBAnimationBtn *centerButton = [[RBAnimationBtn alloc]init];
        centerButton.selected = YES;
        [centerButton addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:centerButton];
        self.centerButton = centerButton;

        NSMutableArray *mutArr = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [mutArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"weak_%02d.png", i]]];
        }
        [centerButton playingWithImgArr:mutArr andTime:2];
        self.backgroundColor = [UIColor whiteColor];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"], NSFontAttributeName: [UIFont boldSystemFontOfSize:10] } forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"], NSFontAttributeName: [UIFont systemFontOfSize:10] } forState:UIControlStateNormal];
        self.tintColor = [UIColor colorWithSexadeString:@"#333333"];
    }
    return self;
}

- (void)clickCenterBtn:(RBTabBar *)tabBar{
    if ([self.tabBarDelegate respondsToSelector:@selector(clickCenterBtn:)]) {
        [self.tabBarDelegate clickCenterBtn:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.centerButton.frame = CGRectMake(RBScreenWidth / 5 * 2 + (RBScreenWidth / 5 - 62) * 0.5, -25, 62, 62);
    int btnIndex = 0;
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {//遍历TabBar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            btn.width = (self.width) / 5;
            btn.x = btn.width * btnIndex;
            btnIndex++;
        }
    }
    [self bringSubviewToFront:self.centerButton];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        CGPoint newA = [self convertPoint:point toView:self.centerButton];
        CGPoint newL = [self convertPoint:point toView:self.centerLabel];
        if ([self.centerButton pointInside:newA withEvent:event]) {
            self.centerButton.selected = YES;
            return self.centerButton;
        }
        else if ([self.centerLabel pointInside:newL withEvent:event]) {
            self.centerButton.selected = YES;
            return self.centerButton;
        } else {
            return [super hitTest:point withEvent:event];
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
