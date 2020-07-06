#import "RBXinWenTabVC.h"
#import "RBNetworkTool.h"
#import "RBXinWenModel.h"
#import "RBBiSaiModel.h"
#import "RBBannerModel.h"
#import "RBBannerCell.h"
#import "RBXinWenBiSaiViewCell.h"
#import "RBXinWenCell.h"
#import "RBXinWenListTabVC.h"

@interface RBXinWenTabVC ()
@property (nonatomic, strong) NSMutableArray *biSaiDataArr;
@property (nonatomic, strong) NSMutableArray *xinWenDataArr;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) int topicTotal;
@end

@implementation RBXinWenTabVC
- (NSMutableArray *)biSaiDataArr {
    if (_biSaiDataArr == nil) {
        _biSaiDataArr = [NSMutableArray array];
    }
    return _biSaiDataArr;
}

- (NSMutableArray *)xinWenDataArr {
    if (_xinWenDataArr == nil) {
        _xinWenDataArr = [NSMutableArray array];
    }
    return _xinWenDataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    // 获取比赛数据
    [self getBiSaiData];
    // 获取新闻数据
    [self getNewsData];
    // 获取话题总条数
    [self gethuatitopicTotal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 54)];
    view.backgroundColor =  [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 46)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击查看更多资讯" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:btn];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [view addSubview:line];
    self.tableView.tableFooterView = view;

    [self.tableView reloadData];
}

- (void)gethuatitopicTotal {
    [RBNetworkTool PostDataWithUrlStr:@"try/go/gethuatitotal" andParam:@{} Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            self.topicTotal = [backData[@"ok"]intValue];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)clickBtn {
    [self.navigationController pushViewController:[[RBXinWenListTabVC alloc]init] animated:YES];
}

- (void)getNewsData {
    NSDictionary *dict1 = @{ @"startId": @(0), @"endId": @(PAGESIZE) };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/newsheadline" andParam:dict1 Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
            return;
        }
        NSDictionary *dic = backData;
        NSArray *array = dic[@"ok"][@"data"];
        NSArray *dataArr = [RBXinWenModel mj_objectArrayWithKeyValuesArray:array];
        [self.xinWenDataArr removeAllObjects];
        [self.xinWenDataArr addObjectsFromArray:dataArr];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    } Fail:^(NSError *_Nonnull error) {
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)getBiSaiData {
    NSString *str = [NSString getStrWithDate:[NSDate date] andFormat:@"yyyyMMdd"];
    NSDictionary *dict = @{ @"date": str };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballmatchlistbydate"  andParam:dict Success:^(NSDictionary *_Nonnull backDataDic) {
         if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]] || [[backDataDic allKeys] containsObject:@"message"] || [[backDataDic allKeys] containsObject:@"err"]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        if (backData[@"err"] != nil) {
            [self getBiSaiData];
            return;
        }
        NSDictionary *dic = backData;
        NSArray *matchs = dic[@"matches"];
        NSDictionary *teams = dic[@"teams"];
        NSDictionary *events = dic[@"events"];
        NSDictionary *stages = dic[@"stages"];
        for (int i = 0; i < matchs.count; i++) {
            NSArray *arr = matchs[i];
            RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
            model.index = i + 1;
            if (model.status >= 1 && model.status <= 7) {
                [self.biSaiDataArr addObject:model];
            }
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } Fail:^(NSError *_Nonnull error) {
        [self getBiSaiData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        RBBannerCell *bannerCell =  [RBBannerCell createCellByTableView:tableView];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (int i = 0; i < 1; i++) {
            RBBannerModel *bannerModel = [[RBBannerModel alloc]init];
            bannerModel.title = @"足球话题讨论区";
            bannerModel.number = self.topicTotal;
            bannerModel.desTitle = @"欢迎在这里和大家一起讨论哦！";
            bannerModel.imageName = @"huati bg";
            [mutArr addObject:bannerModel];
        }
        bannerCell.bannerArr = mutArr;
        cell = bannerCell;
    } else if (indexPath.section == 1) {
        RBXinWenBiSaiViewCell *xinwenBisaiViewCell =  [RBXinWenBiSaiViewCell createCellByTableView:tableView];
        xinwenBisaiViewCell.biSaiArr = self.biSaiDataArr;
        cell = xinwenBisaiViewCell;
    } else {
        RBXinWenCell *xinWenCell =  [RBXinWenCell createCellByTableView:tableView];
        xinWenCell.xinWenArr = self.xinWenDataArr;
        cell = xinWenCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 166;
    } else if (indexPath.section == 1) {
        if (self.biSaiDataArr.count >= 3) {
            return 180 + 87;
        } else {
            return 3 * 60 + 87;
        }
    } else if (indexPath.section == 2) {
        CGFloat height = 0;
        int bigNum = (int)(self.xinWenDataArr.count - 4) / 4;
        for (int i = 3; i < self.xinWenDataArr.count; i++) {
            if ((i - 2) % 4 == 0) {
                RBXinWenModel *model = self.xinWenDataArr[i];
                height += (259 + [model.title getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 24].height);
                continue;
            }
        }
        return height + (self.xinWenDataArr.count - bigNum - 3) * 116 + 371;
    } else {
        return 0;
    }
}

@end
