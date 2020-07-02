#import "RBHuaTiHuiFuCell.h"
#import "RBChekLogin.h"
#import "RBActionView.h"
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBHuiFuVC.h"

typedef void (^ClickCloseBtn)(RBHuaTiHuiFuModel *huaTiHuiFuModel);
typedef void (^LongTap)(RBHuaTiHuiFuModel *huaTiHuiFuModel);

@interface RBHuaTiHuiFuCell ()
@property (nonatomic, strong) UIImageView *useHead;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *huiFuBtn;
@property (nonatomic, strong) UILabel *huiFuLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, copy) LongTap longTap;
@property (nonatomic, copy) ClickCloseBtn clickCloseBtn;
@property (nonatomic, strong) UIImageView *vipIcon;
@end

@implementation RBHuaTiHuiFuCell

+ (instancetype)createCellByTableView:(UITableView *)tableView andClickCellCloseBtn:(nonnull void (^)(RBHuaTiHuiFuModel *))clickCloseBtn {
    static NSString *ID = @"RBHuaTiHuiFuCell";
    RBHuaTiHuiFuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.clickCloseBtn = clickCloseBtn;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView andLongtop:(void (^)(RBHuaTiHuiFuModel *))longTap {
    static NSString *ID = @"RBHuaTiHuiFuCell";
    RBHuaTiHuiFuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *useHead = [[UIImageView alloc]init];
        useHead.image = [UIImage imageNamed:@"user pic"];
        useHead.frame = CGRectMake(16, 16, 32, 32);
        useHead.layer.masksToBounds = YES;
        useHead.layer.cornerRadius = 16;
        self.useHead = useHead;
        [self addSubview:useHead];

        UILabel *userName = [[UILabel alloc]init];
        userName.font = [UIFont systemFontOfSize:14];
        userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        userName.textAlignment = NSTextAlignmentLeft;
        self.userName = userName;
        [self addSubview:userName];

        UIImageView *vipIcon = [[UIImageView alloc]init];
        vipIcon.image = [UIImage imageNamed:@"vip kim"];
        self.vipIcon = vipIcon;
        [self addSubview:vipIcon];

        UILabel *timeLab = [[UILabel alloc]init];
        timeLab.font = [UIFont systemFontOfSize:10];
        timeLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
        timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab = timeLab;
        [self addSubview:timeLab];

        UIButton *zanBtn = [[UIButton alloc]init];
        [zanBtn addTarget:self action:@selector(clickZanBtn) forControlEvents:UIControlEventTouchUpInside];
        self.zanBtn = zanBtn;
        zanBtn.frame = CGRectMake(RBScreenWidth - 100, 17, 55, 16);
        [zanBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        zanBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        zanBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 6, 0, 0);
        [zanBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"up_selected"] forState:UIControlStateSelected];
        [self addSubview:self.zanBtn];

        UIButton *huiFuBtn = [[UIButton alloc]init];
        [huiFuBtn addTarget:self action:@selector(clickReplyBtn) forControlEvents:UIControlEventTouchUpInside];
        huiFuBtn.frame = CGRectMake(RBScreenWidth - 55, 14, 55, 16);
        self.huiFuBtn = huiFuBtn;
        [huiFuBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [huiFuBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateHighlighted];
        [self addSubview:self.huiFuBtn];

        UILabel *huiFuLab = [[UILabel alloc]init];
        huiFuLab.numberOfLines = 0;
        huiFuLab.userInteractionEnabled = YES;
        huiFuLab.font = [UIFont systemFontOfSize:14];
        huiFuLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        huiFuLab.textAlignment = NSTextAlignmentLeft;
        self.huiFuLab = huiFuLab;
        [self addSubview:huiFuLab];

        UIView *secondView = [[UIView alloc]init];
        secondView.userInteractionEnabled = YES;
        self.secondView = secondView;
        secondView.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
        secondView.layer.masksToBounds = YES;
        secondView.layer.cornerRadius = 4;
        [self addSubview:secondView];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self addSubview:line];
    }
    return self;
}

// 点击赞按钮
- (void)clickZanBtn {
    if ([RBChekLogin CheckLogin]) {
        return;
    }
    if ([RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以参与互动" andtype:@"zanlv" andNeedCheck:YES]) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huaTiHuiFuModel.Htid) forKey:@"huatiid"];
    [dict setValue:@"" forKey:@"txt"];
    [dict setValue:@(self.huaTiHuiFuModel.Id) forKey:@"commentid"];
    [dict setValue:@(1) forKey:@"zan"];
    NSString *str = @"apis/huaticomment";
    if (self.huaTiHuiFuModel.type == 1) {
        str = @"apis/videocomment";
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"点赞成功"];
            RBHuaTiHuiFuModel *topicModel = self.huaTiHuiFuModel;
            topicModel.Zannum += 1;
            topicModel.Zan = 1;
            self.huaTiHuiFuModel = topicModel;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)clickReplyBtn {
    NSArray *arr = @[@"回复", @"举报"];
    RBActionView *actionView = [[RBActionView alloc]initWithArray:arr andCancelBtnColor:[UIColor colorWithSexadeString:@"#333333"]  andClickItem:^(NSInteger index) {
        if (index == 0) {
            // 回复
            UIViewController *currentVC = [UIViewController getCurrentVC];
            RBHuiFuVC *huifuVC = [[RBHuiFuVC alloc]init];
            huifuVC.huiFuModel = self.huaTiHuiFuModel;
            huifuVC.title = [NSString stringWithFormat:@"%d楼回复", self.huaTiHuiFuModel.index];
            [currentVC.navigationController pushViewController:huifuVC animated:YES];
        } else {
            [self inform:self.huaTiHuiFuModel];
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
}

// 举报
- (void)inform:(RBHuaTiHuiFuModel *)topicReolyModel {
    if ([RBChekLogin CheckLogin]) {
        return;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(self.huaTiHuiFuModel.Htid) forKey:@"huatiid"];
        [dict setValue:@(topicReolyModel.Id) forKey:@"commentid"];
        NSString *str = @"apis/jubao";
        if (self.huaTiHuiFuModel.type == 1) {
            str = @"apis/jubaovideo";
        }
        [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            if (backData[@"ok"] != nil) {
                [RBToast showWithTitle:@"举报成功"];
            }
        } Fail:^(NSError *_Nonnull error) {
        }];
    }
}

- (void)setHuaTiHuiFuModel:(RBHuaTiHuiFuModel *)huaTiHuiFuModel {
    _huaTiHuiFuModel = huaTiHuiFuModel;
    if (huaTiHuiFuModel.Hfavatar.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:huaTiHuiFuModel.Hfavatar options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                self.useHead.image = image;
            } else {
                [self.useHead sd_setImageWithURL:[NSURL URLWithString:huaTiHuiFuModel.Hfavatar ] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:huaTiHuiFuModel.Hfavatar cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                }];
            }
        }];
    } else {
        self.useHead.image = [UIImage imageNamed:@"user pic"];
    }
    self.userName.text = huaTiHuiFuModel.Hfname;
    if (huaTiHuiFuModel.Hfvip > 0) {
        self.userName.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        self.vipIcon.hidden = NO;
    } else {
        self.userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.vipIcon.hidden = YES;
    }
    if ((huaTiHuiFuModel.canRep == -1)) {
        self.huiFuBtn.hidden = YES;
        self.zanBtn.hidden = YES;
    } else {
        self.huiFuBtn.hidden = NO;
        self.zanBtn.hidden = NO;
    }
    self.userName.frame = CGRectMake(56, 16, RBScreenWidth - 68, 14);
    [self.userName sizeToFit];
    self.vipIcon.frame = CGRectMake(CGRectGetMaxX(self.userName.frame), 16, 35, 16);
    self.timeLab.text = [NSString getStrWithDateInt:self.huaTiHuiFuModel.Hftime andFormat:@"MM月dd日 HH:mm"];
    self.timeLab.frame = CGRectMake(56, CGRectGetMaxY(self.userName.frame) + 4, 120, 10);
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%d", self.huaTiHuiFuModel.Zannum] forState:UIControlStateNormal];
    self.zanBtn.selected = (huaTiHuiFuModel.Zan == 1);
    self.huiFuLab.text = self.huaTiHuiFuModel.Hftxt;
    CGSize size = [self.huaTiHuiFuModel.Hftxt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 72];
    self.huiFuLab.frame = CGRectMake(56, CGRectGetMaxY(self.timeLab.frame) + 10, size.width, size.height);
    for (UIView *view  in self.secondView.subviews) {
        [view removeFromSuperview];
    }
    if (huaTiHuiFuModel.secondArr == nil || huaTiHuiFuModel.secondArr.count == 0) {
        self.secondView.hidden = YES;
        self.line.frame = CGRectMake(16, CGRectGetMaxY(self.huiFuLab.frame) + 17, RBScreenWidth - 32, 1);
    } else {
        for (UIView *view in self.secondView.subviews) {
            [view removeFromSuperview];
        }
        self.secondView.hidden = NO;
        CGFloat currentH = 0;
        for (int i = 0; i < huaTiHuiFuModel.secondArr.count; i++) {
            RBHuaTiHuiFuModel *model = huaTiHuiFuModel.secondArr[i];
            UILabel *label = [[UILabel alloc]init];
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            NSString *str = [NSString stringWithFormat:@"%@:%@", model.Hfname, model.Hftxt];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
            [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#2B8AF7"] } range:NSMakeRange(0, model.Hfname.length + 1)];
            [attr addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"] } range:NSMakeRange(model.Hfname.length + 1, str.length - (model.Hfname.length + 1))];
            CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 88];
            label.attributedText = attr;
            label.frame = CGRectMake(8, 6 + currentH, size.width, size.height);
            currentH += size.height;
            [self.secondView addSubview:label];
        }
        if (huaTiHuiFuModel.secondArr.count < huaTiHuiFuModel.Comnum) {
            // 说明未加载完
            UIButton *loadMoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, currentH + 12, RBScreenWidth - 56 - 16, 30)];
            [loadMoreBtn setTitle:@"展开更多回复" forState:UIControlStateNormal];
            [loadMoreBtn setTitleColor:[UIColor colorWithSexadeString:@"#2B8AF7"] forState:UIControlStateNormal];
            loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.secondView addSubview:loadMoreBtn];
            self.secondView.frame = CGRectMake(56, CGRectGetMaxY(self.huiFuLab.frame) + 8, RBScreenWidth - 56 - 16, currentH + 12 + 30);
            [loadMoreBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        } else {
            self.secondView.frame = CGRectMake(56, CGRectGetMaxY(self.huiFuLab.frame) + 8, RBScreenWidth - 56 - 16, currentH + 12);
        }
        self.line.frame = CGRectMake(16, CGRectGetMaxY(self.secondView.frame) + 17, RBScreenWidth - 32, 1);
    }
}

- (void)clickBtn {
    self.clickCloseBtn(self.huaTiHuiFuModel);
}

@end
