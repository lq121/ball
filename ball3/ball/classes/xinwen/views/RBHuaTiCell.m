#import "RBHuaTiCell.h"
#import "KNPhotoBrowser.h"
#import "RBNetworkTool.h"
#import "RBToast.h"

@interface RBHuaTiCell()<KNPhotoBrowserDelegate>
@property (nonatomic, strong) UIImageView *useHead;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UIButton *orgIcon;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UILabel *lvLab;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *iconsView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UILabel *jingLab;
@property (nonatomic, strong) UILabel *dingLab;
@property (nonatomic, strong) NSMutableArray *itemsArr;
@end


@implementation RBHuaTiCell
+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBHuaTiCell";
    RBHuaTiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *useHead = [[UIImageView alloc]init];
        useHead.image = [UIImage imageNamed:@"user pic"];
        useHead.frame = CGRectMake(8, 16, 32, 32);
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

        UIButton *orgIcon = [[UIButton alloc]init];
        [orgIcon setBackgroundImage:[UIImage imageNamed:@"guanfang"] forState:UIControlStateNormal];
        [orgIcon setTitle:@"官方" forState:UIControlStateNormal];
        orgIcon.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        [orgIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orgIcon.titleLabel.font = [UIFont systemFontOfSize:10];
        self.orgIcon = orgIcon;
        [self addSubview:orgIcon];

        UIImageView *vipIcon = [[UIImageView alloc]init];
        vipIcon.image = [UIImage imageNamed:@"vip kim"];
        self.vipIcon = vipIcon;
        [self addSubview:vipIcon];

        UILabel *lvLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 5.8, 32, 14)];
        self.lvLab = lvLab;
        lvLab.layer.cornerRadius = 2;
        lvLab.layer.masksToBounds = true;
        lvLab.textAlignment = NSTextAlignmentCenter;
        lvLab.textColor = [UIColor whiteColor];
        lvLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:lvLab];

        UILabel *jingLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 5.8, 22, 14)];
        jingLab.textColor = [UIColor whiteColor];
        jingLab.text = @"精";
        self.jingLab = jingLab;
        jingLab.textAlignment = NSTextAlignmentCenter;
        jingLab.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        jingLab.layer.masksToBounds = YES;
        jingLab.layer.cornerRadius = 2;
        jingLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:jingLab];

        UILabel *dingLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 5.8, 22, 14)];
        dingLab.text = @"顶";
        dingLab.layer.masksToBounds = YES;
        dingLab.layer.cornerRadius = 2;
        dingLab.textColor = [UIColor whiteColor];
        self.dingLab = dingLab;
        dingLab.textAlignment = NSTextAlignmentCenter;
        dingLab.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        dingLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:dingLab];

        UIButton *clearBtn = [[UIButton alloc]init];
        [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        self.clearBtn = clearBtn;
        self.clearBtn.hidden = YES;
        [clearBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:clearBtn];

        UIButton *replyBtn = [[UIButton alloc]init];
        replyBtn.userInteractionEnabled = NO;
        replyBtn.frame = CGRectMake(RBScreenWidth - 55, 24, 55, 16);
        [replyBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        self.replyBtn = replyBtn;
        [replyBtn setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
        [self addSubview:self.replyBtn];

        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab = titleLab;
        [self addSubview:titleLab];

        UILabel *desLab = [[UILabel alloc]init];
        desLab.numberOfLines = 0;
        desLab.font = [UIFont systemFontOfSize:14];
        desLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
        desLab.textAlignment = NSTextAlignmentLeft;
        self.desLab = desLab;
        [self addSubview:desLab];

        UIView *iconsView = [[UIView alloc]init];
        self.iconsView = iconsView;
        [self addSubview:iconsView];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self addSubview:line];
    }
    return self;
}

- (void)clickClearBtn {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huaTiModel.Id) forKey:@"id"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/delhuati" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"删除成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refshHuaTi" object:self.huaTiModel];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)setHuaTiModel:(RBHuaTiModel *)huaTiModel{
    _huaTiModel = huaTiModel;
    self.itemsArr = [NSMutableArray array];
    if (huaTiModel.Avatar.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:huaTiModel.Avatar options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                self.useHead.image = image;
            } else {
                [self.useHead sd_setImageWithURL:[NSURL URLWithString:huaTiModel.Avatar ] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:huaTiModel.Avatar cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                }];
            }
        }];
    } else {
        if ([huaTiModel.Uid isEqualToString:@"fangguan"]) {
            self.useHead.image = [UIImage imageNamed:@"share logo"];
        } else {
            self.useHead.image = [UIImage imageNamed:@"user pic"];
        }
    }

    self.clearBtn.frame = CGRectMake(RBScreenWidth - 48, 12, 40, 40);
    self.clearBtn.hidden = !huaTiModel.canClear;
    self.replyBtn.hidden = huaTiModel.canClear;
    self.userName.text = huaTiModel.Username;
    CGSize size = [huaTiModel.Username getLineSizeWithFontSize:14];
    self.userName.frame = CGRectMake(CGRectGetMaxX(self.useHead.frame) + 8, 14, size.width, size.height);
    self.userName.centerY = self.useHead.centerY;
    self.orgIcon.frame = CGRectMake(CGRectGetMaxX(self.userName.frame)+4, 19, 35, 16);
    self.vipIcon.frame = CGRectMake(CGRectGetMaxX(self.userName.frame)+4, 19, 35, 16);
    self.lvLab.text = [NSString stringWithFormat:@"Lv%d", huaTiModel.Lv];
    if (huaTiModel.Vip <= 0) {
        self.vipIcon.hidden = YES;
        self.userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.lvLab.frame = CGRectMake(CGRectGetMaxX(self.userName.frame) + 4, 17, 32, 14);
    } else {
        self.vipIcon.hidden = NO;
        self.userName.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        self.lvLab.frame = CGRectMake(CGRectGetMaxX(self.vipIcon.frame) + 4, 17, 32, 14);
    }
    if (huaTiModel.Lv < 10) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
    } else if (huaTiModel.Lv < 20) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
    } else if (huaTiModel.Lv < 30) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#98D1B2"];
    } else if (huaTiModel.Lv < 40) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFC57F"];
    } else {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF9D95"];
    }
    self.vipIcon.centerY = self.useHead.centerY;
    self.orgIcon.centerY = self.useHead.centerY;
    self.lvLab.centerY = self.useHead.centerY;
    if ([huaTiModel.Uid isEqualToString:@"fangguan"]) {
        self.lvLab.hidden = YES;
        self.orgIcon.hidden = NO;
        if (huaTiModel.Jing == 1) {
            self.jingLab.frame = CGRectMake(CGRectGetMaxX(self.orgIcon.frame) + 4, 17, 22, 14);
            self.dingLab.frame = CGRectMake(CGRectGetMaxX(self.jingLab.frame) + 4, 17, 22, 14);
        } else {
            self.jingLab.frame = CGRectMake(CGRectGetMaxX(self.orgIcon.frame) + 4, 17, 0, 14);
            self.dingLab.frame = CGRectMake(CGRectGetMaxX(self.orgIcon.frame) + 4, 17, 22, 14);
        }
    } else {
        self.lvLab.hidden = NO;
        self.orgIcon.hidden = YES;
        if (huaTiModel.Jing == 1) {
            self.jingLab.frame = CGRectMake(CGRectGetMaxX(self.lvLab.frame) + 4, 17, 22, 14);
            self.dingLab.frame = CGRectMake(CGRectGetMaxX(self.jingLab.frame) + 4, 17, 22, 14);
        } else {
            self.jingLab.frame = CGRectMake(CGRectGetMaxX(self.lvLab.frame) + 4, 17, 0, 14);
            self.dingLab.frame = CGRectMake(CGRectGetMaxX(self.lvLab.frame) + 4, 17, 22, 14);
        }
    }
    self.jingLab.centerY = self.useHead.centerY;
    self.dingLab.centerY = self.useHead.centerY;
    self.dingLab.hidden = (huaTiModel.Ding != 1);
    self.jingLab.hidden = (huaTiModel.Jing != 1);
    self.titleLab.text = huaTiModel.Title;
    self.titleLab.frame = CGRectMake(16, CGRectGetMaxY(self.useHead.frame) + 12, RBScreenWidth - 32, 22);
    self.desLab.text = huaTiModel.Txt;
    CGSize size2 = [huaTiModel.Txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32];
    self.desLab.frame = CGRectMake(16, CGRectGetMaxY(self.titleLab.frame) + 2, RBScreenWidth - 32, size2.height);
    [self.replyBtn setTitle:[NSString stringWithFormat:@" %d", huaTiModel.Comment] forState:UIControlStateNormal];
    NSData *jsonData = nil;
    NSError *err;
    jsonData = [huaTiModel.Img dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    for (UIView *view in self.iconsView.subviews) {
        [view removeFromSuperview];
    }
    if (arr.count == 0) {
        self.iconsView.hidden = YES;
        self.iconsView.frame =  CGRectZero;
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.desLab.frame) + 16, RBScreenWidth, 1);
    } else {
        self.iconsView.hidden = NO;
        CGFloat width = 109;
        for (int i = 0; i < arr.count; i++) {
            NSString *str = arr[i];
            str = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fill,h_109,w_109,limit_0",str];
            UIImageView *icon = [[UIImageView alloc]init];
          
            icon.userInteractionEnabled = YES;
            icon.tag = i;
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewIBAction:)]];
            icon.frame = CGRectMake( (i % 3) * (width + 4), (i / 3) * (width + 4), width, width);
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager.imageCache queryImageForKey:str options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
                if (image != nil) {
                    icon.image = image;
                    icon.image = [image cutImageWithSize:icon.size];
                } else {
                    [icon sd_setImageWithURL:[NSURL URLWithString:str ] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo pic" andFrame: icon.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                        if (image != nil) {
                            [manager.imageCache storeImage:image imageData:nil forKey:str cacheType:SDImageCacheTypeDisk completion:nil];
                            icon.image = [image cutImageWithSize:icon.size];
                        }
                    }];
                }
            }];

            
            icon.layer.masksToBounds = YES;
            icon.layer.cornerRadius = 4;
            KNPhotoItems *items = [[KNPhotoItems alloc] init];
            items.url = arr[i];
            items.sourceView = icon;
            [self.itemsArr addObject:items];
            [self.iconsView addSubview:icon];
        }
        CGFloat height = 0;
        if (arr.count % 3 > 0) {
            height += (width + 4);
        }
        height += (((arr.count) / 3) * (width + 4));
        self.iconsView.frame = CGRectMake(16, CGRectGetMaxY(self.desLab.frame) + 12, RBScreenWidth - 32, height);
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.iconsView.frame) + 16, RBScreenWidth, 1);
    }
}

- (void)imageViewIBAction:(UITapGestureRecognizer *)tap {
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = [self.itemsArr copy];
    photoBrowser.currentIndex = tap.view.tag;
    photoBrowser.isNeedPageControl = true;
    photoBrowser.isNeedPageNumView = true;
    photoBrowser.isNeedRightTopBtn = NO;
    photoBrowser.isNeedPictureLongPress = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.delegate = self;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"btnType" object:[NSNumber numberWithBool:YES]];
    [photoBrowser present];
}

- (void)photoBrowserWillDismiss {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"btnType" object:[NSNumber numberWithBool:NO]];
}


@end
