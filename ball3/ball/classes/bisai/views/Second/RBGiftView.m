#import "RBGiftView.h"
#import "RBToast.h"
typedef void (^ClickItem)(NSDictionary *);

@interface RBGiftView ()<UIScrollViewDelegate>
@property (nonatomic, assign) int currentSelectIndex;
@property (nonatomic, copy) ClickItem clickItem;
@property (nonatomic, strong) UIView *whiteVeiw;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *currentTipBtn;
@property (nonatomic, strong) UIButton *currentSelectGiftBtn;
@property (nonatomic, strong) UIButton *currentSelectPackBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) NSMutableArray *discountArr;
@property (nonatomic, strong) NSArray *coins;
@property (nonatomic, assign) int coinCount;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLab;
@end

@implementation RBGiftView

- (NSMutableArray *)discountArr {
    if (_discountArr == nil) {
        _discountArr = [NSMutableArray array];
    }
    return _discountArr;
}

- (instancetype)initWithFrame:(CGRect)frame andCoinCount:(int)coinCount andClickItem:(nonnull void (^)(NSDictionary *))clickitem {
    if (self = [super initWithFrame:frame]) {
        self.clickItem = clickitem;
        self.coinCount = coinCount;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight, RBScreenWidth, 441 + RBBottomSafeH)];
        whiteVeiw.backgroundColor = [UIColor whiteColor];
        self.whiteVeiw = whiteVeiw;
        [self addSubview:whiteVeiw];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift3"]];
        imageView.frame = CGRectMake(16, -30, 60, 60);
        [whiteVeiw addSubview:imageView];

        UIButton *tipBtn1 = [[UIButton alloc]initWithFrame:CGRectMake((RBScreenWidth-132)*0.5, 25, 50, 17)];
        tipBtn1.selected = YES;
        self.currentTipBtn = tipBtn1;
        tipBtn1.tag = 10;
        [tipBtn1 addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tipBtn1 setTitle:@"礼物" forState:UIControlStateNormal];
        [tipBtn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [tipBtn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        tipBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [whiteVeiw addSubview:tipBtn1];

        UIButton *tipBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipBtn1.frame) + 32, 25, 50, 17)];
        tipBtn2.tag = 11;
        [tipBtn2 addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
        [tipBtn2 setTitle:@"装备包" forState:UIControlStateNormal];
        [tipBtn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [tipBtn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        tipBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [whiteVeiw addSubview:tipBtn2];

        self.indicateView = [[UIView alloc]init];
        self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
        self.indicateView.frame = CGRectMake(0, CGRectGetMaxY(tipBtn1.frame) + 4, 28, 4);
        self.indicateView.centerX = tipBtn1.centerX;
        [whiteVeiw addSubview:self.indicateView];

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
        coinIcon.frame = CGRectMake(CGRectGetMinX(coinLabel.frame) - 20, CGRectGetMaxY(tipLabel2.frame) + 5, 16, 16);
        [whiteVeiw addSubview:coinIcon];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 56, RBScreenWidth, 1)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [whiteVeiw addSubview:line];

        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, RBScreenWidth, 230)];
        scrollView.scrollEnabled = NO;
        self.scrollView = scrollView;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(RBScreenWidth * 2, 230);
        [whiteVeiw addSubview:scrollView];
        NSArray *imgs = @[@"gift／ufo", @"gift／rocket", @"gift／sport car", @"gift／double_rainbow", @"gift／drink", @"gift／rose", @"gift／lollipop", @"gift／good"];
        self.titles = @[@"UFO", @"冲天火箭", @"超级跑车", @"双彩虹", @"82年雪碧", @"玫瑰花", @"棒棒糖", @"赞"];
        self.coins = @[@(5000), @(1000), @(520), @(50), @(50), @(1), @(1), @(1)];
        CGFloat width = (RBScreenWidth - 32 - 12) * 0.25;
        CGFloat height = 104;
        CGFloat margin = 4;

        for (int i = 0; i < imgs.count; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = 401 + i;
            [btn addTarget:self  action:@selector(clickGiftBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.currentSelectGiftBtn = btn;
                btn.layer.cornerRadius = 4;
                btn.layer.shadowColor = [UIColor colorWithSexadeString:@"#0E2958" AndAlpha:0.1].CGColor;
                btn.layer.shadowOffset = CGSizeMake(0, 2);
                btn.layer.shadowOpacity = 1;
                btn.layer.shadowRadius = 8;
            }
            CGFloat x = 16 + (i % 4) * (width + margin);
            CGFloat y = 8 + (i / 4) * (height + 8);
            btn.frame = CGRectMake(x, y, width, height);
            [scrollView addSubview:btn];
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = [UIImage imageNamed:imgs[i]];
            imageView.frame = CGRectMake(18, 0, 48, 48);
            [btn addSubview:imageView];

            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 4, width, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.titles[i];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textColor = [UIColor colorWithSexadeString:@"#333333"];
            [btn addSubview:label];

            UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), width, 17)];
            iconBtn.userInteractionEnabled = NO;
            [iconBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
            iconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [iconBtn setTitle:[NSString stringWithFormat:@"%d", [self.coins[i] intValue]] forState:UIControlStateNormal];
            [iconBtn setImage:[UIImage imageNamed:@"gold coin"] forState:UIControlStateNormal];
            [btn addSubview:iconBtn];
        }

        NSString *Packet = [[NSUserDefaults standardUserDefaults]objectForKey:@"Packet"];
        if (Packet != nil) {
            NSData *jsonData = [Packet dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSArray *arr2 = (NSArray *)dic;
            for (int i = 0; i < arr2.count; i++) {
                NSArray *ar = arr2[i];
                if ([ar[0] intValue] >= 0 && [ar[0] intValue] < 10) {
                    [self.discountArr addObject:ar];
                    continue;
                }
            }

            for (int i = 0; i < self.discountArr.count; i++) {
                NSArray *arr = self.discountArr[i];
                UIButton *btn = [[UIButton alloc]init];
                btn.backgroundColor = [UIColor whiteColor];
                btn.tag = 500 + i;
                [btn addTarget:self  action:@selector(clickPackBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.layer.masksToBounds = NO;
                if (i == 0) {
                    self.currentSelectPackBtn = btn;
                    btn.layer.cornerRadius = 4;
                    btn.layer.shadowColor = [UIColor colorWithSexadeString:@"#0E2958" AndAlpha:0.1].CGColor;
                    btn.layer.shadowOffset = CGSizeMake(0, 2);
                    btn.layer.shadowOpacity = 1;
                    btn.layer.shadowRadius = 8;
                }
                CGFloat x = 16 + (i % 4) * (width + margin) + RBScreenWidth;
                CGFloat y = 8 + (i / 4) * (height + 8);
                btn.frame = CGRectMake(x, y, width, height);
                [scrollView addSubview:btn];
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.image = [UIImage imageNamed:imgs[[arr[0] intValue] - 1]];
                imageView.frame = CGRectMake(18, 0, 48, 48);
                [btn addSubview:imageView];

                UIButton *tipBtn = [[UIButton alloc]init];
                [tipBtn setTitle:[NSString stringWithFormat:@"%d", [arr[1]intValue]] forState:UIControlStateNormal];
                [tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                tipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
                if ([arr[1]intValue] >= 100) {
                    [tipBtn setBackgroundImage:[UIImage imageNamed:@"number pop2"] forState:UIControlStateNormal];
                    tipBtn.frame = CGRectMake(width - 25, 0, 25, 20);
                }else{
                    [tipBtn setBackgroundImage:[UIImage imageNamed:@"number pop"] forState:UIControlStateNormal];
                    tipBtn.frame = CGRectMake(width - 20, 0, 20, 20);
                }
                [btn addSubview:tipBtn];

                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 4, width, 20)];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = self.titles[[arr[0]intValue] - 1];
                label.font = [UIFont boldSystemFontOfSize:14];
                label.textColor = [UIColor colorWithSexadeString:@"#333333"];
                [btn addSubview:label];

                UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), width, 17)];
                iconBtn.userInteractionEnabled = NO;
                [iconBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
                iconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [iconBtn setTitle:[NSString stringWithFormat:@"%d", [self.coins[[arr[0]intValue] - 1] intValue]] forState:UIControlStateNormal];
                [iconBtn setImage:[UIImage imageNamed:@"gold coin"] forState:UIControlStateNormal];
                [btn addSubview:iconBtn];
            }
        }

        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 321, RBScreenWidth, 120)];
        self.bottomView = bottomView;
        [whiteVeiw addSubview:bottomView];

        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 8, 50, 17)];
        tipLabel.text = @"赠送数量";
        tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tipLabel.font = [UIFont systemFontOfSize:12];
        [bottomView addSubview:tipLabel];

        UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 137 - 24, 4, 24, 24)];
        [subBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.subBtn = subBtn;
        [subBtn setBackgroundImage:[UIImage imageNamed:@"btn／minus"] forState:UIControlStateDisabled];
        [subBtn setBackgroundImage:[UIImage imageNamed:@"btn／minus_selected"] forState:UIControlStateNormal];
        [bottomView addSubview:subBtn];

        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(subBtn.frame) + 16, 0, 65, 32)];
        textField.enabled = NO;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = @"1";
        textField.font = [UIFont systemFontOfSize:20];
        textField.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 16;
        self.textField = textField;
        [bottomView addSubview:textField];

        UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 16, 4, 24, 24)];
        [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.addBtn = addBtn;
        [addBtn setBackgroundImage:[UIImage imageNamed:@"btn／add"] forState:UIControlStateNormal];
        [bottomView addSubview:addBtn];

        CGFloat btnwidth = (RBScreenWidth - 32) * 0.5;
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(24, 48, btnwidth - 16, 48)];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn mid cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:cancelBtn];

        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - btnwidth - 16, 48, btnwidth, 48)];
        self.sureBtn = sureBtn;
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn mid sure2"] forState:UIControlStateDisabled];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn mid sure"] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确 定"  forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clicksureBtn) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [bottomView addSubview:sureBtn];

        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.hidden = YES;
        self.titleLab = titleLab;
        titleLab.frame = CGRectMake(0, (421 + RBBottomSafeH) * 0.5, RBScreenWidth, 20);
        titleLab.text = @"什么都没有～";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [whiteVeiw addSubview:titleLab];
    }
    return self;
}

// 选择减号按钮
- (void)clickSubBtn:(UIButton *)btn {
    int count = [self.textField.text intValue];
    count--;
    self.textField.text = [NSString stringWithFormat:@"%d", count];
    if (count <= 0) {
        btn.enabled = NO;
        self.sureBtn.enabled = NO;
    }
}

// 选择加号按钮
- (void)clickAddBtn:(UIButton *)btn {
    int count = [self.textField.text intValue];
    if (self.currentTipBtn.tag == 11) {
        NSArray *ar = self.discountArr[self.currentSelectPackBtn.tag - 500];
        if (count >= [ar[1] intValue]) {
            return;
        }
    }
    count++;
    if (count > 0) {
        self.subBtn.enabled = YES;
        self.sureBtn.enabled = YES;
    }
    self.textField.text = [NSString stringWithFormat:@"%d", count];
}

// 选择某个礼物按钮
- (void)clickGiftBtn:(UIButton *)btn {
    if (btn == self.currentSelectGiftBtn) {
        return;
    }
    self.textField.text = @"1";
    btn.layer.masksToBounds = NO;
    btn.layer.cornerRadius = 4;
    btn.layer.shadowColor = [UIColor colorWithSexadeString:@"#0e2958" AndAlpha:0.1].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 2);
    btn.layer.shadowOpacity = 1;
    btn.layer.shadowRadius = 8;
    self.currentSelectGiftBtn.layer.masksToBounds = YES;
    self.currentSelectGiftBtn = btn;
}

// 选择某个背包按钮
- (void)clickPackBtn:(UIButton *)btn {
    if (btn == self.currentSelectPackBtn) {
        return;
    }
    self.textField.text = @"1";
    btn.layer.masksToBounds = NO;
    btn.layer.cornerRadius = 4;
    btn.layer.shadowColor = [UIColor colorWithSexadeString:@"#0e2958" AndAlpha:0.1].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 2);
    btn.layer.shadowOpacity = 1;
    btn.layer.shadowRadius = 8;
    self.currentSelectPackBtn.layer.masksToBounds = YES;
    self.currentSelectPackBtn = btn;
}

// 选择礼物/装备包按钮
- (void)clickTipBtn:(UIButton *)btn {
    if (btn == self.currentTipBtn) {
        return;
    }
    self.textField.text = @"1";
    self.subBtn.enabled = YES;
    self.currentTipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.currentTipBtn.selected = NO;
    btn.titleLabel.font =  [UIFont boldSystemFontOfSize:16];
    btn.selected = YES;
    self.currentTipBtn = btn;
    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.centerX = self.currentTipBtn.centerX;
    }];
    int index = (int)(btn.tag - 10);
    if (index == 0) {
        self.bottomView.hidden = NO;
        self.titleLab.hidden = YES;
    } else {
        if (self.discountArr == nil || self.discountArr.count == 0) {
            self.bottomView.hidden = YES;
            self.titleLab.hidden = NO;
        } else {
            self.bottomView.hidden = NO;
            self.titleLab.hidden = YES;
        }
    }
    if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
        return;
    } else {
        self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
    }
}

// 取消按钮
- (void)clickCancelBtn {
    [UIView animateWithDuration:durationTime animations:^{
        self.whiteVeiw.y = RBScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 确定按钮
- (void)clicksureBtn {
    // 校验下金币
    if (self.currentTipBtn.tag == 10) {
        // 金币购买
        if (self.coinCount < [self.coins[self.currentSelectGiftBtn.tag - 401] intValue] * [self.textField.text intValue]) {
            [RBToast showWithTitle:@"金币不足,请充值"];
            return;
        }
    }
    NSDictionary *dict;
    NSNumber *packet;
    if (self.currentTipBtn.tag == 10) {
        // 礼物
        packet = [NSNumber numberWithBool:NO];
         NSString *name = self.titles[self.currentSelectGiftBtn.tag - 400-1];
        dict = @{ @"giftId": @(self.currentSelectGiftBtn.tag - 400), @"count": self.textField.text, @"isPackt": packet ,@"name":name};
    } else {
        packet = [NSNumber numberWithBool:YES];
        int giftId = [self.discountArr[self.currentSelectPackBtn.tag - 500][0] intValue];
        NSString *name = self.titles[self.currentSelectPackBtn.tag - 500];
        dict = @{ @"giftId": @(giftId), @"count": self.textField.text, @"isPackt": packet ,@"name":name};
    }
    self.clickItem(dict);
    [self clickCancelBtn];
}

- (void)showWhiteView {
    [UIView animateWithDuration:durationTime animations:^{
        self.whiteVeiw.y = RBScreenHeight - (441 + RBBottomSafeH);
    }];
}

@end
