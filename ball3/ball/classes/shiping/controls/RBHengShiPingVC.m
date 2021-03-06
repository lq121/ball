#import "RBHengShiPingVC.h"
#import "RBCommButton.h"
#import "RBPlayer.h"
#import "WXApi.h"
#import "RBNetworkTool.h"
#import "RBLoginVC.h"
#import "RBTipView.h"
#import "RBFenXiangView.h"
#import "RBHuaTiHuiFuModel.h"
#import "RBChekLogin.h"
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBHuiFuVC.h"
#import "RBHuaTiHuiFuCell.h"

@interface RBHengShiPingVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) RBFenXiangView *fenXiangView;
@property (nonatomic, strong) NSMutableArray *pingLunArr;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *chatToolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int currentP;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, strong) RBPlayer *player;
@property (nonatomic, strong) RBCommButton *topicBtn;
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, strong) UIView *headView;

@end

@implementation RBHengShiPingVC
- (NSMutableArray *)pingLunArr {
    if (_pingLunArr == nil) {
        _pingLunArr = [NSMutableArray array];
    }
    return _pingLunArr;
}

- (RBPlayer *)player {
    if (_player == nil) {
        _player = [[RBPlayer alloc]init];
        [_player setShiPingUrl:self.shiPingModel.Url andType:1];
        [self.player playerBindTableView:self.tableView currentIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.player.frame = CGRectMake(0, RBStatusBarH, RBScreenWidth, 285 - RBStatusBarH);
    }
    return _player;
}

- (UIButton *)topBtn {
    if (_topBtn == nil) {
        UIButton *topBtn = [[UIButton alloc]init];
        topBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [topBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [topBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        topBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [topBtn setTitle:@"0" forState:UIControlStateNormal];
        topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        _topBtn = topBtn;
    }
    return _topBtn;
}

- (UIButton *)reportBtn {
    if (_reportBtn == nil) {
        UIButton *reportBtn = [[UIButton alloc]init];
        reportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        reportBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [reportBtn setTitle:@"0" forState:UIControlStateNormal];
        [reportBtn setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
        [reportBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        reportBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _reportBtn = reportBtn;
    }
    return _reportBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBNavBarAndStatusBarH)];
    headView.hidden = YES;
    self.headView = headView;
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titLebal = [[UILabel alloc]initWithFrame:CGRectMake((RBScreenWidth - 100) * 0.5, RBStatusBarH, 100, RBNavBarAndStatusBarH - RBStatusBarH)];
    titLebal.text = pinglun;
    titLebal.textAlignment = NSTextAlignmentCenter;
    titLebal.font = [UIFont systemFontOfSize:17];
    [headView addSubview:titLebal];
    [[UIApplication sharedApplication].keyWindow addSubview:headView];

    UIButton *backBtn = [[UIButton alloc]init];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(10, RBStatusBarH, 40, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:backBtn];

    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn addTarget:self  action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(RBScreenWidth - 100, RBStatusBarH, 40, 40);
    if ([WXApi isWXAppInstalled]) {
        [[UIApplication sharedApplication].keyWindow addSubview:shareBtn];
    }
    UIButton *upBtn = [[UIButton alloc]init];
    self.upBtn = upBtn;
    [upBtn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [upBtn setImage:[UIImage imageNamed:@"up3"] forState:UIControlStateNormal];
    [upBtn setImage:[UIImage imageNamed:@"up3_selected"] forState:UIControlStateSelected];
    upBtn.frame = CGRectMake(RBScreenWidth - 56, RBStatusBarH, 40, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:upBtn];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backBtn removeFromSuperview];
    [self.upBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.player playPause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = pinglun;
    [self setupTableView];
    [self setupChatToolBar];
    [self getVideoDetail];
    [self rewardLook];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 获取视频详情
- (void)getVideoDetail {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    [dict setValue:@(self.shiPingModel.Id) forKey:@"id"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getvideobyid"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            self.upBtn.selected = [backData[@"zaned"] boolValue];
            NSDictionary *ok = backData[@"ok"];
            [self.topBtn setTitle:[NSString stringWithFormat:@"%ld", [ok[@"Zannum"] longValue]] forState:UIControlStateNormal];
            [self.reportBtn setTitle:[NSString stringWithFormat:@"%ld", [ok[@"Comment"]longValue]] forState:UIControlStateNormal];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, RBScreenHeight - RBBottomSafeH  - 49 + RBStatusBarH);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:tableView];
}

- (void)rewardLook {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/rewardlookzhibo" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [RBTipView tipWithTitle:@"观看视频" andExp:[backData[@"ok"][@"addexp"] intValue] andCoin:[backData[@"ok"][@"addcoin"] intValue]];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    self.topicBtn.hidden = YES;
    self.coverView.hidden = YES;
    self.player.hidden = NO;
    [self.tableView reloadData];
    [self.player playPause];
    __weak typeof(self) weakSelf = self;
    self.player.playingOverBlock = ^(RBPlayer *player) {
        [weakSelf.player playPause];
        weakSelf.topicBtn.hidden = NO;
        weakSelf.coverView.hidden = NO;
    };
}

- (void)getData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentP) forKey:@"p"];
    [dict setValue:@(1) forKey:@"cid"];
    [dict setValue:@(self.shiPingModel.Id) forKey:@"huatiid"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getvideocomment"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        if (self.currentP == 0) {
            [self.pingLunArr removeAllObjects];
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        NSMutableArray *nextArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            RBHuaTiHuiFuModel *huiFuModel = arr[i];
            if ([huiFuModel.Hfid intValue] == -1) {
                if (self.pingLunArr.count != 0 && nextArr.count != 0) {
                    // 设置二级评论
                    RBHuaTiHuiFuModel *lastModel = self.pingLunArr[self.pingLunArr.count - 1];
                    lastModel.secondArr = [NSArray arrayWithArray:nextArr];
                    lastModel.LzUid = self.shiPingModel.Uid;
                    [nextArr removeAllObjects];
                    self.pingLunArr[self.pingLunArr.count - 1] = lastModel;    // 防止第一条评论已加入但是还没有加入二级评论
                }
                [self.pingLunArr addObject:huiFuModel];
            } else {
                [nextArr addObject:huiFuModel];
            }
        }
        if (nextArr.count != 0 && self.pingLunArr.count != 0) {
            // 防止只有一条评论
            RBHuaTiHuiFuModel *lastModel = self.pingLunArr[self.pingLunArr.count - 1];
            lastModel.secondArr = [NSArray arrayWithArray:nextArr];
            lastModel.LzUid = self.shiPingModel.Uid;
            [nextArr removeAllObjects];
        }
        [self.tableView showDataCount:self.pingLunArr.count andTitle:@"还没有回帖，快来抢沙发～" andTitFrame:CGRectMake(0, self.tableView.tableHeaderView.height + 16, RBScreenWidth, 36)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

/// 点击点赞按钮
- (void)clickUpBtn:(UIButton *)btn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.shiPingModel.Id) forKey:@"huatiid"];
    [dict setValue:@"" forKey:@"txt"];
    [dict setValue:@(-1) forKey:@"commentid"];
    [dict setValue:@(1) forKey:@"zan"];
    [dict setValue:self.shiPingModel.Uid forKey:@"huatihuid"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/videocomment" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:xuyao5ji andtype:@"commentlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            self.upBtn.selected = YES;
            [self getVideoDetail];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

/// 点击返回按钮
- (void)clickBackBtn {
    [self.backBtn removeFromSuperview];
    [self.upBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

/// 点击分享按钮
- (void)clickShareBtn:(UIButton *)btn {
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        __block RBHengShiPingVC *weakSelf = self;
        self.fenXiangView =  [[RBFenXiangView alloc]initWithClickItem:^(NSInteger index) {
            [weakSelf getShareDataWithIndex:index];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.fenXiangView];
    }
}

/// 根据选择进行分享（好友/朋友圈）
- (void)getShareDataWithIndex:(NSInteger)index {
    [MBProgressHUD showLoading:jiazhaizhong toView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/weixinappshare"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (index == 1) {
            [self shareWithType:@"Session" andDes:[NSString stringWithFormat:@"%@", self.shiPingModel.Title] andUrlStr:[NSString stringWithFormat:@"%@video?id=%d",  BASESHAREURL, self.shiPingModel.Id] andImage:@"share logo"];
        } else if (index == 2) {
            [self shareWithType:@"Timeline" andDes:[NSString stringWithFormat:@"%@", self.shiPingModel.Title] andUrlStr:[NSString stringWithFormat:@"%@video?id=%d",  BASESHAREURL, self.shiPingModel.Id] andImage:@"share logo"];
        } else {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@video?id=%d", BASESHAREURL, self.shiPingModel.Id];
            [RBToast showWithTitle:yifuzhi];
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// 分享
- (void)shareWithType:(NSString *)type andDes:(NSString *)des andUrlStr:(NSString *)url andImage:(NSString *)image {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"needShow" object:[NSNumber numberWithBool:NO]];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = shipingShareTitle;
        message.description = shipingShareDes;
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
            [self.fenXiangView clickCancelBtn];
        }];
    }
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - keyboardFrame.size.height - 49;
    }];
}

#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - RBBottomSafeH  - 49;
    }];
}

- (void)setupChatToolBar {
    UIView *chatToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight  - RBBottomSafeH  - 49, RBScreenWidth, 49)];
    self.chatToolBar = chatToolBar;
    chatToolBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    chatToolBar.layer.shadowOffset = CGSizeMake(0, -2);
    chatToolBar.layer.shadowOpacity = 1;
    chatToolBar.layer.shadowRadius = 4;
    chatToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chatToolBar];

    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 9, RBScreenWidth - 66 - 32, 32)];
    self.textField = textField;
    textField.returnKeyType =  UIReturnKeySend;
    textField.delegate = self;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 32)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = shuodianshenme;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 16;
    [chatToolBar addSubview:textField];

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 16, 0, 50, 49)];
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:fasong forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chatToolBar addSubview:sendBtn];
}

- (void)clickSendBtn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    if (self.textField.text.length <= 0) {
        [RBToast showWithTitle:shuruhuifu];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.shiPingModel.Id) forKey:@"huatiid"];
    [dict setValue:self.textField.text forKey:@"txt"];
    [dict setValue:@(-1) forKey:@"commentid"];
    [dict setValue:@(0) forKey:@"zan"];
    [dict setValue:self.shiPingModel.Uid forKey:@"huatihuid"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/videocomment" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:xuyao5ji andtype:@"commentlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            self.textField.text = nil;
            [self.textField resignFirstResponder];
            [self getData];
            [self getVideoDetail];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickSendBtn];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pingLunArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize size = [self.shiPingModel.Title getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32];
        return 285 + 16 + size.height + 42 - RBStatusBarH;
    } else {
        RBHuaTiHuiFuModel *huiFuModel = self.pingLunArr[indexPath.row - 1];
        CGSize size = [huiFuModel.Hftxt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 72];
        if (huiFuModel.secondArr == nil || huiFuModel.secondArr.count == 0) {
            return size.height + 70;
        } else {
            CGFloat currentH = 0;
            for (int i = 0; i < huiFuModel.secondArr.count; i++) {
                RBHuaTiHuiFuModel *model = huiFuModel.secondArr[i];
                NSString *str = [NSString stringWithFormat:@"%@:%@", model.Hfname, model.Hftxt];
                CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 88];
                currentH += size.height;
            }
            if (huiFuModel.secondArr.count < huiFuModel.Comnum) {
                return size.height + 100 + currentH + 17;
            } else {
                return size.height + 70 + currentH + 17;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *tableViewCell = [[UITableViewCell alloc]init];
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [headView addSubview:self.player];
        [self.player playPause];
        __weak typeof(self) weakSelf = self;
        self.player.playingOverBlock = ^(RBPlayer *player) {
            [weakSelf.player playPause];
            weakSelf.topicBtn.hidden = NO;
            weakSelf.coverView.hidden = NO;
        };

        UIButton *coverView = [[UIButton alloc]initWithFrame:self.player.frame];
        [coverView addTarget:self action:@selector(showVideoPlayer:) forControlEvents:UIControlEventTouchUpInside];
        self.coverView = coverView;
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [headView addSubview:coverView];
        coverView.hidden = YES;

        RBCommButton *topicBtn = [[RBCommButton alloc] initWithImage:@"btn／replay" andHeighImage:@"btn／replay" andFrame:CGRectMake((RBScreenWidth - 60) * 0.5, RBStatusBarH + 63, 60, 67) andTitle:chongxinbofang andTarget:self andAction:@selector(showVideoPlayer:) andLabelFontSize:14];
        topicBtn.hidden = YES;
        self.topicBtn = topicBtn;
        [headView addSubview:topicBtn];

        UILabel *videoTitleLab = [[UILabel alloc]init];
        videoTitleLab.text = self.shiPingModel.Title;
        videoTitleLab.numberOfLines = 0;
        videoTitleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        videoTitleLab.font = [UIFont systemFontOfSize:16];
        videoTitleLab.textAlignment = NSTextAlignmentLeft;
        CGSize size = [self.shiPingModel.Title getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32];
        videoTitleLab.frame = CGRectMake(16, 16 + 285, RBScreenWidth - 32, size.height);
        [headView addSubview:videoTitleLab];
        [headView addSubview:self.reportBtn];
        [headView addSubview:self.topBtn];
        self.reportBtn.frame = CGRectMake(CGRectGetMaxX(self.topBtn.frame) + 24, CGRectGetMaxY(videoTitleLab.frame) + 10, 50, 16);
        self.topBtn.frame = CGRectMake(16, CGRectGetMaxY(videoTitleLab.frame) + 10, 50, 16);
        headView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, CGRectGetMaxY(videoTitleLab.frame) + 42);
        [tableViewCell.contentView addSubview:headView];
        return tableViewCell;
    } else {
        __weak typeof(self) weakSelf = self;
        RBHuaTiHuiFuCell *cell = [RBHuaTiHuiFuCell createCellByTableView:tableView andClickCellCloseBtn:^(RBHuaTiHuiFuModel *_Nonnull huiFuModel) {
            [weakSelf getDataWithHuiFuModel:huiFuModel andIndexPath:indexPath];
        }];
        RBHuaTiHuiFuModel *huiFuModel = self.pingLunArr[indexPath.row - 1];
        huiFuModel.type = 1;
        huiFuModel.index = (int)indexPath.row;
        cell.huaTiHuiFuModel = huiFuModel;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (void)getDataWithHuiFuModel:(RBHuaTiHuiFuModel *)huiFuModel andIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    int p = (int)huiFuModel.secondArr.count / 10;
    [dict setValue:@(p) forKey:@"p"];
    [dict setValue:@(2) forKey:@"cid"];
    [dict setValue:@(huiFuModel.Id) forKey:@"commentid"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    NSString *str = @"try/go/getvideocomment";
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        NSMutableArray *second = [NSMutableArray arrayWithArray:huiFuModel.secondArr];
        for (RBHuaTiHuiFuModel *model in arr) {
            model.canRep = -1;
            [second addObject:model];
            huiFuModel.secondArr = second;
        }
        self.pingLunArr[indexPath.row - 1] = huiFuModel;
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    if (scrollView.contentOffset.y > 0) {
        self.headView.hidden = NO;
        [self.backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"like black"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"like black_selected"] forState:UIControlStateSelected];
        [self.shareBtn setImage:[UIImage imageNamed:@"share2"] forState:UIControlStateNormal];
    } else {
        self.headView.hidden = YES;
        [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"up3"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"up3_selected"] forState:UIControlStateSelected];
        [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        RBHuiFuVC *huiFuVC = [[RBHuiFuVC alloc]init];
        huiFuVC.huiFuModel = self.pingLunArr[indexPath.row - 1];
        huiFuVC.title = pinglun;
        [self.navigationController pushViewController:huiFuVC animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player destroyPlayer];
    self.player = nil;
}

@end
