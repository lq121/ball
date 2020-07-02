#import "RBLiveTabVC.h"
#import "RBNetworkTool.h"
#import "RBLiveModel.h"
#import "RBLiveCell.h"
#import "RBStatsModel.h"

@interface RBLiveTabVC ()
@property (nonatomic, strong) UIButton *hostBtn;
@property (nonatomic, strong) UIButton *visitingBtn;
@property (nonatomic, strong) NSMutableArray *liveArr;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) NSMutableArray *statsArr;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RBLiveTabVC
- (void)setBiSaiDetailHead:(RBBiSaiDetailHead *)biSaiDetailHead {
    _biSaiDetailHead = biSaiDetailHead;
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, biSaiDetailHead.height + 281)];
    UIView *headView = [[UIView  alloc]initWithFrame:CGRectMake(0, biSaiDetailHead.height, RBScreenWidth, 281)];
    headView.backgroundColor = [UIColor clearColor];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 5;
    CGFloat whiteviewW = (RBScreenWidth - 36) * 0.5;
    for (int i = 0; i < 2; i++) {
        UIView *hostColor = [[UIView alloc]init];
        hostColor.layer.masksToBounds = YES;
        hostColor.layer.cornerRadius = 5;
        [headView addSubview:hostColor];
        UILabel *hostLabel = [[UILabel alloc]init];
        hostLabel.textAlignment = NSTextAlignmentLeft;
        hostLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostLabel.font = [UIFont boldSystemFontOfSize:14];
        [hostLabel sizeToFit];
        [headView addSubview:hostLabel];

        if (i == 0) {
            hostColor.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
            if (![self.biSaiModel.hostTeamName isKindOfClass:[NSNull class]]) {
                hostLabel.text = self.biSaiModel.hostTeamName;
            }
        } else {
            hostColor.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
            if (![self.biSaiModel.visitingTeamName isKindOfClass:[NSNull class]]) {
                hostLabel.text = self.biSaiModel.visitingTeamName;
            }
        }
        CGSize hostsize = [hostLabel.text getLineSizeWithBoldFontSize:14];
        hostLabel.frame = CGRectMake(16 + (whiteviewW - hostsize.width - 14) * 0.5 + 14, 12, hostsize.width, hostsize.height);
        if (i == 1) {
            hostLabel.x = whiteviewW + 20 + (whiteviewW - 14 - hostsize.width) * 0.5 + 14;
        }
        hostColor.frame = CGRectMake(CGRectGetMinX(hostLabel.frame) - 14, 17, 10, 10);
    }

    for (int i = 0; i < 2; i++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, 36, whiteviewW, 56)];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 2;
        whiteView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:whiteView];
        NSArray *imgs = @[@"corner 1", @"yellow card 1", @"red card 1"];
        for (int j = 0; j < imgs.count; j++) {
            UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgs[j]]];
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor colorWithSexadeString:@"#333333"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:16];
            if (i == 0) {
                label.tag = 100 + j;
            } else {
                label.tag = 200 + j;
            }
            [whiteView addSubview:icon];
            [whiteView addSubview:label];
            if (j == 0) {
                icon.frame = CGRectMake(12, 12, 16, 16);
                label.frame = CGRectMake(10, 32, 18, 16);
                label.text = @"0";
            } else if (j == 1) {
                icon.frame = CGRectMake((whiteviewW - 12) * 0.5, 12, 16, 16);
                label.frame = CGRectMake((whiteviewW - 12) * 0.5, 32, 18, 16);
                label.text = @"0";
            } else {
                icon.frame = CGRectMake(whiteviewW - 24, 12, 16, 16);
                label.frame = CGRectMake(whiteviewW - 26, 32, 18, 16);
                label.text = @"0";
            }
        }
        if (i == 0) {
            whiteView.x = 16;
            self.leftView = whiteView;
        } else {
            whiteView.x = 20 + (RBScreenWidth - 36) * 0.5;
            self.rightView = whiteView;
        }
    }
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, 96, RBScreenWidth - 32, 131)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = true;
    whiteView.layer.cornerRadius = 2;
    self.whiteView = whiteView;

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 65, RBScreenWidth - 32, 1)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [whiteView addSubview:line];

    NSArray *strs = @[@"射正球门", @"射偏球门", @"点球", @"进攻", @"危险进攻", @"控球率"];
    CGFloat labelW = (RBScreenWidth - 32) / 3;

    for (int i = 0; i < strs.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = strs[i];
        label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat y = ((i / 3) == 0) ? 12 : 77;
        label.frame = CGRectMake((i % 3) * labelW, y, labelW, 17);
        [whiteView addSubview:label];

        UILabel *left = [[UILabel alloc]init];
        left.tag = 10 + i;
        left.text = @"0";
        left.textColor = [UIColor whiteColor];
        left.textAlignment = NSTextAlignmentCenter;
        left.font = [UIFont boldSystemFontOfSize:14];
        left.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
        [whiteView addSubview:left];
        left.frame = CGRectMake((i % 3) * labelW + (labelW - 57) * 0.5, CGRectGetMaxY(label.frame) + 4, 28, 24);

        UILabel *right = [[UILabel alloc]init];
        right.text = @"0";
        right.tag = 20 + i;
        right.textColor = [UIColor whiteColor];
        right.textAlignment = NSTextAlignmentCenter;
        right.font = [UIFont boldSystemFontOfSize:14];
        right.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        [whiteView addSubview:right];
        right.frame = CGRectMake(CGRectGetMaxX(left.frame) + 1, CGRectGetMaxY(label.frame) + 4, 28, 24);
    }

    [headView addSubview:whiteView];
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.2];
    leftView.frame = CGRectMake((RBScreenWidth - 194) * 0.5, 254, 54, 1);
    [headView addSubview:leftView];

    UILabel *label = [[UILabel alloc]init];
    label.text = @"文字直播";
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(CGRectGetMaxX(leftView.frame) + 8, 243, 70, 22);
    [headView addSubview:label];

    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.2];
    rightView.frame = CGRectMake((RBScreenWidth - 194) * 0.5 + 16 + 54 + 64, 254, 54, 1);
    [headView addSubview:rightView];
    [head addSubview:headView];
    self.tableView.tableHeaderView = head;
    [self.tableView reloadData];
}

- (NSMutableArray *)liveArr {
    if (_liveArr == nil) {
        _liveArr = [NSMutableArray array];
    }
    return _liveArr;
}

- (NSMutableArray *)statsArr {
    if (_statsArr == nil) {
        _statsArr = [NSMutableArray array];
    }
    return _statsArr;
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    if (biSaiModel.status >= 2 && biSaiModel.status <= 4) {
        if (self.timer == nil) {
            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer timerWithTimeInterval:5 target:weakSelf selector:@selector(getLvData) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getLvData];
}

- (void)getLvData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"matchId"];
    [RBNetworkTool PostDataWithUrlStr:@"lav/nanoapigamedetail" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"error"] != nil) {
            return;
        }
        NSData *jsonData = nil;
        NSError *err;
        jsonData = [backData[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        [self.liveArr removeAllObjects];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSArray *statArr = [RBStatsModel mj_objectArrayWithKeyValuesArray:dic[@"stats"]];
        RBStatsModel *jiaoModel, *yellowModel, *redModel;
        NSArray *types = @[@(21), @(22), @(8), @(23), @(24), @(25)];
        for (int j = 0; j < statArr.count; j++) {
            RBStatsModel *model = statArr[j];
            if (model.type == 2) {
                jiaoModel = model;
                continue;
            } else if (model.type == 3) {
                yellowModel = model;
                continue;
            } else if (model.type == 4) {
                redModel = model;
                continue;
            }
            for (int i = 0; i < types.count; i++) {
                if (model.type == [types[i] intValue]) {
                    [self.statsArr addObject:model];
                    continue;
                }
            }
        }
        for (int i = 0; i < 3; i++) {
            UILabel *label = (UILabel *)[self.leftView viewWithTag:100 + i];
            if (i == 0) {
                // 角球
                int corner = jiaoModel.home <= 0 ? 0 : jiaoModel.home;
                label.text = [NSString stringWithFormat:@"%d", corner];
            } else if (i == 1) {
                // 黄牌
                label.text = [NSString stringWithFormat:@"%d", yellowModel.home];
            } else {
                // 红牌
                label.text = [NSString stringWithFormat:@"%d", redModel.home];
            }
        }
        for (int i = 0; i < 3; i++) {
            UILabel *label = (UILabel *)[self.rightView viewWithTag:200 + i];
            if (i == 0) {
                // 角球
                int corner = jiaoModel.away <= 0 ? 0 : jiaoModel.away;
                label.text = [NSString stringWithFormat:@"%d", corner];
            } else if (i == 1) {
                // 黄牌
                label.text = [NSString stringWithFormat:@"%d", yellowModel.away];
            } else {
                // 红牌
                label.text = [NSString stringWithFormat:@"%d", redModel.away];
            }
        }
        [self.liveArr addObjectsFromArray:[RBLiveModel mj_objectArrayWithKeyValuesArray:dic[@"tlive"]]];
        for (int i = 0; i < self.statsArr.count; i++) {
            RBStatsModel *model = self.statsArr[i];
            UILabel *left = [self.whiteView viewWithTag:10 + i];
            UILabel *right = [self.whiteView viewWithTag:20 + i];
            left.text = [NSString stringWithFormat:@"%d", model.home];
            right.text = [NSString stringWithFormat:@"%d", model.away];
        }
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBLiveModel *liveModel = self.liveArr[self.liveArr.count - indexPath.row - 1];
    NSString *dataStr = [liveModel.data stringByReplacingOccurrencesOfString:@"雷速" withString:@"小应体育"];
    return [RBLiveCell getCellHeightWithString:dataStr] + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBLiveCell *cell = [RBLiveCell createCellByTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.liveArr.count  != 0) {
        cell.liveModel = self.liveArr[self.liveArr.count - indexPath.row - 1];
    }
    return cell;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat placeHolderHeight = 0;
    if (RB_iPhoneX) {
        placeHolderHeight = self.biSaiDetailHead.height - RBNavBarAndStatusBarH;
    } else {
        placeHolderHeight = self.biSaiDetailHead.height - RBNavBarAndStatusBarH - RBStatusBarH;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        if (offsetY > self.lastContentOffset.y) {
            //往上滑动
            if (offsetY > (-self.biSaiDetailHead.y)) {
                self.biSaiDetailHead.y = -offsetY;
            }
        } else {
            //往下滑动
            if (offsetY < (-self.biSaiDetailHead.y)) {
                self.biSaiDetailHead.y = -offsetY;
            }
        }
        self.biSaiDetailHead.bigView.hidden = NO;
        self.biSaiDetailHead.smallView.hidden = YES;
        UIButton *btn = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        if (btn != nil) {
            btn.hidden = NO;
        }
        UIButton *btn2 = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
        if (btn2 != nil) {
            btn2.hidden = (self.biSaiModel.status == 8);
        }
    } else if (offsetY > placeHolderHeight) {
        if (self.biSaiDetailHead.y != (-placeHolderHeight)) {
            if (offsetY > self.lastContentOffset.y) {
                //往上滑动
                self.biSaiDetailHead.y = self.biSaiDetailHead.y - (scrollView.contentOffset.y - self.lastContentOffset.y);
            }
            if (self.biSaiDetailHead.y < (-placeHolderHeight)) {
                self.biSaiDetailHead.y = -placeHolderHeight;
            }
            if (self.biSaiDetailHead.y >= 0) {
                self.biSaiDetailHead.y = 0;
            }
            self.biSaiDetailHead.bigView.hidden = YES;
            self.biSaiDetailHead.smallView.hidden = NO;
            UIButton *btn = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
            if (btn != nil) {
                btn.hidden = YES;
            }
            UIButton *btn2 = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
            if (btn2 != nil) {
                btn2.hidden = YES;
            }
        }
    } else if (offsetY < 0) {
        self.biSaiDetailHead.y =  -offsetY;
    }

    self.lastContentOffset = scrollView.contentOffset;
}

- (void)dealloc {
    [self.timer timeInterval];
    self.timer = nil;
}

@end
