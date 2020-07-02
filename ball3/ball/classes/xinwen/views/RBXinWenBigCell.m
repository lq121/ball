#import "RBXinWenBigCell.h"

@interface RBXinWenBigCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, strong) UILabel *tip2;

@end

@implementation RBXinWenBigCell
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

        UILabel *tip2 = [[UILabel alloc]init];
        self.tip2 = tip2;
        tip2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        tip2.font = [UIFont boldSystemFontOfSize:12];
        tip2.textAlignment = NSTextAlignmentRight;
        [self addSubview:tip2];
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXinWenBigCell";
    RBXinWenBigCell *cell = (RBXinWenBigCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

-(void)setXinWenModel:(RBXinWenModel *)xinWenModel{
    _xinWenModel = xinWenModel;
    if (xinWenModel.img.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:xinWenModel.img options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                self.icon.image = [image cutImageWithSize:self.icon.size];
            } else {
                [self.icon sd_setImageWithURL:[NSURL URLWithString:xinWenModel.img ] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo pic"  andFrame: self.icon.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                     self.icon.image = [image cutImageWithSize:self.icon.size];
                    [manager.imageCache storeImage:image imageData:nil forKey:xinWenModel.img cacheType:SDImageCacheTypeDisk completion:nil];
                }];
            }
        }];
    }
    self.label.text = xinWenModel.title;
    self.tip.text = [NSString stringWithFormat:@"%d 阅读 ", xinWenModel.readnum];
    self.tip2.text = [NSString getTimeWithTimeTamp:xinWenModel.createt];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.icon.frame = CGRectMake(12, 13, RBScreenWidth - 24, 198);
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 2;
    self.label.frame = CGRectMake(12, CGRectGetMaxY(self.icon.frame) + 12, RBScreenWidth - 24, [self.label.text getSizeWithFontSize:18 andMaxWidth:RBScreenWidth - 24].height);
    self.tip.frame = CGRectMake(12, CGRectGetMaxY(self.label.frame) + 8, 120, 17);
    self.tip2.frame = CGRectMake(RBScreenWidth - 132, CGRectGetMaxY(self.label.frame) + 8, 120, 17);
}
@end
