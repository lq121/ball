#import "RBAnalyzeVC.h"
#import "RBAnalyFirstCell.h"
#import "RBAnalySecondCell.h"
#import "RBAnalyThirdCell.h"
#import "RBAnalyFourthCell.h"
#import "RBAnalyFiveCell.h"
#import "RBAnalySixCell.h"
#import "RBAnalyzeTitleView.h"
#import "RBNetworkTool.h"
#import "RBToast.h"

@interface RBAnalyzeVC ()
@property (assign, nonatomic, readwrite) NSInteger fiveCount;
@property (nonatomic, assign) NSInteger sixHomeCount;
@property (nonatomic, assign) NSInteger sixAwayCount;
@property (nonatomic, strong) NSDictionary *statusDict;
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
@property (nonatomic, copy) NSString *currentHostLogo;
@property (nonatomic, copy) NSString *currentVisitingLogo;
@property (nonatomic, copy) NSString *competitionName;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, assign) CGPoint lastContentOffset;
@end

@implementation RBAnalyzeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self getguessrate];
    self.sixAwayCount = -1;
    self.sixHomeCount = -1;
}

- (void)setBiSaiDetailHead:(RBBiSaiDetailHead *)biSaiDetailHead {
    _biSaiDetailHead = biSaiDetailHead;
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, biSaiDetailHead.height)];
    self.tableView.tableHeaderView = head;
}

- (void)getguessrate {
    // 猜胜负的数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.biSaiModel.namiId) forKey:@"mid"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getguessrate"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        self.statusDict = backData;
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)loadData {
    NSDictionary *dict = @{ @"matchid": @(self.biSaiModel.namiId) };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballanalysis" andParam:dict Success:^(NSDictionary *_Nonnull backDataDic) {
        if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        if (backData[@"err"] != nil) {
            return;
        }
        NSDictionary *dic = backData;
        NSDictionary *teams = dic[@"teams"];
        NSString *hostKey = [NSString stringWithFormat:@"%d", self.biSaiModel.hostID];
        NSString *visitingKey = [NSString stringWithFormat:@"%d", self.biSaiModel.visitingID];
        NSDictionary *host = teams[hostKey];
        NSDictionary *visiting = teams[visitingKey];
        NSString *matchKey = [NSString stringWithFormat:@"%d", self.biSaiModel.matcheventId];
        self.currentHostName =  host[@"name_zh"];
        self.currentVisitingName = visiting[@"name_zh"];
        self.dict = dic;
        self.currentHostLogo = [NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, host[@"logo"]];
        self.currentVisitingLogo = [NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, visiting[@"logo"]];
        self.competitionName = dic[@"matchevents"][matchKey][@"name_zh"];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSDictionary *history = self.dict[@"history"];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        // 猜胜负
        RBAnalyFirstCell *firstCell = [RBAnalyFirstCell createCellByTableView:tableView];
        firstCell.gameStatus = self.biSaiModel.status;
        firstCell.dict = self.statusDict;
        firstCell.clickBtn = ^(NSInteger tag) {
            // 顶
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:@(weakSelf.biSaiModel.namiId) forKey:@"mid"];
            if (tag == 300) {
                [dict setValue:@(1) forKey:@"t"];
            } else if (tag == 301) {
                [dict setValue:@(0) forKey:@"t"];
            } else {
                [dict setValue:@(2) forKey:@"t"];
            }
            [RBNetworkTool PostDataWithUrlStr:@"apis/guessmatch"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
                if (backData != nil && backData[@"ok"] != nil) {
                    [RBToast showWithTitle:@"投票成功"];
                    [weakSelf getguessrate];
                }
            } Fail:^(NSError *_Nonnull error) {
            }];
        };
        cell = firstCell;
    } else if (indexPath.row == 1) {
        // 分析
        cell =   [RBAnalySecondCell createCellByTableView:tableView];
    } else if (indexPath.row == 2) {
        // 进球分布
        RBAnalyThirdCell *thirdCell =  [RBAnalyThirdCell createCellByTableView:tableView];
        cell = thirdCell;
        if (self.dict[@"injury"] == nil) {
            cell.hidden = YES;
        } else {
            thirdCell.currentHostName = self.currentHostName;
            thirdCell.currentVisitingName = self.currentVisitingName;
            thirdCell.dict = self.dict;
            if (self.dict[@"goal_distribution"] == nil) {
                cell.hidden = YES;
            } else {
                NSDictionary *home = self.dict[@"goal_distribution"][@"home"];
                NSDictionary *away = self.dict[@"goal_distribution"][@"away"];
                if (home.count == 0 && away.count == 0) {
                    cell.hidden = YES;
                }
            }
        }
    } else if (indexPath.row == 3) {
        // 伤停情况
        RBAnalyFourthCell *fourthcell =  [RBAnalyFourthCell createCellByTableView:tableView];
        cell = fourthcell;
        fourthcell.currentVisitingLogo = self.currentVisitingLogo;
        fourthcell.currentHostLogo = self.currentHostLogo;
        fourthcell.currentHostName = self.currentHostName;
        fourthcell.currentVisitingName = self.currentVisitingName;
        fourthcell.dict = self.dict;
    } else if (indexPath.row == 4) {
        // 历史交锋
        RBAnalyFiveCell *fivecell = [RBAnalyFiveCell createCellByTableView:tableView];
        fivecell.clickItem = ^(NSInteger count) {
            weakSelf.fiveCount = count;
            [weakSelf.tableView reloadData];
        };
        cell = fivecell;
        NSArray *vs = history[@"vs"];
        if (vs.count != 0) {
            fivecell.currentHostName = self.currentHostName;
            fivecell.currentVisitingName = self.currentVisitingName;
            fivecell.dict = self.dict;
        }
        cell.hidden = (vs.count == 0);
    } else if (indexPath.row == 5) {
        // 近期战绩
        RBAnalySixCell *sixcell = [RBAnalySixCell createCellByTableView:tableView];
        sixcell.competitionName = self.competitionName;
        sixcell.clickItem1 = ^(NSInteger count) {
            weakSelf.sixHomeCount = count;
            [weakSelf.tableView reloadData];
        };
        sixcell.clickItem2 = ^(NSInteger count) {
            weakSelf.sixAwayCount = count;
            [weakSelf.tableView reloadData];
        };
        sixcell.currentHostName = self.currentHostName;
        sixcell.currentVisitingName = self.currentVisitingName;
        sixcell.currentVisitingLogo = self.currentVisitingLogo;
        sixcell.currentHostLogo = self.currentHostLogo;
        sixcell.dict = self.dict;
        cell = sixcell;
        cell.hidden = (history[@"home"] == nil && history[@"away"] == nil);
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 180;
    } else if (indexPath.row == 1) {
        return 122;
    } else if (indexPath.row == 2) {
        //        没有进球分布
        if (self.dict[@"goal_distribution"] == nil) {
            return 0;
        } else {
            NSDictionary *home = self.dict[@"goal_distribution"][@"home"];
            NSDictionary *away = self.dict[@"goal_distribution"][@"away"];

            if (home.count == 0 && away.count == 0) {
                return 0;
            } else {
                return 138;
            }
        }
    } else if (indexPath.row == 3) {
        // 伤停情况
        NSArray *home = self.dict[@"injury"][@"home"];
        NSArray *away = self.dict[@"injury"][@"away"];
        int footH = 0;
        if (home.count == 0) {
            footH += 53;
        }
        if (away.count == 0) {
            footH += 53;
        }
        return 71 * 2 + footH + 44 * (home.count + away.count) + 46;
    } else if (indexPath.row == 4) {
        // 历史交锋
        NSArray *vs = self.dict[@"history"][@"vs"];
        if (vs.count == 0) {
            return 0;
        } else {
            if (self.fiveCount != 0) {
                return 53 + 44 * (self.fiveCount) + 46;
            } else {
                int count =  (vs.count) > 10 ? 10 : (int)(vs.count);
                return 53 + 44 * (count) + 46;
            }
        }
    } else if (indexPath.row == 5) {
        // 近期战绩
        NSArray *home = self.dict[@"history"][@"home"];
        NSArray *away = self.dict[@"history"][@"away"];
        if (home.count == 0 && away.count == 0) {
            return 133 * 2 + 54;
        } else {
            int count1, count2;
            if (self.sixHomeCount != -1) {
                count1 =  (int)self.sixHomeCount;
            } else {
                count1 =  (home.count) > 10 ? 10 : (int)(home.count);
            }
            if (self.sixAwayCount != -1) {
                count2 =  (int)self.sixAwayCount;
            } else {
                count2 =  (away.count) > 10 ? 10 : (int)(away.count);
            }
            if (count1 == 0 && count2 == 0) {
                return 71 * 2 + 62 * 2 + 46;
            } else if (count1 == 0 && count2 != 0) {
                return 71 * 2 + 44 * (count1 + count2) + 28 + 62 + 46;
            } else if (count1 != 0 && count2 == 0) {
                return 71 * 2 + 44 * (count1 + count2) + 28 + 62 + 46;
            } else {
                return 71 * 2 + 44 * (count1 + count2) + 28 * 2 + 46;
            }
        }
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        self.clickCell();
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat placeHolderHeight = 0;
    if (RB_iPhoneX) {
        placeHolderHeight = self.biSaiDetailHead.height - RBNavBarAndStatusBarH;
    } else {
        placeHolderHeight = self.biSaiDetailHead.height - RBNavBarAndStatusBarH - RBStatusBarH;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        if (offsetY > self.lastContentOffset.y) {
            //往上滑动
            if (offsetY > (-self.biSaiDetailHead.y)) {
                self.biSaiDetailHead.y = -offsetY;
            }
        } else {
            //往下滑动
            if (offsetY < (-self.biSaiDetailHead.y)) {
                self.biSaiDetailHead.y = -offsetY;
            }
        }
        self.biSaiDetailHead.bigView.hidden = NO;
        self.biSaiDetailHead.smallView.hidden = YES;
        UIButton *btn = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (btn != nil) {
            btn.hidden = NO;
        }
        UIButton *btn2 = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
        if (btn2 != nil) {
            btn2.hidden = (self.biSaiModel.status == 8);
        }
    } else if (offsetY > placeHolderHeight) {
        if (self.biSaiDetailHead.y != (-placeHolderHeight)) {
            if (offsetY > self.lastContentOffset.y) {
                //往上滑动
                self.biSaiDetailHead.y = self.biSaiDetailHead.y - (scrollView.contentOffset.y - self.lastContentOffset.y);
            }
            if (self.biSaiDetailHead.y < (-placeHolderHeight)) {
                self.biSaiDetailHead.y = -placeHolderHeight;
            }
            if (self.biSaiDetailHead.y >= 0) {
                self.biSaiDetailHead.y = 0;
            }
        }
        self.biSaiDetailHead.bigView.hidden = YES;
        self.biSaiDetailHead.smallView.hidden = NO;
        UIButton *btn = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (btn != nil) {
            btn.hidden = YES;
        }
        UIButton *btn2 = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
        if (btn2 != nil) {
            btn2.hidden = YES;
        }
    } else if (offsetY < 0) {
        self.biSaiDetailHead.y =  -offsetY;
    }

    self.lastContentOffset = scrollView.contentOffset;
}

@end
