#import "RBAIForecastVC.h"
#import "RBPredictTableVC.h" // 预测
#import "RBIntelligenceVC.h" // 情报
#import "RBPlateTabVC.h" // 亚盘
#import "RBCompensateTabVC.h" // 欧赔
#import "RBSizeTableVC.h" // 大小
#import "RBNetworkTool.h"
#import "RBCompany.h"
#import "RBAiDataModel.h"

@interface RBAIForecastVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RBPredictTableVC *predictVC;
@property (nonatomic, strong) RBIntelligenceVC *intelligenceVC;
@property (nonatomic, strong) RBPlateTabVC *plateTabVC;
@property (nonatomic, strong) RBCompensateTabVC *compensateTabVC;
@property (nonatomic, strong) RBSizeTableVC *sizeTableVC;
@property (nonatomic, strong) NSMutableArray *sizeArr;
@property (nonatomic, strong) NSMutableArray *europeArr;
@property (nonatomic, strong) NSMutableArray *secondArr;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation RBAIForecastVC

- (NSMutableArray *)sizeArr {
    if (_sizeArr == nil) {
        _sizeArr = [NSMutableArray array];
    }
    return _sizeArr;
}

- (NSMutableArray *)europeArr {
    if (_europeArr == nil) {
        _europeArr = [NSMutableArray array];
    }
    return _europeArr;
}

- (NSMutableArray *)secondArr {
    if (_secondArr == nil) {
        _secondArr = [NSMutableArray array];
    }
    return _secondArr;
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    self.predictVC.biSaiModel = biSaiModel;
    self.intelligenceVC.biSaiModel = biSaiModel;
    self.predictVC.matchId = biSaiModel.namiId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.predictVC = [[RBPredictTableVC alloc]init];
    self.predictVC.biSaiModel = self.biSaiModel;
    self.intelligenceVC = [[RBIntelligenceVC alloc]init];
    self.plateTabVC = [[RBPlateTabVC alloc]init];
    self.compensateTabVC = [[RBCompensateTabVC alloc]init];
    self.sizeTableVC = [[RBSizeTableVC alloc]init];
    self.intelligenceVC.biSaiModel = self.biSaiModel;
    self.predictVC.matchId = self.biSaiModel.namiId;
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];

    NSArray *array;
    if (isVip == 2) {
        array = @[self.predictVC, self.intelligenceVC, self.plateTabVC, self.compensateTabVC, self.sizeTableVC];
    } else {
        array = @[self.predictVC, self.plateTabVC, self.compensateTabVC, self.sizeTableVC];
    }

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 32, RBScreenWidth, RBScreenHeight - 184 - 44 - RBBottomSafeH - 32 - RBStatusBarH)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(array.count * RBScreenWidth, RBScreenHeight - 184 - 44 - RBBottomSafeH - 32);
    [self.view addSubview:self.scrollView];

    for (int i = 0; i < array.count; i++) {
        UIViewController *viewCtrl = array[i];
        [self addChildViewController:viewCtrl];
        UIView *view = viewCtrl.view;
        view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        view.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - 184 - 44 - RBBottomSafeH - 32 - RBStatusBarH);
        [self.scrollView addSubview:view];
        if ([viewCtrl isKindOfClass:[RBPredictTableVC class]]) {
            UILabel *tipLabel = [[UILabel alloc]init];
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.text = @"以专业的大数据视角解读比赛胜负";
            tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
            tipLabel.frame = CGRectMake(0, view.height - 50, RBScreenWidth, 17);
            tipLabel.font = [UIFont systemFontOfSize:12];
            [view addSubview:tipLabel];
        }
    }

    [self setupHeadView];
    [self getData];
}

- (void)getData {
    NSArray *idArr = @[@(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10), @(11), @(12), @(13), @(14), @(15), @(16), @(17), @(18), @(19), @(21), @(22)];
    NSArray *NameArr = @[@"BET365", @"皇冠", @"10BET", @"立博", @"明陞", @"澳彩", @"SNAI", @"威廉希尔", @"易胜博", @"韦德", @"EuroBet", @"Inter wetten", @"12bet", @"利记", @"盈禾", @"18Bet", @"Fun88", @"竞彩官方", @"188", @"平博"];
    NSMutableArray *compsArr = [NSMutableArray array];
    for (int i = 0; i < idArr.count; i++) {
        RBCompany *company = [[RBCompany alloc]init];
        company.ID = [idArr[i]intValue];
        company.name_zh = NameArr[i];
        [compsArr addObject:company];
    }

    // 获取即时指数
    NSDictionary *dict3 = @{ @"matchid": @(self.biSaiModel.namiId) };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballoddhistory" andParam:dict3 Success:^(NSDictionary *_Nonnull backDataDic) {
        if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        for (int i = 0; i < compsArr.count; i++) {
            RBCompany *company = compsArr[i];
            NSString *key = [NSString stringWithFormat:@"%ld", company.ID];
            NSArray *bsArr = backData[key][@"bs"];   // 大小
            if (bsArr.count != 0) {
                RBAiDataModel *model = [[RBAiDataModel alloc]init];
                model.company = company.name_zh;
                model.secondHostBall = [bsArr[0][2] doubleValue];
                model.secondCenterBall = [bsArr[0][3] doubleValue];
                model.secondVisiterBall = [bsArr[0][4] doubleValue];
                model.firstHostBall = [bsArr[bsArr.count - 1][2] doubleValue];
                model.firstCenterBall = [bsArr[bsArr.count - 1][3] doubleValue];
                model.firstVisiterBall = [bsArr[bsArr.count - 1][4] doubleValue];
                [self.sizeArr addObject:model];
            }

            NSArray *asiaArr = backData[key][@"asia"];    // 亚盘
            if (asiaArr.count != 0) {
                RBAiDataModel *model2 = [[RBAiDataModel alloc]init];
                model2.company = company.name_zh;
                model2.secondHostBall = [asiaArr[0][2] doubleValue];
                model2.secondCenterBall = [asiaArr[0][3] doubleValue];
                model2.secondVisiterBall = [asiaArr[0][4] doubleValue];
                model2.firstHostBall = [asiaArr[asiaArr.count - 1][2] doubleValue];
                model2.firstCenterBall = [asiaArr[asiaArr.count - 1][3] doubleValue];
                model2.firstVisiterBall = [asiaArr[asiaArr.count - 1][4] doubleValue];
                [self.secondArr addObject:model2];
            }
            NSArray *euArr = backData[key][@"eu"];    // 欧赔
            if (euArr.count != 0) {
                RBAiDataModel *model3 = [[RBAiDataModel alloc]init];
                model3.company = company.name_zh;
                model3.secondHostBall = [euArr[0][2] doubleValue];
                model3.secondCenterBall = [euArr[0][3] doubleValue];
                model3.secondVisiterBall = [euArr[0][4] doubleValue];

                model3.firstHostBall = [euArr[euArr.count - 1][2] doubleValue];
                model3.firstCenterBall = [euArr[euArr.count - 1][3] doubleValue];
                model3.firstVisiterBall = [euArr[euArr.count - 1][4] doubleValue];
                [self.europeArr addObject:model3];
            }
        }
        self.sizeTableVC.sizeArr = self.sizeArr;
        self.plateTabVC.plateArr = self.secondArr;
        self.compensateTabVC.europeArr = self.europeArr;
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setupHeadView {
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    NSArray *titles;
    if (isVip == 2) {
        titles = @[yuce, qingbaoStr, @"亚盘", @"欧赔", @"大小"];
    } else {
        titles = @[yuce, @"亚盘", @"欧赔", @"大小"];
    }

    CGFloat heigth = 32;
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, heigth)];
    selectView.backgroundColor = [UIColor colorWithSexadeString:@"#ffffff" AndAlpha:0.6];
    CGFloat width = (RBScreenWidth - 30) / titles.count;
    self.selectView = selectView;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15 + i * width, 0, width, heigth)];
        btn.backgroundColor = [UIColor colorWithSexadeString:@"#ffffff" AndAlpha:0.6];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 200 + i;
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            [self clickCheckBtn:btn];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:selectView];
}

- (void)clickCheckBtn:(UIButton *)btn {
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    long index = btn.tag - 200;
    if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
        return;
    } else {
        self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
    }
}

- (void)clickinde {
    UIButton *btn = [self.selectView viewWithTag:200];
    [self clickCheckBtn:btn];
}

@end
