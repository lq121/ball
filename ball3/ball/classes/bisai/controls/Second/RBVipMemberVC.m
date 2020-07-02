#import "RBVipMemberVC.h"
#import "RBToast.h"
#import "RBWKWebView.h"
#import "RBTipView.h"
#import "RBTabBarVC.h"
#import "RBNavigationVC.h"
#import "RBWoTabVC.h"
#import "RBWKWebView.h"
#import "RBVipTipView.h"
#import "RBNetworkTool.h"


@interface RBVipMemberVC ()
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSDate *calculatedate;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) int vipType;
@end

@implementation RBVipMemberVC
- (void)viewDidLoad {
    [super viewDidLoad];
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
    vipLab.font = [UIFont systemFontOfSize:12];
    vipLab.textColor = [UIColor colorWithSexadeString:@"#F3C46C"];
    vipLab.backgroundColor = [UIColor colorWithSexadeString:@"#422E08"];
    vipLab.layer.masksToBounds = YES;
    vipLab.layer.cornerRadius = 2;
    [BgView addSubview:vipLab];

    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 32 - 50 - 16, 14, 50, 24)];
    self.rightLab = rightLab;
    rightLab.textAlignment = NSTextAlignmentCenter;
    rightLab.text = @"使用中";
    rightLab.hidden = YES;
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

    UILabel *tipLab2 = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(centerLab.frame) + 2, RBScreenWidth - 32, 22)];
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
    self.label = label;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"VIP SERVICE";
    label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.2];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(CGRectGetMaxX(leftLine.frame), 123, 100, 17);
    [BgView addSubview:label];

    UIView *rightLine = [[UIView alloc]init];
    rightLine.backgroundColor =  [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.1];
    rightLine.frame = CGRectMake(CGRectGetMaxX(label.frame), 131,  (RBScreenWidth - 32 - 24 - 100) * 0.5, 1);
    [BgView addSubview:rightLine];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(24, CGRectGetMaxY(BgView.frame) - 10, RBScreenWidth - 48, 126)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, RBScreenWidth - 48, 126) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(2, 2)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, RBScreenWidth - 48, 126);
    maskLayer.path = maskPath.CGPath;
    bgView.layer.mask = maskLayer;
    bgView.backgroundColor = [UIColor colorWithSexadeString:@"#FFEBC5"];
    [self.view addSubview:bgView];

    UIImageView *left_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanyi zhuangshi"]];
    left_icon.frame = CGRectMake((RBScreenWidth - 48 - 64 - 30) * 0.5, 22, 13, 10);
    [bgView addSubview:left_icon];

    UILabel *label2 = [[UILabel alloc]init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"专享权益";
    label2.textColor =  [UIColor colorWithSexadeString:@"#422E08"];
    label2.font = [UIFont boldSystemFontOfSize:16];
    label2.frame = CGRectMake(CGRectGetMaxX(left_icon.frame) + 2, 16, RBScreenWidth - 48, 22);
    [label2 sizeToFit];
    [bgView addSubview:label2];

    UIImageView *right_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanyi zhuangshi"]];
    right_icon.frame = CGRectMake(CGRectGetMaxX(label2.frame) + 2, 22, 13, 10);
    [bgView addSubview:right_icon];

    NSArray *array = @[@"昵称红名", @"独享情报", @"免广告", @"尊贵身份", @"380金币道具", @"改名无限制"];
    NSArray *icons = @[@"nickname", @"news", @"no ad", @"vip id", @"gift", @"change free"];
    CGFloat width = (RBScreenWidth - 45) / 3;
    CGFloat height = 24;
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#422E08"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tequan／%@", icons[i]]] forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGFloat x = i % 3 * width + 10;
        CGFloat y = i / 3 * (height + 8) + CGRectGetMaxY(label2.frame) + 16;
        btn.frame = CGRectMake(x, y, width, height);
        [bgView addSubview:btn];
    }
    [self.view addSubview:BgView];

    CGSize size = [@"开通会员视为同意小应体育的《充值协议》" getLineSizeWithFontSize:12];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake((RBScreenWidth - size.width - 2 - 24) * 0.5, RBScreenHeight - 78 - 24 - RBStatusBarH - 184 - 44 - RBBottomSafeH, 24, 24);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"choose agree"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"choose agree-selected"] forState:UIControlStateSelected];
    self.btn = btn;
    [self.view addSubview:btn];

    UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 2, RBScreenHeight - 78 - 21 - RBStatusBarH - 184 - 44 - RBBottomSafeH, size.width, 17)];
    self.tipBtn = tipBtn;
    [tipBtn setTitle:@"开通会员视为同意小应体育的《充值协议》" forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn setTitleColor:[UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.6] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipBtn];

    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBScreenHeight - 78 - RBStatusBarH - 184 - 44 - RBBottomSafeH, RBScreenWidth - 32, 68)];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn vip"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
    [submitBtn setTitleColor:[UIColor colorWithSexadeString:@"#F3C46C"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    int vipType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    self.vipType = vipType;
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"vipDict"];
    if (dict != nil) {
        int time = [dict[@"t"]intValue];
        int vip = [dict[@"vip"]intValue];
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:time];
        NSDate *now = [NSDate date];
        int nowTime = [now timeIntervalSince1970];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *datecomps = [[NSDateComponents alloc] init];
        [datecomps setMonth:vip];
        ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
        NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
        self.calculatedate = calculatedate;
        if (nowTime - [calculatedate timeIntervalSince1970] >= 0) {
            vipType = 3;
        } else {
            vipType = 2;
        }
        if (vipType == 1 || vipType == 0) {
            self.rightLab.hidden = YES;
            [self.submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
            btn.hidden = NO;
        } else if (vipType == 3) {
            self.rightLab.hidden = NO;
            self.rightLab.text = @"已失效";
            [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
            self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:self.calculatedate andFormat:@"yyyy.MM.dd"]];
            self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
        } else if (vipType == 2) {
            self.rightLab.hidden = NO;
            self.rightLab.text = @"使用中";
            [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
            self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:self.calculatedate andFormat:@"yyyy.MM.dd"]];
            self.label.textColor = [UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.8];
        }
    } else {
        if (self.vipType == 1 || self.vipType == 0) {
            rightLab.hidden = YES;
            [self.submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
        } else if (self.vipType == 3) {
            rightLab.hidden = NO;
            [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
            rightLab.text = @"已失效";
        } else if (self.vipType == 2) {
            self.rightLab.hidden = NO;
            self.rightLab.text = @"使用中";
            [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
            self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:self.calculatedate andFormat:@"yyyy.MM.dd"]];
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changevip:) name:@"changevip" object:nil];
}

- (void)changevip:(NSNotification *)noti {
    NSDictionary *backData = noti.object;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:backData[@"ok"][@"t"] forKey:@"t"];
    [dict setValue:backData[@"ok"][@"vip"] forKey:@"vip"];
    self.dict = dict;
    RBTabBarVC *tabVC = (RBTabBarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
    RBNavigationVC *nav = tabVC.childViewControllers[4];
    RBWoTabVC *woTabVC =  [nav.childViewControllers firstObject];
    [woTabVC getUserInfo];

    RBVipTipView *vipTipView = [[RBVipTipView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:vipTipView];
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

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    int time = [dict[@"t"]intValue];
    int vip = [dict[@"vip"]intValue];
    int vipType = 1;
    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *now = [NSDate date];
    int nowTime = [now timeIntervalSince1970];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setMonth:vip];
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
    self.calculatedate = calculatedate;
    if (nowTime - [calculatedate timeIntervalSince1970] >= 0) {
        vipType = 3;
    } else {
        vipType = 2;
    }
    self.vipType = vipType;
    if (vipType == 1) {
        self.rightLab.hidden = YES;
        [self.submitBtn setTitle:@"我要开通" forState:UIControlStateNormal];
    } else if (vipType == 3) {
        self.rightLab.hidden = NO;
        self.rightLab.text = @"已失效";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];

        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:calculatedate andFormat:@"yyyy.MM.dd"]];
    } else if (vipType == 2) {
        self.rightLab.hidden = NO;
        self.rightLab.text = @"使用中";
        [self.submitBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        self.label.text = [NSString stringWithFormat:@"%@ 到期", [NSString getStrWithDate:calculatedate andFormat:@"yyyy.MM.dd"]];
    }
}

@end
