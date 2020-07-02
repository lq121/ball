#import "RBPinLunTabVC.h"
#import "RBNetworkTool.h"
#import "RBHuaTiHuiFuModel.h"
#import "RBPinLunCell.h"
#import "RBShiPingModel.h"
#import "RBShuShiPingVC.h"
#import "RBHengShiPingVC.h"
#import "RBHuaTiDetailVC.h"

@interface RBPinLunTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, assign) int currentPage2;
@end

@implementation RBPinLunTabVC
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refshComment:) name:@"refshComment" object:nil];
}

- (void)refshComment:(NSNotification *)noti {
    if (self.type == 1) {
        [self.dataArr2 removeObject:noti.object];
        [self.tableView showDataCount:self.dataArr2.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    } else {
        [self.dataArr removeObject:noti.object];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
    }

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
    [dict setValue:@(0) forKey:@"zan"];
    NSString *str = @"apis/getwodeplhf";
    if (self.type == 1) {
        [dict setValue:@(self.currentPage2) forKey:@"p"];
        str = @"apis/getwodevideoplhf";
    } else {
        [dict setValue:@(self.currentPage) forKey:@"p"];
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        if (self.type == 1) {
            if (self.currentPage2 == 0) {
                [self.dataArr2 removeAllObjects];
            }
        } else {
            if (self.currentPage == 0) {
                [self.dataArr removeAllObjects];
            }
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
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
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
    RBPinLunCell *cell = [RBPinLunCell createCellByTableView:tableView];
    if (self.type == 1) {
        RBHuaTiHuiFuModel *huiFuModel = self.dataArr[indexPath.row];
        huiFuModel.type = 1;
        cell.huiFuModel = huiFuModel;
    } else {
        RBHuaTiHuiFuModel *huiFuModel = self.dataArr[indexPath.row];
        huiFuModel.type = 0;
        cell.huiFuModel = huiFuModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiHuiFuModel *huiFuModel;
    if (self.type == 1) {
        huiFuModel = self.dataArr2[indexPath.row];
    } else {
        huiFuModel = self.dataArr[indexPath.row];
    }

    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *str;
    if ([huiFuModel.Hfuid isEqualToString:uid]) {
        str = [NSString stringWithFormat:@"评论:%@", huiFuModel.Hftxt];
    } else {
        str = [NSString stringWithFormat:@"回复您:%@", huiFuModel.Hftxt];
    }
    CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 122];
    return size.height + 73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiHuiFuModel *model;
    RBHuaTiDetailVC *detailTabVC = [[RBHuaTiDetailVC alloc]init];
    if (self.type == 1) {
        [self getVideoDetailWithIndex:(int)indexPath.row];
    } else {
        model = self.dataArr[indexPath.row];
        detailTabVC.huaTiId = model.Htid;
        [self.navigationController pushViewController:detailTabVC animated:YES];
        detailTabVC.type = 0;
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
                RBHengShiPingVC *hengShiPingVC = [[RBHengShiPingVC alloc]init];
                hengShiPingVC.shiPingModel = [RBShiPingModel mj_objectWithKeyValues:ok];
                [self.navigationController pushViewController:hengShiPingVC animated:YES];
            } else {
                // 竖版
                RBShuShiPingVC *shuShiPingVC = [[RBShuShiPingVC alloc]init];
                shuShiPingVC.shiPingModel = [RBShiPingModel mj_objectWithKeyValues:ok];
                [self.navigationController pushViewController:shuShiPingVC animated:YES];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
