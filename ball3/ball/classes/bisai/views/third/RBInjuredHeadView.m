#import "RBInjuredHeadView.h"


@implementation RBInjuredHeadView

+ (UIView *)HeadViewWithLogo:(NSString *)logo andName:(NSString *)name {
    UIView *view = [[UIView alloc]init];

    view.frame = CGRectMake(0, 0, RBScreenWidth, 71);
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(16, 42, RBScreenWidth - 32, 29)];
    grayView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:grayView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(8, 8)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    grayView.layer.mask = maskLayer;
    [view addSubview:grayView];

    UILabel *label = [[UILabel alloc]init];
    label.text = name;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    CGSize size =  [label.text getLineSizeWithFontSize:16];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((RBScreenWidth - size.width - 8 - 20) * 0.5, 13, 20, 20)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    label.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 8, (41 - size.height) * 0.5, size.width, size.height);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache queryImageForKey:logo options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            imageView.image = image;
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:logo cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];
    [view addSubview:imageView];
    [view addSubview:label];
    view.backgroundColor = [UIColor whiteColor];

    NSArray *array = @[@"球员", @"位置", @"受伤情况"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.size = CGSizeMake(26, 17);
        [label sizeToFit];
        label.y = 48;

        if (i == 0) {
            label.x = 28;
        } else if (i == 1) {
            label.centerX = RBScreenWidth * 0.5;
        } else if (i == 2) {
            label.x = RBScreenWidth * 0.5 + 34;
        }
        [view addSubview:label];
    }

    return view;
}

@end
