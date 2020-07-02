#import "RBAllHuaTiTabVC.h"
#import "RBNetworkTool.h"
#import "RBHuaTiModel.h"
#import "RBHuaTiCell.h"
#import "RBHuaTiDetailVC.h"

@interface RBAllHuaTiTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *type;
@end

@implementation RBAllHuaTiTabVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData {
    self.currentPage += 1;
    [self loadDataByType:self.type];
}

- (void)loadNewData {
    self.currentPage = 0;
    [self loadDataByType:self.type];
}

- (void)loadDataWithType:(NSString *)type {
    self.type = type;
    self.currentPage = 0;
    [self loadDataByType:self.type];
}

- (void)loadDataByType:(NSString *)type {
    self.type = type;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:[NSString stringWithFormat:@"try/go/%@", self.type]  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray *arr = backData[@"ok"];
        if (arr.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:[RBHuaTiModel mj_objectArrayWithKeyValuesArray:arr]];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiCell *cell = [RBHuaTiCell createCellByTableView:tableView];
    cell.huaTiModel = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiModel *hutTiModel = self.dataArr[indexPath.row];
    CGFloat height = 84;
    CGSize size = [hutTiModel.Txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32];
    height += size.height;
    NSData *jsonData = nil;
    NSError *err;
    jsonData = [hutTiModel.Img dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (arr.count == 0) {
        height += 17;
    } else {
        CGFloat width = 109;

        if (arr.count % 3 > 0) {
            height += (width + 4);
        }
        height += ((arr.count) / 3) * (width + 4);
        height += 29;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiModel *model = self.dataArr[indexPath.row];
    RBHuaTiDetailVC *desTabVC = [[RBHuaTiDetailVC alloc]init];
    desTabVC.huaTiModel = model;
    [self.navigationController pushViewController:desTabVC animated:YES];
}

@end
