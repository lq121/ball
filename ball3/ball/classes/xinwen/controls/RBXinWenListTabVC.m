#import "RBXinWenListTabVC.h"
#import "RBBannerView.h"
#import "RBNetworkTool.h"
#import "RBXinWenModel.h"
#import "RBXinWenBigCell.h"
#import "RBXinWenDetailTabVC.h"
#import "RBXinWenSmallCell.h"

@interface RBXinWenListTabVC ()<BannerDataSource,BannerDelegate>
@property(nonatomic,strong)RBBannerView *bannerView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int pageSize;
@end

@implementation RBXinWenListTabVC
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.title = @"新闻资讯";
    self.pageSize = 0;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadnewsLine)];
    [self.tableView.mj_footer beginRefreshing];
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 351)];
    RBBannerView *bannerView = [[RBBannerView alloc]initWithFrame:CGRectMake(0, 12, RBScreenWidth, 331)];
    bannerView.delegate = self;
    bannerView.datasource = self;
    bannerView.showPageCotl = YES;
    self.bannerView = bannerView;
    [self.bannerView reloadData];
    [head addSubview:bannerView];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame), RBScreenWidth, 8)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [head addSubview:line];
    self.tableView.tableHeaderView = head ;
}

- (void)loadnewsLine {
    NSDictionary *dict1 = @{ @"startId": @(self.pageSize), @"endId": @(self.pageSize + 10) };
    self.pageSize += 10;
    [RBNetworkTool PostDataWithUrlStr:@"try/go/newsheadline" andParam:dict1 Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSDictionary *dic = backData;
        NSArray *array = dic[@"ok"][@"data"];
        if (array.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArr addObjectsFromArray:[RBXinWenModel mj_objectArrayWithKeyValuesArray:array]];
        [self.tableView reloadData];
        [self.bannerView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)numberOfCellForBannerView:(RBBannerView *)bannerView{
   if (self.dataArr.count >= 3) {
        return 3;
    } else {
        return self.dataArr.count;
    }
}

- (UIView *)bannerView:(RBBannerView *)bannerView cellForIndex:(NSInteger)index{
    RBXinWenBigCell *bigCell = [[RBXinWenBigCell alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 298)];
    bigCell.xinWenModel = self.dataArr[index];
    return bigCell;
}

- (void)bannerView:(RBBannerView *)bannerView didSelectedIndex:(NSInteger)index{
    RBXinWenDetailTabVC *xinWenDetaiTabVC = [[RBXinWenDetailTabVC alloc]init];
    xinWenDetaiTabVC.xinWenModel = self.dataArr[index];
    [[UIViewController getCurrentVC].navigationController pushViewController:xinWenDetaiTabVC animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count-3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ((indexPath.row+1) % 4 == 0) {
        RBXinWenBigCell *bigCell = [RBXinWenBigCell createCellByTableView:tableView];
        bigCell.xinWenModel = self.dataArr[indexPath.row+3];
        cell = bigCell;
    } else {
        RBXinWenSmallCell *smallCell = [RBXinWenSmallCell createCellByTableView:tableView];
        smallCell.xinwenModel = self.dataArr[indexPath.row+3];
        cell = smallCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row+1) % 4 == 0) {
        RBXinWenModel *model = self.dataArr[indexPath.row];
        return (259 + [model.title getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 24].height);
    } else {
        return 116;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBXinWenDetailTabVC *xinWenDetailTabVC = [[RBXinWenDetailTabVC alloc]init];
    xinWenDetailTabVC.canGoBack = YES;
    xinWenDetailTabVC.xinWenModel = self.dataArr[indexPath.row+3];
    [self.navigationController pushViewController:xinWenDetailTabVC animated:YES];
}

@end
