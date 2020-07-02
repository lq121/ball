#import "RBUserRecharge.h"

typedef void (^ClickItem)(int);
@interface RBUserRecharge ()
@property (nonatomic, assign) int currentSelectIndex;
@property (nonatomic, copy) ClickItem clickItem;
@property (nonatomic, strong) UIView *whiteVeiw;
@property (nonatomic, strong) NSArray *coins;
@end

@implementation RBUserRecharge

- (instancetype)initWithFrame:(CGRect)frame andCoinCount:(int)coinCount andClickItem:(nonnull void (^)(int))clickitem {
    if (self = [super initWithFrame:frame]) {
        self.clickItem = clickitem;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight, RBScreenWidth, 378 + RBBottomSafeH)];
        whiteVeiw.backgroundColor = [UIColor whiteColor];
        self.whiteVeiw = whiteVeiw;
        [self addSubview:whiteVeiw];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Money2"]];
        imageView.frame = CGRectMake(16, -30, 60, 60);
        [whiteVeiw addSubview:imageView];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, CGRectGetMaxY(imageView.frame), 50, 17)];
        tipLabel.text = @"用户充值";
        tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tipLabel.font = [UIFont systemFontOfSize:12];
        [whiteVeiw addSubview:tipLabel];

        UILabel *tipLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 50 - 16, 8, 50, 17)];
        tipLabel2.text = @"我的余额";
        tipLabel2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7];
        tipLabel2.font = [UIFont systemFontOfSize:12];
        [whiteVeiw addSubview:tipLabel2];

        UILabel *coinLabel = [[UILabel alloc]init];
        coinLabel.textAlignment = NSTextAlignmentRight;
        coinLabel.text = [NSString stringWithFormat:@"%d", coinCount];
        CGSize size =  [coinLabel.text getLineSizeWithBoldFontSize:16];
        coinLabel.frame = CGRectMake(RBScreenWidth - size.width - 16, CGRectGetMaxY(tipLabel2.frame) + 2, size.width, 19);
        coinLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7];
        coinLabel.font = [UIFont boldSystemFontOfSize:16];
        [whiteVeiw addSubview:coinLabel];
        UIImageView *coinIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gold coin"]];
        coinIcon.frame = CGRectMake(CGRectGetMinX(coinLabel.frame) - 16, CGRectGetMaxY(tipLabel2.frame) + 5, 12, 12);
        [whiteVeiw addSubview:coinIcon];

        NSArray *coins = @[@6, @98, @198, @698, @998, @1998];
        self.coins = coins;
        for (int i = 0; i < coins.count; i++) {
            UIButton *btn = [[UIButton alloc]init];
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat width = (RBScreenWidth - 32 - 7) * 0.5;
            CGFloat height = 67;
            if (i % 2 == 0) {
                x = 16;
            } else {
                x = 16 + 7 + width;
            }
            y = (i / 2) * (74) + 67;
            btn.frame = CGRectMake(x, y, width, height);
            btn.layer.masksToBounds = true;
            btn.layer.cornerRadius = 2;
            [btn.layer setBorderWidth:1];
            btn.layer.borderColor = [UIColor colorWithSexadeString:@"F8F8F8"].CGColor;
            [btn setBackgroundImage:[UIImage imageNamed:@"choose blue"] forState:UIControlStateSelected];

            btn.tag = 20 + i;
            [btn addTarget:self action:@selector(clickCoinBtn:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gold coin"]];
            [btn addSubview:icon];
            icon.frame = CGRectMake(8, 12, 16, 16);

            UILabel *label1 = [[UILabel alloc]init];
            label1.text = [NSString stringWithFormat:@"%d", [coins[i]intValue] * 10];
            label1.textAlignment = NSTextAlignmentLeft;
            label1.textColor = [UIColor colorWithSexadeString:@"#333333"];
            label1.alpha = 0.8;
            label1.font = [UIFont boldSystemFontOfSize:22];
            label1.frame = CGRectMake(CGRectGetMaxY(icon.frame) + 5, 7, 100, 26);
            [btn addSubview:label1];

            UILabel *label2 = [[UILabel alloc]init];
            label2.text = [NSString stringWithFormat:@"赠送%d点经验", [coins[i]intValue]];
            label2.textAlignment = NSTextAlignmentLeft;
            label2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
            label2.font = [UIFont systemFontOfSize:12];
            label2.frame = CGRectMake(16, CGRectGetMaxY(label1.frame) + 3, 150, 17);
            [btn addSubview:label2];

            UILabel *label3 = [[UILabel alloc]init];
            NSString *str = [NSString stringWithFormat:@"¥ %d", [coins[i]intValue]];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
            [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, 2)];
            [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(2, str.length - 2)];
            label3.textAlignment = NSTextAlignmentRight;
            label3.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
            label3.attributedText = attStr;
            label3.frame = CGRectMake(width - 109, 11, 100, 19);
            [btn addSubview:label3];
            if (i == 0) {
                btn.selected = YES;
                self.currentSelectIndex = 0;
            }
            [whiteVeiw addSubview:btn];
        }
        CGFloat btnwidth = (RBScreenWidth - 32) * 0.5;
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(24, 304, btnwidth - 16, 50)];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn mid cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [whiteVeiw addSubview:cancelBtn];

        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - btnwidth - 16, 304, btnwidth, 48)];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn mid cancel"] forState:UIControlStateDisabled];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn mid sure"] forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor whiteColor];
        [sureBtn setTitle:@"充 值"  forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clicksureBtn) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [whiteVeiw addSubview:sureBtn];
    }
    return self;
}

- (void)clickCoinBtn:(UIButton *)btn {
    UIButton *selectBtn = [self viewWithTag:20 + self.currentSelectIndex];
    selectBtn.selected = NO;
    btn.selected = YES;
    self.currentSelectIndex = (int)btn.tag - 20;
}

- (void)clickCancelBtn {
    [UIView animateWithDuration:durationTime animations:^{
        self.whiteVeiw.y = RBScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clicksureBtn {
    [self clickCancelBtn];
    self.clickItem(self.currentSelectIndex);
}

- (void)showWhiteView {
    [UIView animateWithDuration:durationTime animations:^{
        self.whiteVeiw.y = RBScreenHeight - (378 + RBBottomSafeH);
    }];
}

@end
