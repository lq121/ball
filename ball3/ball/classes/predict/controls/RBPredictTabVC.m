#import "RBPredictTabVC.h"
#import "RBNearCollectionCell.h"
#import "RBLoginVC.h"
#import "RBNetworkTool.h"
#import "RBMyPredictVC.h"
#import "RBBiSaiModel.h"
#import "RBNearCollectionView.h"
#import "RBPredictCell.h"
#import "RBPredictListTabVC.h"
#import "RBChekLogin.h"
#import "RBBiSaiDetailVC.h"

@interface RBPredictTabVC ()
@property (nonatomic, strong) RBNearCollectionCell *nearCollectionCell;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSMutableArray *nearpredictArr;
@property (nonatomic, strong) NSMutableArray *hotpredictArr;
@property (nonatomic, assign) int currentReP; // 热门
@property (nonatomic, assign) int currentJinP;// 近期
@property (nonatomic, assign) int currentReStyle;// 热门style
@property (nonatomic, assign) int currentJinStyle; // 近期style
@property (nonatomic, strong) UIButton *predictBtn;
@property (nonatomic, strong) UILabel *tipLab2;
@property (nonatomic, strong) NSTimer *timer;/// 定时器
@property (nonatomic, assign) BOOL show;
@end

@implementation RBPredictTabVC

- (NSMutableArray *)nearpredictArr {
    if (_nearpredictArr == nil) {
        _nearpredictArr = [NSMutableArray array];
    }
    return _nearpredictArr;
}

- (NSMutableArray *)hotpredictArr {
    if (_hotpredictArr == nil) {
        _hotpredictArr = [NSMutableArray array];
    }
    return _hotpredictArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithSexadeString:@"#213A4B"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    self.navigationItem.titleView = titleLabel;
    UIButton *myBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 56, 50)];
    [myBtn setTitle:@"我购买的" forState:UIControlStateNormal];
    [myBtn setTitleColor:[UIColor colorWithSexadeString:@"#36C8B9"] forState:UIControlStateNormal];
    myBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [myBtn addTarget:self action:@selector(clickMyBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:myBtn];
    if (self.tableView.contentOffset.y >= 40) {
        UIView *head = [[UIApplication sharedApplication].keyWindow viewWithTag:666];
        if (head != nil) {
            // 近期分析头部删除
            head.hidden = NO;
        }
        self.tableView.y = RBNavBarAndStatusBarH + 40;
    } else {
        self.tableView.y = RBNavBarAndStatusBarH;
    }
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIView *head = [[UIApplication sharedApplication].keyWindow viewWithTag:666];
    head.hidden = YES;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerRun {
    self.show = !self.show;
    if (self.hotpredictArr.count > 0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

/// 获取近期分析
- (void)getJinpredictData {
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [mutDict setValue:@(0) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getjinqiyuce2" andParam:mutDict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        self.currentJinStyle = [backData[@"s"]intValue];
        NSArray *arr = [RBPredictModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        if (self.currentJinP == 0) {
            [self.nearpredictArr removeAllObjects];
        }
        [self.nearpredictArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

/// 获取热门分析
- (void)getHotpredictData {
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [mutDict setValue:@(self.currentReP) forKey:@"p"];
    [mutDict setValue:@(self.currentReStyle) forKey:@"style"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getremenyuce" andParam:mutDict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        self.currentReStyle = [backData[@"s"]intValue];
        NSArray *arr = [RBPredictModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        if (self.currentReP == 0) {
            [self.hotpredictArr removeAllObjects];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.hotpredictArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)clickpredictBtn {
    RBPredictModel *predictModel = [self.nearpredictArr firstObject];
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
        detailTabVC.index = 2;
        detailTabVC.biSaiModel = [self predictModelTobiSaiModel:predictModel];
        [self.navigationController pushViewController:detailTabVC animated:YES];
    }
}

- (void)clickMyBtn:(UIButton *)btn {
    RBMyPredictVC *myPredictVC = [[RBMyPredictVC alloc]init];
    [self.navigationController pushViewController:myPredictVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentReP = 0;
    self.currentJinP = 0;
    self.currentReStyle = 0;
    self.currentJinStyle = 0;
    [self getHotpredictData];
    [self getJinpredictData];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;

    // 近期分析头部
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, RBNavBarAndStatusBarH, RBScreenWidth, 40)];
    view.hidden = YES;
    view.tag = 666;
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guo"]];
    icon.frame = CGRectMake(12, 12, 16, 16);
    [view addSubview:icon];

    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.text = @"近期分析";
    tipLab.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 4, 12, 80, 16);
    tipLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLab.font = [UIFont boldSystemFontOfSize:16];
    tipLab.textAlignment = NSTextAlignmentLeft;
    [tipLab sizeToFit];
    [view addSubview:tipLab];

    UILabel *tipLab2 = [[UILabel alloc]init];
    self.tipLab2 = tipLab2;
    tipLab2.frame = CGRectMake(CGRectGetMaxX(tipLab.frame) + 16, 12, RBScreenWidth - 79 - 32 - CGRectGetMaxX(tipLab.frame), 16);
    tipLab2.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLab2.font = [UIFont boldSystemFontOfSize:12];
    tipLab2.textAlignment = NSTextAlignmentLeft;
    [view addSubview:tipLab2];

    UIButton *predictBtn = [[UIButton alloc]init];
    self.predictBtn = predictBtn;
    [predictBtn addTarget:self action:@selector(clickpredictBtn) forControlEvents:UIControlEventTouchUpInside];
    [predictBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    predictBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    predictBtn.frame = CGRectMake(RBScreenWidth - 79, 8, 67, 24);
    predictBtn.layer.cornerRadius = 1;
    predictBtn.layer.masksToBounds = YES;
    [view addSubview:predictBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:view];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gengxinBiSaiModels:) name:@"gengxinBiSaiModels" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMoreJipredict) name:@"getMoreJipredict" object:nil];
}

- (void)getMoreJipredict {
    self.currentJinP += 1;
    [self getJinpredictData];
}

- (void)gengxinBiSaiModels:(NSNotification *)noti {
    NSArray *gengxinBiSaiModels = noti.object;
    for (int i = 0; i < self.hotpredictArr.count; i++) {
       RBPredictModel *model = self.hotpredictArr[i];
        for (RBBiSaiModel *biSaiModel in gengxinBiSaiModels) {
            if (model.namiid == biSaiModel.namiId) {
                model.state = biSaiModel.status;
                model.startballt = biSaiModel.TeeTime;
                model.zhufen = biSaiModel.hostScore;
                model.kefen = biSaiModel.visitingScore;
                self.hotpredictArr[i] = model;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)loadMoreData {
    self.currentReP += 1;
    [self getHotpredictData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.hotpredictArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guo"]];
        icon.frame = CGRectMake(12, 12, 16, 16);
        [view addSubview:icon];

        UILabel *tipLab = [[UILabel alloc]init];
        tipLab.text = @"近期分析";
        tipLab.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 4, 12, 80, 16);
        tipLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tipLab.font = [UIFont boldSystemFontOfSize:16];
        tipLab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:tipLab];

        UIButton *moreBtn = [[UIButton alloc]init];
        self.moreBtn = moreBtn;
        [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        moreBtn.frame = CGRectMake(RBScreenWidth - 62, 0, 50, 42);
        [view addSubview:moreBtn];
        [cell.contentView addSubview:view];
        cell.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        RBNearCollectionView *collectionView = [[RBNearCollectionView alloc]initWithFrame:CGRectMake(10, 40, RBScreenWidth - 10, 97) collectionViewLayout:layout andmodels:self.nearpredictArr andClickItem:^(NSInteger index) {
    if ([RBChekLogin NotLogin]) {
                return;
            } else {
                RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
                detailTabVC.index = 2;
                detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.nearpredictArr[index]];
                [self.navigationController pushViewController:detailTabVC animated:YES];
            }
        }];

        [cell addSubview:collectionView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        RBPredictCell *predicell = [RBPredictCell createCellByTableView:tableView];
        predicell.selectionStyle = UITableViewCellSelectionStyleNone;
        RBPredictModel *predictModel = self.hotpredictArr[indexPath.row];
        predictModel.show = self.show;
        predicell.predictModel = predictModel;
        return predicell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 149;
    } else {
        return 117;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        return view;
    } else {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
        view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huo"]];
        icon.frame = CGRectMake(12, 16, 16, 16);
        [view addSubview:icon];

        UILabel *tipLab = [[UILabel alloc]init];
        tipLab.text = @"热门分析";
        tipLab.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 4, 16, 80, 16);
        tipLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tipLab.font = [UIFont boldSystemFontOfSize:16];
        tipLab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:tipLab];
        return view;
    }
}

- (void)clickMoreBtn {
    [self.navigationController pushViewController:[[RBPredictListTabVC alloc]init] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *head = [[UIApplication sharedApplication].keyWindow viewWithTag:666];
    if (scrollView.contentOffset.y >= 40) {
        self.tableView.y = RBNavBarAndStatusBarH + 40;
        if (head != nil) {
            head.hidden = NO;
        }
        RBPredictModel *predictModel = [self.nearpredictArr firstObject];
        self.tipLab2.text = [NSString stringWithFormat:@"%@ vs %@", predictModel.zhuname[0], predictModel.kename[0]];
        if (predictModel.Result == 1 || predictModel.Result == 2 || predictModel.Result == 3) {
            [self.predictBtn setTitle:@"分析    准" forState:UIControlStateNormal];
            self.predictBtn.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        } else if (predictModel.Result == 11) {
            [self.predictBtn setTitle:@"分析    走" forState:UIControlStateNormal];
            self.predictBtn.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        } else if (predictModel.Result == 21) {
            [self.predictBtn setTitle:@"分析    错" forState:UIControlStateNormal];
            self.predictBtn.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        }
    } else {
        if (head != nil) {
            head.hidden = YES;
        }
        self.tableView.y = RBNavBarAndStatusBarH;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([RBChekLogin NotLogin]) {
        return;
    }else {
        RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
        detailTabVC.index = 2;
        detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.hotpredictArr[indexPath.row]];
        [self.navigationController pushViewController:detailTabVC animated:YES];
    }
}

- (RBBiSaiModel *)predictModelTobiSaiModel:(RBPredictModel *)predictModel {
    RBBiSaiModel *biSaiModel = [[RBBiSaiModel alloc]init];
    biSaiModel.eventLongName = predictModel.name[1];
    biSaiModel.namiId = predictModel.namiid;
    biSaiModel.hostID = predictModel.zhuid;
    biSaiModel.visitingID = predictModel.keid;
    biSaiModel.hostTeamName = predictModel.zhuname[0];
    biSaiModel.visitingTeamName = predictModel.kename[0];
    biSaiModel.biSaiTime = predictModel.startt;
    biSaiModel.TeeTime = predictModel.startballt;
    biSaiModel.eventName = predictModel.name[0];
    biSaiModel.eventId = predictModel.saijiid;
    biSaiModel.stageName = predictModel.jieduanname[0];
    biSaiModel.hostCorner = predictModel.zhujiao;
    biSaiModel.visitingCorner = predictModel.kejiao;
    biSaiModel.hostHalfScore = predictModel.zhuhalffen;
    biSaiModel.visitingHalfScore = predictModel.kehalffen;
    biSaiModel.hostPointScore = predictModel.zhudianfen;
    biSaiModel.visitingPointScore = predictModel.kedianfen;
    biSaiModel.hostScore = predictModel.zhufen;
    biSaiModel.visitingScore = predictModel.kefen;
    biSaiModel.hostRedCard = predictModel.zhuhong;
    biSaiModel.visitingRedCard = predictModel.kehong;
    biSaiModel.hostYellowCard = predictModel.zhuhuang;
    biSaiModel.visitingYellowCard = predictModel.kehuang;
    biSaiModel.hostOvertimeScore = predictModel.zhuaddfen;
    biSaiModel.visitingOvertimeScore = predictModel.keaddfen;
    biSaiModel.hostPenaltyScore = predictModel.zhudianfen;
    biSaiModel.visitingPenaltyScore = predictModel.kedianfen;
    biSaiModel.status = predictModel.state;
    biSaiModel.hostLogo = predictModel.zhulogo;
    biSaiModel.visitingLogo = predictModel.kelogo;
    biSaiModel.hasIntelligence = (BOOL)predictModel.qingbao;
    return biSaiModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}



@end
