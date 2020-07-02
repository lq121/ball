#import "RBHudongHeadView.h"
typedef void (^ClickItem)(NSInteger);
@interface RBHudongHeadView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) ClickItem clickItem;
@end

@implementation RBHudongHeadView
- (instancetype)initWithFrame:(CGRect)frame firstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andClickItem:(void (^)(NSInteger index))clickitem {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.clickItem = clickitem;
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (RBScreenWidth - 1) * 0.5, 44)];
        btn1.backgroundColor = [UIColor whiteColor];
        btn1.selected = YES;
        self.selectBtn = btn1;
        btn1.tag = 0;
        [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitle:firstTitle forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateSelected];
        [self addSubview:btn1];

        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth * 0.5, 0, (RBScreenWidth - 1) * 0.5, 44)];
        btn2.backgroundColor = [UIColor whiteColor];
        btn2.tag = 1;
        [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTitle:secondTitle forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateSelected];
        [self addSubview:btn2];
    }
    return self;
}

- (void)clickBtn:(UIButton *)btn {
    if (self.selectBtn == btn) {
        return;
    }
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    self.clickItem(btn.tag);
}

@end
