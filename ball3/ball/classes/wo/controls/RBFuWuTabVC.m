#import "RBFuWuTabVC.h"
#import "RBNetworkTool.h"
#import "RBJinBiModel.h"
#import "RBJinBiCell.h"

@interface RBFuWuTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int currentPage;
@end

@implementation RBFuWuTabVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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

- (void)getData {
    [MBProgressHUD showLoading:jiazhaizhong toView:self.tableView];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getdetailservercost2" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        if (backData[@"ok"] != nil) {
            NSArray *data = backData[@"ok"][@"data"];
            NSArray *arr = [RBJinBiModel mj_objectArrayWithKeyValuesArray:data];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBJinBiCell *cell = [RBJinBiCell createCellByTableView:tableView];
    cell.jinBiModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

@end
