#import "RBZanTabVC.h"
#import "RBNetworkTool.h"
#import "RBZanCell.h"
#import "RBHuaTiHuiFuModel.h"
#import "RBHuaTiDetailVC.h"
#import "RBHengShiPingVC.h"
#import "RBShuShiPingVC.h"
#import "RBShiPingModel.h"

@interface RBZanTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, assign) int currentPage2;
@end

@implementation RBZanTabVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)dataArr2 {
    if (_dataArr2 == nil) {
        _dataArr2 = [NSMutableArray array];
    }
    return _dataArr2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.currentPage2 = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (void)loadNewData {
    if (self.type == 1) {
        self.currentPage2 = 0;
    } else {
        self.currentPage = 0;
    }
    [self loaddata];
}

- (void)loadMoreData {
    if (self.type == 1) {
        self.currentPage2 += 1;
    } else {
        self.currentPage += 1;
    }
    [self loaddata];
}

- (void)loaddata {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(1) forKey:@"zan"];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    NSString *str = @"apis/getwodeplhf"; // 话题的赞
    if (self.type == 1) {
        str = @"apis/getwodevideoplhf"; // 视频的赞
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        if (arr.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.type == 1) {
            [self.dataArr2 addObjectsFromArray:arr];
            [self.tableView showDataCount:self.dataArr2.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else {
            [self.dataArr addObjectsFromArray:arr];
            [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        }
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.type == 1) {
            [self.dataArr2 removeAllObjects];
            [self.tableView showDataCount:self.dataArr2.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        } else {
            [self.dataArr removeAllObjects];
            [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == 1) {
        return self.dataArr2.count;
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBZanCell *cell = [[RBZanCell alloc]init];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    if (self.type == 1) {
        cell.huiFuModel = self.dataArr2[indexPath.row];
    } else {
        cell.huiFuModel = self.dataArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiHuiFuModel *model;
    RBHuaTiDetailVC *desTabVC = [[RBHuaTiDetailVC alloc]init];
    if (self.type == 1) {
        // 获取视频信息
        [self getVideoDetailWithIndex:(int)indexPath.row];
    } else {
        model = self.dataArr[indexPath.row];
        desTabVC.huaTiId = model.Htid;
        [self.navigationController pushViewController:desTabVC animated:YES];
        desTabVC.type = 0;
    }
}

// 获取视频详情
- (void)getVideoDetailWithIndex:(int)index {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    RBHuaTiHuiFuModel *model = self.dataArr2[index];
    [dict setValue:@(model.Htid) forKey:@"id"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getvideobyid"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            NSDictionary *ok = backData[@"ok"];
            if ([ok[@"Heng"] intValue] == 1) {
                // 横屏
                RBHengShiPingVC *hengPingDetailVC = [[RBHengShiPingVC alloc]init];
                hengPingDetailVC.shiPingModel = [RBShiPingModel mj_objectWithKeyValues:ok];
                [self.navigationController pushViewController:hengPingDetailVC animated:YES];
            } else {
                // 竖版
                RBShuShiPingVC *shuShiPingDetailVC = [[RBShuShiPingVC alloc]init];
                shuShiPingDetailVC.shiPingModel = [RBShiPingModel mj_objectWithKeyValues:ok];
                [self.navigationController pushViewController:shuShiPingDetailVC animated:YES];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

@end
