#import "RBDetailInjuredCell.h"


@interface RBDetailInjuredCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RBDetailInjuredCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBDetailInjuredCell";
    RBDetailInjuredCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RBDetailInjuredCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)setInjuredModel:(RBInjuredModel *)injuredModel {
    _injuredModel = injuredModel;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGEPLAYERBASEURL, injuredModel.logo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            self.userHead.image = image;
        } else {
            [self.userHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEPLAYERBASEURL, injuredModel.logo]] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGEPLAYERBASEURL, injuredModel.logo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];
    self.nameLabel.text = injuredModel.name;
    self.positionLabel.text = injuredModel.position;
    self.reasonLabel.text = injuredModel.reason;
    if (injuredModel.isLast) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, RBScreenWidth - 32, 44) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(2, 2)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, RBScreenWidth - 32, 44);
        maskLayer.path = maskPath.CGPath;
        self.bgView.layer.mask = maskLayer;
    }
}


@end
