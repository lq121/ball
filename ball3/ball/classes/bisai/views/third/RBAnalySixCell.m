#import "RBAnalySixCell.h"
#import "RBAnalyzeTitleView.h"
#import "RBDetailDataCell.h"
#import "RBBiSaiDetailHeadView.h"

@interface RBAnalySixCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homeShowArr;
@property (nonatomic, strong) NSMutableArray *awayShowArr;
@property (nonatomic, assign) BOOL hasclickFirst;
@property (nonatomic, assign) BOOL hasClickSecond;
@property (nonatomic, strong) NSArray *homeArr;
@property (nonatomic, strong) NSArray *awayArr;

@end

@implementation RBAnalySixCell

- (NSMutableArray *)homeShowArr {
    if (_homeShowArr == nil) {
        _homeShowArr = [NSMutableArray array];
    }
    return _homeShowArr;
}

- (NSMutableArray *)awayShowArr {
    if (_awayShowArr == nil) {
        _awayShowArr = [NSMutableArray array];
    }
    return _awayShowArr;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSDictionary *historyDict = dict[@"history"];
    NSArray *home = historyDict[@"home"];
    NSArray *away = historyDict[@"away"];
    self.homeArr = home;
    self.awayArr = away;
    [self.homeShowArr removeAllObjects];
    [self.awayShowArr removeAllObjects];

    [self disposeData:self.hasclickFirst andHaseSelectSecond:self.hasClickSecond andNoBlock:YES];
    if (self.homeShowArr.count == 0 && self.awayShowArr.count == 0) {
        self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, (self.homeShowArr.count + self.awayShowArr.count) * 44 + 71 * 2 + 62 * 2);
    } else if (self.homeShowArr.count != 0 && self.awayShowArr.count == 0) {
        self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, (self.homeShowArr.count + self.awayShowArr.count) * 44 + 71 * 2 + 62 + 28);
    } else if (self.homeShowArr.count == 0 && self.awayShowArr.count != 0) {
        self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, (self.homeShowArr.count + self.awayShowArr.count) * 44 + 71 * 2 + 62 + 28);
    } else {
        self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, (self.homeShowArr.count + self.awayShowArr.count) * 44 + 71 * 2 + 2 * 28);
    }
    [self.tableView reloadData];
}


+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalySixCell";
    RBAnalySixCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        __weak typeof(self) weakSelf = self;
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"近期战绩" andFrame:CGRectMake(0, 0, RBScreenWidth, 46) andSecondTitle:@"" andDetail:@"" andFirstBtn:@"同赛事" andSecondBtn:@"同主客" andClickFirstBtn:^(BOOL selected) {
            weakSelf.hasclickFirst = selected;
            [weakSelf disposeData:self.hasclickFirst andHaseSelectSecond:self.hasClickSecond andNoBlock:NO];
        } andClickSecondBtn:^(BOOL selected) {
            weakSelf.hasClickSecond = selected;
            [weakSelf disposeData:self.hasclickFirst andHaseSelectSecond:self.hasClickSecond andNoBlock:NO];
        }];
        [self addSubview:titleView];
        UITableView *tableView = [[UITableView alloc]init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self addSubview:tableView];
    }
    return self;
}

- (void)disposeData:(BOOL)hasSelectFirst andHaseSelectSecond:(BOOL)selected andNoBlock:(BOOL)noblock {
    [self.homeShowArr removeAllObjects];
    [self.awayShowArr removeAllObjects];
    NSDictionary *teams = self.dict[@"teams"];
    for (int i = 0; i < self.homeArr.count; i++) {
        NSArray *arr = self.homeArr[i];
        RBBiSaiDatailCellModel *cellModel = [[RBBiSaiDatailCellModel alloc]init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[arr[3]intValue]];
        cellModel.dataTime = [NSString getStrWithDate:date andFormat:@"yyyy\nMM/dd"];
        NSString *matchKey = [NSString stringWithFormat:@"%d", [arr[1]intValue]];
        cellModel.eventName =  self.dict[@"matchevents"][matchKey][@"name_zh"];
        NSArray *arr1 = arr[5];
        NSArray *arr2 = arr[6];
        NSArray *arr3 = arr[7]; // 盘路
        NSString *team1key = [NSString stringWithFormat:@"%d", [arr1[0]intValue]];
        NSString *team2key = [NSString stringWithFormat:@"%d", [arr2[0]intValue]];
        cellModel.team1Name = teams[team1key][@"name_zh"];
        cellModel.team2Name = teams[team2key][@"name_zh"];
        cellModel.hostAllScore = [arr1[2]intValue];
        cellModel.hostHalfScore = [arr1[3]intValue];
        cellModel.visitingAllScore = [arr2[2]intValue];
        cellModel.visitingHalfScore = [arr2[3]intValue];
        cellModel.currentVisitingName = self.currentVisitingName;
        cellModel.currentHostName =  self.currentHostName;
        if (hasSelectFirst) {
            // 同赛事
            if (![cellModel.eventName isEqualToString:self.competitionName]) {
                continue;
            }
        }
        if (selected) {
            // 同主客
            if (![cellModel.team1Name isEqualToString:self.currentHostName]) {
                continue;
            }
        }
        NSString *disStr = arr3[0];
        NSArray *StrArr = [disStr componentsSeparatedByString:@","];
        if (![disStr isEqualToString:@""] && StrArr != nil && StrArr[1] != nil) {
            float disCount =  [StrArr[1] floatValue];
            float bigDisCount, firstCount, secondCount;
            firstCount = cellModel.hostAllScore;
            secondCount = cellModel.visitingAllScore;
            if ([self judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
                if ([self judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f", disCount];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f", disCount];
                }
                if ([cellModel.team1Name isEqualToString:self.currentHostName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            } else if (disCount > 0) {
                bigDisCount = disCount;
                if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                }

                if ([cellModel.team1Name isEqualToString:self.currentHostName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            } else {
                bigDisCount = -disCount;
                if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                }

                if ([cellModel.team1Name isEqualToString:self.currentHostName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            }
        }

        [self.homeShowArr addObject:cellModel];
        if (self.homeShowArr.count >= 10) {
            break;
        }
    }
    for (int i = 0; i < self.awayArr.count; i++) {
        NSArray *arr = self.awayArr[i];
        RBBiSaiDatailCellModel *cellModel = [[RBBiSaiDatailCellModel alloc]init];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[arr[3]intValue]];
        cellModel.dataTime = [NSString getStrWithDate:date andFormat:@"yyyy\nMM/dd"];
        NSString *matchKey = [NSString stringWithFormat:@"%d", [arr[1]intValue]];
        cellModel.eventName =  self.dict[@"matchevents"][matchKey][@"name_zh"];
        NSArray *arr1 = arr[5];
        NSArray *arr2 = arr[6];
        NSArray *arr3 = arr[7]; // 盘路
        NSString *team1key = [NSString stringWithFormat:@"%d", [arr1[0]intValue]];
        NSString *team2key = [NSString stringWithFormat:@"%d", [arr2[0]intValue]];
        cellModel.team1Name = teams[team1key][@"name_zh"];
        cellModel.team2Name = teams[team2key][@"name_zh"];
        cellModel.hostAllScore = [arr1[2]intValue];
        cellModel.hostHalfScore = [arr1[3]intValue];
        cellModel.visitingAllScore = [arr2[2]intValue];
        cellModel.visitingHalfScore = [arr2[3]intValue];
        cellModel.currentVisitingName = self.currentVisitingName;
        cellModel.currentHostName =  self.currentHostName;
        if (hasSelectFirst) {
            // 同赛事
            if (![cellModel.eventName isEqualToString:self.competitionName]) {
                continue;
            }
        }
        if (selected) {
            // 同主客
            if (![cellModel.team2Name isEqualToString:self.currentHostName]) {
                continue;
            }
        }
        NSString *disStr = arr3[0];
        NSArray *StrArr = [disStr componentsSeparatedByString:@","];
        if (![disStr isEqualToString:@""] && StrArr != nil && StrArr[1] != nil) {
            float disCount =  [StrArr[1] floatValue];
            float bigDisCount, firstCount, secondCount;
            firstCount = cellModel.hostAllScore;
            secondCount = cellModel.visitingAllScore;
            if ([self judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
                if ([self judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f", disCount];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f", disCount];
                }
                if ([cellModel.team1Name isEqualToString:self.currentVisitingName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            } else if (disCount > 0) {
                bigDisCount = disCount;
                if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                }

                if ([cellModel.team1Name isEqualToString:self.currentVisitingName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            } else {
                bigDisCount = -disCount;
                if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![self judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [self judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    cellModel.dish = [NSString stringWithFormat:@"-%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
                }
                if ([cellModel.team1Name isEqualToString:self.currentVisitingName]) {
                    // 主队在左侧
                    if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                } else {
                    if (firstCount - secondCount < disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n赢", cellModel.dish];
                    } else if (firstCount - secondCount > disCount) {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n输", cellModel.dish];
                    } else {
                        cellModel.dish = [NSString stringWithFormat:@"%@\n走", cellModel.dish];
                    }
                }
            }
        }

        [self.awayShowArr addObject:cellModel];
        if (self.awayShowArr.count  >= 10) {
            break;
        }
    }
    if (!noblock) {
        self.clickItem1(self.homeShowArr.count);
        self.clickItem2(self.awayShowArr.count);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.homeShowArr.count;
    } else {
        return self.awayShowArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailDataCell *cell = [RBDetailDataCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.detailModel = self.homeShowArr[indexPath.row];
    } else {
        RBBiSaiDatailCellModel *model = self.awayShowArr[indexPath.row];
        model.type = 1;
        cell.detailModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 71;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        if (self.homeShowArr.count != 0) {
            height += 28;
        } else {
            height += 62;
        }
    } else {
        if (self.awayShowArr.count != 0) {
            height += 28;
        } else {
            height += 62;
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [RBBiSaiDetailHeadView HeadViewWithLogo:self.currentHostLogo andName:self.currentHostName];
    } else {
        return [RBBiSaiDetailHeadView HeadViewWithLogo:self.currentVisitingLogo andName:self.currentVisitingName];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, RBScreenWidth, 0);
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, RBScreenWidth, 8)];
    grayView.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 62)];
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    label.text = @"暂无战绩";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:grayView];
    [footView addSubview:label];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, RBScreenWidth - 16, 20)];
    [footView addSubview:label2];
    int jinScore = 0,shiScore = 0,win = 0,fail = 0,average = 0;
    if (section == 0) {
        for (int i = 0; i < self.homeShowArr.count; i++) {
            RBBiSaiDatailCellModel *model = self.homeShowArr[i];
            if ([model.team1Name isEqualToString:self.currentHostName]) {
                jinScore += model.hostAllScore;
                shiScore += model.visitingAllScore;
                if (model.hostAllScore < model.visitingAllScore) {
                    fail += 1;
                } else if (model.hostAllScore == model.visitingAllScore) {
                    average += 1;
                } else {
                    win += 1;
                }
            } else {
                jinScore += model.visitingAllScore;
                shiScore += model.hostAllScore;
                if (model.hostAllScore < model.visitingAllScore) {
                    win += 1;
                } else if (model.hostAllScore == model.visitingAllScore) {
                    average += 1;
                } else {
                    fail += 1;
                }
            }
        }
        int win2 = 0;
        if (self.homeShowArr.count != 0) {
            win2 = ((win * 100) / ((int)self.homeShowArr.count));
        }
        label2.text = [NSString stringWithFormat:@"近%d场战绩，%@ %d胜 %d平 %d负 进%d球 失%d球 胜率：%2d%%", (int)self.homeShowArr.count, self.currentHostName, win, average, fail, jinScore, shiScore, win2 ];
    } else {
        for (int i = 0; i < self.awayShowArr.count; i++) {
            RBBiSaiDatailCellModel *model = self.awayShowArr[i];
            if ([model.team1Name isEqualToString:self.currentVisitingName]) {
                jinScore += model.hostAllScore;
                shiScore += model.visitingAllScore;
                if (model.hostAllScore < model.visitingAllScore) {
                    fail += 1;
                } else if (model.hostAllScore == model.visitingAllScore) {
                    average += 1;
                } else {
                    win += 1;
                }
            } else {
                jinScore += model.visitingAllScore;
                shiScore += model.hostAllScore;
                if (model.hostAllScore < model.visitingAllScore) {
                    win += 1;
                } else if (model.hostAllScore == model.visitingAllScore) {
                    average += 1;
                } else {
                    fail += 1;
                }
            }
        }
        int win2 = 0;
        if (self.awayShowArr.count != 0) {
            win2 = ((win * 100) / ((int)self.awayShowArr.count));
        }
        label2.text = [NSString stringWithFormat:@"近%d场战绩，%@ %d胜 %d平 %d负 进%d球 失%d球 胜率：%2d%%", (int)self.awayShowArr.count, self.currentVisitingName, win, average, fail, jinScore, shiScore, win2];
    }

    label2.font = [UIFont systemFontOfSize:11];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor colorWithSexadeString:@"#333333"];

    CGFloat height = 0;
    if (section == 0) {
        if (self.homeShowArr.count != 0) {
            height += 28;
            label2.hidden = NO;
            label.hidden = YES;
            grayView.hidden = NO;
        } else {
            height += 62;
            label2.hidden = YES;
            label.hidden = NO;
            grayView.hidden = YES;
        }
    } else {
        if (self.awayShowArr.count != 0) {
            height += 28;
            label2.hidden = NO;
            label.hidden = YES;
            grayView.hidden = NO;
        } else {
            height += 62;
            label2.hidden = YES;
            label.hidden = NO;
            grayView.hidden = YES;
        }
    }
    footView.height = height;
    return footView;
}

- (BOOL)judgeDivisibleWithFirstNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber {
    // 默认记录为整除
    BOOL isDivisible = YES;
    if (secondNumber == 0) {
        return NO;
    }

    CGFloat result = firstNumber / secondNumber;
    NSString *resultStr = [NSString stringWithFormat:@"%f", result];
    NSRange range = [resultStr rangeOfString:@"."];
    NSString *subStr = [resultStr substringFromIndex:range.location + 1];

    for (NSInteger index = 0; index < subStr.length; index++) {
        unichar ch = [subStr characterAtIndex:index];
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
            isDivisible = NO;
            break;
        }
    }
    return isDivisible;
}

@end
