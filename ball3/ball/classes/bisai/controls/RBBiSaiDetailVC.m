#import "RBBiSaiDetailVC.h"
#import "RBLiveTabVC.h"
#import "RBChatVC.h"
#import "RBAIForecastVC.h"
#import "RBAnalyzeVC.h"
#import "RBVipMemberVC.h"
#import "RBFMDBTool.h"
#import "RBNetworkTool.h"
#import "RBFenXiangView.h"
#import "WXApi.h"
#import "RBToast.h"
#import "SocketRocketUtility.h"
#import "RBBiSaiDetailHead.h"
#import "RBChekLogin.h"

@interface RBBiSaiDetailVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) RBFenXiangView *shareView;
@property (nonatomic, strong) RBLiveTabVC *liveTabVC;
@property (nonatomic, strong) RBChatVC *chatVC;
@property (nonatomic, strong) RBAIForecastVC *aiForecastVC;
@property (nonatomic, strong) RBAnalyzeVC *analyzeVC;
@property (nonatomic, strong) RBVipMemberVC *vipMemberVC;
@property (nonatomic, strong) RBBiSaiDetailHead *biSaiDetailHead;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) int hasData;
@property (nonatomic, assign) int hasBuy;
@end

@implementation RBBiSaiDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.contentOffset = CGPointMake(self.index * RBScreenWidth, self.scrollView.contentOffset.y);
    self.navigationController.navigationBarHidden = YES;
    UIButton *backBtn = [[UIButton alloc]init];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, RBStatusBarH, 40, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:backBtn];

    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.tag = 888;
    [shareBtn addTarget:self  action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(RBScreenWidth - 100, RBStatusBarH, 40, 40);
    if ([WXApi isWXAppInstalled]) {
        [[UIApplication sharedApplication].keyWindow addSubview:shareBtn];
    }
    UIButton *attentionBtn = [[UIButton alloc]init];
    attentionBtn.tag = 777;
    attentionBtn.hidden = (self.biSaiModel.status == 8);
    self.attentionBtn = attentionBtn;
    self.attentionBtn.selected = [[RBFMDBTool sharedFMDBTool]selectAttentionBiSaiModelWithId:self.biSaiModel.namiId];
    [attentionBtn addTarget:self action:@selector(clickAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [attentionBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [attentionBtn setImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateSelected];
    attentionBtn.frame = CGRectMake(RBScreenWidth - 56, RBStatusBarH, 40, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:attentionBtn];
    if (attentionBtn.hidden) {
        shareBtn.x = RBScreenWidth - 56;
    }
    [self.chatVC connct];
    [self getBiSaiInfo];
}

#pragma mark - 允许接受多个手势 (这个方法很重要，不要遗漏)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (RBBiSaiDetailHead *)biSaiDetailHead {
    if (_biSaiDetailHead == nil) {
        __weak typeof(self) weakSelf = self;
        CGFloat height = 0;

        if (@available(iOS 10, *)) {
            if (RB_iPhoneX) {
                height = (228 + RBStatusBarH - 24);
            } else {
                height = (228 + RBStatusBarH);
            }
        } else {
            height = (228 +  RBStatusBarH + 20);
        }
        _biSaiDetailHead = [[RBBiSaiDetailHead alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, height) andIndex:self.index andClickBtn:^(int index) {
            [weakSelf.chatVC.textField resignFirstResponder];
            if (index != 0) {
                weakSelf.index = index;
            }
            if (index == 1 || index == 4) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.scrollView.contentOffset = CGPointMake(index * RBScreenWidth, -RBStatusBarH);
                }];
            } else {
                weakSelf.scrollView.contentOffset = CGPointMake(index * RBScreenWidth,  weakSelf.scrollView.contentOffset.y);
            }
        }];
        _biSaiDetailHead.biSaiModel = self.biSaiModel;
    }
    return _biSaiDetailHead;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backBtn removeFromSuperview];
    [self.attentionBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    self.chatVC.chatToolBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasData = 0;
    self.hasBuy = 0;
    for (UIView *head in [UIApplication sharedApplication].keyWindow.subviews) {
        if (head.tag == 666) {
            head.hidden = YES;
        }
    }
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:self.scrollView];
    self.liveTabVC = [[RBLiveTabVC alloc]init];
    self.chatVC = [[RBChatVC alloc]init];
    self.aiForecastVC = [[RBAIForecastVC alloc]init];
    self.analyzeVC = [[RBAnalyzeVC alloc]init];
    self.vipMemberVC = [[RBVipMemberVC alloc]init];
    self.biSaiModel.eventLongName = @"";
    self.chatVC.biSaiModel = self.biSaiModel;
    self.liveTabVC.biSaiModel = self.biSaiModel;
    self.aiForecastVC.biSaiModel = self.biSaiModel;
    self.analyzeVC.biSaiModel = self.biSaiModel;
    __weak typeof(self) weakSelf = self;
    self.analyzeVC.clickCell = ^{
        [weakSelf.biSaiDetailHead clickIndex:2];
        [weakSelf.aiForecastVC clickinde];
    };
    NSArray *array = @[self.liveTabVC, self.chatVC, self.aiForecastVC, self.analyzeVC, self.vipMemberVC];
    for (UIViewController *vc in array) {
        [self addChildViewController:vc];
    }

    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *viewCtrl = self.childViewControllers[i];
        UIView *view = viewCtrl.view;
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
        }
        if (i == 0 || i == 3) {
            // 可以滑动
            view.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - RBStatusBarH);
        } else {
            view.frame = CGRectMake(i * RBScreenWidth, self.biSaiDetailHead.height, RBScreenWidth, RBScreenHeight - self.biSaiDetailHead.height - RBStatusBarH);
        }
        if (i == 0) {
            RBLiveTabVC *tab = (RBLiveTabVC *)viewCtrl;
            tab.biSaiDetailHead = self.biSaiDetailHead;
        } else if (i == 3) {
            RBAnalyzeVC *analzeVC = (RBAnalyzeVC *)viewCtrl;
            analzeVC.biSaiDetailHead = self.biSaiDetailHead;
        }
        [self.scrollView addSubview:view];
    }
    [self.scrollView addSubview:self.biSaiDetailHead];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBiSaiModels:) name:@"changeBiSaiModels" object:nil];
}

- (void)changeBiSaiModels:(NSNotification *)noti {
    NSArray *changeBiSaiModels = noti.object;
    for (int i = 0; i < changeBiSaiModels.count; i++) {
        RBBiSaiModel *model = changeBiSaiModels[i];
        if (self.biSaiModel.namiId == model.namiId) {
            self.biSaiModel.hostScore = model.hostScore;
            self.biSaiModel.status = model.status;
            self.biSaiModel.visitingScore = model.visitingScore;
            self.biSaiDetailHead.biSaiModel = self.biSaiModel;
            self.chatVC.biSaiModel = self.biSaiModel;
            self.liveTabVC.biSaiModel = self.biSaiModel;
            self.aiForecastVC.biSaiModel = self.biSaiModel;
            self.analyzeVC.biSaiModel = self.biSaiModel;
            self.biSaiDetailHead.biSaiModel = self.biSaiModel;
        }
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(RBScreenWidth * 5, 0);
    }
    return _scrollView;
}

- (void)getaiDataWithIndex:(int)index {
    // 获取预测数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.biSaiModel.namiId) forKey:@"matchid"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getmatchaidata"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hidHUDFromView:self.view];
        if ([backData[@"err"] intValue] == 50011) {
            // 比赛不存在
            [[RBFMDBTool sharedFMDBTool]deleteBiSaiModelWithId:self.biSaiModel.namiId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBiSai" object:nil];
            [[UIViewController getCurrentVC].navigationController popViewControllerAnimated:YES];
        }
        if (backData[@"err"] == nil && backData[@"error"] == nil && backData != nil && backData[@"ok"] != nil) {
            [self setDataWith:backData andIndex:index];
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hidHUDFromView:self.view];
    }];
}

- (void)setDataWith:(NSDictionary *)backData andIndex:(int)index {
    NSDictionary *ok = backData[@"ok"];
    NSMutableArray *buy = [NSMutableArray array]; // 购买信息
    [buy addObject:ok[@"Rbuy"]];
    [buy addObject:ok[@"Sbuy"]];
    [buy addObject:ok[@"Dbuy"]];
    NSArray *titles = @[@"让球", @"胜平负", @"大小球"];
    NSArray *D = ok[@"D"];  // 大小球数据
    NSArray *R = ok[@"R"]; // 让球数据
    NSArray *S = ok[@"S"]; // 胜平负数据
    int hasBuy = 0;
    int hasData = 0;
    for (int i = 0; i < titles.count; i++) {
        // 查看是否有购买数据
        hasBuy += [buy[i]intValue];
        if (i == 0 && ![R isKindOfClass:[NSNull class]] && R.count >= 3) {
            hasData += 1;
        } else if (i == 1 && ![S isKindOfClass:[NSNull class]] && S.count >= 3) {
            hasData += 1;
        } else if (i == 2 && ![D isKindOfClass:[NSNull class]] && D.count >= 3) {
            hasData += 1;
        }
    }
    self.hasBuy = hasBuy;
    self.hasData = hasData;
    if (index == 1) {
        [self shareWithType:@"Session" andDes:[NSString stringWithFormat:@"智能预测-%@队 VS %@队【小应体育 APP】", self.biSaiModel.hostTeamName, self.biSaiModel.visitingTeamName] andUrlStr:[NSString stringWithFormat:@"%@game/%d", BASESHAREURL, self.biSaiModel.namiId] andImage:@"share logo"];
    } else if (index == 2) {
        [self shareWithType:@"Timeline" andDes:[NSString stringWithFormat:@"智能预测-%@队 VS %@队【小应体育 APP】", self.biSaiModel.hostTeamName, self.biSaiModel.visitingTeamName] andUrlStr:[NSString stringWithFormat:@"%@game/%d", BASESHAREURL, self.biSaiModel.namiId] andImage:@"share logo"];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@game/%d", BASESHAREURL, self.biSaiModel.namiId];
        [RBToast showWithTitle:@"已复制到您的粘贴板"];
    }
}

// 获取球赛信息
- (void)getBiSaiInfo {
    NSString *str = [NSString stringWithFormat:@"api/sports/football/match/detail?id=%d", self.biSaiModel.namiId];
    NSDictionary *dict = @{ @"data": str };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/gameproxy" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData.allKeys.count != 0) {
            NSDictionary *info =  backData[@"info"];
            NSDictionary *home_team = backData[@"home_team"];
            NSDictionary *away_team = backData[@"away_team"];
            self.biSaiModel.biSaiTime = [info[@"matchtime"]intValue];
            self.biSaiModel.TeeTime = [info[@"realtime"]intValue];
            self.biSaiModel.status = [info[@"statusid"] intValue];
            self.biSaiModel.eventLongName = backData[@"matchevent"][@"name_zh"];
            self.biSaiModel.hostLogo = home_team[@"logo"];
            self.biSaiModel.hostScore = [home_team[@"score"] intValue];
            self.biSaiModel.hostTeamName = home_team[@"name_zh"];
            self.biSaiModel.visitingLogo = away_team[@"logo"];
            self.biSaiModel.visitingScore = [away_team[@"score"] intValue];
            self.biSaiModel.visitingTeamName = away_team[@"name_zh"];
            self.chatVC.biSaiModel = self.biSaiModel;
            self.liveTabVC.biSaiModel = self.biSaiModel;
            self.liveTabVC.biSaiDetailHead = self.biSaiDetailHead;
            self.aiForecastVC.biSaiModel = self.biSaiModel;
            self.analyzeVC.biSaiModel = self.biSaiModel;
            self.biSaiDetailHead.biSaiModel = self.biSaiModel;
            self.attentionBtn.hidden = (self.biSaiModel.status == 8);
            if (self.attentionBtn.hidden) {
                self.shareBtn.x = RBScreenWidth - 56;
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

/// 点击关注按钮
- (void)clickAttentionBtn:(UIButton *)btn {
    if ([RBChekLogin CheckLogin]) {
        return;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.biSaiModel.biSaiTime];
        [dict setValue:[NSString getStrWithDate:date andFormat:@"yyyyMMdd"] forKey:@"date"];
        [dict setValue:[NSNumber numberWithBool:btn.selected] forKey:@"del"];
        [dict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"matchid"];
        [RBNetworkTool PostDataWithUrlStr:@"apis/guanzhu"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            if (backData[@"ok"] != nil) {
                btn.selected = !btn.selected;
                if (btn.selected) {
                    [[RBFMDBTool sharedFMDBTool]addAttentionBiSaiModel:self.biSaiModel];
                    self.biSaiModel.hasAttention = YES;
                    [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:self.biSaiModel];
                } else {
                    [[RBFMDBTool sharedFMDBTool]deleteAttentionBiSaiModelWithId:self.biSaiModel.namiId];
                    self.biSaiModel.hasAttention = NO;
                    [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:self.biSaiModel];
                }
            }
        } Fail:^(NSError *_Nonnull error) {
            btn.selected = !btn.selected;
        }];
    }
}

/// 点击返回按钮
- (void)clickBackBtn {
    [self.backBtn removeFromSuperview];
    [self.attentionBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [[SocketRocketUtility instance] SRWebSocketClose];
    UIView *chatToolBar = [[UIApplication sharedApplication].keyWindow viewWithTag:5001];
    [chatToolBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/// 点击分享按钮
- (void)clickShareBtn:(UIButton *)btn {
    if ([RBChekLogin CheckLogin]) {
        return;
    } else {
        __block RBBiSaiDetailVC *weakSelf = self;
        self.shareView =  [[RBFenXiangView alloc]initWithClickItem:^(NSInteger index) {
            [weakSelf getShareDataWithIndex:(int)index];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    }
}

/// 根据选择进行分享（好友/朋友圈）
- (void)getShareDataWithIndex:(int)index {
    [MBProgressHUD showLoading:@"加载中…" toView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/weixinappshare"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self getaiDataWithIndex:index];
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// 分享
- (void)shareWithType:(NSString *)type andDes:(NSString *)des andUrlStr:(NSString *)url andImage:(NSString *)image {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"needShow" object:[NSNumber numberWithBool:YES]];
        //根据比赛的状态以及是否是预测界面，预测界面是否有数据
        if (self.index == 2 && self.aiForecastVC.checkBtn.tag == 200) {
            // 进入到了预测页面，判断是否有数据
            if (self.biSaiModel.status == 8) {
                // 比赛结束
                if (self.hasData) {
                    [self shareImgWithType:type];
                }
            } else if (self.hasBuy) {
                [self shareImgWithType:type];
            } else {
                [self sharMsgWithType:type andDes:des andUrlStr:url andImage:image];
            }
        } else {
            [self sharMsgWithType:type andDes:des andUrlStr:url andImage:image];
        }
    }
}

- (void)shareImgWithType:(NSString *)type {
    NSData *imageData = UIImagePNGRepresentation([self createShareView]);
    WXImageObject *ext = [WXImageObject object];
    // 小于10MB
    ext.imageData = imageData;
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    if ([type isEqualToString:@"Session"]) {
        req.scene = WXSceneSession;
    } else {
        req.scene = WXSceneTimeline;
    }
    req.message = message;
    [WXApi sendReq:req completion:^(BOOL success) {
    }];
}

- (void)sharMsgWithType:(NSString *)type andDes:(NSString *)des andUrlStr:(NSString *)url andImage:(NSString *)image {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = des;
    if (self.biSaiModel.status == 8) {
        message.description = @"你的ai智能预测专家";
    } else {
        message.description = @"谁会赢呢，快来看看";
    }
    [message setThumbImage:[UIImage imageNamed:@"share logo"]];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if ([type isEqualToString:@"Session"]) {
        req.scene = WXSceneSession;
    } else {
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req completion:^(BOOL success) {
        [self.shareView clickCancelBtn];
    }];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.biSaiDetailHead.origin = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (UIImage *)createShareView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    bgView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIImageView *BG = [[UIImageView alloc]initWithFrame:bgView.bounds];
    [bgView addSubview:BG];
    BG.image = [UIImage imageNamed:@"share bg"];

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(50, 28, RBScreenWidth - 100, RBScreenHeight - 113 - 28)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];

    CGSize size = [@"小应体育" getLineSizeWithBoldFontSize:14];
    UIButton *topBtn = [[UIButton alloc]init];
    [topBtn setImage:[UIImage imageNamed:@"ding logo"] forState:UIControlStateNormal];
    [topBtn setTitle:@"小应体育" forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [topBtn setTitleColor:[UIColor colorWithSexadeString:@"#213A4B"] forState:UIControlStateNormal];
    topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    topBtn.frame = CGRectMake((RBScreenWidth - 100 - size.width - 32) * 0.5, 7, size.width + 32, 20);
    [whiteView addSubview:topBtn];

    UIImageView *currentImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, RBScreenWidth - 100, RBScreenHeight - 113 - 28 - 34)];
    [whiteView addSubview:currentImage];
    currentImage.image = [self getNormalImage];

    UIView *whiteView2 = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - 100, RBScreenWidth, 100)];
    whiteView2.backgroundColor = [UIColor whiteColor];
    whiteView2.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.06].CGColor;
    whiteView2.layer.shadowOffset = CGSizeMake(0, -1);
    whiteView2.layer.shadowOpacity = 1;
    whiteView2.layer.shadowRadius = 6;
    [bgView addSubview:whiteView2];

    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(55, 20, 60, 60)];
    [whiteView2 addSubview:codeImage];
    codeImage.image = [UIImage imageNamed:@"download code"];

    CGSize size2 = [@"真正智能预测专家" getLineSizeWithBoldFontSize:22];
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(127, 26, size2.width, 30)];
    tip1.text = @"真正智能预测专家";
    tip1.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tip1.textAlignment = NSTextAlignmentLeft;
    tip1.font = [UIFont boldSystemFontOfSize:22];
    [whiteView2 addSubview:tip1];

    UIButton *tipBtn = [[UIButton alloc]init];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"red pop"] forState:UIControlStateNormal];
    [tipBtn setTitle:@"很准" forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipBtn.frame = CGRectMake(CGRectGetMaxX(tip1.frame) + 2, 27, 40, 18);
    [whiteView2 addSubview:tipBtn];

    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(127, CGRectGetMaxY(tip1.frame) + 4, RBScreenWidth - 127, 14)];
    tip2.text = @"扫描下载小应体育 App";
    tip2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
    tip2.textAlignment = NSTextAlignmentLeft;
    tip2.font = [UIFont systemFontOfSize:12];
    [whiteView2 addSubview:tip2];

    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [bgView.layer renderInContext:ctx];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 获取屏幕截图

- (UIImage *)getNormalImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(RBScreenWidth, RBScreenHeight), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
