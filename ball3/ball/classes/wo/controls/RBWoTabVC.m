#import "RBWoTabVC.h"
#import "RBWoHead.h"
#import "RBWoModel.h"
#import "RBNetworkTool.h"
#import "RBWoFirstCell.h"
#import "RBWoCell.h"
#import "RBYongHuXinXiTabVC.h"
#import "RBLoginVC.h"
#import "RBSheZhiTabVC.h"
#import "RBDengJiVC.h"
#import "RBBangZhuVC.h"

@interface RBWoTabVC ()
/// 用户信息数组
@property (nonatomic, strong) NSMutableArray *infoArr;
/// 消息数组
@property (nonatomic, strong) NSMutableArray *xiaoXiArr;
/// 话题数组
@property (nonatomic, strong) NSMutableArray *huaTiArr;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 经验
@property (nonatomic, assign) int exp;
/// 等级
@property (nonatomic, assign) int Viplevel;
/// vip
@property (nonatomic, assign) int vip;
/// 购买vip时间
@property (nonatomic, assign) int vipst;
/// 金币
@property (nonatomic, assign) float coinCount;
/// 头部
@property (nonatomic, strong) RBWoHead *myHeadView;
@property (nonatomic, strong) NSMutableArray *shiPingArr;
@end

@implementation RBWoTabVC
- (NSMutableArray *)infoArr {
    if (_infoArr == nil) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}

- (NSMutableArray *)xiaoXiArr {
    if (_xiaoXiArr == nil) {
        _xiaoXiArr = [NSMutableArray array];
    }
    return _xiaoXiArr;
}

- (NSMutableArray *)huaTiArr {
    if (_huaTiArr == nil) {
        _huaTiArr = [NSMutableArray array];
    }
    return _huaTiArr;
}

- (NSMutableArray *)shiPingArr {
    if (_shiPingArr == nil) {
        _shiPingArr = [NSMutableArray array];
    }
    return _shiPingArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self timerRun];
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer timerWithTimeInterval:10 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.navigationController.navigationBarHidden = YES;
    [self getUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    NSArray *icons = @[@"personal info", @"setting2", @"fans", @"help"];
    NSArray *tips = @[@"个人信息", @"通用设置", @"等级勋章", @"帮助与反馈"];
    for (int i = 0; i < icons.count; i++) {
        RBWoModel *model = [[RBWoModel alloc]init];
        model.image = icons[i];
        model.tip = tips[i];
        [self.infoArr addObject:model];
    }

    self.myHeadView = [[RBWoHead alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 248 + RBStatusBarH)];
    if (RB_iPhoneX) {
        self.myHeadView = [[RBWoHead alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 248 + RBStatusBarH - 24)];
    }
    self.tableView.tableHeaderView = self.myHeadView;
}

///定时器获取消息状态和话题状态（显示红点）
- (void)timerRun {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getwodestate"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [self.huaTiArr removeAllObjects];
            NSArray *arr = backData[@"ok"];
            [self.huaTiArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];

    [RBNetworkTool PostDataWithUrlStr:@"apis/getmsgstate"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [self.xiaoXiArr removeAllObjects];
            NSArray *arr = backData[@"ok"];
            [self.xiaoXiArr addObjectsFromArray:arr];
            [self.tableView reloadData];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];

    [RBNetworkTool PostDataWithUrlStr:@"apis/getwodeshiPingstate" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.shiPingArr removeAllObjects];
        NSArray *arr = backData[@"ok"];
        [self.shiPingArr addObjectsFromArray:arr];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)getUserInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        self.myHeadView.userDict = @{};
        self.vip = 0;
        [self.tableView reloadData];
        return;
    }
    if (![uid isEqualToString:@""] && uid != nil) {
        [dict setValue:uid forKey:@"uid"];
        [RBNetworkTool PostDataWithUrlStr:@"apis/getuserdetail" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            if (backData[@"err"] != nil) {
                return;
            }
            self.myHeadView.userDict = backData;
            NSDictionary *dataDict = backData;
            NSDictionary *ok = dataDict[@"ok"];
            if (self.infoArr.count > 0) {
                RBWoModel *woModel = self.infoArr[0];
                woModel.Usedyqcode = ok[@"Usedyqcode"];
                self.infoArr[0] = woModel;
            }
            self.coinCount = [ok[@"Gold"] floatValue];
            self.exp = [ok[@"Exp"] intValue];
            self.Viplevel = [ok[@"Viplevel"] intValue];
            if ([ok.allKeys containsObject:@"Vip"]) {
                self.vip = [ok[@"Vip"] intValue];
                self.vipst = [ok[@"Vipst"] intValue];
                NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:self.vipst];
                NSDate *now = [NSDate date];
                int nowTime = [now timeIntervalSince1970];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *datecomps = [[NSDateComponents alloc] init];
                [datecomps setMonth:self.vip];
                NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
                if (nowTime - [calculatedate timeIntervalSince1970] >= 0) {
                    // 过期
                    self.vip = 0;
                }
            }
            if (self.vip != 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:@(self.vipst) forKey:@"t"];
                [dict setValue:@(self.vip) forKey:@"vip"];
                [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"vipDict"];
                [[NSUserDefaults standardUserDefaults]setObject:@(2) forKey:@"isVip"];
            } else {
                [[NSUserDefaults standardUserDefaults]setObject:@(0) forKey:@"isVip"];
            }
            [[NSUserDefaults standardUserDefaults]setObject:ok[@"Nickname"] forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults]setObject:ok[@"Packet"] forKey:@"Packet"];
            [[NSUserDefaults standardUserDefaults]setObject:@([ok[@"Viplevel"]intValue]) forKey:@"Viplevel"];
            [[NSUserDefaults standardUserDefaults]setObject:@([ok[@"Exp"]intValue]) forKey:@"Exp"];
            [[NSUserDefaults standardUserDefaults]setObject:@(self.coinCount) forKey:@"coinCount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView reloadData];
        } Fail:^(NSError *_Nonnull error) {
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 8)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85;
    } else {
        return 48;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RBWoFirstCell *cell = [RBWoFirstCell createCellByTableView:tableView];
        cell.xiaoXiArr = self.xiaoXiArr;
        cell.huaTiArr = self.huaTiArr;
        int count = 0;
        for (int i = 0; i < self.xiaoXiArr.count; i++) {
            if (i != 1) {
                count += [self.xiaoXiArr[i] intValue];
            }
        }
        cell.showXiaoXiTip = count > 0;
        int count2 = 0;
        for (int i = 0; i < self.huaTiArr.count; i++) {
            count2 += [self.huaTiArr[i] intValue];
        }
        for (int j = 0; j < self.shiPingArr.count; j++) {
            count2 += [self.shiPingArr[j] intValue];
        }
        cell.showHuaTiTip = count2 > 0;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        RBWoCell *cell = [RBWoCell createCellByTableView:tableView];
        if (indexPath.row == 0) {
            //设置圆角
            UIView *cellView = [cell viewWithTag:100];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cellView.bounds;
            maskLayer.path = maskPath.CGPath;
            cellView.layer.mask = maskLayer;
        }
        if (indexPath.row == 3) {
            //设置圆角
            UIView *cellView = [cell viewWithTag:100];
            UIView *line = [cell viewWithTag:101];
            [line removeFromSuperview];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cellView.bounds;
            maskLayer.path = maskPath.CGPath;
            cellView.layer.mask = maskLayer;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.woModel = self.infoArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= -RBStatusBarH) {
        offset.y = -RBStatusBarH;
    }
    self.tableView.contentOffset = offset;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
            if (uid != nil && ![uid isEqualToString:@""]) {
                RBYongHuXinXiTabVC *yongHuXinXiTabVC = [[RBYongHuXinXiTabVC alloc]init];
                [self.navigationController pushViewController:yongHuXinXiTabVC animated:YES];
            } else {
                RBLoginVC *loginVC = [[RBLoginVC alloc]init];
                loginVC.fromVC = self;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        } else if (indexPath.row == 1) {
            RBSheZhiTabVC *shezhiTabVC = [[RBSheZhiTabVC alloc]init];
            [self.navigationController pushViewController:shezhiTabVC animated:YES];
        } else if (indexPath.row == 2) {
            RBDengJiVC *dengJiVC = [[RBDengJiVC alloc]init];
            dengJiVC.lv = self.Viplevel;
            dengJiVC.exp = self.exp;
            [self.navigationController pushViewController:dengJiVC animated:YES];
        } else if (indexPath.row == 3) {
            RBBangZhuVC *bangZhuVC = [[RBBangZhuVC alloc]init];
            [self.navigationController pushViewController:bangZhuVC animated:YES];
        }
    }
}

@end
