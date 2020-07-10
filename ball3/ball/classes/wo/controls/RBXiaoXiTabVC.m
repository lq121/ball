#import "RBXiaoXiTabVC.h"
#import "RBNetworkTool.h"
#import "RBXiaoXiModel.h"
#import "RBXiaoXiCell.h"
#import "RBFMDBTool.h"

@interface RBXiaoXiTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation RBXiaoXiTabVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddata)];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
}

- (void)loaddata {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getmsg" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        [self.dataArr removeAllObjects];
        NSArray *arr = [RBXiaoXiModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        NSMutableArray *dArr = [NSMutableArray arrayWithArray:arr];
        for (int i = 0; i < dArr.count; i++) {
            RBXiaoXiModel *model = dArr[i];
            model.type = 3;
            [[RBFMDBTool sharedFMDBTool]addMsgModel:model];
            [self.dataArr addObject:model];
        }
        [self.dataArr addObjectsFromArray:[[RBFMDBTool sharedFMDBTool] selectMsgModelWithType:3]];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:[[RBFMDBTool sharedFMDBTool] selectMsgModelWithType:3]];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBXiaoXiCell *cell = [RBXiaoXiCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xiaoxiModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count != 0) {
        RBXiaoXiModel *model = self.dataArr[indexPath.row];
        CGSize size = [model.txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64];
        return size.height + 66;
    } else {
        return 0;
    }
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RBXiaoXiModel *xiaoXiModel = self.dataArr[indexPath.row];
        [[RBFMDBTool sharedFMDBTool]delelteMsgWithId:xiaoXiModel.Id];
        [self.dataArr removeObject:xiaoXiModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
