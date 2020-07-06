#import "RBHuiFuVC.h"
#import "RBChekLogin.h"
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBHuaTiHuiFuCell.h"

@interface RBHuiFuVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *chatToolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIView *footView;
@end

@implementation RBHuiFuVC
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self setupTableView];
    [self setupHeadView];
    [self setupChatToolBar];
    [self getData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH  - 49);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:tableView];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData {
    self.currentPage += 1;
    [self getData];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setupHeadView {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];

    UIImageView *useHead = [[UIImageView alloc]init];
    useHead.image = [UIImage imageNamed:@"user pic"];
    useHead.frame = CGRectMake(16, 16, 32, 32);
    useHead.layer.masksToBounds = YES;
    useHead.layer.cornerRadius = 16;
    [headView addSubview:useHead];

    UILabel *lvLab = [[UILabel alloc]init];
    lvLab.layer.cornerRadius = 2;
    lvLab.layer.masksToBounds = true;
    lvLab.textAlignment = NSTextAlignmentCenter;
    lvLab.textColor = [UIColor whiteColor];
    lvLab.font = [UIFont systemFontOfSize:10];
    [headView addSubview:lvLab];

    UILabel *userName = [[UILabel alloc]init];
    userName.font = [UIFont systemFontOfSize:14];
    userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
    userName.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:userName];

    UIButton *orgIcon = [[UIButton alloc]init];
    [orgIcon setBackgroundImage:[UIImage imageNamed:@"guanfang"] forState:UIControlStateNormal];
    [orgIcon setTitle:@"官方" forState:UIControlStateNormal];
    orgIcon.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [orgIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orgIcon.titleLabel.font = [UIFont systemFontOfSize:10];
    [headView addSubview:orgIcon];

    UIImageView *vipIcon = [[UIImageView alloc]init];
    vipIcon.image = [UIImage imageNamed:@"vip kim"];
    [headView addSubview:vipIcon];

    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = [UIFont systemFontOfSize:10];
    timeLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
    timeLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLab];

    UIButton *zanBtn = [[UIButton alloc]init];
    self.zanBtn = zanBtn;
    zanBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 6, 0, 0);
    [zanBtn addTarget:self action:@selector(clickZanBtn) forControlEvents:UIControlEventTouchUpInside];
    zanBtn.frame = CGRectMake(RBScreenWidth - 55, 17, 55, 16);
    [zanBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [zanBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [zanBtn setImage:[UIImage imageNamed:@"up_selected"] forState:UIControlStateSelected];
    [headView addSubview:zanBtn];

    UILabel *replyLab = [[UILabel alloc]init];
    replyLab.font = [UIFont systemFontOfSize:14];
    replyLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    replyLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:replyLab];

    if (self.huiFuModel.Hfavatar.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:self.huiFuModel.Hfavatar options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                useHead.image = image;
            } else {
                [useHead sd_setImageWithURL:[NSURL URLWithString:self.huiFuModel.Hfavatar ] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:self.huiFuModel.Hfavatar cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                }];
            }
        }];
    }else {
        if ([self.huiFuModel.LzUid isEqualToString:@"fangguan"]) {
           useHead.image = [UIImage imageNamed:@"qidong logo"];
        } else {
           useHead.image = [UIImage imageNamed:@"user pic"];
        }
    }

    userName.text = self.huiFuModel.Hfname;
    CGSize size = [self.huiFuModel.Hfname getLineSizeWithFontSize:14];
    userName.frame = CGRectMake(CGRectGetMaxX(useHead.frame) + 8, useHead.y, size.width, 14);
    orgIcon.frame = CGRectMake(CGRectGetMaxX(userName.frame), useHead.y - 3, 35, 16);
    vipIcon.frame = CGRectMake(CGRectGetMaxX(userName.frame), useHead.y - 3, 35, 16);
    orgIcon.hidden = ![self.huiFuModel.Hfuid isEqualToString:@"fangguan"];
    if (self.huiFuModel.Hfvip  <= 0) {
        vipIcon.hidden = YES;
        userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        lvLab.frame = CGRectMake(CGRectGetMaxX(userName.frame) + 4, useHead.y, 32, 14);
    } else {
        vipIcon.hidden = NO;
        userName.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        lvLab.frame = CGRectMake(CGRectGetMaxX(vipIcon.frame) + 4, useHead.y, 32, 14);
    }
    lvLab.text = [NSString stringWithFormat:@"Lv%d", self.huiFuModel.Hflv];
    lvLab.hidden = [self.huiFuModel.Hfuid isEqualToString:@"fangguan"];
    timeLab.text = [NSString getStrWithDateInt:self.huiFuModel.Hftime andFormat:@"MM月dd日 HH:mm"];
    timeLab.frame = CGRectMake(56, CGRectGetMaxY(userName.frame) + 4, 120, 10);
    [zanBtn setTitle:[NSString stringWithFormat:@"%d", self.self.huiFuModel.Zannum] forState:UIControlStateNormal];
    zanBtn.selected = (self.huiFuModel.Zan == 1);
    replyLab.text = self.self.huiFuModel.Hftxt;
    CGSize size2 = [self.huiFuModel.Hftxt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 72];
    replyLab.frame = CGRectMake(56, CGRectGetMaxY(timeLab.frame) + 10, size2.width, size2.height);
    headView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(replyLab.frame) + 16);
    self.tableView.tableHeaderView = headView;
}

- (void)setupChatToolBar {
    UIView *chatToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBBottomSafeH  - 49 - RBNavBarAndStatusBarH, RBScreenWidth, 49)];
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
    textField.placeholder = @"回复楼主…";
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
    [self.view addSubview:chatToolBar];
}

// 点击赞按钮
- (void)clickZanBtn {
    if ([RBChekLogin NotLogin]) {
        return;
    }else if([RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"zanlv" andNeedCheck:YES]){
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huiFuModel.Htid) forKey:@"huatiid"];
    [dict setValue:@"" forKey:@"txt"];
    [dict setValue:@(self.huiFuModel.Id) forKey:@"commentid"];
    [dict setValue:@(1) forKey:@"zan"];
    NSString *str = @"apis/huaticomment";
    if (self.huiFuModel.type == 1) {
        str = @"apis/videocomment";
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"zanlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"点赞成功"];
            [self.zanBtn setTitle:[NSString stringWithFormat:@"%d", self.huiFuModel.Zannum + 1] forState:UIControlStateNormal];
            self.zanBtn.selected = YES;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
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
    [dict setValue:@(self.huiFuModel.Htid) forKey:@"huatiid"];
    [dict setValue:self.textField.text forKey:@"txt"];
    [dict setValue:@(self.huiFuModel.Id) forKey:@"commentid"];
    [dict setValue:@(0) forKey:@"zan"];
    [dict setValue:self.huiFuModel.LzUid forKey:@"huatihuid"];
    NSString *str = @"apis/huaticomment";
    if (self.huiFuModel.type == 1) {
        str = @"apis/videocomment";
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"commentlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            self.textField.text = nil;
            [self.textField resignFirstResponder];
            self.huiFuModel.Comnum += 1;
            self.currentPage = 0;
            [self getData];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - keyboardFrame.size.height - 49 - RBNavBarAndStatusBarH;
    }];
}

#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - RBBottomSafeH  - 49 - RBNavBarAndStatusBarH;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickSendBtn];
    return YES;
}

- (void)getData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [dict setValue:@(2) forKey:@"cid"];
    [dict setValue:@(self.huiFuModel.Id) forKey:@"commentid"];
    NSString *str = @"try/go/getcomment";
    if (self.huiFuModel.type == 1) {
        str = @"try/go/getvideocomment";
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_footer endRefreshing];
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        for (RBHuaTiHuiFuModel *model in arr) {
            model.canRep = -1;
            [self.dataArr addObject:model];
        }
        if (self.dataArr.count == self.huiFuModel.Comnum) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataArr.count > 0) {
            self.tableView.tableFooterView = self.footView;
        }
        [self.tableView showDataCount:self.dataArr.count andTitle:@"还没有回帖，快来抢沙发～" andTitFrame:CGRectMake(0, self.tableView.tableHeaderView.height + 16, RBScreenWidth, 36)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        if (self.dataArr.count == 0) {
            return cell;
        }
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        headView.frame = CGRectMake(0, 0, RBScreenWidth, 46);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 18, 100, 20)];
        self.titleLabel = titleLabel;
        NSString *str = [NSString stringWithFormat:@"全部回复 %lu", (unsigned long)self.huiFuModel.Comnum];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"] } range:NSMakeRange(0, 4)];
        [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#9E9E9E"] } range:NSMakeRange(4, str.length - 4)];
        titleLabel.attributedText = attr;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        [headView addSubview:titleLabel];
        [cell.contentView addSubview:headView];
        return cell;
    } else {
        RBHuaTiHuiFuCell *cell = [RBHuaTiHuiFuCell createCellByTableView:tableView andClickCellCloseBtn:^(RBHuaTiHuiFuModel *_Nonnull huiFuModel) {
        }];
        RBHuaTiHuiFuModel *huaTihuiFuModel = self.dataArr[indexPath.row];
        huaTihuiFuModel.index = (int)indexPath.row + 1;
        cell.huaTiHuiFuModel = huaTihuiFuModel;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.dataArr.count == 0) {
            return 0;
        } else {
            return 46;
        }
    } else {
        RBHuaTiHuiFuModel *huiFuModel = self.dataArr[indexPath.row];
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
            return size.height + 70 + currentH + 17;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
