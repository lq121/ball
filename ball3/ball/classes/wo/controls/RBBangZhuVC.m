#import "RBBangZhuVC.h"
#import "RBChekLogin.h"
#import "RBLiuYanVC.h"
#import "RBFanKuiTabVC.h"
#import "RBBangZhuDesVC.h"

@interface RBBangZhuVC ()

@end

@implementation RBBangZhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.title = @"帮助与反馈";

    UILabel *tip1 = [[UILabel alloc]init];
    tip1.text = @"常见问题";
    tip1.frame = CGRectMake(16, 24, 120, 22);
    tip1.font = [UIFont boldSystemFontOfSize:16];
    tip1.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip1 sizeToFit];
    [self.view addSubview:tip1];

    NSArray *bigTitles = @[@"为什么我的账号被封禁？", @"遇到bug，数据错，卡顿等怎么办?", @"充值未到账怎么办？"];
    for (int i = 0; i < bigTitles.count; i++) {
        BOOL showLine = YES;
        if (i == bigTitles.count) {
            showLine = NO;
        }
        UIButton *btn = [self cretaBigBtnWithFrame:CGRectMake(0, i * 60 + 54, RBScreenWidth, 60) andTitle:bigTitles[i] andshowLine:showLine];
        btn.tag = 300 + i;
        [self.view addSubview:btn];
    }
    UIView *view = [self.view viewWithTag:(300 + bigTitles.count - 1)];
    UILabel *tip2 = [[UILabel alloc]init];
    tip2.text = @"问题分类";
    tip2.frame = CGRectMake(16, CGRectGetMaxY(view.frame) + 24, 120, 22);
    tip2.font = [UIFont boldSystemFontOfSize:16];
    tip2.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip2 sizeToFit];
    [self.view addSubview:tip2];

    NSArray *minTitles = @[@"账号问题", @"性能问题", @"充值问题", @"功能建议", @"其他问题"];
    CGFloat width = (RBScreenWidth - 32 - 16) / 3;
    CGFloat height = 32;
    for (int i = 0; i < minTitles.count; i++) {
        CGFloat x = 16 + (i % 3) * (width + 8);
        CGFloat y = CGRectGetMaxY(tip2.frame) + 16 + (i / 3) * (16 + height);
        UIButton *btn = [self cretaMinBtnWithFrame:CGRectMake(x, y, width, height) andTitle:minTitles[i]];
        btn.tag = 400 + i;
        [self.view addSubview:btn];
    }

    UIButton *otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH - 44, RBScreenWidth, 44)];
    [otherBtn addTarget:self action:@selector(clickOtherBtn) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.backgroundColor = [UIColor whiteColor];
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:otherBtn];
    [otherBtn setTitleColor:[UIColor colorWithSexadeString:@"#FA7268"] forState:UIControlStateNormal];
    [otherBtn setTitle:@"咨询其他问题，请留言" forState:UIControlStateNormal];
    CGSize size = [@"咨询其他问题，请留言" getLineSizeWithFontSize:14];

    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_Arrow"]];
    icon.frame = CGRectMake(size.width + (RBScreenWidth - size.width) * 0.5 + 4, 17, 12, 12);
    [otherBtn addSubview:icon];

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 80, RBStatusBarH + 8, 80, 36)];
    [checkBtn setTitle:@"反馈记录" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [checkBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)clickCheckBtn {
    [self.navigationController pushViewController:[[RBFanKuiTabVC alloc]init] animated:YES];
}

- (void)clickOtherBtn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    [self.navigationController pushViewController:[[RBLiuYanVC alloc]init] animated:YES];
}

- (UIButton *)cretaBigBtnWithFrame:(CGRect)frame andTitle:(NSString *)title andshowLine:(BOOL)showLine {
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn addTarget:self action:@selector(clickBigBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.frame = CGRectMake(16, 0, frame.size.width - 32, frame.size.height);
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [btn addSubview:label];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, frame.size.height - 1, frame.size.width - 32, 1)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [btn addSubview:line];
    line.hidden = !showLine;
    return btn;
}

- (UIButton *)cretaMinBtnWithFrame:(CGRect)frame andTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn addTarget:self action:@selector(clickMinBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 16;
    return btn;
}

- (void)clickMinBtn:(UIButton *)btn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    RBLiuYanVC *liuYanVC =  [[RBLiuYanVC alloc]init];
    liuYanVC.selectIndex = (int)btn.tag - 400;
    [self.navigationController pushViewController:liuYanVC animated:YES];
}

- (void)clickBigBtn:(UIButton *)btn {
    RBBangZhuDesVC *bangZhuDesVC = [[RBBangZhuDesVC alloc]init];
    bangZhuDesVC.selectItem = (int)btn.tag - 300;
    bangZhuDesVC.title = @"常见问题";
    [self.navigationController pushViewController:bangZhuDesVC animated:YES];
}

@end
