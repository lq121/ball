#import "RBWoHuaTiTabVC.h"
#import "RBNetworkTool.h"
#import "RBHuaTiCell.h"
#import "RBHuaTiModel.h"
#import "RBHuaTiDetailVC.h"

@interface RBWoHuaTiTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int currentPage;
@end

@implementation RBWoHuaTiTabVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refshHuaTi:) name:@"refshHuaTi" object:nil];
}

- (void)refshHuaTi:(NSNotification *)noti {
    [self.dataArr removeObject:noti.object];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (void)loadNewData {
    self.currentPage = 0;
    [self loaddata];
}

- (void)loadMoreData {
    self.currentPage += 1;
    [self loaddata];
}

- (void)loaddata {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(0) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getwodehuati" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray *arr = [RBHuaTiModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        if (arr.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        for (RBHuaTiModel *huaTiModel in arr) {
            huaTiModel.canClear = YES;
            [self.dataArr addObject:huaTiModel];
        }
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.dataArr removeAllObjects];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiCell *cell = [[RBHuaTiCell alloc]init];
    cell.huaTiModel = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiModel *huaTiModel = self.dataArr[indexPath.row];
    CGFloat height = 84;
    CGSize size = [huaTiModel.Txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32];
    height += size.height;
    NSData *jsonData = nil;
    NSError *err;
    jsonData = [huaTiModel.Img dataUsingEncoding:NSUTF8StringEncoding];
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
    RBHuaTiDetailVC *desVC = [[RBHuaTiDetailVC alloc]init];
    desVC.huaTiModel = model;
    [self.navigationController pushViewController:desVC animated:YES];
}

@end
