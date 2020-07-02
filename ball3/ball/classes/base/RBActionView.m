#import "RBActionView.h"
typedef void (^ClickItem)(NSInteger);
typedef void (^ClickSureBtn)(void);
typedef void (^ClickLeftBtn)(void);

@interface RBActionView ()
@property (strong, nonatomic) UIView *garyView;
@property (nonatomic, copy) ClickItem clickItem;
@property (nonatomic, copy) ClickSureBtn clickSureBtn;
@property (nonatomic, copy) ClickLeftBtn clickLeftBtn;
@end

@implementation RBActionView
- (instancetype)initWithArray:(NSArray *)array andCancelBtnColor:(UIColor *)cancelColor andClickItem:(nonnull void (^)(NSInteger))clickitem {
    if (self  = [super initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)]) {
        self.clickItem = clickitem;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight, RBScreenWidth, 64 * (array.count + 1) + 8)];
        self.garyView = garyView;
        garyView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [UIView animateWithDuration:durationTime animations:^{
            garyView.y = RBScreenHeight - 64 * (array.count + 1) - 8;
        }];
        garyView.layer.masksToBounds = true;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:garyView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = garyView.bounds;
        maskLayer.path = maskPath.CGPath;
        garyView.layer.mask = maskLayer;
        [self addSubview:garyView];

        for (int i = 0; i < array.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * 64, RBScreenWidth, 63)];
            btn.tag = 100 + i;
            btn.backgroundColor = [UIColor whiteColor];
            NSString *title = array[i];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            if ([title isEqualToString:@"回复"]) {
                [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
            } else {
                [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [garyView addSubview:btn];
        }

        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, array.count * 64 + 8, RBScreenWidth, 64)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:cancelColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:cancelBtn];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andLeft:(NSString *)left andRight:(NSString *)right andClickLeftBtn:(void (^)(void))clickLeftBtn andClickSureBtn:(void (^)(void))clickSureBtn {
    if (self  = [super initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)]) {
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        self.clickSureBtn = clickSureBtn;
        self.clickLeftBtn = clickLeftBtn;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        UIView *garyView = [[UIView alloc]initWithFrame:frame];
        garyView.backgroundColor = [UIColor whiteColor];
        garyView.layer.masksToBounds = true;
        garyView.layer.cornerRadius = 2;
        garyView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        garyView.layer.shadowOffset = CGSizeMake(0, 2);
        garyView.layer.shadowOpacity = 1;
        garyView.layer.shadowRadius = 10;
        [self addSubview:garyView];

        CGFloat width = (frame.size.width - 2) * 0.5;
        CGFloat height = frame.size.height;

        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:left forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickleftBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:cancelBtn];

        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), 0, 2, height);
        view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [garyView addSubview:view];

        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view.frame) + 2, 0, width, height)];
        sureBtn.backgroundColor = [UIColor whiteColor];
        [sureBtn setTitle:right forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clicksureBtn) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:sureBtn];
    }

    return self;
}

- (void)clickleftBtn {
    [self clickCancelBtn];
    self.clickLeftBtn();
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure andClickSureBtn:(void (^)(void))clickSureBtn {
    if (self  = [super initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)]) {
        self.userInteractionEnabled = YES;
        self.clickSureBtn = clickSureBtn;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        UIView *garyView = [[UIView alloc]initWithFrame:frame];
        garyView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        garyView.layer.masksToBounds = true;
        garyView.layer.cornerRadius = 2;
        [self addSubview:garyView];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:label];

        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 1, frame.size.width * 0.5 - 1, 50)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:cancel forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:cancelBtn];

        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame) + 1, CGRectGetMaxY(label.frame) + 1, frame.size.width * 0.5 - 1, 50)];
        sureBtn.backgroundColor = [UIColor whiteColor];
        [sureBtn setTitle:sure forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clicksureBtn) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [garyView addSubview:sureBtn];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andSure:(NSString *)sure andClickSureBtn:(void (^)(void))clickSureBtn {
    return [self initWithFrame:frame andTitle:title andCancel:@"取消" andSure:sure andClickSureBtn:clickSureBtn];
}

- (void)clicksureBtn {
    [self clickCancelBtn];
    self.clickSureBtn();
}

- (void)clickBtn:(UIButton *)btn {
    self.clickItem(btn.tag - 100);
    [self clickCancelBtn];
}

- (void)clickCancelBtn {
    [UIView animateWithDuration:durationTime animations:^{
        self.garyView.y = RBScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
