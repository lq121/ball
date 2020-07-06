#import "RBMyPredictTabVC.h"
#import "RBNetworkTool.h"
#import "RBPredictModel.h"
#import "RBMyPredictCell.h"
#import "RBLoginVC.h"
#import "RBBiSaiModel.h"
#import "RBChekLogin.h"
#import "RBBiSaiDetailVC.h"

@interface RBMyPredictTabVC ()
@property (nonatomic, strong) NSMutableArray *noYuDataArray;
@property (nonatomic, strong) NSMutableArray *yuDataArray;
@property (nonatomic, assign) int noP;
@property (nonatomic, assign) int p;
@property (nonatomic, strong) UIView *footView;
@end

@implementation RBMyPredictTabVC

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

- (NSMutableArray *)noYuDataArray {
    if (_noYuDataArray == nil) {
        _noYuDataArray = [NSMutableArray array];
    }
    return _noYuDataArray;
}

- (NSMutableArray *)yuDataArray {
    if (_yuDataArray == nil) {
        _yuDataArray = [NSMutableArray array];
    }
    return _yuDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noP = 0;
    self.p = 0;
}

- (void)getPredictData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.status == 0) {
        [dict setValue:@(self.noP) forKey:@"p"];
        [RBNetworkTool PostDataWithUrlStr:@"apis/getbuyweisai" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            if (self.noP == 0) {
                [self.noYuDataArray removeAllObjects];
            }
            NSArray *array = [RBPredictModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
            [self.noYuDataArray addObjectsFromArray:array];
            [self.tableView showDataCount:self.noYuDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
            if (self.noYuDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        } Fail:^(NSError *_Nonnull error) {
        }];
    } else {
        [dict setValue:@(self.p) forKey:@"p"];
        [RBNetworkTool PostDataWithUrlStr:@"apis/getbuyyisai" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            if (self.p == 0) {
                [self.yuDataArray removeAllObjects];
            }
            NSArray *array = [RBPredictModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
            [self.yuDataArray addObjectsFromArray:array];
            [self.tableView showDataCount:self.yuDataArray.count andimage:@"nothing" andTitle:@"没有任何数据呀" andImageSize:CGSizeMake(146, 183)];
            if (self.yuDataArray.count > 0) {
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        } Fail:^(NSError *_Nonnull error) {
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.status == 0) {
        return self.noYuDataArray.count;
    } else {
        return self.yuDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBMyPredictCell *myPredictCell = [RBMyPredictCell createCellByTableView:tableView];
    myPredictCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.status == 0) {
        myPredictCell.predictModel = self.noYuDataArray[indexPath.row];
    } else {
        myPredictCell.predictModel = self.yuDataArray[indexPath.row];
    }
    return myPredictCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
        detailTabVC.index = 2;
        if (self.status == 0) {
            detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.noYuDataArray[indexPath.row]];
        } else {
            detailTabVC.biSaiModel = [self predictModelTobiSaiModel:self.yuDataArray[indexPath.row]];
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
