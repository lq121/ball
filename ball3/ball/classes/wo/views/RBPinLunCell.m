#import "RBPinLunCell.h"
#import "RBNetworkTool.h"
#import "RBToast.h"

@interface RBPinLunCell()
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *clearBtn;
@end

@implementation RBPinLunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *head = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user pic"]];
        self.head = head;
        head.layer.masksToBounds = YES;
        head.layer.cornerRadius = 16;
        self.head = head;
        [self addSubview:head];

        UILabel *userNameLab = [[UILabel alloc]init];
        self.userNameLab = userNameLab;
        userNameLab.textAlignment = NSTextAlignmentLeft;
        userNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        userNameLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:userNameLab];

        UILabel *timeLab = [[UILabel alloc]init];
        self.timeLab = timeLab;
        timeLab.textAlignment = NSTextAlignmentLeft;
        timeLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
        timeLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLab];

        UILabel *desLab = [[UILabel alloc]init];
        desLab.numberOfLines = 0;
        self.desLab = desLab;
        desLab.textAlignment = NSTextAlignmentLeft;
        desLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        desLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:desLab];

        UIView *line = [[UIView alloc] init];
        self.line = line;
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        line.frame = CGRectMake(16, 0, RBScreenWidth - 32, 60);
        [self addSubview:line];

        UIButton *clearBtn = [[UIButton alloc]init];
        [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        self.clearBtn = clearBtn;
        self.clearBtn.hidden = YES;
        [clearBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:clearBtn];
    }
    return self;
}

-(void)setHuiFuModel:(RBHuaTiHuiFuModel *)huiFuModel{
    _huiFuModel = huiFuModel;
    if (huiFuModel.Hfavatar.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:self.huiFuModel.Hfavatar options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                self.head.image = image;
            } else {
                [self.head sd_setImageWithURL:[NSURL URLWithString:self.huiFuModel.Hfavatar ] placeholderImage:[UIImage imageNamed:@"guan user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:self.huiFuModel.Hfavatar cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                }];
            }
        }];
    }
    self.userNameLab.text = huiFuModel.Hfname;
    self.timeLab.text = [NSString getStrWithDateInt:huiFuModel.Hftime andFormat:@"MM月dd日 HH:mm"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    NSString *str;

    if ([uid isEqualToString:huiFuModel.Hfuid]) {
        str = [NSString stringWithFormat:@"评论:%@", huiFuModel.Hftxt];
        self.clearBtn.hidden = NO;
    } else {
        str = [NSString stringWithFormat:@"回复您:%@", huiFuModel.Hftxt];
        self.clearBtn.hidden = YES;
    }
    CGSize size = [str getSizeWithFontSize:14 andMaxWidth:RBScreenWidth-122];
    self.head.frame = CGRectMake(16, 16, 32, 32);
    self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, 18, RBScreenWidth - 122, 14);
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, CGRectGetMaxY(self.userNameLab.frame) + 4, RBScreenWidth - 122, 14);
    self.clearBtn.frame = CGRectMake(RBScreenWidth - 48, 12, 40, 40);
    self.desLab.text = str;
    self.desLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, CGRectGetMaxY(self.timeLab.frame) + 10, RBScreenWidth - 122, size.height);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.desLab.frame) + 16, RBScreenWidth, 1);
}

+ (instancetype)createCellByTableView:(UITableView *)tableView{
    static NSString *indentifier = @"RBPinLunCell";
    RBPinLunCell *cell = (RBPinLunCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)clickClearBtn {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.huiFuModel.Id) forKey:@"commentid"];
    NSString *str = @"apis/delcomment";
    if (self.huiFuModel.type == 1) {
        str = @"apis/delvideocomment";
    }
    [RBNetworkTool PostDataWithUrlStr:str andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"删除成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refshComment" object:self.huiFuModel];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}
@end
