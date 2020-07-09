#import "RBPredictListTabVC.h"
#import "RBNetworkTool.h"
#import "RBPredictModel.h"
#import "RBBiSaiModel.h"
#import "RBNearPredictCell.h"
#import "RBLoginVC.h"
#import "RBChekLogin.h"
#import "RBBiSaiDetailVC.h"

@interface RBPredictListTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int currentP;
/// 让球记录每一个时间点中的数据量（例如2020-0626有12条 2020-0627有15条 2020-0628有5条 [12,15,5]）
@property (nonatomic, strong) NSMutableArray *numPredictDataArray;
@property (nonatomic, strong) UIView *footView;
@end

@implementation RBPredictListTabVC

- (UIView *)footView {
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 65)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, RBScreenWidth, 17)];
        lab.text = @"全部加载完毕啦～";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [_footView addSubview:lab];
    }
    return _footView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)numPredictDataArray {
    if (_numPredictDataArray == nil) {
        _numPredictDataArray = [NSMutableArray array];
    }
    return _numPredictDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"近期预测";
    self.currentP = 0;
    [self.numPredictDataArray addObject:@(0)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self getYuData];
}

- (void)loadMoreData {
    self.currentP += 1;
    [self getYuData];
}

- (void)getYuData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentP) forKey:@"p"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getjinqiyuce2" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_footer endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        NSArray *array = [RBPredictModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        if (self.currentP == 0) {
            [self.dataArray removeAllObjects];
            [self.numPredictDataArray removeAllObjects];
            [self.numPredictDataArray addObject:@(1)];
        }
        for (int i = 0; i < array.count; i++) {
            RBPredictModel *model = array[i];
            if (self.dataArray.count >= 1) {
                RBPredictModel *lastModel = [self.dataArray lastObject];
                if ([self isSameDay:lastModel.startt Time2:model.startt]) {
            // 同一天
                    int num = [[self.numPredictDataArray lastObject]intValue];
                    self.numPredictDataArray[self.numPredictDataArray.count - 1] = @(num + 1);
                } else {
                    [self.numPredictDataArray addObject:@(1)];
                }
            }
            // 防止显示其他数据,手动将胜平负,大小球数据为不准
            model.spsresult = 0;
            model.dxresult = 0;
            [self.dataArray addObject:model];
        }
        [self.tableView showDataCount:self.dataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numPredictDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numPredictDataArray[section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBNearPredictCell *nearPredictCell = [RBNearPredictCell createCellByTableView:tableView];
    nearPredictCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        nearPredictCell.predictModel = self.dataArray[indexPath.row];
    } else {
        int index = 0;
        for (int i = 0; i < indexPath.section; i++) {
            index += [self.numPredictDataArray[i] intValue];
        }
        nearPredictCell.predictModel = self.dataArray[indexPath.row + index];
    }

    return nearPredictCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2 {
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:pDate2];
    return [comp1 day]   == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    tipLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.1];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textColor = [UIColor colorWithSexadeString:@"#333333"];

    RBPredictModel *predictModel;
    if (self.dataArray.count == 0) {
        return tipLab;
    }
    int index = 0;
    for (int i = 0; i <= section; i++) {
        index += [self.numPredictDataArray[i]intValue];
    }
    predictModel = self.dataArray[index - 1];
    tipLab.text = [NSString getStrWithDateInt:predictModel.startt andFormat:@"yyyy年MM月dd日"];

    [view addSubview:tipLab];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
        detailTabVC.index = 2;
        if (indexPath.section == 0) {
            detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.dataArray[indexPath.row]];
        } else {
            int index = 0;
            for (int i = 0; i < indexPath.section; i++) {
                index += [self.numPredictDataArray[i] intValue];
            }
            detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.dataArray[indexPath.row + index]];
        }

        [self.navigationController pushViewController:detailTabVC animated:YES];
    }
}

- (RBBiSaiModel *)predictModelTobiSaiModel:(RBPredictModel *)predictModel {
    RBBiSaiModel *biSaiModel = [[RBBiSaiModel alloc]init];
    biSaiModel.eventLongName = predictModel.name[1];
    biSaiModel.namiId = predictModel.namiid;
    biSaiModel.hostID = predictModel.zhuid;
    biSaiModel.visitingID = predictModel.keid;
    biSaiModel.hostTeamName = predictModel.zhuname[0];
    biSaiModel.visitingTeamName = predictModel.kename[0];
    biSaiModel.biSaiTime = predictModel.startt;
    biSaiModel.TeeTime = predictModel.startballt;
    biSaiModel.eventName = predictModel.name[0];
    biSaiModel.eventId = predictModel.saijiid;
    biSaiModel.stageName = predictModel.jieduanname[0];
    biSaiModel.hostCorner = predictModel.zhujiao;
    biSaiModel.visitingCorner = predictModel.kejiao;
    biSaiModel.hostHalfScore = predictModel.zhuhalffen;
    biSaiModel.visitingHalfScore = predictModel.kehalffen;
    biSaiModel.hostPointScore = predictModel.zhudianfen;
    biSaiModel.visitingPointScore = predictModel.kedianfen;
    biSaiModel.hostScore = predictModel.zhufen;
    biSaiModel.visitingScore = predictModel.kefen;
    biSaiModel.hostRedCard = predictModel.zhuhong;
    biSaiModel.visitingRedCard = predictModel.kehong;
    biSaiModel.hostYellowCard = predictModel.zhuhuang;
    biSaiModel.visitingYellowCard = predictModel.kehuang;
    biSaiModel.hostOvertimeScore = predictModel.zhuaddfen;
    biSaiModel.visitingOvertimeScore = predictModel.keaddfen;
    biSaiModel.hostPenaltyScore = predictModel.zhudianfen;
    biSaiModel.visitingPenaltyScore = predictModel.kedianfen;
    biSaiModel.status = predictModel.state;
    biSaiModel.hostLogo = predictModel.zhulogo;
    biSaiModel.visitingLogo = predictModel.kelogo;
    biSaiModel.hasIntelligence = (BOOL)predictModel.qingbao;
    return biSaiModel;
}

@end
