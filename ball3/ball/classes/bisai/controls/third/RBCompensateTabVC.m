#import "RBCompensateTabVC.h"
#import "RBCompensateCell.h"
#import "RBAiDataModel.h"

@interface RBCompensateTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *threeArr;
@end

@implementation RBCompensateTabVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)threeArr {
    if (_threeArr == nil) {
        _threeArr = [NSMutableArray array];
    }
    return _threeArr;
}

- (void)setEuropeArr:(NSArray *)europeArr {
    _europeArr = europeArr;
    [self.dataArr addObjectsFromArray:europeArr];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    if (europeArr.count != 0) {
        double minFirstHostBall, minFirstCenterBall, minFirstVisitBall, minSecondHostBall, minSecondCenterBall, minSecondVisitBall, maxFirstHostBall, maxFirstCenterBall, maxFirstVisitBall, maxSecondHostBall, maxSecondCenterBall, maxSecondVisitBall, sumFirstHostBall, sumFirstCenterBall, sumFirstVisitBall, sumSecondHostBall, sumSecondCenterBall, sumSecondVisitBall;
        RBAiDataModel *aiModel = europeArr[0];
        minFirstHostBall = aiModel.firstHostBall;
        minFirstCenterBall = aiModel.firstCenterBall;
        minFirstVisitBall = aiModel.firstVisiterBall;
        minSecondHostBall = aiModel.secondHostBall;
        minSecondCenterBall = aiModel.secondCenterBall;
        minSecondVisitBall = aiModel.secondVisiterBall;

        maxFirstHostBall = aiModel.firstHostBall;
        maxFirstCenterBall = aiModel.firstCenterBall;
        maxFirstVisitBall = aiModel.firstVisiterBall;
        maxSecondHostBall = aiModel.secondHostBall;
        maxSecondCenterBall = aiModel.secondCenterBall;
        maxSecondVisitBall = aiModel.secondVisiterBall;

        sumFirstHostBall = aiModel.firstHostBall;
        sumFirstCenterBall = aiModel.firstCenterBall;
        sumFirstVisitBall = aiModel.firstVisiterBall;
        sumSecondHostBall = aiModel.secondHostBall;
        sumSecondCenterBall = aiModel.secondCenterBall;
        sumSecondVisitBall = aiModel.secondVisiterBall;

        for (int i = 1; i < europeArr.count; i++) {
            RBAiDataModel *model = europeArr[i];
            sumFirstHostBall += model.firstHostBall;
            sumFirstCenterBall += model.firstCenterBall;
            sumFirstVisitBall += model.firstVisiterBall;

            sumSecondHostBall += model.secondHostBall;
            sumSecondCenterBall += model.secondCenterBall;
            sumSecondVisitBall += model.secondVisiterBall;

            if (model.firstHostBall > maxFirstHostBall) {
                maxFirstHostBall = model.firstHostBall;
            }
            if (model.firstCenterBall > maxFirstCenterBall) {
                maxFirstCenterBall = model.firstCenterBall;
            }
            if (model.firstVisiterBall > maxFirstVisitBall) {
                maxFirstVisitBall = model.firstVisiterBall;
            }

            if (model.secondHostBall  > maxSecondHostBall) {
                maxSecondHostBall = model.secondHostBall;
            }
            if (model.secondCenterBall > maxSecondCenterBall) {
                maxSecondCenterBall = model.secondCenterBall;
            }
            if (model.secondVisiterBall > maxSecondVisitBall) {
                maxSecondVisitBall = model.secondVisiterBall;
            }

            if (model.firstHostBall < minFirstHostBall) {
                minFirstHostBall = model.firstHostBall;
            }
            if (model.firstCenterBall < minFirstCenterBall) {
                minFirstCenterBall = model.firstCenterBall;
            }
            if (model.firstVisiterBall < minFirstVisitBall) {
                minFirstVisitBall = model.firstVisiterBall;
            }

            if (model.secondHostBall  < minSecondHostBall) {
                minSecondHostBall = model.secondHostBall;
            }
            if (model.secondCenterBall < minSecondCenterBall) {
                minSecondCenterBall = model.secondCenterBall;
            }
            if (model.secondVisiterBall < minSecondVisitBall) {
                minSecondVisitBall = model.secondVisiterBall;
            }
        }

        RBAiDataModel *model1 = [[RBAiDataModel alloc]init];
        model1.company = @"最高值";
        model1.firstHostBall = maxFirstHostBall;
        model1.firstCenterBall = maxFirstCenterBall;
        model1.firstVisiterBall = maxFirstVisitBall;
        model1.secondHostBall = maxSecondHostBall;
        model1.secondCenterBall = maxSecondCenterBall;
        model1.secondVisiterBall = maxSecondVisitBall;

        RBAiDataModel *model2 = [[RBAiDataModel alloc]init];
        model2.company = @"最低值";
        model2.firstHostBall = minFirstHostBall;
        model2.firstCenterBall = minFirstCenterBall;
        model2.firstVisiterBall = minFirstVisitBall;
        model2.secondHostBall = minSecondHostBall;
        model2.secondCenterBall = minSecondCenterBall;
        model2.secondVisiterBall = minSecondVisitBall;

        RBAiDataModel *model3 = [[RBAiDataModel alloc]init];
        model3.company = @"平均值";
        model3.firstHostBall = (sumFirstHostBall * 100) / (europeArr.count * 100);
        model3.firstCenterBall = (sumFirstCenterBall * 100) / (europeArr.count * 100);
        model3.firstVisiterBall = (sumFirstVisitBall * 100) / (europeArr.count * 100);
        model3.secondHostBall = (sumSecondHostBall * 100) / (europeArr.count * 100);
        model3.secondCenterBall = (sumSecondCenterBall * 100) / (europeArr.count * 100);
        model3.secondVisiterBall = (sumSecondVisitBall * 100) / (europeArr.count * 100);

        [self.threeArr addObject:model1];
        [self.threeArr addObject:model2];
        [self.threeArr addObject:model3];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataArr.count == 0) {
            return 0;
        } else {
            return self.threeArr.count;
        }
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBCompensateCell *cell = [RBCompensateCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.aiDataModel = self.dataArr[indexPath.row];
    } else {
        cell.aiDataModel = self.threeArr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 58;
    } else {
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc]init];
    } else {
        NSArray *array = @[@"公司", @"主胜", @"平局", @"客胜"];
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 37)];
        titleView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        CGFloat width = (RBScreenWidth - 32 - 58) / (array.count + 1);
        for (int i = 0; i < array.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.text = array[i];
            label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(24 + i * width, 16, width, 17);
            if (i >= 1) {
                label.frame = CGRectMake(24 + (i + 1) * width, 16, width, 17);
            }
            label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
            if (i != 3) {
                label.textAlignment = NSTextAlignmentLeft;
            } else {
                label.textAlignment = NSTextAlignmentRight;
            }
            [titleView addSubview:label];
            if (i == 0) {
                label.x = 58 + 16 + 16;
            } else if (i == 1) {
                label.x = RBScreenWidth - 160 - width + 24;
            } else if (i == 2) {
                label.x = RBScreenWidth - 81 - width + 24;
            } else {
                label.x = RBScreenWidth - 30 - width;
            }
        }
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        if (self.dataArr.count == 0) {
            return 0;
        } else {
            return 37;
        }
    }
}


@end
