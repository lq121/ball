#import "RBHuiYuanVC.h"
#import "RBWKWebView.h"
#import "RBToast.h"
#import "RBNetworkTool.h"

@interface RBHuiYuanVC ()
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSDate *calculatedate;
@end

@implementation RBHuiYuanVC

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    int time = [dict[@"t"]intValue];
    int vip = [dict[@"vip"]intValue];
    int huiYanType = 1;
    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *now = [NSDate date];
    int nowTime = [now timeIntervalSince1970];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setMonth:vip];
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
    self.calculatedate = calculatedate;
    if (nowTime - [calculatedate timeIntervalSince1970] >= 0) {
        huiYanType = 3;
    } else {
        huiYanType = 2;
    }
    self.huiYanType = huiYanType;
    if (huiYanType == 1 || huiYanType == 0) {
        self.rightLab.hidden = YES;
        self.btn.hidden = NO;
        [self.submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
    } else if (huiYanType == 3) {
        self.rightLab.hidden = NO;
        self.rightLab.text = @"已失效";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        self.rightLab.backgroundColor = [UIColor colorWithSexadeString:@"#EDDEC0"];
        self.rightLab.textColor = [UIColor colorWithSexadeString:@"#8E5C00"];
        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:calculatedate andFormat:@"yyyy.MM.dd"]];
        self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
    } else if (huiYanType == 2) {
        self.rightLab.hidden = NO;
        self.rightLab.text = @"使用中";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:calculatedate andFormat:@"yyyy.MM.dd"]];
        self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员权益";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#FEF4E1"];
    UIImageView *BgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip bg"]];
    BgView.frame = CGRectMake(16, 8, RBScreenWidth - 32, 147);
    BgView.layer.shadowColor = [UIColor colorWithSexadeString:@"#864900" AndAlpha:0.1].CGColor;
    BgView.layer.shadowOffset = CGSizeMake(0, 6);
    BgView.layer.shadowOpacity = 1.0;
    BgView.clipsToBounds = NO;

    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huangguan"]];
    icon.frame = CGRectMake(16, 19, 16, 16);
    [BgView addSubview:icon];

    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(37, 16, 120, 22)];
    tipLab.text = @"小应体育会员";
    tipLab.font = [UIFont boldSystemFontOfSize:16];
    tipLab.textColor = [UIColor colorWithSexadeString:@"#422E08"];
    [tipLab sizeToFit];
    [BgView addSubview:tipLab];

    UILabel *vipLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab.frame) + 4, 15, 42, 20)];
    vipLab.text = @"尊享版";
    vipLab.textAlignment = NSTextAlignmentCenter;
    vipLab.font = [UIFont boldSystemFontOfSize:12];
    vipLab.textColor = [UIColor colorWithSexadeString:@"#F3C46C"];
    vipLab.backgroundColor = [UIColor colorWithSexadeString:@"#422E08"];
    vipLab.layer.masksToBounds = YES;
    vipLab.layer.cornerRadius = 2;
    [BgView addSubview:vipLab];

    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 32 - 50 - 16, 14, 50, 24)];
    self.rightLab = rightLab;
    rightLab.textAlignment = NSTextAlignmentCenter;
    rightLab.text = @"使用中";
    rightLab.textColor = [UIColor colorWithSexadeString:@"#8E5C00"];
    rightLab.font = [UIFont systemFontOfSize:12];
    rightLab.backgroundColor = [UIColor colorWithSexadeString:@"#E1A73C"];
    rightLab.layer.masksToBounds = YES;
    rightLab.layer.cornerRadius = 12;
    [BgView addSubview:rightLab];

    UILabel *centerLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, RBScreenWidth - 64, 36)];
    NSString *str = @"30 元/月";
    centerLab.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range1 = NSMakeRange(0, 3);
    NSRange range2 = NSMakeRange(3, str.length - 3);
    [attr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:30], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#422E08"] } range:range1];
    [attr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#422E08"] } range:range2];
    centerLab.attributedText = attr;
    [BgView addSubview:centerLab];

    UILabel *tipLab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(centerLab.frame) + 2, RBScreenWidth - 64, 22)];
    tipLab2.text = @"享680金币套餐优惠";
    tipLab2.textAlignment = NSTextAlignmentCenter;
    tipLab2.textColor = [UIColor colorWithSexadeString:@"#422E08"];
    tipLab2.font = [UIFont systemFontOfSize:16];
    [BgView addSubview:tipLab2];

    UIView *leftLine = [[UIView alloc]init];
    leftLine.backgroundColor =  [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.1];
    leftLine.frame = CGRectMake(12, 131,  (RBScreenWidth - 32 - 24 - 100) * 0.5, 1);
    [BgView addSubview:leftLine];

    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"VIP SERVICE";
    label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.2];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(CGRectGetMaxX(leftLine.frame), 123, 100, 17);
    [BgView addSubview:label];
    self.label = label;

    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor =  [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.1];
    rightLine.frame = CGRectMake(CGRectGetMaxX(label.frame), 131,  (RBScreenWidth - 32 - 24 - 100) * 0.5, 1);
    [BgView addSubview:rightLine];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(BgView.frame), RBScreenWidth - 48, 221)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, RBScreenWidth - 48, 221) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(8, 8)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, RBScreenWidth - 48, 221);
    maskLayer.path = maskPath.CGPath;
    bgView.layer.mask = maskLayer;
    bgView.backgroundColor = [UIColor colorWithSexadeString:@"#FFEBC5"];
    [self.view addSubview:bgView];
    [self.view addSubview:BgView];

    UIImageView *left_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanyi zhuangshi"]];
    left_icon.frame = CGRectMake((RBScreenWidth - 48 - 64 - 30) * 0.5, 32, 13, 10);
    [bgView addSubview:left_icon];

    UILabel *label2 = [[UILabel alloc]init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"专享权益";
    label2.textColor =  [UIColor colorWithSexadeString:@"#422E08"];
    label2.font = [UIFont boldSystemFontOfSize:16];
    label2.frame = CGRectMake(CGRectGetMaxX(left_icon.frame) + 2, 25, RBScreenWidth - 48, 22);
    [label2 sizeToFit];
    [bgView addSubview:label2];

    UIImageView *right_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanyi zhuangshi"]];
    right_icon.frame = CGRectMake(CGRectGetMaxX(label2.frame) + 2, 32, 13, 10);
    [bgView addSubview:right_icon];

    NSArray *array = @[@"昵称红名", @"独享情报", @"免广告", @"尊贵身份", @"380金币道具", @"改名无限制"];
    NSArray *icons = @[@"nickname", @"news", @"no ad", @"vip id", @"gift", @"change free"];
    CGFloat width = (RBScreenWidth - 50) / 3;
    CGFloat height = 80;
    for (int i = 0; i < array.count; i++) {
        CGFloat x = i % 3 * width;
        CGFloat y = i / 3 * (height) + 59;
        [bgView addSubview:[self createTipViewWithFrame:CGRectMake(x, y, width, height) AndImage:[NSString stringWithFormat:@"tequan／%@", icons[i]] andTitle:array[i]]];
    }

    CGSize size = [@"开通会员视为同意小应体育的《充值协议》" getLineSizeWithFontSize:12];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake((RBScreenWidth - size.width - 9) * 0.5, RBScreenHeight - 78 - 24 - RBNavBarAndStatusBarH - RBBottomSafeH, 24, 24);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"choose agree"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"choose agree-selected"] forState:UIControlStateSelected];
    self.btn = btn;
    [self.view addSubview:btn];

    UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 2, RBScreenHeight - 78 - 21 - RBNavBarAndStatusBarH - RBBottomSafeH, size.width, 17)];
    self.tipBtn = tipBtn;
    [tipBtn setTitle:@"开通会员视为同意小应体育的《充值协议》" forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn setTitleColor:[UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.6] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipBtn];

    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBScreenHeight - 78 - RBNavBarAndStatusBarH - RBBottomSafeH, RBScreenWidth - 32, 68)];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn vip"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
    [submitBtn setTitleColor:[UIColor colorWithSexadeString:@"#F3C46C"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

    if (self.huiYanType == 1 || self.huiYanType == 0) {
        self.rightLab.hidden = YES;
        [self.submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
    } else if (self.huiYanType == 3) {
        self.rightLab.hidden = NO;
        self.rightLab.backgroundColor = [UIColor colorWithSexadeString:@"#EDDEC0"];
        self.rightLab.textColor = [UIColor colorWithSexadeString:@"#8E5C00"];
        self.rightLab.text = @"已失效";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:self.calculatedate andFormat:@"yyyy.MM.dd"]];
        self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
    } else if (self.huiYanType == 2) {
        self.rightLab.hidden = NO;
        self.rightLab.text = @"使用中";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:self.calculatedate andFormat:@"yyyy.MM.dd"]];
        self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changevip:) name:@"changevip" object:nil];
}

- (void)changevip:(NSNotification *)noti {
    NSDictionary *backData = noti.object;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:backData[@"ok"][@"t"] forKey:@"t"];
    [dict setValue:backData[@"ok"][@"vip"] forKey:@"vip"];
    self.dict = dict;
    if (backData[@"ok"][@"vip"] != 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@([backData[@"ok"][@"t"] intValue]) forKey:@"t"];
        [dict setValue:@([backData[@"ok"][@"vip"] intValue]) forKey:@"vip"];
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"vipDict"];
        [[NSUserDefaults standardUserDefaults]setObject:@(2) forKey:@"isVip"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (UIView *)createTipViewWithFrame:(CGRect)frame AndImage:(NSString *)image andTitle:(NSString *)title {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imageView.frame = CGRectMake((frame.size.width - 32) * 0.5, 12, 32, 32);
    [view addSubview:imageView];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 4, frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithSexadeString:@"#422E08"];
    [view addSubview:label];
    return view;
}

- (void)clickBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)clickTipBtn:(UIButton *)btn {
    RBWKWebView *webVC = [[RBWKWebView alloc]init];
    webVC.url = @"hios/deposit-policy.html";
    webVC.title = @"充值协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickSubmitBtn {
    if (self.btn.selected == NO) {
        [RBToast showWithTitle:@"请先阅读并同意协议和政策"];
        return;
    } else {
        [RBNetworkTool orderWithJsonDic:[NSMutableDictionary dictionary] Type:ToolApiAppleDisburse andStyle:7 Result:^(NSDictionary *backData, MoneyStatus status, NSError *error) {
            if (error != nil || backData[@"err"] != nil) {
                [RBToast showWithTitle:@"下单失败" ];
            }
        }];
    }
}

@end
