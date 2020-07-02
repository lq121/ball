#import "RBAnalyFiveCell.h"
#import "RBAnalyzeTitleView.h"
#import "RBDetailDataCell.h"
#import "RBBiSaiDetailHeadView.h"

@interface RBAnalyFiveCell ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL hasSelected;
@property (nonatomic, strong) NSDictionary *historyDict;

@end

@implementation RBAnalyFiveCell

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self.dataArr removeAllObjects];
    self.historyDict =  dict[@"history"];
    [self disposeWithSelected:self.hasSelected];
    self.tableView.frame = CGRectMake(0, 46, RBScreenWidth, self.dataArr.count * 44 + 33 + 20);
    [self.tableView reloadData];
}



+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalyFiveCell";
    RBAnalyFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
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
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"历史交锋" andFrame:CGRectMake(0, 0, RBScreenWidth, 46) andSecondTitle:@"" andDetail:@"" andFirstBtn:@"主客相同" andSecondBtn:@"" andClickFirstBtn:^(BOOL selected) {
            weakSelf.hasSelected = selected;
            [weakSelf.dataArr removeAllObjects];
            // 选中
            [weakSelf disposeWithSelected:self.hasSelected];
            [weakSelf.tableView reloadData];
        } andClickSecondBtn:^(BOOL selected) {
        }];
        [self addSubview:titleView];
        UITableView *tableView = [[UITableView alloc]init];
        tableView.tableHeaderView = [RBBiSaiDetailHeadView HeadViewWithLogo:@""   andName:@""];
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

- (void)disposeWithSelected:(BOOL)selected {
    NSArray *historyVSArr = self.historyDict[@"vs"];
    for (int i = 0; i < historyVSArr.count; i++) {
        NSArray *arr = historyVSArr[i];
        NSDictionary *teams = self.dict[@"teams"];
        NSArray *arr1 = arr[5]; // 主队
        NSArray *arr2 = arr[6]; // 客队
        NSArray *arr3 = arr[7];  // 盘口
        RBBiSaiDatailCellModel *cellModel = [[RBBiSaiDatailCellModel alloc]init];
        NSString *team1key = [NSString stringWithFormat:@"%d", [arr1[0]intValue]];
        NSString *team2key = [NSString stringWithFormat:@"%d", [arr2[0]intValue]];
        cellModel.team1Name = teams[team1key][@"name_zh"];
        cellModel.team2Name = teams[team2key][@"name_zh"];
        if (selected) {
            if ((![cellModel.team1Name isEqualToString:self.currentHostName] || ![cellModel.team2Name isEqualToString:self.currentVisitingName]) && (![cellModel.team1Name isEqualToString:self.currentVisitingName] || ![cellModel.team2Name isEqualToString:self.currentHostName])) {
                continue;
            }
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[arr[3]intValue]];
        cellModel.dataTime = [NSString getStrWithDate:date andFormat:@"yyyy\nMM/dd"];
        NSString *matchKey = [NSString stringWithFormat:@"%d", [arr[1]intValue]];
        cellModel.eventName =  self.dict[@"matchevents"][matchKey][@"name_zh"];
        cellModel.hostAllScore = [arr1[2]intValue];
        cellModel.hostHalfScore = [arr1[3]intValue];
        cellModel.visitingAllScore = [arr2[2]intValue];
        cellModel.visitingHalfScore = [arr2[3]intValue];
        cellModel.currentVisitingName = self.currentVisitingName;
        cellModel.currentHostName =  self.currentHostName;
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

        [self.dataArr addObject:cellModel];
        if (self.dataArr.count == 10) {
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDetailDataCell *cell = [RBDetailDataCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 20)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, RBScreenWidth - 16, 20)];
    int jinScore = 0,shiScore = 0,win = 0,fail = 0,average = 0;
    for (int i = 0; i < self.dataArr.count; i++) {
        RBBiSaiDatailCellModel *model = self.dataArr[i];
        if ([model.team1Name isEqualToString:model.currentHostName]) {
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
    if (self.dataArr.count != 0) {
        win2 = ((win * 100) / ((int)self.dataArr.count));
    }
    label.text = [NSString stringWithFormat:@"近%d场战绩，%@ %d胜 %d平 %d负 进%d球 失%d球 胜率：%2d%%", (int)self.dataArr.count, self.currentHostName, win, average, fail, jinScore, shiScore, win2];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [bgView addSubview:label];
    return bgView;
}

/**
 *  判断两个浮点数是否整除
 *
 *  @param firstNumber  第一个浮点数(被除数)
 *  @param secondNumber 第二个浮点数(除数,不能为0)
 *
 *  @return 返回值可判定是否整除
 */
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
