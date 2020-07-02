#import "RBHuaTiDetailVC.h"
#import "RBHuaTiHuiFuModel.h"
#import "RBNetworkTool.h"
#import "RBChekLogin.h"
#import "RBToast.h"
#import "RBTipView.h"
#import "KNPhotoBrowser.h"
#import "RBHuaTiHuiFuCell.h"
#import "RBHuiFuVC.h"

@interface RBHuaTiDetailVC ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *chatToolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL btn2Selected;
@property (nonatomic, strong) NSMutableArray *itemsArr;

@end

@implementation RBHuaTiDetailVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.huaTiModel != nil) {
        self.currentPage = 0;
        [self getDataWithLzUid:NO];
    }
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"足球话题讨论区";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self setupTableView];

    [self setupChatToolBar];
    if (self.huaTiModel == nil && self.huaTiId != 0) {
        [self gethuaTiDes];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 获取单个话题
- (void)gethuaTiDes {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huaTiId) forKey:@"id"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/gethuatibyid" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            self.huaTiModel = [RBHuaTiModel mj_objectWithKeyValues:backData[@"ok"]];
            [self setupHeadView];
            self.currentPage = 0;
            [self getDataWithLzUid:NO];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH  - 49);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self.view addSubview:tableView];
    [self setupHeadView];
}

- (void)setupChatToolBar {
    UIView *chatToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH  - 49, RBScreenWidth, 49)];
    self.chatToolBar = chatToolBar;
    chatToolBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    chatToolBar.layer.shadowOffset = CGSizeMake(0, -2);
    chatToolBar.layer.shadowOpacity = 1;
    chatToolBar.layer.shadowRadius = 4;
    chatToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chatToolBar];

    if (self.huaTiModel.Clock == 1) {
        UIButton *btn = [[UIButton alloc]init];
        btn.enabled = NO;
        btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [btn setTitle:@"该帖已锁定，暂不能回复" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#8B8B8B"] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.backgroundColor = [UIColor colorWithSexadeString:@"#E4E4E4"];
        btn.frame = CGRectMake(16, 9, RBScreenWidth - 66 - 32, 32);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 16;
        [chatToolBar addSubview:btn];

        UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 16, 0, 50, 49)];
        sendBtn.enabled = NO;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithSexadeString:@"#8B8B8B"] forState:UIControlStateDisabled];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [chatToolBar addSubview:sendBtn];
    } else {
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
    }
}

- (void)clickSendBtn {
    if ([RBChekLogin CheckLogin]) {
        return;
    }
    if ([RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"commentlv" andNeedCheck:YES]) {
        return;
    }
    if (self.textField.text.length <= 0) {
        [RBToast showWithTitle:@"请输入回复内容"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huaTiModel.Id) forKey:@"huatiid"];
    [dict setValue:self.textField.text forKey:@"txt"];
    [dict setValue:@(-1) forKey:@"commentid"];
    [dict setValue:@(0) forKey:@"zan"];
    [dict setValue:self.huaTiModel.Uid forKey:@"huatihuid"];

    [RBNetworkTool PostDataWithUrlStr:@"apis/huaticomment" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"commentlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            self.textField.text = nil;
            [self.textField resignFirstResponder];
            [RBTipView tipWithTitle:@"评论成功" andExp:[backData[@"addexp"] intValue] andCoin:[backData[@"addcoin"] intValue] andY:150];
            [self getDataWithLzUid:NO];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setupHeadView {
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *useHead = [[UIImageView alloc]init];
    useHead.image = [UIImage imageNamed:@"user pic"];
    useHead.frame = CGRectMake(8, 16, 32, 32);
    useHead.layer.masksToBounds = YES;
    useHead.layer.cornerRadius = 16;
    [headView addSubview:useHead];

    UILabel *userName = [[UILabel alloc]init];
    userName.font = [UIFont systemFontOfSize:14];
    userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
    userName.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:userName];

    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = [UIFont systemFontOfSize:10];
    timeLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
    timeLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:timeLab];

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

    UILabel *lvLab = [[UILabel alloc]init];
    lvLab.layer.cornerRadius = 2;
    lvLab.layer.masksToBounds = true;
    lvLab.textAlignment = NSTextAlignmentCenter;
    lvLab.textColor = [UIColor whiteColor];
    lvLab.font = [UIFont systemFontOfSize:10];
    [headView addSubview:lvLab];
    
    UILabel *jingLab = [[UILabel alloc]init];
    jingLab.textColor = [UIColor whiteColor];
    jingLab.text = @"精";
    jingLab.textAlignment = NSTextAlignmentCenter;
    jingLab.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
    jingLab.layer.masksToBounds = YES;
    jingLab.layer.cornerRadius = 2;
    jingLab.font = [UIFont systemFontOfSize:10];
    [headView addSubview:jingLab];

    UILabel *dingLab = [[UILabel alloc]init];
    dingLab.text = @"顶";
    dingLab.layer.masksToBounds = YES;
    dingLab.layer.cornerRadius = 2;
    dingLab.textColor = [UIColor whiteColor];
    dingLab.textAlignment = NSTextAlignmentCenter;
    dingLab.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
    dingLab.font = [UIFont systemFontOfSize:10];
    [headView addSubview:dingLab];
    

    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLab];

    UILabel *desLab = [[UILabel alloc]init];
    desLab.numberOfLines = 0;
    desLab.font = [UIFont systemFontOfSize:14];
    desLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
    desLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:desLab];

    if (self.huaTiModel.Avatar.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:self.huaTiModel.Avatar options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                useHead.image = image;
            } else {
                [useHead sd_setImageWithURL:[NSURL URLWithString:self.huaTiModel.Avatar ] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:self.huaTiModel.Avatar cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                }];
            }
        }];
    }else {
        if ([self.huaTiModel.Uid isEqualToString:@"fangguan"]) {
            useHead.image = [UIImage imageNamed:@"qidong logo"];
        } else {
            useHead.image = [UIImage imageNamed:@"user pic"];
        }
    }
    userName.text = self.huaTiModel.Username;
    CGSize size = [self.huaTiModel.Username getLineSizeWithFontSize:14];
    userName.frame = CGRectMake(CGRectGetMaxX(useHead.frame) + 8, useHead.y, size.width, 14);
    orgIcon.frame = CGRectMake(CGRectGetMaxX(userName.frame), useHead.y-2, 35, 16);
    vipIcon.frame = CGRectMake(CGRectGetMaxX(userName.frame), useHead.y-2, 35, 16);
    orgIcon.hidden = ![self.huaTiModel.Uid isEqualToString:@"fangguan"];
    if (self.huaTiModel.Vip <= 0) {
        vipIcon.hidden = YES;
        userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        lvLab.frame = CGRectMake(CGRectGetMaxX(userName.frame) + 4, useHead.y, 32, 14);
    } else {
        vipIcon.hidden = NO;
        userName.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        lvLab.frame = CGRectMake(CGRectGetMaxX(vipIcon.frame) + 4, useHead.y, 32, 14);
    }
    if ([self.huaTiModel.Uid isEqualToString:@"fangguan"]) {
        if (self.huaTiModel.Jing == 1) {
            jingLab.frame = CGRectMake(CGRectGetMaxX(orgIcon.frame) + 4, useHead.y, 22, 14);
            dingLab.frame = CGRectMake(CGRectGetMaxX(jingLab.frame) + 4, useHead.y, 22, 14);
        } else {
            jingLab.frame = CGRectMake(CGRectGetMaxX(orgIcon.frame) + 4, useHead.y, 0, 14);
            dingLab.frame = CGRectMake(CGRectGetMaxX(orgIcon.frame) + 4, useHead.y, 22, 14);
        }
    }else{
        if (self.huaTiModel.Jing == 1) {
            jingLab.frame = CGRectMake(CGRectGetMaxX(lvLab.frame) + 4, useHead.y, 22, 14);
            dingLab.frame = CGRectMake(CGRectGetMaxX(jingLab.frame) + 4, useHead.y, 22, 14);
        } else {
            jingLab.frame = CGRectMake(CGRectGetMaxX(lvLab.frame) + 4, useHead.y, 0, 14);
            dingLab.frame = CGRectMake(CGRectGetMaxX(lvLab.frame) + 4, useHead.y, 22, 14);
        }
    }
    jingLab.hidden = (self.huaTiModel.Jing != 1);
    dingLab.hidden = (self.huaTiModel.Ding != 1);
    
    lvLab.text = [NSString stringWithFormat:@"Lv%d", self.huaTiModel.Lv];
    lvLab.hidden = [self.huaTiModel.Uid isEqualToString:@"fangguan"];
    timeLab.text = [NSString getStrWithDateInt:self.huaTiModel.Createt andFormat:@"MM月dd日 HH:mm"];
    timeLab.frame = CGRectMake(CGRectGetMaxX(useHead.frame) + 8, 32, 120, 10);
    [timeLab sizeToFit];
    if (self.huaTiModel.Lv < 10) {
        lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
    } else if (self.huaTiModel.Lv < 20) {
        lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
    } else if (self.huaTiModel.Lv < 30) {
        lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#98D1B2"];
    } else if (self.huaTiModel.Lv < 40) {
        lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFC57F"];
    } else {
        lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF9D95"];
    }
    titleLab.text = self.huaTiModel.Title;
    titleLab.frame = CGRectMake(16, CGRectGetMaxY(useHead.frame) + 12, RBScreenWidth - 32, 22);
    desLab.text = self.huaTiModel.Txt;
    CGSize size2 = [self.huaTiModel.Txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32];
    desLab.frame = CGRectMake(16, CGRectGetMaxY(titleLab.frame) + 2, RBScreenWidth - 32, size2.height);
    CGFloat height = 0;
    if (self.huaTiModel.Img.length != 0) {
        self.itemsArr = [NSMutableArray array];
        UIView *iconsView = [[UIView alloc]init];
        [headView addSubview:iconsView];
        iconsView.hidden = NO;
        CGFloat width = 109;
        NSData *jsonData = nil;
        NSError *err;
        jsonData = [self.huaTiModel.Img dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        for (int i = 0; i < arr.count; i++) {
             __block NSString *str = arr[i];
            UIImageView *icon = [[UIImageView alloc]init];
            icon.frame = CGRectMake( (i % 3) * (width + 4), (i / 3) * (width + 4), width, width);
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager.imageCache queryImageForKey:str options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
                if (image != nil) {
                    icon.image = [image cutImageWithSize:icon.size];
                } else {
                    str = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,h_109,w_109,limit_0",str];
                    [icon sd_setImageWithURL:[NSURL URLWithString:str ] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo pic"  andFrame: icon.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                        if (image != nil) {
                            [manager.imageCache storeImage:image imageData:nil forKey:str cacheType:SDImageCacheTypeDisk completion:nil];
                            icon.image = [image cutImageWithSize:icon.size];
                        }
                    }];
                }
            }];
            icon.tag = i;
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
            icon.userInteractionEnabled = YES;
            icon.layer.masksToBounds = YES;
            icon.layer.cornerRadius = 4;
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
              items.url = arr[i];
            items.sourceView = icon;
            [self.itemsArr addObject:items];
            [iconsView addSubview:icon];
        }

        if (arr.count % 3 > 0) {
            height += (width + 4);
        }
        height += (((arr.count) / 3) * (width + 4));
        iconsView.frame = CGRectMake(16, CGRectGetMaxY(desLab.frame) + 12, RBScreenWidth - 32, height);
        headView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(iconsView.frame) + 16);
    } else {
        headView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(desLab.frame) + 16);
    }
    self.tableView.tableHeaderView = headView;
}

- (void)getDataWithLzUid:(BOOL)needUid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (needUid) {
        [dict setValue:self.huaTiModel.Uid forKey:@"lzuid"];
    }
    [dict setValue:@(self.currentPage) forKey:@"p"];
    [dict setValue:@(1) forKey:@"cid"];
    [dict setValue:@(self.huaTiModel.Id) forKey:@"huatiid"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:uid forKey:@"uid"];
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getcomment"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        if (self.currentPage == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        NSMutableArray *nextArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            RBHuaTiHuiFuModel *huaTiModel = arr[i];
            if ([huaTiModel.Hfid intValue] == -1) {
                if (self.dataArr.count != 0 && nextArr.count != 0) {
                    // 设置二级评论
                    RBHuaTiHuiFuModel *lastModel = self.dataArr[self.dataArr.count - 1];
                    lastModel.secondArr = [NSArray arrayWithArray:nextArr];
                    lastModel.LzUid = self.huaTiModel.Uid;
                    [nextArr removeAllObjects];
                    self.dataArr[self.dataArr.count - 1] = lastModel;    // 防止第一条评论已加入但是还没有加入二级评论
                }
                [self.dataArr addObject:huaTiModel];
            } else {
                [nextArr addObject:huaTiModel];
            }
        }
        if (nextArr.count != 0 && self.dataArr.count != 0) {
            // 防止只有一条评论
            RBHuaTiHuiFuModel *lastModel = self.dataArr[self.dataArr.count - 1];
            lastModel.secondArr = [NSArray arrayWithArray:nextArr];
            lastModel.LzUid = self.huaTiModel.Uid;
            [nextArr removeAllObjects];
        }
        [self.tableView showDataCount:self.dataArr.count andTitle:@"还没有回帖，快来抢沙发～" andTitFrame:CGRectMake(0, self.tableView.tableHeaderView.height + 16 + 46, RBScreenWidth, 36)];
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}



- (void)imageViewIBAction:(UITapGestureRecognizer *)tap {
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.isNeedPageControl = true;
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = NO;
    photoBrowser.isNeedPictureLongPress = true;
    [photoBrowser present];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - keyboardFrame.size.height - 49 - RBNavBarAndStatusBarH;
    }];
}

#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatToolBar.y = RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH  - 49;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickSendBtn];
    return YES;
}

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
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        headView.frame = CGRectMake(0, 0, RBScreenWidth, 46);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 18, 100, 20)];
        self.titleLabel = titleLabel;
        NSString *str = [NSString stringWithFormat:@"全部回复 %lu", (unsigned long)self.huaTiModel.Comment];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"] } range:NSMakeRange(0, 4)];
        [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#9E9E9E"] } range:NSMakeRange(4, str.length - 4)];
        titleLabel.attributedText = attr;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        [headView addSubview:titleLabel];

        UIButton *btn2 = [[UIButton alloc]init];
        btn2.selected = self.btn2Selected;
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn2 setTitle:@"只看楼主" forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E3E3E3"]] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateSelected];
        btn2.layer.masksToBounds = YES;
        btn2.layer.cornerRadius = 11;
        [headView addSubview:btn2];
        btn2.frame = CGRectMake(RBScreenWidth - 80, 16, 64, 22);
        [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:headView];
        return cell;
    } else {
      __weak typeof(self) weakSelf = self;
        RBHuaTiHuiFuCell *cell = [RBHuaTiHuiFuCell createCellByTableView:tableView andClickCellCloseBtn:^(RBHuaTiHuiFuModel * _Nonnull huaTiHuiFUModel) {
            [weakSelf getDataWithhuaTiReplyModel:huaTiHuiFUModel andIndexPath:indexPath];
        }];
        RBHuaTiHuiFuModel *huaTiHuiFuModel = self.dataArr[indexPath.row];
        huaTiHuiFuModel.index = (int)indexPath.row + 1;
        cell.huaTiHuiFuModel = huaTiHuiFuModel;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (void)getDataWithhuaTiReplyModel:(RBHuaTiHuiFuModel* )huaTiReplyModel andIndexPath:(NSIndexPath*)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    int p = (int)huaTiReplyModel.secondArr.count / 10;
    [dict setValue:@(p) forKey:@"p"];
    [dict setValue:@(2) forKey:@"cid"];
    [dict setValue:@(huaTiReplyModel.Id) forKey:@"commentid"];
    NSString *str = @"try/go/getcomment";
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData == nil || backData[@"err"] != nil) {
            return;
        }
        NSArray *arr = [RBHuaTiHuiFuModel mj_objectArrayWithKeyValuesArray:backData[@"ok"]];
        NSMutableArray *second = [NSMutableArray arrayWithArray:huaTiReplyModel.secondArr];
        for (RBHuaTiHuiFuModel *model in arr) {
            model.canRep = -1;
            [second addObject:model];
            huaTiReplyModel.secondArr = second;
        }
        self.dataArr[indexPath.row] =huaTiReplyModel;
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 46;
    } else {
        RBHuaTiHuiFuModel *huaTiHuiFuModel = self.dataArr[indexPath.row];
        CGSize size = [huaTiHuiFuModel.Hftxt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 72];
        if (huaTiHuiFuModel.secondArr == nil || huaTiHuiFuModel.secondArr.count == 0) {
            return size.height + 70;
        } else {
            CGFloat currentH = 0;
            for (int i = 0; i < huaTiHuiFuModel.secondArr.count; i++) {
                RBHuaTiHuiFuModel *model = huaTiHuiFuModel.secondArr[i];
                NSString *str = [NSString stringWithFormat:@"%@:%@", model.Hfname, model.Hftxt];
                CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 88];
                currentH += size.height;
            }
            if (huaTiHuiFuModel.secondArr.count < huaTiHuiFuModel.Comnum) {
                 return size.height + 100 + currentH + 17;
            }else{
                return size.height + 70 + currentH + 17;
            }
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RBHuiFuVC *huiFuVC = [[RBHuiFuVC alloc]init];
    huiFuVC.huiFuModel = self.dataArr[indexPath.row];
    huiFuVC.title = [NSString stringWithFormat:@"%ld楼回复", (long)indexPath.row+1];
    [self.navigationController pushViewController:huiFuVC animated:YES];
}

- (void)clickBtn1:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)clickBtn2:(UIButton *)btn {
    self.btn2Selected = !self.btn2Selected;
    self.currentPage = 0;
    [self getDataWithLzUid:self.btn2Selected];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
