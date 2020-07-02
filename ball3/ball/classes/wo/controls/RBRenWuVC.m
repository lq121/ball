#import "RBRenWuVC.h"
#import "RBAniProgress.h"
#import "RBRenWuModel.h"
#import "RBWKWebView.h"
#import "RBNetworkTool.h"
#import "WXApi.h"
#import "RBToast.h"
#import "RBFenXiangView.h"
#import "RBRenWuCell.h"

@interface RBRenWuVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *whiteVeiw;
@property (nonatomic, strong) RBAniProgress *pv2;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *headView;
@end

@implementation RBRenWuVC

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, RBStatusBarH, 40, 40)];
    backBtn.tag = 1010;
    self.backBtn = backBtn;
    [backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:backBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backBtn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日任务";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self getData];
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, RBScreenWidth, 115 + 247);
    headView.hidden = YES;
    self.tableView.tableHeaderView = headView;
    [self setupheadView];
    NSArray *imgs = @[@"sign", @"vidio", @"share", @"pinglun", @"xiaofei", @"shiming", @"vip"];
    int time = self.vipst;
    int vip = self.vip;
    NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setMonth:vip];
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:createTime options:0];
    NSDate *now = [NSDate date];
    NSCalendar *calend = [NSCalendar currentCalendar];
    NSDateComponents *delta = [calend components:NSCalendarUnitWeekOfMonth | NSCalendarUnitYear fromDate:now toDate:calculatedate options:0];
    NSArray *tips;
    if ([delta month] >= 0 && [delta year] >= 0) {
        tips = @[@"每日签到", @"观看视频", @"每日分享", @"讨论区发表话题或留言", @"消费预测", @"实名认证", @"本月已充值去续费"];
    } else {
        tips = @[@"每日签到", @"观看视频", @"每日分享", @"讨论区发表话题或留言", @"消费预测", @"实名认证", @"会员充值"];
    }
    NSArray *btnTitiles = @[@"去签到", @"去观看", @"去分享", @"去评论", @"去消费", @"去认证", @"去充值"];
    NSArray *Ids = @[@(3), @(1), @(4), @(5), @(7), @(6), @(8)];
    for (int i = 0; i < imgs.count; i++) {
        RBRenWuModel *model = [[RBRenWuModel alloc]init];
        model.imageName = imgs[i];
        model.tip = tips[i];
        model.Id = [Ids[i]intValue];
        model.btnTitle = btnTitiles[i];
        [self.dataArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)setupheadView {
    UIView *headView = [[UIView alloc]init];
    self.headView = headView;
    UIImageView *Bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"renwu bg"]];
    [headView addSubview:Bg];
    Bg.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, 136 + RBStatusBarH * 2);
    if (RB_iphone) {
        Bg.height = 136 + RBStatusBarH * 2 - 24;
    }

    UILabel *title = [[UILabel alloc]init];
    title.text = @"每日任务";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    title.font = [UIFont systemFontOfSize:22];
    [headView addSubview:title];
    title.frame = CGRectMake(50, RBStatusBarH + 7, RBScreenWidth - 100, 30);

    UILabel *desLab = [[UILabel alloc]init];
    desLab.text = @"每日完成如下任务，可获得更多奖励";
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.textColor = [UIColor whiteColor];
    desLab.font = [UIFont systemFontOfSize:14];
    [headView addSubview:desLab];
    desLab.frame = CGRectMake(50, CGRectGetMaxY(title.frame) + 8, RBScreenWidth - 100, 18);

    headView.frame = CGRectMake(0, 0, RBScreenWidth, 364 + RBStatusBarH);
    UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(8, 115 + RBStatusBarH, RBScreenWidth - 16, 247)];
    if (RB_iphone) {
        whiteVeiw.y = 115 + RBStatusBarH - 24;
    }
    self.whiteVeiw = whiteVeiw;
    whiteVeiw.backgroundColor = [UIColor whiteColor];
    whiteVeiw.layer.cornerRadius = 4;
    whiteVeiw.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    whiteVeiw.layer.shadowOffset = CGSizeMake(0, 2);
    whiteVeiw.layer.shadowOpacity = 1;
    whiteVeiw.layer.shadowRadius = 10;
    [headView addSubview:whiteVeiw];

    CGSize size = [@"邀请好友" getLineSizeWithFont:[UIFont boldSystemFontOfSize:20]];
    CGFloat x = (RBScreenWidth - (size.width + 50)) * 0.5;
    UIImageView *icon1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuangshi"]];
    [whiteVeiw addSubview:icon1];
    icon1.frame = CGRectMake(x, 22, 13, 10);

    UILabel *topupLabel = [[UILabel alloc]init];
    topupLabel.text = @"邀请好友";
    topupLabel.textAlignment = NSTextAlignmentCenter;
    topupLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    topupLabel.font = [UIFont boldSystemFontOfSize:20];
    topupLabel.frame = CGRectMake(CGRectGetMaxX(icon1.frame) + 4, 16, size.width, size.height);
    [whiteVeiw addSubview:topupLabel];

    CGSize size2 = [@"得金币" getLineSizeWithFont:[UIFont boldSystemFontOfSize:16]];
    UILabel *topupLabel2 = [[UILabel alloc]init];
    topupLabel2.text = @"得金币";
    topupLabel2.textAlignment = NSTextAlignmentCenter;
    topupLabel2.textColor = [UIColor colorWithSexadeString:@"#333333"];
    topupLabel2.font = [UIFont boldSystemFontOfSize:16];
    topupLabel2.frame = CGRectMake(CGRectGetMaxX(icon1.frame) + 4, CGRectGetMaxY(topupLabel.frame), size.width, size2.height);
    [whiteVeiw addSubview:topupLabel2];

    UIImageView *icon2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhuangshi"]];
    [whiteVeiw addSubview:icon2];
    icon2.frame = CGRectMake(CGRectGetMaxX(topupLabel.frame) + 4, 22, 13, 10);

    UIButton *whatBtn = [[UIButton alloc]init];
    whatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    [whatBtn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    whatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    whatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [whatBtn setBackgroundImage:[UIImage imageNamed:@"rule"] forState:UIControlStateNormal];
    [whatBtn setTitle:@"规则" forState:UIControlStateNormal];
    whatBtn.frame = CGRectMake(RBScreenWidth - 16 - 56, 14, 56, 24);
    [whatBtn addTarget:self action:@selector(clickWhatBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteVeiw addSubview:whatBtn];

    NSArray *coins = @[@10, @20, @30, @50, @80];
    NSArray *numbers = @[@1, @5, @10, @15, @20];

    RBAniProgress *pv2 = [[RBAniProgress alloc] initWithFrame:CGRectMake(32, 102, RBScreenWidth - 16 - 64, 16)];
    self.pv2 = pv2;
    pv2.backgroundColor = [UIColor clearColor];
    pv2.layer.cornerRadius = 10;
    pv2.trackTintColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    pv2.progressTintColors = @[[UIColor colorWithSexadeString:@"#FA7268"], [UIColor colorWithSexadeString:@"#FA7268"]];
    pv2.nodeColor = [UIColor colorWithSexadeString:@"#E64F44"];
    pv2.hideStripes = YES;
    pv2.numberOfNodes = 5;
    pv2.hideAnnulus = YES;
    [pv2 setProgress:0 animated:NO];
    [whiteVeiw addSubview:pv2];

    CGFloat margin2 = (RBScreenWidth - 16 - 24 - 5 * 52) / 4;
    for (int i = 0; i < 5; i++) {
        UIButton *iconBtn = [[UIButton alloc]init];
        iconBtn.tag = 500 + i;
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"coin gift"] forState:UIControlStateNormal];
        [iconBtn setTitle:[NSString stringWithFormat:@"%d枚", [coins[i]intValue]] forState:UIControlStateNormal];
        iconBtn.frame = CGRectMake(12 + (52 + margin2) * i, 125, 46, 33);
        iconBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        iconBtn.titleEdgeInsets = UIEdgeInsetsMake(19, 0, 0, 0);
        [whiteVeiw addSubview:iconBtn];
    }

    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(29 + (110) * i, 82, 46, 33)];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"%d位", [numbers[i]intValue]];
        } else {
            label.text = [NSString stringWithFormat:@"累计%d位", [numbers[i]intValue]];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font =  [UIFont systemFontOfSize:12];
        [label sizeToFit];
        UIButton *iconBtn = [whiteVeiw viewWithTag:500 + i];
        label.centerX = iconBtn.centerX;
        [whiteVeiw addSubview:label];
    }

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 181, RBScreenWidth - 32, 48)];
    [checkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
    [checkBtn setTitle:@"去邀请" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.layer.masksToBounds = YES;
    checkBtn.layer.cornerRadius = 24;
    [whiteVeiw addSubview:checkBtn];
    self.tableView.tableHeaderView = headView;
}

- (void)clickWhatBtn {
    RBWKWebView *webVC = [[RBWKWebView alloc]init];
    webVC.title = @"如何邀请好友";
    webVC.url = @"hios/how-to-invite.html";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)getData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/gettaskinfo"andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        [self.tableView.mj_header endRefreshing];
        if (backData[@"err"] != nil) {
            return;
        }
        NSArray *form = backData[@"form"];
        NSArray *data = backData[@"data"];
        NSMutableArray *progressData = [NSMutableArray array];
        for (int i = 0; i < form.count; i++) {
            NSDictionary *dict = form[i];
            for (int k = 0; k < self.dataArr.count; k++) {
                RBRenWuModel *model = self.dataArr[k];
                if (model.Id == [dict[@"Id"] intValue]) {
                    model.Addcoin = [dict[@"Addcoin"]intValue];
                    model.Addexp = [dict[@"Addexp"]intValue];
                    model.Allnum = [dict[@"Allnum"]intValue];
                    model.Daynum = [dict[@"Daynum"]intValue];
                    model.Everytimerd = [dict[@"Everytimerd"]intValue];
                    self.dataArr[k] = model;
                    break;
                } else if ([dict[@"Id"]intValue] >= 9) {
                    RBRenWuModel *model = [[RBRenWuModel alloc]init];
                    model.Addcoin = [dict[@"Addcoin"]intValue];
                    model.Addexp = [dict[@"Addexp"]intValue];
                    model.Id = [dict[@"Id"]intValue];
                    model.Daynum = [dict[@"Daynum"]intValue];
                    model.Everytimerd = [dict[@"Everytimerd"]intValue];
                    [progressData addObject:model];
                    break;
                }
            }
        }

        for (int i = 0; i < data.count; i++) {
            NSDictionary *dict = data[i];
            if ([dict[@"Style"] intValue] >= 9) {
                for (int k = 0; k < progressData.count; k++) {
                    RBRenWuModel *model = progressData[k];
                    if (model.Id == [dict[@"Style"] intValue]) {
                        if (model.Daynum == -1) {
                            // 不是每日任务
                            model.Num = [dict[@"Num"]intValue];
                            progressData[k] = model;
                            break;
                        } else if ([[NSString getStrWithDate:[NSDate date] andFormat:@"yyyyMMdd"] isEqualToString:dict[@"Day"]]) {
                            model.Num = [dict[@"Num"]intValue];
                            progressData[k] = model;
                            break;
                        }
                        break;
                    }
                }
            } else {
                for (int k = 0; k < self.dataArr.count; k++) {
                    RBRenWuModel *model = self.dataArr[k];
                    if (model.Id == [dict[@"Style"] intValue]) {
                        if (model.Daynum == -1) {
                            // 不是每日任务
                            model.Num = [dict[@"Num"]intValue];
                            self.dataArr[k] = model;
                            break;
                        } else if ([[NSString getStrWithDate:[NSDate date] andFormat:@"yyyyMMdd"] isEqualToString:dict[@"Day"]]) {
                            model.Num = [dict[@"Num"]intValue];
                            self.dataArr[k] = model;
                            break;
                        }

                        break;
                    }
                }
            }
        }

        for (int j = 0; j < progressData.count; j++) {
            RBRenWuModel *model = progressData[j];
            UIButton *btn1 = [self.whiteVeiw viewWithTag:400 + j];
            btn1.selected = model.Daynum <= model.Num;
            UILabel *label = [btn1 viewWithTag:1000];
            label.text = @"完成";
            [label sizeToFit];
            UIButton *btn2 = [self.whiteVeiw viewWithTag:500 + j];
            if (model.Daynum <= model.Num) {
                label.centerX = btn2.centerX;
            }
            if (j == progressData.count - 1) {
                [self.pv2 setProgress:model.Num / (model.Daynum * 1.0)];
            }
        }
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)clickBackBtn {
    [self.backBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCheckBtn {
    if (![WXApi isWXAppSupportApi]) {
        [RBToast showWithTitle:@"请先安装微信客户端再邀请朋友" andY:RBScreenHeight * 0.5];
    } else {
        __block RBRenWuVC *weakSelf = self;
        RBFenXiangView *fenXiangView = [[RBFenXiangView alloc]initWithCopy:YES andClickItem:^(NSInteger index) {
            weakSelf.index = (int)index;
            [weakSelf getShareUrl];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:fenXiangView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBRenWuCell *cell = [RBRenWuCell createCellByTableView:tableView];
    if (indexPath.section == 1) {
        cell.renWuModel = self.dataArr[indexPath.row + 4];
    } else {
        cell.renWuModel = self.dataArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    } else {
        return 54;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *grayView = [[UIView alloc]init];
    if (section == 0) {
        grayView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        grayView.frame = CGRectMake(0, 0, RBScreenWidth, 30);
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"更多任务";
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.frame = CGRectMake(16, 0, 80, 22);
        [grayView addSubview:label];
    } else {
        grayView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        grayView.frame = CGRectMake(0, 0, RBScreenWidth, 54);
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"其他任务";
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.frame = CGRectMake(16, 26, 80, 22);
        [grayView addSubview:label];
    }
    return grayView;
}

//生成二维码
- (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //给过滤器添加数据<字符串长度893>
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    //获取二维码过滤器生成二维码
    CIImage *image = [filter outputImage];
    UIImage *img = [self createNonInterpolatedUIImageFromCIImage:image WithSize:size];
    return img;
}

//二维码清晰
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image WithSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));

    //创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGColorSpaceRelease(cs);
    CGImageRelease(bitmapImage);
    UIImage *codeimage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return codeimage;
}

- (void)getShareUrl {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getuseurl"andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        self.url = backData[@"ok"][@"web"];
        [self shareImageWithType:self.index andImage:[self createShareView]];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (UIImage *)createShareView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    bgView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIImageView *BG = [[UIImageView alloc]initWithFrame:CGRectMake(16, (RBScreenHeight - 407) * 0.5, RBScreenWidth - 32, 121)];
    [bgView addSubview:BG];
    BG.image = [UIImage imageNamed:@"shareDownBG"];

    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, RBScreenWidth - 64,  [@"小应体育App\n有你感兴趣的内容" getSizeWithFont:[UIFont boldSystemFontOfSize:20] andMaxWidth:RBScreenWidth - 64].height)];
    tip.text = @"小应体育 App\n有你感兴趣的内容";
    tip.numberOfLines = 0;
    tip.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont boldSystemFontOfSize:20];
    [BG addSubview:tip];

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(BG.frame), RBScreenWidth - 32, 286)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];

    UIView *codeView = [[UIView alloc]initWithFrame:CGRectMake((RBScreenWidth - 148) * 0.5, (RBScreenHeight - 407) * 0.5 + 84, 148, 148)];
    UIImageView *codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 140, 140)];
    codeImage.image = [self generateQRCodeWithString:self.url Size:140];
    [bgView addSubview:codeView];
    [codeView addSubview:codeImage];

    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(codeView.frame) + 4, RBScreenWidth - 32, 17)];
    tip2.text = @"长按二维码，下载客户端";
    tip2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    tip2.textAlignment = NSTextAlignmentCenter;
    tip2.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:tip2];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 152, RBScreenWidth - 64, 1)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F2F2F2"];
    [whiteView addSubview:line];

    UILabel *tip1Lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 13, RBScreenWidth - 32, 25)];
    tip1Lab1.text = @"- 邀请码 -";
    tip1Lab1.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tip1Lab1.textAlignment = NSTextAlignmentCenter;
    tip1Lab1.font = [UIFont systemFontOfSize:18];
    [whiteView addSubview:tip1Lab1];

    UILabel *tip1Lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tip1Lab1.frame) + 2, RBScreenWidth - 32, 17)];
    tip1Lab2.text = @"新用户注册填写邀请码可获得奖励";
    tip1Lab2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    tip1Lab2.textAlignment = NSTextAlignmentCenter;
    tip1Lab2.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:tip1Lab2];
    CGFloat margin = (RBScreenWidth - 32 - 112 - 6 * 32) / 5;
    for (int i = 0; i < self.Yqcode.length; i++) {
        NSString *c = [self.Yqcode substringWithRange:NSMakeRange(i, 1)];
        UILabel *label = [[UILabel alloc]init];
        label.text = c;
        label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.04];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font = [UIFont systemFontOfSize:22];
        label.frame = CGRectMake(56 + (32 + margin) * i, CGRectGetMaxY(tip1Lab2.frame) + 24, 32, 40);
        [whiteView addSubview:label];
    }
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

- (void)shareImageWithType:(int)type andImage:(UIImage *)image {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"needShow" object:[NSNumber numberWithBool:NO]];
        NSData *imageData = UIImagePNGRepresentation(image);
        WXImageObject *ext = [WXImageObject object];
        // 小于10MB
        ext.imageData = imageData;
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = ext;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        if (type == 1) {
            req.scene = WXSceneSession;
        } else {
            req.scene = WXSceneTimeline;
        }
        req.message = message;
        [WXApi sendReq:req completion:^(BOOL success) {
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat placeHolderHeight =  230 + 30 + RBStatusBarH;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= placeHolderHeight) {
        self.tableView.contentOffset = CGPointMake(0, placeHolderHeight);
    } else {
        self.tableView.contentOffset = CGPointMake(0, offsetY);
    }
    if (offsetY > 136) {
        self.navigationController.navigationBarHidden = NO;
        self.backBtn.hidden = YES;
    } else {
        self.navigationController.navigationBarHidden = YES;
        self.backBtn.hidden = NO;
    }
}

@end
