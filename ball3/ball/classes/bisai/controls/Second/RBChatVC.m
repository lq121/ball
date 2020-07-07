#import "RBChatVC.h"
#import "RBCommButton.h"
#import "RBUserRecharge.h"
#import "RBGiftView.h"
#import "RBSendGiftView.h"
#import "RBNetworkTool.h"
#import "SocketRocketUtility.h"
#import "RBTipViewCell.h"
#import "RBChatCell.h"
#import "RBChatModel.h"
#import "RBToast.h"


@interface RBChatVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *chattoken;
@property (nonatomic, assign) int hasCheckTag;
@property (nonatomic, strong) RBChatModel *chatModel;
@end

@implementation RBChatVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.chatToolBar.hidden = YES;
    [self.textField resignFirstResponder];
}

- (UIView *)chatToolBar {
    if (!_chatToolBar) {
        UIView *chatToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBBottomSafeH - 49, RBScreenWidth, 49 + RBBottomSafeH)];
        chatToolBar.tag = 5001;
        chatToolBar.hidden = YES;
        chatToolBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
        chatToolBar.layer.shadowOffset = CGSizeMake(0, -2);
        chatToolBar.layer.shadowOpacity = 1;
        chatToolBar.layer.shadowRadius = 4;
        chatToolBar.backgroundColor = [UIColor whiteColor];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 9, RBScreenWidth - 128 - 24 - 32, 32)];
        self.textField = textField;
        textField.returnKeyType =  UIReturnKeySend;
        textField.delegate = self;
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 32)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.placeholder = @"跟大家聊聊呗～";
        textField.font = [UIFont systemFontOfSize:16];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 16;
        [chatToolBar addSubview:textField];

        UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + 8, 0, 50, 49)];
        [sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [chatToolBar addSubview:sendBtn];

        RBCommButton *moneyBtn = [[RBCommButton alloc]initWithImage:@"chongzhi" andHeighImage:@"chongzhi" andFrame:CGRectMake(CGRectGetMaxX(sendBtn.frame) + 8, 4, 28, 41) andTitle:@"充值" andTarget:self andAction:@selector(clickMoneyBtn) andLabelFontSize:10];
        [chatToolBar addSubview:moneyBtn];
        RBCommButton *giftBtn = [[RBCommButton alloc]initWithImage:@"gift2" andHeighImage:@"gift2" andFrame:CGRectMake(CGRectGetMaxX(moneyBtn.frame) + 24, 4, 28, 41) andTitle:@"礼物" andTarget:self andAction:@selector(clickGiftBtn) andLabelFontSize:10];
        [chatToolBar addSubview:giftBtn];
        _chatToolBar = chatToolBar;
    }
    return _chatToolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectSocket];
    [self.view endEditing:YES];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
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
    [[UIApplication sharedApplication].keyWindow addSubview:self.chatToolBar];
    UITableView *tabView = [[UITableView alloc]init];
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tabView;
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.backgroundColor = [UIColor whiteColor];

    tabView.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - height - self.chatToolBar.height - RBBottomSafeH);
    [self.view addSubview:tabView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectSuccess) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickCheckBtn:) name:@"clickfirstToolBarBtn" object:nil];
}

- (void)clickCheckBtn:(NSNotification *)noti {
    self.hasCheckTag = [noti.object intValue];
}

- (void)connct {
    if (self.chattoken == nil || self.chattoken.length == 0) {
        [self connectSocket];
    }
}

- (void)connectSocket {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"matchId"];
    __weak typeof(self) weakSelf = self;
    [RBNetworkTool PostDataWithUrlStr:@"apis/getchattoken" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil || backData[@"ok"] == nil) {
            return;
        }
        weakSelf.chattoken = backData[@"ok"];
        // 断开原来的socket
        if ([SocketRocketUtility instance].socketReadyState != SR_CLOSED) {
            [[SocketRocketUtility instance] SRWebSocketClose];
        }
        // 链接新的socket
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:BASocket];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)connectSuccess {
    if (self.hasSend || self.chattoken == nil) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [dict setObject:uid forKey:@"act"];
    [dict setValue:@[] forKey:@"frds"];
    [dict setValue:@"login" forKey:@"hid"];
    [dict setValue:@[] forKey:@"quns"];
    [dict setValue:@(1) forKey:@"nosave"];
    [dict setValue:self.chattoken forKey:@"token"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[SocketRocketUtility instance]sendData:str];
    self.hasSend = YES;
}

- (void)clickSendBtn {
    NSString *sendStr = self.textField.text;
    sendStr = [sendStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (sendStr.length <= 0) {
        [RBToast showWithTitle:@"不能发送空字符"];
        return;
    }
    RBChatModel *chatModel = [[RBChatModel alloc]init];
    if (self.chatModel != nil) {
        chatModel.uid = self.chatModel.uid;
        chatModel.vipLevel = self.chatModel.vipLevel;
        chatModel.nickName = self.chatModel.nickName;
        chatModel.c = 1;
        chatModel.msg = self.textField.text;
        chatModel.game = self.biSaiModel.eventLongName;
        chatModel.anchorName = @"平台";
        int vip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
        chatModel.vip = vip;
    } else {
        [RBToast showWithTitle:@"发送失败"];
        self.textField.text = nil;
        return;
    }
    self.textField.text = nil;
    NSDictionary *dict = chatModel.mj_keyValues;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    [mutDict setValue:str forKey:@"data"];
    [mutDict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"to"];
    [mutDict setValue:@(0) forKey:@"propid"];
    [mutDict setValue:@(0) forKey:@"propnum"];
    [mutDict setValue:self.biSaiModel.eventLongName forKey:@"game"];
    [mutDict setValue:@(0) forKey:@"usepacket"];
    [mutDict setValue:@(0) forKey:@"nosave"];

    [RBNetworkTool PostDataWithUrlStr:@"apis/sendzhibomsg" andParam:mutDict Success:^(NSDictionary *_Nonnull backData) {
    } Fail:^(NSError *_Nonnull error) {
    }];
}

// 监听到服务器返回的socket
- (void)SRWebSocketDidReceiveMsg:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    if (dic == nil || [dic isKindOfClass:[NSNull class]]) return;
    if ([dic[@"hid"] isEqualToString:@"rsplogin"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"joinzhibo" forKey:@"hid"];
        [dict setValue:@[[NSString stringWithFormat:@"%d", self.biSaiModel.namiId]] forKey:@"zhibo"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[SocketRocketUtility instance] sendData:str];
        return;
    }
    if ([dic[@"hid"] isEqualToString:@"rspjoinzhibo"]) {
        // 收到直播数据返回
        NSDictionary *msgData = dic[@"data"];
        if ([msgData objectForKey:@"newmsg"]) {
            NSArray *newmsg = dic[@"data"][@"newmsg"];
            NSDictionary *msgDic = [newmsg firstObject];
            if ([msgDic objectForKey:@"msg"]) {
                NSArray *msgArr = msgDic[@"msg"];
                if (![msgArr isKindOfClass:[NSNull class]] && msgArr != nil  && msgArr.count > 0) {
                    for (int i = 0; i < msgArr.count; i++) {
                        NSDictionary *dict = msgArr[i];
                        RBChatModel *model = [RBChatModel mj_objectWithKeyValues:dict[@"data"]];
                        [self.dataArr addObject:model];
                        [self.tableView reloadData];
                    }
                }
            }
        }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(3) forKey:@"c"];
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        [dict setObject:uid forKey:@"uid"];
        if (self.chattoken != nil) {
            [dict setObject:self.chattoken forKey:@"token"];
        }
        int Viplevel = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Viplevel"]intValue];
        NSString *nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        if (![nickName isEqualToString:@""] && nickName != nil && ![nickName isKindOfClass:[NSNull class]]) {
            [dict setObject:nickName forKey:@"nickname"];
        }
        [dict setObject:@(Viplevel) forKey:@"viplevel"];
        NSDictionary *dict2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"vipDict"];
        int vip = [dict2[@"vip"]intValue];
        [dict setObject:@(vip) forKey:@"vip"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
        [mutDict setValue:str forKey:@"data"];
        [mutDict setValue:[NSString stringWithFormat:@"%d", self.biSaiModel.namiId] forKey:@"to"];
        [mutDict setValue:@(0) forKey:@"propid"];
        [mutDict setValue:@(0) forKey:@"propnum"];
        [mutDict setValue:self.biSaiModel.eventLongName forKey:@"game"];
        [mutDict setValue:@(0) forKey:@"usepacket"];
        [mutDict setValue:@(1) forKey:@"nosave"];
        [RBNetworkTool PostDataWithUrlStr:@"apis/sendzhibomsg" andParam:mutDict Success:^(NSDictionary *_Nonnull backData) {
        } Fail:^(NSError *_Nonnull error) {
        }];
    }
    if ([dic[@"err"] intValue] != 0 && dic != nil) {
        [RBToast showWithTitle:@"发送失败"];
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if ([dic[@"hid"] isEqualToString:@"msg"]) {
        NSDictionary *data = dic[@"data"][@"data"];
        RBChatModel *chatModel = [RBChatModel mj_objectWithKeyValues:data];
        if (chatModel == nil || chatModel.c == 4) {
            return;
        }
        if (chatModel.c == 3 && [uid isEqualToString:chatModel.uid]) {
            self.chatModel = chatModel;
        }
        if ([uid isEqualToString:chatModel.uid] && chatModel.c != 3) {
            [self addEXp];
        }
        if (chatModel.c == 2 && self.hasCheckTag == 201) { // 只有在聊天界面才显示发送礼物
            RBSendGiftView *sendGiftView = [[RBSendGiftView alloc]initWithFrame:CGRectMake(-RBScreenWidth + 68, 184 * 2, RBScreenWidth - 68, 100) andViplevel:chatModel.vipLevel andNickName:chatModel.nickName andGiftId:chatModel.giftId andCount:chatModel.giftNum];
            sendGiftView.tag = 999;
            [[UIApplication sharedApplication].keyWindow addSubview:sendGiftView];
            if ([chatModel.uid isEqualToString:uid]) {
                // 自己发出的扣除金币，或者扣除背包中的礼物
                if (chatModel.UsePack) {
                    NSString *Packet = [[NSUserDefaults standardUserDefaults]objectForKey:@"Packet"];
                    if (Packet != nil) {
                        NSData *jsonData = [Packet dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&err];
                        NSMutableArray *arr2 = (NSMutableArray *)dic;
                        for (int i = 0; i < arr2.count; i++) {
                            NSMutableArray *ar = [NSMutableArray arrayWithArray:arr2[i]];
                            if ([ar[0]intValue] == chatModel.giftId) {
                                ar[1] = @([ar[1] intValue] - chatModel.giftNum);
                                if ([ar[1] intValue] <= 0) {
                                    [arr2 removeObjectAtIndex:i];
                                } else {
                                    arr2[i] = ar;
                                }
                                break;
                            }
                        }
                        NSData *data = [NSJSONSerialization dataWithJSONObject:arr2
                                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                         error:nil];
                        NSString *string = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
                        [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"Packet"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                } else {
                    int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
                    NSArray *coins = @[@(5000), @(1000), @(520), @(50), @(50), @(1), @(1), @(1)];
                    coinCount -= [coins[chatModel.giftId - 1] intValue] * chatModel.giftNum;
                    [[NSUserDefaults standardUserDefaults]setObject:@(coinCount) forKey:@"coinCount"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            [sendGiftView show];
        }
        [self.dataArr addObject:chatModel];
        [self.tableView reloadData];
        if (self.dataArr.count > 0) {
            if ([self.tableView numberOfRowsInSection:0] > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}

- (void)addEXp {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/rewardliaotian" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
    } Fail:^(NSError *_Nonnull error) {
    }];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.tableView.height = self.view.height - keyboardFrame.size.height - 49;
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        self.chatToolBar.y = RBScreenHeight - keyboardFrame.size.height - 49;
    }];
}

#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
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
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - RBBottomSafeH - 49;
        self.tableView.height = RBScreenHeight - height - self.chatToolBar.height - RBBottomSafeH;
    }];
}

- (void)clickMoneyBtn {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    CGFloat coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]floatValue];

    RBUserRecharge *userRecharge =  [[RBUserRecharge alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight) andCoinCount:coinCount andClickItem:^(int index) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(myDelayTime * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [RBNetworkTool orderWithJsonDic:[NSMutableDictionary dictionary] Type:ToolApiAppleDisburse andStyle:index + 1 Result:^(NSDictionary *backData, MoneyStatus status, NSError *error) {
                               if (error != nil || backData[@"err"] != nil) {
                                   [RBToast showWithTitle:@"下单失败" ];
                               }
                           }];
                       });
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:userRecharge];
    [userRecharge showWhiteView];
}

- (void)clickGiftBtn {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    CGFloat coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]floatValue];
    __weak typeof(self) weakSelf = self;
    RBGiftView *giftView = [[RBGiftView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight) andCoinCount:coinCount andClickItem:^(NSDictionary *dict) {
        if (weakSelf.chatModel == nil) {
            [RBToast showWithTitle:@"连接错误"];
            return;
        }
        RBChatModel *chatModel = [[RBChatModel alloc]init];
        if (weakSelf.chatModel != nil) {
            chatModel.uid = weakSelf.chatModel.uid;
            chatModel.vipLevel = weakSelf.chatModel.vipLevel;
            chatModel.nickName = weakSelf.chatModel.nickName;
            chatModel.c = 2;
            chatModel.game = weakSelf.biSaiModel.eventLongName;
            chatModel.anchorName = @"平台";
            chatModel.giftId = [dict[@"giftId"]intValue];
            chatModel.name = dict[@"name"];
            chatModel.giftNum = [dict[@"count"]intValue];
            chatModel.UsePack = [dict[@"isPackt"]boolValue];
            int vip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
            chatModel.vip = vip;
        }
        NSDictionary *dict2 = chatModel.mj_keyValues;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict2 options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
        [mutDict setValue:str forKey:@"data"];
        [mutDict setValue:[NSString stringWithFormat:@"%d", weakSelf.biSaiModel.namiId] forKey:@"to"];
        [mutDict setValue:@([dict[@"giftId"]intValue]) forKey:@"propid"];
        [mutDict setValue:@([dict[@"count"]intValue]) forKey:@"propnum"];
        [mutDict setValue:dict[@"name"] forKey:@"name"];
        [mutDict setValue:self.biSaiModel.eventLongName forKey:@"game"];
        [mutDict setValue:@([dict[@"isPackt"]intValue]) forKey:@"usepacket"];
        [mutDict setValue:@(1) forKey:@"nosave"];

        [RBNetworkTool PostDataWithUrlStr:@"apis/sendzhibomsg" andParam:mutDict Success:^(NSDictionary *_Nonnull backData) {
        } Fail:^(NSError *_Nonnull error) {
        }];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:giftView];
    [giftView showWhiteView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
    [self clickSendBtn];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBChatModel *chatModel = self.dataArr[indexPath.row];
    if (chatModel.c == 3) {
        RBTipViewCell *cell = [RBTipViewCell createCellByTableView:tableView];
        cell.chatModel = chatModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        RBChatCell *cell = [RBChatCell createCellByTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.chatModel = chatModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBChatModel *chatModel = self.dataArr[indexPath.row];
    if (chatModel.c == 3) {
        return 24;
    } else {
        RBChatCell *cell = [RBChatCell createCellByTableView:tableView];
        cell.chatModel = chatModel;
        return [cell getCellHeight];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 24)];
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.backgroundColor = [UIColor colorWithSexadeString:@"#EAEAEA"];
    leftLab.text = @"违规者封号处理";
    leftLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    leftLab.font = [UIFont systemFontOfSize:12];
    return leftLab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (void)dealloc {
    [self.textField resignFirstResponder];
    [self.chatToolBar removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
