#import "RBDengJiVC.h"
#import "RBDengJiModel.h"
#import "RBDengjiCollView.h"
#import "RBTabBarVC.h"
#import "RBChongZhiVC.h"
#import "RBHuiYuanVC.h"
#import "RBDengjiDesTabVC.h"

@interface RBDengJiVC ()
@end

@implementation RBDengJiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *experienceArr = @[@(0), @(10), @(55), @(145), @(290), @(500), @(785), @(1155), @(1620), @(2285), @(3248), @(4607), @(6460), @(8905), @(12040), @(15963), @(20772), @(26565), @(33440), @(42315), @(53689), @(68061), @(85930), @(107795), @(134155), @(165509), @(202356), @(245195), @(294525), @(353855), @(425182), @(510503), @(611815), @(731115), @(870400), @(1031667), @(1216913), @(1428135), @(1667330), @(1936525), @(2245716), @(2604899), @(3024070), @(3513225), @(4082360), @(4741471), @(5500554), @(6369605), @(7358620), @(8477635)];
    self.title = @"我的等级";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(279, 31, 80, 40);
    [btn setTitle:@"等级说明表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 175)];
    bgView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:bgView];

    UIImageView *Bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip blue bg"]];
    Bg.frame = CGRectMake(16, 8, RBScreenWidth - 32, 175);
    [bgView addSubview:Bg];

    UIImageView *king = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"king"]];
    king.frame = CGRectMake((RBScreenWidth - 32 - 48) * 0.5, 18, 48, 33);
    [Bg addSubview:king];

    UILabel *lv = [[UILabel alloc]init];
    lv.textAlignment = NSTextAlignmentCenter;
    lv.textColor = [UIColor colorWithSexadeString:@"FFCB00"];
    lv.font = [UIFont systemFontOfSize:16];
    lv.text = [NSString stringWithFormat:@"Lv.%d", self.lv];
    [Bg addSubview:lv];
    lv.frame = CGRectMake(0, CGRectGetMaxY(king.frame) + 2, RBScreenWidth - 32, 22);

    UILabel *lv2 = [[UILabel alloc]init];
    lv2.textAlignment = NSTextAlignmentCenter;
    lv2.textColor = [UIColor whiteColor];
    lv2.font = [UIFont systemFontOfSize:14];
    [Bg addSubview:lv2];
    lv2.text = [NSString stringWithFormat:@"还差%d点升级Lv.%d", [experienceArr[self.lv]intValue] - self.exp, self.lv + 1];
    lv2.frame = CGRectMake(0, CGRectGetMaxY(lv.frame) + 24, RBScreenWidth - 32, 20);

    UIProgressView *progressView = [[UIProgressView alloc]init];
    progressView.frame = CGRectMake(22, CGRectGetMaxY(lv2.frame) + 8, RBScreenWidth - 32 - 44, 8);
    progressView.progressTintColor = [UIColor colorWithSexadeString:@"#FFCB00"];
    progressView.trackTintColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    if (self.exp > 0) {
        progressView.progress = (self.exp * 100.0) / ([experienceArr[self.lv]intValue] * 100.0);
    } else {
        progressView.progress = 0;
    }

    progressView.transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    [Bg addSubview:progressView];
    progressView.layer.masksToBounds = true;
    progressView.layer.cornerRadius = 4;

    UILabel *lv3 = [[UILabel alloc]init];
    lv3.textAlignment = NSTextAlignmentRight;
    lv3.textColor = [UIColor colorWithSexadeString:@"#FFCB00"];
    lv3.font = [UIFont systemFontOfSize:12];
    [Bg addSubview:lv3];
    lv3.text = [NSString stringWithFormat:@"%d/%d", self.exp, [experienceArr[self.lv]intValue]];
    lv3.frame = CGRectMake(22, CGRectGetMaxY(progressView.frame) + 4, RBScreenWidth - 32 - 44, 17);

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 175, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 175)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.shadowColor = [UIColor colorWithSexadeString:@"#000000" AndAlpha:0.1].CGColor;
    whiteView.layer.shadowOffset = CGSizeMake(0, -4);
    whiteView.layer.shadowOpacity = 1;
    whiteView.layer.shadowRadius = 6;
    [self.view addSubview:whiteView];

    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    [whiteView addSubview:tipLabel];
    tipLabel.text = @"如何快速升级";
    tipLabel.frame = CGRectMake(0, 24, RBScreenWidth, 22);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(8, 17, 8, 17);
    layout.minimumInteritemSpacing = 0;

    NSArray *tips = @[@"每日签到", @"每日分享", @"消费金币", @"充值金币", @"购买会员", @"期待更多..."];
    NSArray *des = @[@"完成每日签到送送送", @"每次可获得奖励", @"非会员改昵称/购买分析", @"送等额奖励", @"奖励爽翻天", @""];
    NSArray *icons = @[@"sign", @"gift", @"buy", @"wallet2", @"vip", @""];
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < tips.count; i++) {
        RBDengJiModel *model = [[RBDengJiModel alloc]init];
        model.title = tips[i];
        model.des = des[i];
        model.icon = icons[i];
        if (i == tips.count - 1) {
            model.isOther = true;
        }
        [models addObject:model];
    }
    RBDengjiCollView *collectionView = [[RBDengjiCollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame) + 16, RBScreenWidth, 105 * 3 + 40) collectionViewLayout:layout andmodels:models andClickItem:^(NSInteger index) {
        UIViewController *currentVC =  [UIViewController getCurrentVC];
        if (index == 0) {
            [currentVC.navigationController popViewControllerAnimated:YES];
        } else if (index == 1 || index == 2) {
            [currentVC.navigationController popViewControllerAnimated:NO];
            RBTabBarVC *tabBarVC = (RBTabBarVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
            tabBarVC.selectedIndex = 3;
        } else if (index == 3) {
            // 钱包
            RBChongZhiVC *chongZhiVC = [[RBChongZhiVC alloc]init];
            int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
            chongZhiVC.coinCount = coinCount;
            [currentVC.navigationController pushViewController:chongZhiVC animated:YES];
        } else if (index == 4) {
            UIViewController *currentVC = [UIViewController getCurrentVC];
            RBHuiYuanVC *huiYuanVC = [[RBHuiYuanVC alloc]init];
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"vipDict"];
            if (dict != nil) {
                huiYuanVC.dict = dict;
            }
            [currentVC.navigationController pushViewController:huiYuanVC animated:YES];
        }
    }];
    [whiteView addSubview:collectionView];
    [collectionView reloadData];
}

- (void)clickBtn {
    [self.navigationController pushViewController:[[RBDengjiDesTabVC alloc]init] animated:YES];
}

@end
