#import "RBBiSaiDetailHeadView.h"


@implementation RBBiSaiDetailHeadView

+ (UIView *)HeadViewWithLogo:(NSString *)logo andName:(NSString *)name {
    UIView *view = [[UIView alloc]init];
    if ([logo isEqualToString:@""]) {
        view.frame = CGRectMake(0, 0, RBScreenWidth, 33);
    } else {
        view.frame = CGRectMake(0, 0, RBScreenWidth, 71);
        UILabel *label = [[UILabel alloc]init];
        label.text = name;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        CGSize size = [label.text sizeWithAttributes:@{ NSFontAttributeName: label.font }];

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
    }
    view.backgroundColor = [UIColor whiteColor];

    NSArray *array = @[@"日期", @"赛事", @"主队", @"比分", @"客队"];
    NSArray *margins = @[@(16), @(20), @(10), @(10), @(10)];
    NSArray *widths = @[@(40), @(50), @(65), @(35), @(65)];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = array[i];
        label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        if (i == 2) {
            label.textAlignment = NSTextAlignmentRight;
        } else if (i == 3) {
            label.textAlignment = NSTextAlignmentCenter;
        } else {
            label.textAlignment = NSTextAlignmentLeft;
        }

        label.font = [UIFont systemFontOfSize:12];
        CGFloat x = 0;
        for (int j = 0; j <= i; j++) {
            x += [margins[j]floatValue];
        }
        for (int k = 1; k <= i; k++) {
            x += [widths[k - 1] floatValue];
        }
        label.frame = CGRectMake(x, 8, [widths[i] floatValue], 17);
        if ([logo isEqualToString:@""]) {
            label.y = 8;
        } else {
            label.y = 48;
        }

        [view addSubview:label];
    }

    UILabel *label = [[UILabel alloc]init];
    label.text = @"盘路";
    label.textAlignment = NSTextAlignmentRight;
    label.frame = CGRectMake(RBScreenWidth - 16 - 36, 8, 36, 17);
    if ([logo isEqualToString:@""]) {
        label.y = 8;
    } else {
        label.y = 48;
    }
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    [view addSubview:label];
    return view;
}

@end
