#import "RBWoHead.h"
#import "RBChekLogin.h"
#import "RBLoginVC.h"
#import "RBRenWuVC.h"
#import "RBYongHuXinXiTabVC.h"
#import "RBNetworkTool.h"
#import "RBTipView.h"
#import "RBHuiYuanVC.h"

@interface RBWoHead ()
@property (nonatomic, strong) UIButton *head;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIImageView *vipImage;
@property (nonatomic, strong) UIButton *asHostBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UILabel *coin;
@property (nonatomic, strong) UILabel *check;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UILabel *lvLabel;
@property (nonatomic, strong) UIButton *vipBtn;
@property (nonatomic, assign) int vip;
@property (nonatomic, assign) int vipst;
@end

@implementation RBWoHead
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIView *topView = [[UIView alloc]init];
        if (@available(iOS 10, *)) {
            topView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, 158 + 2 * RBStatusBarH);
            if (RB_iPhoneX) {
                topView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, 158 + 2 * RBStatusBarH - 24);
            }
        } else {
            topView.frame = CGRectMake(0, 0, RBScreenWidth, 158 + RBStatusBarH);
        }
        topView.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
        [self addSubview:topView];

        UIButton *head = [[UIButton alloc]init];
        [head setBackgroundImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        [head addTarget:self action:@selector(clickHeadBtn) forControlEvents:UIControlEventTouchUpInside];
        head.frame = CGRectMake(12, RBStatusBarH + 24, 64, 64);
        head.layer.cornerRadius = 32;
        head.layer.masksToBounds = YES;
        [topView addSubview:head];
        self.head = head;

        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 36 + RBStatusBarH, 138, 40)];
        loginBtn.layer.cornerRadius = 20;
        loginBtn.layer.masksToBounds = YES;
        [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#36C8B9"]] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [loginBtn addTarget:self  action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.hidden = YES;
        [topView addSubview:loginBtn];
        self.loginBtn = loginBtn;

        UILabel *userName = [[UILabel alloc]init];
        userName.text = @"用户昵称";
        userName.textAlignment = NSTextAlignmentLeft;
        userName.font = [UIFont systemFontOfSize:20];
        userName.textColor = [UIColor whiteColor];
        [topView addSubview:userName];
        userName.frame = CGRectMake(CGRectGetMaxX(head.frame) + 13, RBStatusBarH + 24, 200, 28);
        self.userName = userName;

        UIImageView *vipImage = [[UIImageView alloc]init];
        vipImage.image = [UIImage imageNamed:@"vip kim"];
        vipImage.frame = CGRectMake(CGRectGetMaxX(head.frame) + 13, CGRectGetMaxY(userName.frame) + 8, 36, 16);
        vipImage.hidden = YES;
        self.vipImage = vipImage;
        [topView addSubview:self.vipImage];

        UILabel *lvLabel = [[UILabel alloc]init];
        lvLabel.textAlignment = NSTextAlignmentCenter;
        lvLabel.text = @"Lv.0";
        lvLabel.font = [UIFont boldSystemFontOfSize:10];
        lvLabel.textColor = [UIColor whiteColor];
        lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
        [topView addSubview:lvLabel];
        lvLabel.frame = CGRectMake(CGRectGetMaxX(head.frame) + 13, CGRectGetMaxY(userName.frame) + 8, 32, 14);
        lvLabel.layer.masksToBounds = true;
        lvLabel.layer.cornerRadius = 2;
        self.lvLabel = lvLabel;

        UIButton *vipBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 110, RBStatusBarH + 24, 110, 32)];
        vipBtn.hidden = YES;
        [vipBtn addTarget:self  action:@selector(clickVipBtn) forControlEvents:UIControlEventTouchUpInside];
        self.vipBtn = vipBtn;
        [vipBtn setBackgroundImage:[UIImage imageNamed:@"get vip bg"] forState:UIControlStateNormal];
        [vipBtn setTitle:@"获取会员" forState:UIControlStateNormal];
        [vipBtn setTitleColor:[UIColor colorWithSexadeString:@"#422E08"] forState:UIControlStateNormal];
        vipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        vipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        UIImageView *tipImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"little triangle  brown"]];
        tipImage.frame = CGRectMake(92, 13, 6, 6);
        tipImage.userInteractionEnabled = YES;
        [vipBtn addSubview:tipImage];
        [topView addSubview:vipBtn];

        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(12, 112 + RBStatusBarH, RBScreenWidth - 24, 136)];
        if (RB_iPhoneX) {
            bottomView.frame = CGRectMake(12, 112 + RBStatusBarH - 24, RBScreenWidth - 24, 136);
        }
        bottomView.layer.cornerRadius = 2;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"calendar"];
        imageView.frame = CGRectMake(16, 34, 24, 24);
        [bottomView addSubview:imageView];

        UILabel *myIcon = [[UILabel alloc]init];
        myIcon.textAlignment = NSTextAlignmentLeft;
        myIcon.text = @"我的金币";
        myIcon.font = [UIFont systemFontOfSize:16];
        myIcon.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [bottomView addSubview:myIcon];
        myIcon.frame = CGRectMake(56, 25, 70, 22);

        UILabel *coin = [[UILabel alloc]init];
        self.coin = coin;
        coin.textAlignment = NSTextAlignmentLeft;
        coin.text = @"0";
        coin.font = [UIFont boldSystemFontOfSize:30];
        coin.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [bottomView addSubview:self.coin];

        UILabel *check = [[UILabel alloc]init];
        self.check = check;
        check.textAlignment = NSTextAlignmentLeft;
        check.text = @"已连续签到0天";
        check.font = [UIFont systemFontOfSize:12];
        check.textColor = [UIColor colorWithSexadeString:@"#333333"];
        check.alpha = 0.4;
        check.frame = CGRectMake(56, 53, 200, 22);
        [check sizeToFit];
        [bottomView addSubview:check];

        UIButton *checkBtn = [[UIButton alloc]init];
        self.checkBtn = checkBtn;
        [checkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
        [checkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
        [checkBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [checkBtn setTitle:@"已签到" forState:UIControlStateDisabled];
        [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
        [checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        checkBtn.layer.masksToBounds = YES;
        checkBtn.layer.cornerRadius = 2;
        [bottomView addSubview:checkBtn];
        checkBtn.frame = CGRectMake(RBScreenWidth - 32 - 72 - 16, 24, 72, 32);

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 79, RBScreenWidth - 64, 1)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [bottomView addSubview:line];

        UIButton *taskBtn = [[UIButton alloc]init];
        [taskBtn addTarget:self action:@selector(clickRenWuBtn) forControlEvents:UIControlEventTouchUpInside];
        taskBtn.frame = CGRectMake(0, CGRectGetMaxY(line.frame), RBScreenWidth - 32, 56);
        [bottomView addSubview:taskBtn];

        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"daily assignment"];
        img.frame = CGRectMake(0, 12, 91, 32);
        [taskBtn addSubview:img];

        UILabel *RBLabe = [[UILabel alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(clickRenWuBtn)];
        [RBLabe addGestureRecognizer:tap];
        RBLabe.userInteractionEnabled = YES;
        RBLabe.text = @"今日份奖励领取了吗？";
        RBLabe.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        RBLabe.font = [UIFont systemFontOfSize:14];
        RBLabe.frame = CGRectMake(CGRectGetMaxX(img.frame) + 7, 18, [RBLabe.text getLineSizeWithFontSize:14].width, 20);
        [taskBtn addSubview:RBLabe];

        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn addTarget:self action:@selector(clickRenWuBtn) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithSexadeString:@"#B8B8B8"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        moreBtn.frame = CGRectMake(RBScreenWidth - 81 - 32, 19.5, 50, 17);
        [taskBtn addSubview:moreBtn];

        UIImageView *icon = [[UIImageView alloc]init];
        icon.userInteractionEnabled = YES;
        icon.image = [UIImage imageNamed:@"little triangle grey"];
        icon.frame = CGRectMake(CGRectGetMaxX(moreBtn.frame) + 4, 24.5, 7, 7);
        [taskBtn addSubview:icon];
    }
    return self;
}

- (void)clickRenWuBtn {
    UIViewController *currentVC = [UIViewController getCurrentVC];
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        RBRenWuVC *renWuVC = [[RBRenWuVC alloc]init];
        renWuVC.dict = self.userDict;
        renWuVC.Yqcode = self.userDict[@"ok"][@"Yqcode"];
        [currentVC.navigationController pushViewController:renWuVC animated:YES];
    }
}

- (void)clickHeadBtn {
    RBYongHuXinXiTabVC *yonghuXinXiTabVC = [[RBYongHuXinXiTabVC alloc]init];
    [[UIViewController getCurrentVC].navigationController pushViewController:yonghuXinXiTabVC animated:YES];
}

- (void)setUserDict:(NSDictionary *)userDict {
    _userDict = userDict;
    NSDictionary *dataDict = userDict;
    NSDictionary *signquest = dataDict[@"signquest"];
    if (dataDict == nil || signquest == nil) {
        self.loginBtn.hidden = NO;
        self.userName.hidden = YES;
        self.lvLabel.hidden = YES;
        self.coin.text = @"0";
        self.checkBtn.enabled = YES;
        self.vipImage.hidden = YES;
        [self.head setBackgroundImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        self.check.text = @"已连续签到0天";
        self.vipBtn.hidden = YES;
        return;
    }
    self.vipBtn.hidden = NO;
    self.check.text = [NSString stringWithFormat:@"已连续签到%d天", [signquest[@"seq"]intValue]];
    self.checkBtn.enabled = ![signquest[@"signtoday"]boolValue];
    NSDictionary *ok = dataDict[@"ok"];
    if ([ok.allKeys containsObject:@"Vip"]) {
        int vip = [ok[@"Vip"] intValue];
        int vipst = [ok[@"Vipst"] intValue];
        self.vip = vip;
        self.vipst = vipst;
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:vipst];
        NSDate *now = [NSDate date];
        int nowTime = [now timeIntervalSince1970];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *datecomps = [[NSDateComponents alloc] init];
        [datecomps setMonth:vip];
        NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
        if (nowTime - [calculatedate timeIntervalSince1970] < 0) {
            // 未过期
            self.userName.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
            self.vipImage.hidden = NO;
            self.lvLabel.x = CGRectGetMaxX(self.vipImage.frame) + 4;
            [self.vipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        } else {
            self.userName.textColor = [UIColor whiteColor];
            self.vipImage.hidden = YES;
            self.lvLabel.x = CGRectGetMaxX(self.head.frame) + 13;
            [self.vipBtn setTitle:@"获取会员" forState:UIControlStateNormal];
        }
    }
    if (ok[@"Iconurl"] != nil && ![ok[@"Iconurl"] isEqualToString:@""]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:ok[@"Iconurl"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.head setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            });
        });
    }
    self.loginBtn.hidden = YES;
    self.userName.hidden = NO;
    if (ok[@"Nickname"] != nil && ![ok[@"Nickname"] isEqualToString:@""]) {
        NSString *str = ok[@"Nickname"];
        if (str.length > 6) {
            self.userName.text = [str substringFromIndex:str.length - 6];
        } else {
            self.userName.text = str;
        }
    } else {
        NSString *str = ok[@"Username"];
        if (str.length > 6) {
            self.userName.text = [str substringFromIndex:str.length - 6];
        } else {
            self.userName.text = str;
        }
    }
    self.lvLabel.text = [NSString stringWithFormat:@"Lv.%d", [ok[@"Viplevel"]intValue]];
    if ([ok[@"Viplevel"]intValue] < 10) {
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
    } else if ([ok[@"Viplevel"]intValue] < 20) {
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
    } else if ([ok[@"Viplevel"]intValue] < 30) {
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#98D1B2"];
    } else if ([ok[@"Viplevel"]intValue] < 40) {
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#FFC57F"];
    } else {
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#FF9D95"];
    }
    self.lvLabel.hidden = NO;
    self.coin.text = [NSString stringWithFormat:@"%d", [ok[@"Gold"] intValue]];
    self.coin.frame = CGRectMake(132, 16, [self.coin.text getLineSizeWithFont:[UIFont boldSystemFontOfSize:30]].width, 25);
}

- (void)clickCheckBtn:(UIButton *)btn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/signquest" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        if (backData[@"ok"] != nil) {
            [RBTipView tipWithTitle:@"签到成功" andExp:[backData[@"addexp"]intValue] andCoin:[backData[@"addcoin"]intValue]];
            // 签到成功
            NSDictionary *dict = backData;
            NSDictionary *okDic = dict[@"ok"];
            btn.enabled = ![okDic[@"Signtoday"]boolValue];
            self.check.text = [NSString stringWithFormat:@"已连续签到%d天", [okDic[@"Seqdays"]intValue]];
            self.checkBtn.enabled = NO;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)clickLoginBtn {
    UIViewController *currentVC = [UIViewController getCurrentVC];
    RBLoginVC *loginVC = [[RBLoginVC alloc]init];
    loginVC.fromVC = [UIViewController getCurrentVC];
    [currentVC.navigationController pushViewController:loginVC animated:YES];
}

- (void)clickVipBtn {
    UIViewController *currentVC = [UIViewController getCurrentVC];
    RBHuiYuanVC *huiYuanVC = [[RBHuiYuanVC alloc]init];
    if (self.vip != 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(self.vipst) forKey:@"t"];
        [dict setValue:@(self.vip) forKey:@"vip"];
        huiYuanVC.dict = dict;
    }
    [currentVC.navigationController pushViewController:huiYuanVC animated:YES];
}

@end
