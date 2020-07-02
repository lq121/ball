#import "RBChongZhiVC.h"
#import "RBWKWebView.h"
#import "RBToast.h"
#import "RBZiJinMingXiVC.h"
#import "RBNetworkTool.h"

@interface RBChongZhiVC ()
@property (assign, nonatomic, readwrite) long currentSelectIndex;
@property (nonatomic, strong) UILabel *jinBiLab;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *tipBtn;
@end

@implementation RBChongZhiVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 262 + RBTopDifHeight)];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    [self.view addSubview:headView];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"我的钱包";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:16];
    [headView addSubview:title];
    title.frame = CGRectMake(100, RBStatusBarH + 12, RBScreenWidth - 200, 25);

    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(RBScreenWidth - 84 - 16, RBStatusBarH + 14.5, 84, 22);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitle:@"资金明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithSexadeString:@"#36C8B9"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
   

    UIImageView *row = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info"]];
    [rightBtn addSubview:row];
    row.frame = CGRectMake(74, 6, 10, 10);
    [headView addSubview:rightBtn];

    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, RBStatusBarH - 1.5, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];

    UILabel *jinBiLab = [[UILabel alloc]init];
    self.jinBiLab = jinBiLab;
    jinBiLab.text = [NSString stringWithFormat:@"%d", self.coinCount];
    jinBiLab.textAlignment = NSTextAlignmentCenter;
    jinBiLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
    jinBiLab.font = [UIFont boldSystemFontOfSize:50];
    [headView addSubview:jinBiLab];
    jinBiLab.frame = CGRectMake(0, RBStatusBarH + 68, RBScreenWidth, 58);

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCoinCount) name:@"changeCoinCount" object:nil];
    int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
    self.jinBiLab.text = [NSString stringWithFormat:@"%d", coinCount];

    UILabel *coinTipLabel = [[UILabel alloc]init];
    coinTipLabel.text = @"金币数量";
    coinTipLabel.textAlignment = NSTextAlignmentCenter;
    coinTipLabel.textColor = [UIColor whiteColor];
    coinTipLabel.font = [UIFont boldSystemFontOfSize:12];
    [headView addSubview:coinTipLabel];
    coinTipLabel.frame = CGRectMake(0, CGRectGetMaxY(jinBiLab.frame) + 4, RBScreenWidth, 17);

    UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(16, 208 + RBTopDifHeight, RBScreenWidth - 32, 281)];
    whiteVeiw.backgroundColor = [UIColor whiteColor];
    whiteVeiw.layer.masksToBounds = true;
    whiteVeiw.layer.cornerRadius = 2;
    [self.view addSubview:whiteVeiw];

    UILabel *topupLabel = [[UILabel alloc]init];
    topupLabel.text = @"充值数量";
    topupLabel.textAlignment = NSTextAlignmentLeft;
    topupLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    topupLabel.font = [UIFont boldSystemFontOfSize:16];
    topupLabel.frame = CGRectMake(16, 16, RBScreenWidth * 0.5, 17);
    [whiteVeiw addSubview:topupLabel];

    NSArray *coins = @[@6, @98, @198, @698, @998, @1998];
    for (int i = 0; i < coins.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = (RBScreenWidth - 64 - 7) * 0.5;
        CGFloat height = 67;
        if (i % 2 == 0) {
            x = 16;
        } else {
            x = 16 + 7 + width;
        }
        y = (i / 2) * (74) + CGRectGetMaxY(topupLabel.frame) + 16;
        btn.frame = CGRectMake(x, y, width, height);
        [btn setBackgroundImage:[UIImage imageNamed:@"Unchoose"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"choose blue"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"choose blue"] forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
            self.currentSelectIndex = 0;
        }
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
        label1.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 5, 7, 100, 26);
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
        [whiteVeiw addSubview:btn];
    }

    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(whiteVeiw.frame) + 16, RBScreenWidth - 32, 90)];
    tipLabel.text = @"1. 充值金币即赠送相关经验值，可提升等级身份\n2. 充值成功后，有可能会延迟显示，需要缓冲时间，请耐心等待\n3. 如充值始终无法到账，可联系QQ：2484275675";
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor colorWithSexadeString:@"#484848" AndAlpha:0.6];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipLabel.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipLabel.text length])];
    [tipLabel setAttributedText:attributedString1];
    [tipLabel sizeToFit];
    [self.view addSubview:tipLabel];
    
    CGSize size = [@"支付订单视为同意小应体育的《充值协议》" getLineSizeWithFontSize:12];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake((RBScreenWidth - size.width - 9) * 0.5, RBScreenHeight - 48 - 28 - 21 - RBBottomSafeH, 24, 24);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"choose agree"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"choose agree-selected"] forState:UIControlStateSelected];
    self.btn = btn;
    [self.view addSubview:btn];

    UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 2, RBScreenHeight - 48 - 24 - 21 - RBBottomSafeH, size.width, 17)];
    self.tipBtn = tipBtn;
    [tipBtn setTitle:@"支付订单视为同意小应体育的《充值协议》" forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(clickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tipBtn setTitleColor:[UIColor colorWithSexadeString:@"#422E08" AndAlpha:0.6] forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:tipBtn];
    

    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBScreenHeight - 24 - 48 - RBBottomSafeH, RBScreenWidth - 32, 48)];
    [rechargeBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [rechargeBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(clickRechargeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
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

- (void)changeCoinCount {
    int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
    self.jinBiLab.text = [NSString stringWithFormat:@"%d", coinCount];
}

- (void)clickRechargeBtn {
    if (self.btn.selected == NO) {
        [RBToast showWithTitle:@"请先阅读并同意协议和政策"];
        return;
    }
    [RBNetworkTool orderWithJsonDic:[NSMutableDictionary dictionary] Type:ToolApiAppleDisburse andStyle:(int)self.currentSelectIndex + 1 Result:^(NSDictionary *backData, MoneyStatus status, NSError *error) {
               if (error != nil || backData[@"err"] != nil) {
                   [RBToast showWithTitle:@"下单失败" ];
               }
           }];
}

- (void)clickCoinBtn:(UIButton *)btn {
    UIButton *selectBtn = [self.view viewWithTag:20 + self.currentSelectIndex];
    selectBtn.selected = NO;
    btn.selected = YES;
    self.currentSelectIndex = (int)btn.tag - 20;
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBtn {
    [self.navigationController pushViewController:[[RBZiJinMingXiVC alloc]init] animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
