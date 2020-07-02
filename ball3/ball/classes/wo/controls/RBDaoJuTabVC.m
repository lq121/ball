#import "RBDaoJuTabVC.h"
#import "RBNetworkTool.h"
#import "RBDaoJuCell.h"
#import "RBDaoJuModel.h"

@interface RBDaoJuTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int currentPage;
@end

@implementation RBDaoJuTabVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)getData {
    [MBProgressHUD showLoading:@"加载中…" toView:self.tableView];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getdetailpropcost" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        if (backData[@"ok"] != nil) {
            NSArray *data = backData[@"ok"][@"data"];
            NSArray *arr = [RBDaoJuModel mj_objectArrayWithKeyValuesArray:data];
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.currentPage == 0) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            [self.tableView showDataCount:self.dataArr.count andTitle:@"暂无消费记录"];
            [self.tableView reloadData];
        }
        [self.tableView showDataCount:self.dataArr.count andTitle:@"暂无消费记录"];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self getData];
}

- (void)loadMoreData {
    self.currentPage += 1;
    [self getData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBDaoJuCell *cell = [RBDaoJuCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.daoJuModel = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    hedView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *arr = @[@"主播", @"赛事", @"礼物", @"额度"];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 80, 20)];
    label1.text = @"时间";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    [hedView addSubview:label1];
    CGFloat width = (RBScreenWidth - 32 - 80) / arr.count;
    for (int i  = 0; i < arr.count; i++) {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(96 + i * width, 12, width, 20)];
        label1.text = arr[i];
        if (i == arr.count - 1) {
            label1.textAlignment = NSTextAlignmentRight;
        } else if (i == 1) {
            label1.textAlignment = NSTextAlignmentLeft;
        } else {
            label1.textAlignment = NSTextAlignmentCenter;
        }
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        [hedView addSubview:label1];
    }
    return hedView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

@end
