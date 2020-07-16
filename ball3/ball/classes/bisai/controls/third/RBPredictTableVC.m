#import "RBPredictTableVC.h"
#import "RBBiSaiPredictCell.h"
#import "RBBISaiPredictModel.h"
#import "RBNetworkTool.h"
#import "RBOrderDisburseVC.h"
#import "RBFMDBTool.h"
#import "RBFloatOption.h"

@interface RBPredictTableVC ()
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation RBPredictTableVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getaiData];
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    [self getaiData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (void)getaiData {
    // 获取分析数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.matchId == 0) return;
    [dict setValue:@(self.matchId) forKey:@"matchid"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getmatchaidata" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"] intValue] == 50011) {
            // 比赛不存在
            [[RBFMDBTool sharedFMDBTool]deleteBiSaiModelWithId:self.biSaiModel.namiId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBiSai" object:nil];
            [[UIViewController getCurrentVC].navigationController popViewControllerAnimated:YES];
        }
        if (backData[@"err"] == nil && backData[@"error"] == nil && backData != nil && backData[@"ok"] != nil) {
            [self setDataWith:backData];
        }
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    }];
}

- (void)setDataWith:(NSDictionary *)backData {
    [self.dataArr removeAllObjects];
    NSDictionary *ok = backData[@"ok"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ok options:0 error:0];
    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[RBFMDBTool sharedFMDBTool]updateBiSaiModelWithNamiId:self.biSaiModel.namiId andBallData:dataStr];
    [[RBFMDBTool sharedFMDBTool]updateAttentionBiSaiModelWithNamiId:self.biSaiModel.namiId andBallData:dataStr];
    NSMutableArray *buy = [NSMutableArray array]; // 购买信息
    [buy addObject:ok[@"Sbuy"]];
    [buy addObject:ok[@"Rbuy"]];
    [buy addObject:ok[@"Dbuy"]];
    NSArray *titles = @[ shengpingfu, rangqiu, daxiaoqiu];
    NSArray *D = ok[@"D"];  // 大小球数据
    NSArray *R = ok[@"R"]; // 让球数据
    NSArray *S = ok[@"S"]; // 胜平负数据
    for (int i = 0; i < titles.count; i++) {
        RBBISaiPredictModel *model = [[RBBISaiPredictModel alloc]init];
        model.titleName = titles[i]; // 名字
        model.coin = [backData[@"cost"] intValue]; // 金币
        model.flat = -1;
        if (i != 2) {
            model.showLine = YES; // 是否需要下划线
        }
        if (i == 0) {
            model.noData = ([S isKindOfClass:[NSNull class]]  || S.count == 0);
        } else if (i == 1) {
            model.noData = ([R isKindOfClass:[NSNull class]] || R.count == 0);
        } else {
            model.noData = ([D isKindOfClass:[NSNull class]]  ||  D.count == 0);
        }
        if (i == 1 && ![R isKindOfClass:[NSNull class]] && R.count >= 3) {
            CGFloat disCount = [R[1]floatValue];
            if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
                if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                    if (disCount > 0) {
                        model.desTitle = [NSString stringWithFormat:@"主让 %0.0f", disCount];
                    } else if (disCount == 0) {
                        model.desTitle = [NSString stringWithFormat:@"%0.0f", disCount];
                    } else {
                        model.desTitle = [NSString stringWithFormat:@"客让 %0.0f", -disCount];
                    }
                } else {
                    if (disCount > 0) {
                        model.desTitle = [NSString stringWithFormat:@"主让 %0.1f", disCount];
                    } else if (disCount == 0) {
                        model.desTitle = [NSString stringWithFormat:@"%0.1f", disCount];
                    } else {
                        model.desTitle = [NSString stringWithFormat:@"客让 %0.1f", -disCount];
                    }
                }
            } else {
                CGFloat bigDisCount;
                NSString *str = @"";
                if (disCount > 0) {
                    str = [str stringByAppendingString:@"主让 "];
                    bigDisCount = disCount;
                } else {
                    str = [str stringByAppendingString:@"客让 "];
                    bigDisCount = -disCount;
                }
                if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%@%0.0f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%@%0.0f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%@%0.1f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    model.desTitle = [NSString stringWithFormat:@"%@%0.1f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                }
            }
        } else if (i == 0 && ![S isKindOfClass:[NSNull class]] && S.count >= 3) {
            model.desTitle = @"";
        } else if (i == 2 && ![D isKindOfClass:[NSNull class]] && D.count >= 3) {
            if ([RBFloatOption judgeDivisibleWithFirstNumber:[D[1]floatValue] andSecondNumber:0.5]) {
                model.desTitle = [NSString stringWithFormat:@"%@球", [NSString formatFloat:[D[1]floatValue]]];
            } else {
                CGFloat bigDisCount = [D[1]floatValue];
                if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%0.0f/%0.0f球", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%0.0f/%0.1f球", bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    model.desTitle = [NSString stringWithFormat:@"%0.1f/%0.0f球", bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    model.desTitle = [NSString stringWithFormat:@"%0.1f/%0.1f球", bigDisCount - 0.25, bigDisCount + 0.25];
                }
            }
        }

        if ([buy[i] intValue] == 0 && self.biSaiModel.status != 8) { // 是否有购买或者已完赛
            model.status = 1;
        } else {
            model.status = 2;
            if (i == 1 && ![R isKindOfClass:[NSNull class]] && R.count >= 3) {
                model.negative = ([R[0]floatValue] * 100) / (([R[0]floatValue] + [R[2]floatValue]) * 100) * 100;
            } else if (i == 0 && ![S isKindOfClass:[NSNull class]] && S.count >= 3) {
                CGFloat w0 = [S[0]floatValue];
                CGFloat w1 = [S[1]floatValue];
                CGFloat w2 = [S[2]floatValue];
                NSMutableArray *mutArr = [NSMutableArray arrayWithArray:S];

                CGFloat max = MAX(MAX(w0, w1), w2);
                CGFloat min = MIN(MIN(w0, w1), w2);
                int m = 0, n = 0;
                for (int i = 0; i < 3; i++) {
                    if (max == [S[i]floatValue]) {
                        m = i;
                    }
                    if (min == [S[i]floatValue]) {
                        n = i;
                    }
                }
                NSString *temp = mutArr[m];
                mutArr[m] = mutArr[n];
                mutArr[n] = temp;
                model.win = ([mutArr[0]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
                model.flat = ([mutArr[1]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
                model.negative = ([mutArr[2]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
            } else if (i == 2 && ![D isKindOfClass:[NSNull class]] && D.count >= 3) {
                model.negative = ([D[0]floatValue] * 100) / (([D[0]floatValue] + [D[2]floatValue]) * 100) * 100;
            }
        }
        if (self.biSaiModel.status == 8) {
            if (i == 1) {
                model.status = 3;
                model.zhunqueType = [ok[@"Rret"] intValue];
            } else if (i == 0) {
                model.status = 3;
                model.zhunqueType = [ok[@"Sret"] intValue];
            } else if (i == 2) {
                model.status = 3;
                model.zhunqueType = [ok[@"Dret"] intValue];
            }
        }
        [self.dataArr addObject:model];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBBiSaiPredictCell *cell = [RBBiSaiPredictCell createCellByTableView:tableView];
    __weak typeof(self) weakSelf = self;
    cell.clickBtn = ^(NSInteger index) {
        RBOrderDisburseVC *orderDisburseVC = [[RBOrderDisburseVC alloc]init];
        orderDisburseVC.biSaiModel = weakSelf.biSaiModel;
        orderDisburseVC.biSaipredictModel = weakSelf.dataArr[index - 1];
        [weakSelf.navigationController pushViewController:orderDisburseVC animated:YES];
    };
    cell.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biSaiPredictModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

@end
