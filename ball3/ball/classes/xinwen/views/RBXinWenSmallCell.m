#import "RBXinWenSmallCell.h"

@interface RBXinWenSmallCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBXinWenSmallCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *icon = [[UIImageView alloc]init];
        self.icon = icon;
        [self addSubview:icon];

        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        self.label = label;
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];

        UILabel *tip = [[UILabel alloc]init];
        self.tip = tip;
        tip.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        tip.font = [UIFont systemFontOfSize:12];
        tip.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tip];

        UIView *line = [[UIView alloc]init];
        self.line = line;
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self addSubview:line];
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXinWenSmallCell";
    RBXinWenSmallCell *cell = (RBXinWenSmallCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

-(void)setXinwenModel:(RBXinWenModel *)xinwenModel{
    _xinwenModel = xinwenModel;
    if (xinwenModel.img.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:xinwenModel.img options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                self.icon.image = [image cutImageWithSize:self.icon.size];
            } else {
                [self.icon sd_setImageWithURL:[NSURL URLWithString:xinwenModel.img] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo small"  andFrame:self.icon.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    [manager.imageCache storeImage:image imageData:nil forKey:xinwenModel.img cacheType:SDImageCacheTypeDisk completion:nil];
                    self.icon.image = [image cutImageWithSize:self.icon.size];
                }];
            }
        }];
    }
    self.label.text = xinwenModel.title;
    self.tip.text = [NSString stringWithFormat:@"%d 阅读 | %@", xinwenModel.readnum, [NSString getTimeWithTimeTamp:xinwenModel.createt]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.icon.frame = CGRectMake(RBScreenWidth - 132, 16, 120, 90);
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 2;
    self.label.frame = CGRectMake(12, 16, RBScreenWidth - 152, [self.label.text getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 152].height);
    self.tip.frame = CGRectMake(12, 86, 120, 17);
    self.line.frame = CGRectMake(12, self.height - 1, RBScreenWidth - 24, 1);
}

@end
