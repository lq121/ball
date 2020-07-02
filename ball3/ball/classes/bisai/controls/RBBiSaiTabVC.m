#import "RBBiSaiTabVC.h"
#import "RBBiSaiModel.h"
#import "RBBiSaiCell.h"
#import "RBNetworkTool.h"
#import "RBBiSaiDetailVC.h"
#import "RBFMDBTool.h"
#import "MJRefresh.h"

@interface RBBiSaiTabVC ()
/// 是否显示
@property (nonatomic, assign) BOOL show;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 全部
@property (nonatomic, strong) NSMutableArray *allDataArray;
///进行中
@property (nonatomic, strong) NSMutableArray *beginingDataArray;
/// 赛程
@property (nonatomic, strong) NSMutableArray *scheduleDataArray;
/// 赛过
@property (nonatomic, strong) NSMutableArray *resultDataArray;
/// 关注
@property (nonatomic, strong) NSMutableArray *attentionDataArray;
/// 关注历史
@property (nonatomic, strong) NSMutableArray *attentionHistoryDataArray;
/// 全部加载完提示
@property (nonatomic, strong) UIView *footView;
@end

@implementation RBBiSaiTabVC

- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 65)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, RBScreenWidth, 17)];
        lab.text = @"全部加载完毕啦～";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [_footView addSubview:lab];
    }
    return _footView;
}

- (NSMutableArray *)allDataArray {
    if (_allDataArray == nil) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableArray *)beginingDataArray {
    if (_beginingDataArray == nil) {
        _beginingDataArray = [NSMutableArray array];
    }
    return _beginingDataArray;
}

- (NSMutableArray *)scheduleDataArray {
    if (_scheduleDataArray == nil) {
        _scheduleDataArray = [NSMutableArray array];
    }
    return _scheduleDataArray;
}

- (NSMutableArray *)resultDataArray {
    if (_resultDataArray == nil) {
        _resultDataArray = [NSMutableArray array];
    }
    return _resultDataArray;
}

- (NSMutableArray *)attentionDataArray {
    if (_attentionDataArray == nil) {
        _attentionDataArray = [NSMutableArray array];
    }
    return _attentionDataArray;
}

- (NSMutableArray *)attentionHistoryDataArray {
    if (_attentionHistoryDataArray == nil) {
        _attentionHistoryDataArray = [NSMutableArray array];
    }
    return _attentionHistoryDataArray;
}

- (void)getLocalBiSaiData {
    if (self.biSaiType == 0) {
        // 全部
        [self.allDataArray removeAllObjects];
    } else if (self.biSaiType == 1) {
        // 进行中
        [self.beginingDataArray removeAllObjects];
    } else if (self.biSaiType == 2) {
        // 赛程
        [self.scheduleDataArray removeAllObjects];
    } else if (self.biSaiType == 3) {
        // 赛果
        [self.resultDataArray removeAllObjects];
    } else if (self.biSaiType == 4) {
        // 关注
        [self.attentionDataArray removeAllObjects];
    } else if (self.biSaiType == 5) {
        // 关注历史
        [self.attentionHistoryDataArray removeAllObjects];
    }
    BOOL loadDataOver = [[[NSUserDefaults standardUserDefaults]objectForKey:@"loadDataOver"]boolValue];
    if (loadDataOver) {
        if (self.biSaiType == 0) {
            NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:[[NSDate date] timeIntervalSince1970] andMinStatus:1 andMaxStatus:7];
            [self.allDataArray addObjectsFromArray:array];
            if (self.allDataArray.count == 0) {
                NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:[[NSDate date] timeIntervalSince1970] andMinStatus:9 andMaxStatus:13];
                [self.allDataArray addObjectsFromArray:array];
            }
            [self setMatchArr];
        } else if (self.biSaiType == 1) {
            NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:[[NSDate date] timeIntervalSince1970] andMinStatus:2 andMaxStatus:4];
            [self.beginingDataArray addObjectsFromArray:array];
            [self setMatchArr];
        } else if (self.biSaiType == 2) {
            // 赛程
            NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:self.date andMinStatus:1 andMaxStatus:0];
            [self.scheduleDataArray addObjectsFromArray:array];
            if (self.scheduleDataArray.count == 0) {
                [self getBiSaiData];
            } else {
                [self setMatchArr];
            }
        } else if (self.biSaiType == 3) {
            // 赛果
            NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:self.date andMinStatus:8 andMaxStatus:0];
            [self.resultDataArray addObjectsFromArray:array];
            if (self.resultDataArray.count == 0) {
                [self getBiSaiData];
            } else {
                [self setMatchArr];
            }
        } else if (self.biSaiType == 4) {
            // 今日关注(数据存储比较复杂每次都取网络数据)
            [self getGuanZhuData];
        } else if (self.biSaiType == 5) {
            // 历史关注(查询今日关注是必定会有历史关注数据)
            NSArray *array = [[RBFMDBTool sharedFMDBTool]selectAttentionBiSaiModelWithTime:self.date];
            [self.attentionHistoryDataArray addObjectsFromArray:array];
        }
        if (self.hasSelect) {
            [self showData];
        }
        [self.tableView reloadData];
        if (self.biSaiType == 0) {
            [self.tableView showDataCount:self.allDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
            if (self.allDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
        } else if (self.biSaiType == 1) {
            if (self.beginingDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.beginingDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 2) {
            if (self.scheduleDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.scheduleDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 3) {
            if (self.resultDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.resultDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 4) {
            if (self.attentionDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.attentionDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2 ];
        } else if (self.biSaiType == 5) {
            if (self.attentionHistoryDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.attentionHistoryDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2];
        }
    } else {
        [self getBiSaiData];
    }
}

- (void)setMatchArr {
    NSMutableArray *mutArr = [NSMutableArray array];
    switch (self.biSaiType) {
        case 0:
            for (RBBiSaiModel *model in self.allDataArray) {
                [mutArr addObject:model.eventName];
            }
            break;
        case 1:
            for (RBBiSaiModel *model in self.beginingDataArray) {
                [mutArr addObject:model.eventName];
            }
            break;
        case 2:
            for (RBBiSaiModel *model in self.scheduleDataArray) {
                [mutArr addObject:model.eventName];
            }
            break;
        case 3:
            for (RBBiSaiModel *model in self.resultDataArray) {
                [mutArr addObject:model.eventName];
            }
            break;
    }

    [[NSUserDefaults standardUserDefaults]setObject:mutArr forKey:@"matchArr"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)showData {
    NSArray *seletmatchArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"seletmatchArr"];
    if (seletmatchArr == nil || seletmatchArr.count == 0) return;
    NSMutableArray *mutArr = [NSMutableArray array];
    switch (self.biSaiType) {
        case 0:
            for (NSString *str in seletmatchArr) {
                for (int i = 0; i < self.allDataArray.count; i++) {
                    RBBiSaiModel *biSaiModel = self.allDataArray[i];
                    if ([biSaiModel.eventName isEqualToString:str]) {
                        [mutArr addObject:biSaiModel];
                    }
                }
            }
            [self.allDataArray removeAllObjects];
            self.allDataArray = [NSMutableArray arrayWithArray:mutArr];
            break;
        case 1:
            for (NSString *str in seletmatchArr) {
                for (int i = 0; i < self.beginingDataArray.count; i++) {
                    RBBiSaiModel *biSaiModel = self.beginingDataArray[i];
                    if ([biSaiModel.eventName isEqualToString:str]) {
                        [mutArr addObject:biSaiModel];
                    }
                }
            }
            [self.beginingDataArray removeAllObjects];
            self.beginingDataArray = [NSMutableArray arrayWithArray:mutArr];
            break;
        case 2:
            for (NSString *str in seletmatchArr) {
                for (int i = 0; i < self.scheduleDataArray.count; i++) {
                    RBBiSaiModel *biSaiModel = self.scheduleDataArray[i];
                    if ([biSaiModel.eventName isEqualToString:str]) {
                        [mutArr addObject:biSaiModel];
                    }
                }
            }
            [self.scheduleDataArray removeAllObjects];
            self.scheduleDataArray = [NSMutableArray arrayWithArray:mutArr];
            break;
        case 3:
            for (NSString *str in seletmatchArr) {
                for (int i = 0; i < self.resultDataArray.count; i++) {
                    RBBiSaiModel *biSaiModel = self.resultDataArray[i];
                    if ([biSaiModel.eventName isEqualToString:str]) {
                        [mutArr addObject:biSaiModel];
                    }
                }
            }
            [self.resultDataArray removeAllObjects];
            self.resultDataArray = [NSMutableArray arrayWithArray:mutArr];
            break;
    }
}

// 获取关注数据
- (void)getGuanZhuData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getguanzhu"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            if (self.biSaiType == 4) {
                [self.attentionDataArray removeAllObjects];
            } else {
                [self.attentionHistoryDataArray removeAllObjects];
            }
            NSArray *okArr = backData[@"ok"];
            for (int i = 0; i < okArr.count; i++) {
                NSArray *arry = okArr[i];
                if (arry.count > 1) {
                    NSMutableArray *mutArr = [NSMutableArray array];
                    [mutArr addObject:arry[0]];
                    NSDate *date = [NSString stringToDate:[NSString stringWithFormat:@"%@", arry[0]]];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    dateFormatter.dateFormat = @"yyyyMMdd";
                    NSDate *now = [NSString stringToDate:[dateFormatter stringFromDate:[NSDate date]]];
                    NSComparisonResult result = [date compare:now];
                    NSDictionary *dict = @{ @"date": arry[0] };
                    // 获取
                    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballmatchlistbydate" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
                        if (backData[@"err"] != nil) {
                            return;
                        }
                        NSDictionary *dic = backData;
                        NSArray *matchs = dic[@"matches"];
                        NSDictionary *teams = dic[@"teams"];
                        NSDictionary *events = dic[@"events"];
                        NSDictionary *stages = dic[@"stages"];
                        for (int j = 1; j < arry.count; j++) {
                            for (int i = 0; i < matchs.count; i++) {
                                NSArray *arr = matchs[i];
                                if ([arry[j] intValue] == [arr[0] intValue]) {
                                    RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
                                    model.hasAttention = YES;
                                    if (result ==  NSOrderedSame || result == NSOrderedDescending) {
                                        // 只加载后面的，过期的不加载
                                        [mutArr addObject:model];
                                    }
                                    continue;
                                }
                            }
                        }
                        [self.attentionDataArray addObject:mutArr];
                        BOOL nodata = true;
                        for (int k = 0; k < self.attentionDataArray.count; k++) {
                            NSArray *arr = self.attentionDataArray[k];
                            if (arr.count > 1) {
                                nodata = false;
                                break;
                            }
                        }
                        if (nodata) {
                            [self.tableView showDataCount:0 andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2];
                            [self.tableView reloadData];
                        } else {
                            [self.tableView showDataCount:self.attentionDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2];
                            [self.tableView reloadData];
                        }
                        for (int j = 1; j < arry.count; j++) {
                            for (int i = 0; i < matchs.count; i++) {
                                NSArray *arr = matchs[i];
                                if ([arry[j] intValue] == [arr[0] intValue]) {
                                    RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
                                    model.hasAttention = YES;
                                    if (![[RBFMDBTool sharedFMDBTool] selectAttentionBiSaiModelWithId:model.namiId]) {
                                        [[RBFMDBTool sharedFMDBTool]addAttentionBiSaiModel:model];
                                    } else {
                                        [[RBFMDBTool sharedFMDBTool]updateAttentionBiSaiModel:model];
                                    }
                                    [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:model];
                                    continue;
                                }
                            }
                        }
                    } Fail:^(NSError *_Nonnull error) {
                    }];
                } else {
                    [self.attentionHistoryDataArray addObject:@[arry[0]]];
                }
                [MBProgressHUD hideHUDForView:self.tableView animated:YES];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)getBiSaiData {
    [MBProgressHUD showLoading:@"加载中" toView:self.view];
    NSString *str =  [NSString getStrWithDate:[NSDate date] andFormat:@"yyyyMMdd"];
    if (self.date > 0) {
        str = [NSString getStrWithDateInt:self.date andFormat:@"yyyyMMdd"];
    }
    NSDictionary *dict = @{ @"date": str };
    [RBNetworkTool PostDataWithUrlStr:@"ttry/go/getfootballmatchlistbydate"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            if (self.biSaiType == 0) {
                if (model.status >= 1 && model.status <= 7) {
                    [self.allDataArray addObject:model];
                }
            } else if (self.biSaiType == 1) {
                if (model.status >= 2 && model.status <= 4) {
                    [self.beginingDataArray addObject:model];
                }
            } else if (self.biSaiType == 2) {
                if (model.status == 1) {
                    [self.scheduleDataArray addObject:model];
                }
            } else if (self.biSaiType == 3) {
                if (model.status == 8) {
                    [self.resultDataArray addObject:model];
                }
            } else if (self.biSaiType == 4) {
                if (model.hasAttention) {
                    [self.attentionDataArray addObject:model];
                }
            } else if (self.biSaiType == 5) {
                if (model.hasAttention) {
                    [self.attentionHistoryDataArray addObject:model];
                }
            }
        }
        if (self.biSaiType == 0) {
            if (self.allDataArray.count == 0) {
                for (int i = 0; i < matchs.count; i++) {
                    NSArray *arr = matchs[i];
                    RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
                    model.index = i + 1;
                    if (model.status > 8) {
                        [self.allDataArray addObject:model];
                    }
                }
            }
            [self setMatchArr];
            if (self.hasSelect) {
                [self showData];
            }
            [self.tableView showDataCount:self.allDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
            if (self.allDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
        } else if (self.biSaiType == 1) {
            if (self.beginingDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self setMatchArr];
            if (self.hasSelect) {
                [self showData];
            }
            [self.tableView showDataCount:self.beginingDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 2) {
            if (self.scheduleDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self setMatchArr];
            if (self.hasSelect) {
                [self showData];
            }
            [self.tableView showDataCount:self.scheduleDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 3) {
            if (self.resultDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self setMatchArr];
            if (self.hasSelect) {
                [self showData];
            }
            [self.tableView showDataCount:self.resultDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else if (self.biSaiType == 4) {
            if (self.attentionDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.attentionDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2 ];
        } else if (self.biSaiType == 5) {
            if (self.attentionHistoryDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView showDataCount:self.attentionHistoryDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183) andType:2];
        }
        [self.tableView reloadData];

        // 添加到数据库
        for (int i = 0; i < matchs.count; i++) {
            NSArray *arr = matchs[i];
            RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
            model.index = i + 1;
            if ([[RBFMDBTool sharedFMDBTool]selectBiSaiModelWithId:model.namiId]) {
                [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:model];
            } else {
                [[RBFMDBTool sharedFMDBTool]addBiSaiModel:model];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getBiSaiData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.biSaiType != 2 && self.biSaiType != 3) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBiSaiModels:) name:@"changeBiSaiModels" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteBiSai) name:@"deleteBiSai" object:nil];
}

- (void)deleteBiSai {
    [self getLocalBiSaiData];
}

- (void)changeBiSaiModels:(NSNotification *)noti {
    NSArray *changeBiSaiModels = noti.object;
    [self changeModelsWithArray:changeBiSaiModels];
}

- (void)loadData {
    [MBProgressHUD showLoading:@"加载中" toView:self.tableView];
    if (self.biSaiType == 3) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        });
        return;
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballlive" andParam:@{} Success:^(NSDictionary *_Nonnull backDataDic) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        NSArray *array = (NSArray *)backData;
        NSMutableArray *changeArr = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSArray *arr = array[i];
            NSArray *hostArr = arr[2];
            NSArray *visitArr = arr[3];
            RBBiSaiModel *biSaiModel = [[RBFMDBTool sharedFMDBTool]selectBiSaiModelWithNamiId:[arr[0]intValue]];
            if (biSaiModel.namiId != 0) {
                biSaiModel.status = [arr[1]intValue];
                biSaiModel.hostScore = [hostArr[0] intValue];
                biSaiModel.hostHalfScore = [hostArr[1] intValue];
                biSaiModel.hostRedCard = [hostArr[2] intValue];
                biSaiModel.hostYellowCard = [hostArr[3] intValue];
                biSaiModel.hostCorner = [hostArr[4]intValue];
                biSaiModel.visitingScore = [visitArr[0] intValue];
                biSaiModel.visitingHalfScore = [visitArr[1] intValue];
                biSaiModel.visitingRedCard = [visitArr[2] intValue];
                biSaiModel.visitingYellowCard = [visitArr[3] intValue];
                biSaiModel.visitingCorner = [visitArr[4]intValue];
                biSaiModel.TeeTime = [arr[4]intValue];
                [changeArr addObject:biSaiModel];
                [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:biSaiModel];
            }
        }
        [self changeModelsWithArray:changeArr];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}

- (void)changeModelsWithArray:(NSArray *)changeBiSaiModels {
    if (self.biSaiType == 0) {
        for (int i = 0; i < self.allDataArray.count; i++) {
            RBBiSaiModel *model = self.allDataArray[i];
            for (RBBiSaiModel *biSaiModel in changeBiSaiModels) {
                if (biSaiModel.status == 8 && model.namiId == biSaiModel.namiId) {
                    [self.allDataArray removeObject:model];
                    break;
                } else if (biSaiModel.status >= 0 && model.namiId == biSaiModel.namiId) {
                    self.allDataArray[i] = biSaiModel;
                    break;
                }
            }
        }
        if (self.allDataArray.count == 0) {
            NSArray *array = [[RBFMDBTool sharedFMDBTool] selectBiSaiModelWithTime:[[NSDate date] timeIntervalSince1970] andMinStatus:9 andMaxStatus:13];
            [self.allDataArray addObjectsFromArray:array];
        }
        [self.tableView showDataCount:self.allDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } else if (self.biSaiType == 1) {
        for (int i = 0; i < self.beginingDataArray.count; i++) {
            RBBiSaiModel *model = self.beginingDataArray[i];
            for (RBBiSaiModel *biSaiModel in changeBiSaiModels) {
                if (biSaiModel.status >= 8 && model.namiId == biSaiModel.namiId) {
                    [self.beginingDataArray removeObject:model];
                    break;
                } else if (biSaiModel.status >= 0 && model.namiId == biSaiModel.namiId) {
                    self.beginingDataArray[i] = biSaiModel;
                    break;
                }
            }
        }
        [self.tableView reloadData];
    } else if (self.biSaiType == 2) {
        for (int i = 0; i < self.scheduleDataArray.count; i++) {
            RBBiSaiModel *model = self.scheduleDataArray[i];
            for (RBBiSaiModel *biSaiModel in changeBiSaiModels) {
                if (biSaiModel.status >= 8 && model.namiId == biSaiModel.namiId) {
                    [self.scheduleDataArray removeObject:model];
                    break;
                } else if (biSaiModel.status >= 0 && model.namiId == biSaiModel.namiId) {
                    self.scheduleDataArray[i] = biSaiModel;
                    break;
                }
            }
        }
        [self.tableView reloadData];
    } else if (self.biSaiType == 4) {
        for (int i = 0; i < self.attentionDataArray.count; i++) {
            NSArray *array = self.attentionDataArray[i];
            for (int j = 1; j < array.count; j++) {
                RBBiSaiModel *model = array[j];
                for (RBBiSaiModel *biSaiModel in changeBiSaiModels) {
                    if (model.namiId == biSaiModel.namiId) {
                        self.attentionDataArray[i][j] = biSaiModel;
                        break;
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
}

- (void)timerRun {
    self.show = !self.show;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.biSaiType == 4) {
        return self.attentionDataArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.biSaiType == 4) {
        if (self.attentionDataArray.count == 0) {
            return 0;
        } else {
            NSArray *arr = self.attentionDataArray[section];
            if (arr.count > 1) {
                return 24;
            } else {
                return 0;
            }
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *garyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    garyView.backgroundColor = [UIColor colorWithSexadeString:@"F8F8F8"];
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    tipLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.1];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [garyView addSubview:tipLab];

    if (self.biSaiType == 4) {
        NSArray *arr = self.attentionDataArray[section];
        NSDate *date = [NSString stringToDate:[NSString stringWithFormat:@"%@", arr[0]]];
        tipLab.text = [NSString getStrWithDate:date andFormat:@"yyyy年MM月dd日"];
        if (arr.count > 1) {
            garyView.height = 24;
        } else {
            garyView.height = 0;
        }
    } else {
        garyView.height = 0;
    }
    return garyView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.biSaiType) {
        case 0:
            return self.allDataArray.count;
        case 1:
            return self.beginingDataArray.count;
        case 2:
            return self.scheduleDataArray.count;
        case 3:
            return self.resultDataArray.count;
        case 4: {
            NSArray *arr = self.attentionDataArray[section];
            return arr.count - 1;
        }
        case 5:
            return self.attentionHistoryDataArray.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiModel *model;
    switch (self.biSaiType) {
        case 0:
            model =  self.allDataArray[indexPath.row];
            break;
        case 1:
            model =  self.beginingDataArray[indexPath.row];
            break;
        case 2:
            model =  self.scheduleDataArray[indexPath.row];
            break;
        case 3:
            model =  self.resultDataArray[self.resultDataArray.count - indexPath.row - 1];
            break;
        case 4: {
            NSArray *arr = self.attentionDataArray[indexPath.section];
            model =  arr[indexPath.row + 1];
            break;
        }
        case 5:
            model =  self.attentionHistoryDataArray[indexPath.row];
            break;
    }
    if (model.status == 2) {
        // 上半场
        model.TeeTimeStr = [NSString stringWithFormat:@"上半场 %@", [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:model.TeeTime]];
    } else if (model.status == 3) {
        model.TeeTimeStr = @"中";
    } else if (model.status >= 4 && model.status <= 7) {
        long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:model.TeeTime] longLongValue];
        if (timeCount + 45 > 90) {
            model.TeeTimeStr = @"下半场 90+";
        } else {
            model.TeeTimeStr = [NSString stringWithFormat:@"下半场 %ld", timeCount + 45];
        }
    } else if (model.status  == 8) {
        model.TeeTimeStr = @"完";
    } else if (model.status == 1) {
        model.TeeTimeStr = @"未";
    } else if (model.status > 8 || model.status == 0) {
        model.TeeTimeStr = @"延迟";
    }
    if (model.status == 2 || model.status == 4) {
        if (self.show) {
            if (![model.TeeTimeStr containsString:@"'"]) {
                model.TeeTimeStr = [NSString stringWithFormat:@"%@'", model.TeeTimeStr];
            }
        } else {
            if ([model.TeeTimeStr containsString:@"'"]) {
                model.TeeTimeStr = [model.TeeTimeStr substringToIndex:model.TeeTimeStr.length - 1];
            }
        }
    }
    RBBiSaiCell *cell = [RBBiSaiCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biSaiModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiModel *model;
    switch (self.biSaiType) {
        case 0:
            model =  self.allDataArray[indexPath.row];
            break;
        case 1:
            model =  self.beginingDataArray[indexPath.row];
            break;
        case 2:
            model =  self.scheduleDataArray[indexPath.row];
            break;
        case 3:
            model =   self.resultDataArray[self.resultDataArray.count - indexPath.row - 1];
            break;
        case 4: {
            NSArray *arr = self.attentionDataArray[indexPath.section];
            model =  arr[indexPath.row + 1];
            break;
        }
        case 5:
            model =  self.attentionHistoryDataArray[indexPath.row];
            break;
    }
    if (model.stage == nil) {
        return 123;
    } else {
        return 147;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiModel *model;
    switch (self.biSaiType) {
        case 0:
            model =  self.allDataArray[indexPath.row];
            break;
        case 1:
            model =  self.beginingDataArray[indexPath.row];
            break;
        case 2:
            model =  self.scheduleDataArray[indexPath.row];
            break;
        case 3:
            model =   self.resultDataArray[self.resultDataArray.count - indexPath.row - 1];
            break;
        case 4: {
            NSArray *arr = self.attentionDataArray[indexPath.section];
            model =  arr[indexPath.row + 1];
            break;
        }
        case 5:
            model =  self.attentionHistoryDataArray[indexPath.row];
            break;
    }
    RBBiSaiDetailVC *biSaiDeatilVC = [[RBBiSaiDetailVC alloc]init];
    biSaiDeatilVC.biSaiModel = model;
    if (model.status == 1 || model.status > 8) {
        // 未
        biSaiDeatilVC.index = 3;
    } else {
        // 比赛进行时
        biSaiDeatilVC.index = 0;
    }
    [self.navigationController pushViewController:biSaiDeatilVC animated:YES];
}

@end
