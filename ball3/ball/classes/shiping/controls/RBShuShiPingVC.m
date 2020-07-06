#import "RBShuShiPingVC.h"
#import "RBCommButton.h"
#import "RBPlayer.h"
#import "WXApi.h"
#import "RBNetworkTool.h"
#import "RBTipView.h"
#import "RBFenXiangView.h"
#import "RBHuaTiHuiFuModel.h"
#import "RBNetworkTool.h"
#import "RBChekLogin.h"
#import "RBToast.h"
#import "RBHuaTiHuiFuCell.h"
#import "RBHuiFuVC.h"

@interface RBShuShiPingVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *upBtn;
@property (nonatomic, strong) RBFenXiangView *fenxiangView;
@property (nonatomic, strong) NSMutableArray *pingLunArr;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *chatToolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *pingLunBtn;
@property (nonatomic, strong) RBPlayer *player;
@property (nonatomic, strong) RBCommButton *topicBtn;
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, strong) UIView *headView;
@end

@implementation RBShuShiPingVC

- (NSMutableArray *)pingLunArr {
    if (_pingLunArr == nil) {
        _pingLunArr = [NSMutableArray array];
    }
    return _pingLunArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBNavBarAndStatusBarH)];
    headView.hidden = YES;
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titLebal = [[UILabel alloc]initWithFrame:CGRectMake((RBScreenWidth - 100) * 0.5, RBStatusBarH, 100, RBNavBarAndStatusBarH - RBStatusBarH)];
    titLebal.text = @"评论";
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

    self.headView = headView;
    [self setupChatToolBar];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backBtn removeFromSuperview];
    [self.upBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.player pause];
    [self.chatToolBar removeFromSuperview];
    [self.headView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self setupTableView];
    [self setupHeadView];
    [self getVideoDetail];

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
            [self.pingLunBtn setTitle:[NSString stringWithFormat:@"%ld", [ok[@"Comment"]longValue]] forState:UIControlStateNormal];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, RBScreenHeight + RBStatusBarH);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:tableView];
}

- (void)setupHeadView {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    self.player = [[RBPlayer alloc]init];
    [self.player setShiPingUrl:self.shiPingModel.Url andType:0];
    [self.player playerBindTableView:self.tableView currentIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    [headView addSubview:self.player];
    __weak typeof(self) weakSelf = self;
    self.player.playingOverBlock = ^(RBPlayer *_Nonnull player) {
        [weakSelf.player playPause];
        weakSelf.topicBtn.hidden = NO;
        weakSelf.coverView.hidden = NO;
    };

    UIButton *coverView = [[UIButton alloc]init];
    [coverView addTarget:self action:@selector(showVideoPlayer:) forControlEvents:UIControlEventTouchUpInside];
    self.coverView = coverView;
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [headView addSubview:coverView];
    coverView.hidden = YES;
    CGSize size = [self.shiPingModel.Title getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32];
    RBCommButton *topicBtn = [[RBCommButton alloc] initWithImage:@"btn／replay" andHeighImage:@"btn／replay" andFrame:CGRectMake((RBScreenWidth - 60) * 0.5, (RBScreenHeight - size.height - 26 - 32 - 67) * 0.5, 60, 67) andTitle:@"重新播放" andTarget:self andAction:@selector(showVideoPlayer:) andLabelFontSize:14];
    topicBtn.hidden = YES;
    self.topicBtn = topicBtn;
    [headView addSubview:topicBtn];

    UILabel *videoTitleLab = [[UILabel alloc]init];
    videoTitleLab.text = self.shiPingModel.Title;
    videoTitleLab.numberOfLines = 0;
    videoTitleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    videoTitleLab.font = [UIFont systemFontOfSize:16];
    videoTitleLab.textAlignment = NSTextAlignmentLeft;
    videoTitleLab.frame = CGRectMake(16, RBScreenHeight - size.height - 26 - 32 + 16, RBScreenWidth - 32, size.height);
    [headView addSubview:videoTitleLab];

    UIButton *topBtn = [[UIButton alloc]init];
    topBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [topBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    topBtn.frame = CGRectMake(16, CGRectGetMaxY(videoTitleLab.frame) + 10, 50, 16);
    topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    self.topBtn = topBtn;
    [headView addSubview:topBtn];

    UIButton *pingLunBtn = [[UIButton alloc]init];
    pingLunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.pingLunBtn = pingLunBtn;
    pingLunBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    pingLunBtn.frame = CGRectMake(CGRectGetMaxX(topBtn.frame) + 24, CGRectGetMaxY(videoTitleLab.frame) + 10, 50, 16);
    [pingLunBtn setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
    [pingLunBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    pingLunBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    self.pingLunBtn = pingLunBtn;
    [headView addSubview:pingLunBtn];
    self.player.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - size.height - 26 - 32);
    self.coverView.frame = self.player.bounds;
    headView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, RBScreenHeight);
    self.tableView.tableHeaderView = headView;
    [self rewardLook];
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
    self.player = [[RBPlayer alloc]init];
    [self.player setShiPingUrl:self.shiPingModel.Url andType:0];
    [self.player playerBindTableView:self.tableView currentIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGSize size = [self.shiPingModel.Title getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32];
    self.player.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - size.height - 26 - 32);
    [self.tableView.tableHeaderView addSubview:self.player];
    __weak typeof(self) weakSelf = self;
    self.player.playingOverBlock = ^(RBPlayer *player) {
        [weakSelf.player playPause];
        weakSelf.topicBtn.hidden = NO;
        weakSelf.coverView.hidden = NO;
    };
}

- (void)getData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [dict setValue:@(1) forKey:@"cid"];
    [dict setValue:@(self.shiPingModel.Id) forKey:@"huatiid"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getvideocomment"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
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
                    self.pingLunArr[self.pingLunArr.count - 1] = lastModel;     // 防止第一条评论已加入但是还没有加入二级评论
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
            [RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"commentlv" andNeedCheck:NO];
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
        __weak typeof(self) weakSelf = self;
        self.fenxiangView =  [[RBFenXiangView alloc]initWithClickItem:^(NSInteger index) {
            [weakSelf getShareDataWithIndex:index];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.fenxiangView];
    }
}

/// 根据选择进行分享（好友/朋友圈）
- (void)getShareDataWithIndex:(NSInteger)index {
    [MBProgressHUD showLoading:@"加载中…" toView:self.view];
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
            pasteboard.string = [NSString stringWithFormat:@"%@video?id=%d",  BASESHAREURL, self.shiPingModel.Id];
            [RBToast showWithTitle:@"已复制到您的粘贴板"];
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
        message.title = @"小应体育";
        message.description = des;
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
            [self.fenxiangView clickCancelBtn];
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
    chatToolBar.hidden = YES;
    chatToolBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    chatToolBar.layer.shadowOffset = CGSizeMake(0, -2);
    chatToolBar.layer.shadowOpacity = 1;
    chatToolBar.layer.shadowRadius = 4;
    chatToolBar.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:chatToolBar];

    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 9, RBScreenWidth - 66 - 32, 32)];
    self.textField = textField;
    textField.returnKeyType =  UIReturnKeySend;
    textField.delegate = self;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 32)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @"说点什么…";
    textField.font = [UIFont systemFontOfSize:16];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 16;
    [chatToolBar addSubview:textField];

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 16, 0, 50, 49)];
    [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chatToolBar addSubview:sendBtn];
}

- (void)clickSendBtn {
    if ([RBChekLogin NotLogin]) {
        return;
    }
    if (self.textField.text.length <= 0) {
        [RBToast showWithTitle:@"请输入回复内容"];
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
            [RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"commentlv" andNeedCheck:NO];
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
    return self.pingLunArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuaTiHuiFuModel *huiFuModel = self.pingLunArr[indexPath.row];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    RBHuaTiHuiFuCell *cell = [RBHuaTiHuiFuCell createCellByTableView:tableView andClickCellCloseBtn:^(RBHuaTiHuiFuModel *_Nonnull huiFuModel) {
        [weakSelf getDataWithHuaTiHuiFuModel:huiFuModel andIndexPath:indexPath];
    }];
    RBHuaTiHuiFuModel *huiFuModel = self.pingLunArr[indexPath.row];
    huiFuModel.type = 1;
    huiFuModel.index = (int)indexPath.row + 1;
    cell.huaTiHuiFuModel = huiFuModel;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)getDataWithHuaTiHuiFuModel:(RBHuaTiHuiFuModel *)huiFuModel andIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    int p = (int)huiFuModel.secondArr.count / 10;
    [dict setValue:@(p) forKey:@"p"];
    [dict setValue:@(2) forKey:@"cid"];
    [dict setValue:@(huiFuModel.Id) forKey:@"commentid"];
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
        self.pingLunArr[indexPath.row] = huiFuModel;
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuiFuVC *huiFuVC = [[RBHuiFuVC alloc]init];
    huiFuVC.huiFuModel = self.pingLunArr[indexPath.row];
    huiFuVC.title = @"评论";
    [self.navigationController pushViewController:huiFuVC animated:YES];
    self.chatToolBar.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player destroyPlayer];
    self.player = nil;
    [self.chatToolBar removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    if (scrollView.contentOffset.y > 0) {
        self.headView.hidden = NO;
        self.tableView.height = RBScreenHeight + RBStatusBarH - 49 - RBBottomSafeH;
        self.chatToolBar.hidden = NO;
        [self.backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"like black"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"like black_selected"] forState:UIControlStateSelected];
        [self.shareBtn setImage:[UIImage imageNamed:@"share2"] forState:UIControlStateNormal];
    } else if (scrollView.contentOffset.y < -RBStatusBarH) {
        self.headView.hidden = YES;
        self.chatToolBar.hidden = YES;
        self.tableView.height = RBScreenHeight + RBStatusBarH;
        [self.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"up3"] forState:UIControlStateNormal];
        [self.upBtn setImage:[UIImage imageNamed:@"up3_selected"] forState:UIControlStateSelected];
        [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
}

@end
