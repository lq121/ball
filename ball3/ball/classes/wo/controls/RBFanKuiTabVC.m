#import "RBFanKuiTabVC.h"
#import "RBNetworkTool.h"
#import "RBFanKuiCell.h"
#import "RBFanKuiDesVC.h"

@interface RBFanKuiTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation RBFanKuiTabVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.title = @"反馈记录";
    [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
    [self.tableView reloadData];
    [self loadData];
}

- (void)loadData {
    [MBProgressHUD showLoading:jiazhaizhong toView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(0) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getfeedback" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            NSArray *arr = backData[@"ok"];
            [self.dataArr addObjectsFromArray:[RBFanKuiModel mj_objectArrayWithKeyValuesArray:arr]];
            [self.tableView showDataCount:self.dataArr.count andimage:@"nothing" andTitle:meiyourenheshuju andImageSize:CGSizeMake(146, 183)];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBFanKuiCell *cell = [RBFanKuiCell createCellByTableView:tableView];
    cell.fanKuiModel = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RBFanKuiDesVC *fanKuiDesVC = [[RBFanKuiDesVC alloc]init];
    fanKuiDesVC.fanKuiModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:fanKuiDesVC animated:YES];
}

@end
