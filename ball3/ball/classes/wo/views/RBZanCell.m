#import "RBZanCell.h"
@interface RBZanCell ()
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBZanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    self.head.frame = CGRectMake(16, 16, 32, 32);
    self.userNameLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, 18, RBScreenWidth - 72, 14);
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, CGRectGetMaxY(self.userNameLab.frame) + 4, RBScreenWidth - 72, 14);
    self.desLab.frame = CGRectMake(CGRectGetMaxX(self.head.frame) + 8, CGRectGetMaxY(self.timeLab.frame) + 10, RBScreenWidth - 72, 14);
    self.line.frame = CGRectMake(0, 92, RBScreenWidth, 1);
    self.userNameLab.text = huiFuModel.Hfname;
    self.timeLab.text = [NSString getStrWithDateInt:huiFuModel.Hftime andFormat:@"MM月dd日 HH:mm"];
    self.desLab.text = @"赞了您";
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBZanCell";
    RBZanCell *cell = (RBZanCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}


@end
