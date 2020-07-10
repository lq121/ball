#import "RBXinWenDetailTabVC.h"
#import "RBXinwenDetailModel.h"
#import "RBCommButton.h"
#import "WXApi.h"
#import "RBToast.h"
#import "RBNetworkTool.h"
#import "RBXinWenListTabVC.h"

@interface RBXinWenDetailTabVC ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *titleView1;
@property (nonatomic, strong) UIView *titleView2;
@property (nonatomic, assign) int index;
@end

@implementation RBXinWenDetailTabVC

- (UIView *)titleView1 {
    if (_titleView1 == nil) {
        _titleView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 77, 20)];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xinwenIcon1"]];
        icon.frame = _titleView1.bounds;
        [_titleView1 addSubview:icon];
    }
    return _titleView1;
}

- (UIView *)titleView2 {
    if (_titleView2 == nil) {
        _titleView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 101, 28)];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xinwenIcon2"]];
        icon.frame = _titleView2.bounds;
        [_titleView2 addSubview:icon];
    }
    return _titleView2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor colorWithSexadeString:@"#F8F8F8"]];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleView1;
    //消除阴影
    [self.dataArr removeAllObjects];
    if (self.xinWenModel.detailPag.count > self.xinWenModel.detailImg.count) {
        // 文字多于图片
        for (int i = 0; i < self.xinWenModel.detailPag.count; i++) {
            RBXinwenDetailModel *model = [[RBXinwenDetailModel alloc]init];
            model.title = self.xinWenModel.detailPag[i];
            model.status = 1;
            [self.dataArr addObject:model];
        }
        for (int j = 0; j < self.xinWenModel.detailImg.count; j++) {
            RBXinwenDetailModel *model = [[RBXinwenDetailModel alloc]init];
            model.img = self.xinWenModel.detailImg[j];
            model.status = 2;
            [self.dataArr insertObject:model atIndex:(2 * j)];
        }
    } else {
        // 图片多于文字
        for (int i = 0; i < self.xinWenModel.detailImg.count; i++) {
            RBXinwenDetailModel *model = [[RBXinwenDetailModel alloc]init];
            model.img = self.xinWenModel.detailImg[i];
            [self.dataArr addObject:model];
            model.status = 2;
        }
        for (int j = 0; j < self.xinWenModel.detailPag.count; j++) {
            RBXinwenDetailModel *model = [[RBXinwenDetailModel alloc]init];
            model.title = self.xinWenModel.detailPag[j];
            model.status = 1;
            [self.dataArr insertObject:model atIndex:2 * j + 1];
        }
    }

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 160)];
    view.backgroundColor =  [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 45)];
    topView.backgroundColor = [UIColor whiteColor];
    [view addSubview:topView];

    UILabel *readLabel = [[UILabel alloc]init];
    readLabel.textAlignment = NSTextAlignmentLeft;
    readLabel.font = [UIFont boldSystemFontOfSize:12];
    readLabel.frame = CGRectMake(16, 16, 100, 17);
    readLabel.text = [NSString stringWithFormat:@"%d 阅读 ", self.xinWenModel.readnum];
    readLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    [topView addSubview:readLabel];

    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.font = [UIFont boldSystemFontOfSize:12];
    timeLabel.frame = CGRectMake(RBScreenWidth - 116, 16, 100, 17);
    timeLabel.text = [NSString getTimeWithTimeTamp:self.xinWenModel.createt];
    timeLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    [topView addSubview:timeLabel];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 45, RBScreenWidth, 46)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击查看更多资讯" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:btn];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, RBScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [view addSubview:line];

    UIView *shearView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, RBScreenWidth, 60)];

    shearView.backgroundColor = [UIColor whiteColor];
    [view addSubview:shearView];

    UILabel *label = [[UILabel alloc]init];
    label.text = fenxiang;
    label.font = [UIFont systemFontOfSize:16];
    label.frame = CGRectMake(16, 19, 32, 22);
    [label sizeToFit];
    [shearView addSubview:label];

    CGFloat margin = (RBScreenWidth - 159 - 55 * 3) * 0.5;
    RBCommButton *WXBtn = [[RBCommButton alloc] initWithImage:@"wx2" andHeighImage:@"wx2" andFrame:CGRectMake(123, 8, 55, 47) andTitle:weixinhaoyou andTarget:self andAction:@selector(clickBtn:) andLabelFontSize:12];
    WXBtn.tag = 1;
    [shearView addSubview:WXBtn];
    RBCommButton *wFriendsBtn = [[RBCommButton alloc] initWithImage:@"quan2" andHeighImage:@"quan2" andFrame:CGRectMake(CGRectGetMaxX(WXBtn.frame) + margin, 8,  55, 47) andTitle:pengyouquan andTarget:self andAction:@selector(clickBtn:) andLabelFontSize:12];
    wFriendsBtn.tag = 2;
    [shearView addSubview:wFriendsBtn];
    RBCommButton *copyBtn = [[RBCommButton alloc] initWithImage:@"link2" andHeighImage:@"link2" andFrame:CGRectMake(CGRectGetMaxX(wFriendsBtn.frame) + margin, 8,  55, 47) andTitle:fuzhilianjie andTarget:self andAction:@selector(clickBtn:) andLabelFontSize:12];
    copyBtn.tag = 3;
    [shearView addSubview:copyBtn];
    if (![WXApi isWXAppInstalled]) {
        shearView.hidden = YES;
        view.height = 100;
    }
    self.tableView.tableFooterView = view;
}

- (void)clickBtn:(UIButton *)btn {
    self.index = (int)btn.tag;
    if (self.index == 3) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"http://test.Youtoball.com:8080/download";
        [RBToast showWithTitle:yifuzhi];
    } else {
        [self shareurlWithType:self.index];
    }
}

- (void)shareurlWithType:(int)type {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [MBProgressHUD showLoading:jiazhaizhong toView:self.view];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        if (uid != nil && ![uid isEqualToString:@""]) {
            [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
        }
        [RBNetworkTool PostDataWithUrlStr:@"try/go/weixinappshare"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"needShow" object:[NSNumber numberWithBool:NO]];
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = appName;
            message.description = self.xinWenModel.title;
            [message setThumbImage:[UIImage imageNamed:@"share logo"]];
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = BASEWEBURL;
            message.mediaObject = webpageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            if (type == 1) {
                req.scene = WXSceneSession;
            } else {
                req.scene = WXSceneTimeline;
            }
            [WXApi sendReq:req completion:^(BOOL success) {
            }];
        } Fail:^(NSError *_Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xinWenModel.detailImg.count + self.xinWenModel.detailPag.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *titLabel = [[UILabel alloc]init];
        titLabel.textAlignment = NSTextAlignmentLeft;
        titLabel.font = [UIFont boldSystemFontOfSize:26];
        titLabel.numberOfLines = 0;
        titLabel.frame = CGRectMake(16, 8, RBScreenWidth - 32, [self.xinWenModel.title getSizeWithFont:[UIFont boldSystemFontOfSize:26] andMaxWidth:RBScreenWidth - 32].height);
        titLabel.text = self.xinWenModel.title;
        titLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];

        UILabel *readLabel = [[UILabel alloc]init];
        readLabel.textAlignment = NSTextAlignmentLeft;
        readLabel.font = [UIFont boldSystemFontOfSize:12];
        readLabel.frame = CGRectMake(16, CGRectGetMaxY(titLabel.frame) + 16, 100, 17);
        readLabel.text = [NSString stringWithFormat:@"%d 阅读 ", self.xinWenModel.readnum];
        readLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [cell.contentView addSubview:readLabel];

        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont boldSystemFontOfSize:12];
        timeLabel.frame = CGRectMake(RBScreenWidth - 116, CGRectGetMaxY(titLabel.frame) + 16, 100, 17);
        timeLabel.text = [NSString getTimeWithTimeTamp:self.xinWenModel.createt];
        timeLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:titLabel];
    } else {
        RBXinwenDetailModel *model = self.dataArr[indexPath.row - 1];
        if (model.status == 1) {
            UILabel *desLabel = [[UILabel alloc]init];
            desLabel.textAlignment = NSTextAlignmentLeft;
            desLabel.font = [UIFont systemFontOfSize:18];
            desLabel.numberOfLines = 0;
            desLabel.text = model.title;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
            NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:6];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, model.title.length)];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.title length])];
            CGFloat contentHeight = [attributedString boundingRectWithSize:CGSizeMake(RBScreenWidth - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
            desLabel.frame = CGRectMake(16, 0, RBScreenWidth - 32, contentHeight);
            desLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
            [cell.contentView addSubview:desLabel];
        } else {
            UIImageView *icon = [[UIImageView alloc]init];
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = 5;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager.imageCache queryImageForKey:model.img options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
                if (image != nil) {
                    icon.image = image;
                    CGSize size = image.size;
                    if (size.width != 0 && size.height != 0) {
                        CGFloat scale = size.width / (RBScreenWidth - 32);
                        icon.frame = CGRectMake(16, 8, RBScreenWidth - 32, size.height / scale);
                        [cell.contentView addSubview:icon];
                    }
                } else {
                    CGSize size = [UIImage getOnlinePictureSizeWithUrl:model.img];
                    if (size.width != 0 && size.height != 0) {
                        CGFloat scale = size.width / (RBScreenWidth - 32);
                        icon.frame = CGRectMake(16, 8, RBScreenWidth - 32, size.height / scale);
                        [cell.contentView addSubview:icon];
                    }
                    [icon sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo pic" andFrame:icon.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                        if (image != nil) {
                            [manager.imageCache storeImage:image imageData:nil forKey:model.img cacheType:SDImageCacheTypeDisk completion:nil];
                        }
                    }];
                }
            }];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self.xinWenModel.title getSizeWithFontSize:26 andMaxWidth:RBScreenWidth - 32].height + 48;
    } else {
        RBXinwenDetailModel *model = self.dataArr[indexPath.row - 1];
        if (model.status == 1) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
            NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:6];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, model.title.length)];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.title length])];
            CGFloat contentHeight = [attributedString boundingRectWithSize:CGSizeMake(RBScreenWidth - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
            return contentHeight;
        } else {
            __block CGSize size = CGSizeZero;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager.imageCache queryImageForKey:model.img options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
                if (image != nil) {
                    size = image.size;
                }
            }];
            if (size.width == 0) {
                size = [UIImage getOnlinePictureSizeWithUrl:model.img];
            }
            if (size.width == 0) {
                return 0;
            }
            CGFloat scale = size.width / (RBScreenWidth - 32);
            return size.height / scale + 16;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 54;
}

- (void)clickBtn {
    if (self.canGoBack) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[UIViewController getCurrentVC].navigationController pushViewController:[[RBXinWenListTabVC alloc]init] animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > [self.xinWenModel.title getSizeWithFontSize:26 andMaxWidth:RBScreenWidth - 32].height + 20) {
        self.navigationItem.titleView = self.titleView2;
    } else {
        self.navigationItem.titleView = self.titleView1;
    }
}

@end
