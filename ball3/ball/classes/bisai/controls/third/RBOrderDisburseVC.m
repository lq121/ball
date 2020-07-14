#import "RBOrderDisburseVC.h"
#import "RBChongZhiVC.h"
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBWKWebView.h"
#import "RBNetworkTool.h"
#import "RBChongZhiVC.h"

@interface RBOrderDisburseVC ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *chostBtn;
@property (nonatomic, strong) UIButton *coinBtn;
@property (nonatomic, strong) UIButton *zhiFuBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *tipBtn;
@end

@implementation RBOrderDisburseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单支付";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIView *bigCenterView = [[UIView alloc]initWithFrame:CGRectMake(14, 16, RBScreenWidth - 28, RBScreenHeight - RBNavBarAndStatusBarH - 16 - 72)];
    bigCenterView.layer.shadowOpacity = 1;
    bigCenterView.layer.shadowRadius = 10;
    bigCenterView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    bigCenterView.layer.shadowOffset = CGSizeMake(0, -4);
    bigCenterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigCenterView];

    UILabel *titlab = [[UILabel alloc]init];
    titlab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    titlab.textAlignment = NSTextAlignmentCenter;
    titlab.font = [UIFont boldSystemFontOfSize:18];
    titlab.text = @"订单详情";
    titlab.frame = CGRectMake(0, 14,  RBScreenWidth - 32, 25);
    [bigCenterView addSubview:titlab];
    NSArray *arr = @[@"商品详情", @"商品类型", @"商品价格"];
    for (int i = 0; i < arr.count; i++) {
        UILabel *leftLab = [[UILabel alloc]init];
        leftLab.text = arr[i];
        leftLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.font = [UIFont systemFontOfSize:12];
        leftLab.frame = CGRectMake(16, 66 + i * 38, 50, 17);
        [bigCenterView addSubview:leftLab];

        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.text = arr[i];
        rightLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        rightLab.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            rightLab.text = [NSString stringWithFormat:@"%@VS%@", self.biSaiModel.hostTeamName, self.biSaiModel.visitingTeamName];
        } else if (i == 1) {
            rightLab.text = [NSString stringWithFormat:@"%@", self.biSaipredictModel.titleName];
        } else {
            rightLab.text = [NSString stringWithFormat:@"¥%d", self.biSaipredictModel.coin];
        }
        rightLab.textAlignment = NSTextAlignmentRight;
        [bigCenterView addSubview:rightLab];
        rightLab.frame = CGRectMake(72, 64 + i * 38, RBScreenWidth - 120, 22);
    }
    NSString *Packet = [[NSUserDefaults standardUserDefaults]objectForKey:@"Packet"];
    if (![Packet isEqualToString:@""] && Packet.length != 0) {
        UILabel *titlab2 = [[UILabel alloc]init];
        titlab2.textColor = [UIColor colorWithSexadeString:@"#333333"];
        titlab2.textAlignment = NSTextAlignmentLeft;
        titlab2.font = [UIFont boldSystemFontOfSize:16];
        titlab2.text = @"使用优惠券";
        titlab2.frame = CGRectMake(16, 177,  100, 22);
        [bigCenterView addSubview:titlab2];
        NSString *Packet = [[NSUserDefaults standardUserDefaults]objectForKey:@"Packet"];
        NSData *jsonData = [Packet dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];

        UILabel *titlab3 = [[UILabel alloc]init];
        titlab3.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
        titlab3.textAlignment = NSTextAlignmentRight;
        titlab3.font = [UIFont systemFontOfSize:12];
        titlab3.frame = CGRectMake(RBScreenWidth - 168, 177,  100, 22);
        [bigCenterView addSubview:titlab3];

        int disCount = 0;
        NSArray *arr2 = (NSArray *)dic;
        for (int i = 0; i < arr2.count; i++) {
            NSArray *ar = arr2[i];
            if ([ar[0] intValue] >= 10001 && [ar[0] intValue] < 20000) {
                disCount = [ar[1] intValue];
                break;
            }
        }
        titlab2.hidden = !(disCount > 0);
        titlab3.hidden = !(disCount > 0);
        titlab3.text = [NSString stringWithFormat:@"剩余%d张", disCount];

        int count = MIN(3, disCount);
        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(titlab2.frame) + 5 + i * 44, RBScreenWidth - 64, 44)];
            btn.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
            [bigCenterView addSubview:btn];
            if (i != count - 1) {
                UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 43, RBScreenWidth - 64, 1)];
                line1.backgroundColor =  [UIColor whiteColor];
                [btn addSubview:line1];
            }

            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 120, 44)];
            tip.text = @"0折优惠券";
            tip.font = [UIFont systemFontOfSize:14];
            tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
            [btn addSubview:tip];
            UIButton *choseBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 64 - 68, 10, 60, 24)];
            choseBtn.layer.masksToBounds = YES;
            choseBtn.layer.cornerRadius = 4;
            [choseBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            [choseBtn setTitle:@"已选择" forState:UIControlStateSelected];
            [choseBtn addTarget:self action:@selector(clickChoseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [choseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [choseBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateSelected];
            choseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            choseBtn.tag = 99 + i;
            [choseBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
            [choseBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateSelected];
            [btn addSubview:choseBtn];
            if (i == 0) {
                choseBtn.selected = YES;
                self.chostBtn = choseBtn;
            }
        }
    }

    UILabel *tip2 = [[UILabel alloc]init];
    tip2.textAlignment = NSTextAlignmentLeft;
    tip2.text = @"购买须知：\n分析的购买仅限于智能分析消费；一经售出不可退还；\n购彩有风险，分析结果可能与最终结果不同；活动解释权归小应体育平台所有。";
    tip2.font = [UIFont systemFontOfSize:12];
    tip2.numberOfLines = 0;
    tip2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    tip2.frame = CGRectMake(16, RBScreenHeight  - 72 - 61 - [tip2.text getSizeWithFontSize:12 andMaxWidth:RBScreenWidth - 64].height - 16 - RBNavBarAndStatusBarH - 30, RBScreenWidth - 64, [tip2.text getSizeWithFontSize:12 andMaxWidth:RBScreenWidth - 64].height);
    [bigCenterView addSubview:tip2];

    UIButton *btn = [[UIButton alloc]init];

    [btn addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"choose disagree2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"choose agree-selected"] forState:UIControlStateSelected];
    self.btn = btn;
    [bigCenterView addSubview:btn];

    NSString *str1 = @"支付订单视为同意小应体育的 ";
    NSString *str2 = @"《用户协议》";
    NSString *str3 = he;
    NSString *str4 = @"《隐私政策》";
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@", str1, str2, str3, str4];
    NSRange range1 = [str rangeOfString:str1];
    NSRange range2 = [str rangeOfString:str2];
    NSRange range3 = [str rangeOfString:str3];
    NSRange range4 = [str rangeOfString:str4];
    UITextView *textView = [[UITextView alloc] init];
    [bigCenterView addSubview:textView];
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentRight;

    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate = self;
    [bigCenterView addSubview:textView];
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0f] }];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333"] range:range1];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333"] range:range2];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333"] range:range3];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333"] range:range4];
    NSString *valueString1 = [[NSString stringWithFormat:@"first://%@", str2] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString3 = [[NSString stringWithFormat:@"second://%@", str4] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [mastring addAttribute:NSLinkAttributeName value:valueString1 range:range2];
    [mastring addAttribute:NSLinkAttributeName value:valueString3 range:range4];
    textView.attributedText = mastring;
    CGFloat contentHeight = [mastring boundingRectWithSize:CGSizeMake(RBScreenWidth - 64, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height + 40;
    textView.frame = CGRectMake(35,  CGRectGetMaxY(tip2.frame) + 16, RBScreenWidth - 64 - 35, contentHeight);
    btn.frame = CGRectMake(16,  CGRectGetMinY(textView.frame) + 17 * 0.5, 17, 17);

    UIView *BottomView = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBNavBarAndStatusBarH  - 72 - RBBottomSafeH, RBScreenWidth, 72 + RBBottomSafeH)];
    BottomView.backgroundColor = [UIColor whiteColor];
    BottomView.layer.cornerRadius = 2;
    BottomView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    BottomView.layer.shadowOffset = CGSizeMake(0, 2);
    BottomView.layer.shadowOpacity = 1;
    BottomView.layer.shadowRadius = 10;
    [self.view addSubview:BottomView];

    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.text = @"订单金额";
    tipLab.frame = CGRectMake(16, 12, 80, 17);
    [tipLab sizeToFit];
    [BottomView addSubview:tipLab];

    UIButton *coinBtn = [[UIButton alloc]init];
    self.coinBtn = coinBtn;
    coinBtn.userInteractionEnabled = NO;
    [coinBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    coinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    if (self.chostBtn == nil) {
        [coinBtn setTitle:[NSString stringWithFormat:@"¥%d", self.biSaipredictModel.coin] forState:UIControlStateNormal];
    } else {
        [coinBtn setTitle:[NSString stringWithFormat:@"¥%d", 0] forState:UIControlStateNormal];
    }
    coinBtn.frame = CGRectMake(16, 31, 120, 33);
    coinBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    coinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [BottomView addSubview:coinBtn];

    UIButton *zhiFuBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 168 - 16, 20, 168, 48)];
    [zhiFuBtn addTarget:self action:@selector(zhiFu) forControlEvents:UIControlEventTouchUpInside];
    self.zhiFuBtn = zhiFuBtn;
    [zhiFuBtn setBackgroundImage:[UIImage imageNamed:@"btn mid sure"] forState:UIControlStateNormal];
    [zhiFuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zhiFuBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateDisabled];
    [zhiFuBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    zhiFuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [BottomView addSubview:zhiFuBtn];
    if (self.chostBtn == nil) {
        [self.coinBtn setTitle:[NSString stringWithFormat:@"¥%d", self.biSaipredictModel.coin] forState:UIControlStateNormal];
    } else {
        [self.coinBtn setTitle:[NSString stringWithFormat:@"¥%d", 0] forState:UIControlStateNormal];
    }
    self.rechargeBtn.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeai) name:@"changeai" object:nil];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"first"]) {
        RBWKWebView *webVC = [[RBWKWebView alloc]init];
        webVC.title = yonghuxieyi;
        webVC.url = @"hios/user-policy.html";
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"second"]) {
        RBWKWebView *webVC = [[RBWKWebView alloc]init];
        webVC.url = @"hios/privacy-policy.html";
        webVC.title = yinsizhengce;
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    return YES;
}

- (void)changeai {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickTipBtn:(UIButton *)btn {
    self.btn.selected = !self.btn.selected;
}

- (void)clickRechargeBtn {
    RBChongZhiVC *chongZhiVC = [[RBChongZhiVC alloc]init];
    int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
    chongZhiVC.coinCount = coinCount;
    [self.navigationController pushViewController:chongZhiVC animated:YES];
}

- (void)clickChoseBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.chostBtn == btn) {
        self.chostBtn = nil;
    } else {
        self.chostBtn.selected = NO;
        btn.selected = YES;
        self.chostBtn = btn;
    }
    if (self.chostBtn == nil) {
        [self.coinBtn setTitle:[NSString stringWithFormat:@"¥%d", self.biSaipredictModel.coin] forState:UIControlStateNormal];
    } else {
        [self.coinBtn setTitle:[NSString stringWithFormat:@"¥%d", 0] forState:UIControlStateNormal];
    }
}

- (void)zhiFu {
    if (self.btn.selected == NO) {
        [RBToast showWithTitle:@"请先阅读并同意协议和政策"];
        return;
    }
    // 订单类型
    int index = 0;
    if ([self.biSaipredictModel.titleName isEqualToString:rangqiu]) {
        index = 1;
    } else if ([self.biSaipredictModel.titleName isEqualToString:shengpingfu]) {
        index = 2;
    } else {
        index = 3;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (self.chostBtn != nil) { // 使用优惠券直接支付
        [dict setValue:@(1) forKey:@"type"];
        [dict setValue:@(10001) forKey:@"propid"];
        [dict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"matchid"];
        [dict setValue:@(index) forKey:@"aitype"];
        NSString *bisaiTitle = self.biSaiModel.eventName;
        NSString *mark = [NSString stringWithFormat:@"%@VS%@%@", self.biSaiModel.hostTeamName, self.biSaiModel.visitingTeamName, [NSString getStrWithDateInt:self.biSaiModel.biSaiTime andFormat:@"yyyy-MM-dd HH:mm:ss"]];
        [dict setObject:bisaiTitle forKey:@"game"];
        [dict setObject:mark forKey:@"mark"];
        [self orderWithDict:dict];
    } else { // 不使用优惠券
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
        [mutDict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"matchid"];
        [mutDict setValue:@(index) forKey:@"aitype"];
        NSString *bisaiTitle = [NSString stringWithFormat:@"%@VS%@%@", self.biSaiModel.hostTeamName, self.biSaiModel.visitingTeamName, [NSString getStrWithDateInt:self.biSaiModel.biSaiTime andFormat:@"yyyy-MM-dd HH:mm:ss"]];
        [mutDict setObject:bisaiTitle forKey:@"game"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutDict options:0 error:0];
        NSString *mark = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setObject:mark forKey:@"mark"];
        [dict setValue:@(0) forKey:@"type"];
        // 苹果支付
        [RBNetworkTool orderWithJsonDic:[NSMutableDictionary dictionary] Type:ToolApiAppleDisburse andStyle:8 Result:^(NSDictionary *backData, MoneyStatus status, NSError *error) {
            if (error != nil || backData[@"err"] != nil) {
                [RBToast showWithTitle:@"下单失败" ];
            }
        }];
        
    }
}

- (void)orderWithDict:(NSDictionary *)dict {
    [RBNetworkTool PostDataWithUrlStr:@"apis/buyai2" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            NSString *Packet = [[NSUserDefaults standardUserDefaults]objectForKey:@"Packet"];
            NSData *jsonData = [Packet dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSMutableArray *arr2 = [NSMutableArray arrayWithArray:(NSArray *)dic];
            for (int i = 0; i < arr2.count; i++) {
                NSMutableArray *ar = [NSMutableArray arrayWithArray:arr2[i]];
                if ([ar[0] intValue] == 10001) {
                    if ([ar[1] intValue]  == 1) {
                        [arr2 removeObject:arr2[i]];
                    } else {
                        ar[1] = [NSString stringWithFormat:@"%d", [ar[1] intValue] - 1];
                        arr2[i] = ar;
                    }
                    break;
                }
            }
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr2 options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults]setObject:dataStr forKey:@"Packet"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
            coinCount  = coinCount - [self.coinBtn.currentTitle intValue];
            [[NSUserDefaults standardUserDefaults]setValue:@(coinCount) forKey:@"coinCount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [RBToast showWithTitle:@"购买成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

@end
