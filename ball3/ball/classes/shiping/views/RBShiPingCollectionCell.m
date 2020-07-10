#import "RBShiPingCollectionCell.h"

#define CollW ((RBScreenWidth - 31) / 2.0)

@interface RBShiPingCollectionCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *tipLab;
@end

@implementation RBShiPingCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for (UIView *subView in self.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIImageView *imageView = [[UIImageView alloc]init];
        self.imageView = imageView;
        [self addSubview:imageView];

        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.numberOfLines = 0;
        self.titleLab = titleLab;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [self addSubview:titleLab];

        UILabel *desLab = [[UILabel alloc]init];
        desLab.text = appName;
        self.desLab = desLab;
        desLab.font = [UIFont systemFontOfSize:12];
        desLab.textAlignment = NSTextAlignmentLeft;
        desLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        [self addSubview:desLab];
    }
    return self;
}

-(void)setShiPingModel:(RBShiPingModel *)shiPingModel{
    _shiPingModel = shiPingModel;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
     CGFloat imageH = 0;
    if (shiPingModel.Heng == 1) {
        imageH = 97;
    }else{
        imageH = 229;
    }
    self.imageView.frame = CGRectMake(0, 0, CollW, imageH);
    self.titleLab.text = shiPingModel.Title;
    self.titleLab.frame = CGRectMake(8, CGRectGetMaxY(self.imageView.frame) + 8, CollW - 16, [self.titleLab.text getSizeWithFont:[UIFont systemFontOfSize:14] andMaxWidth:CollW - 16].height);
    self.desLab.frame = CGRectMake(8, CGRectGetMaxY(self.titleLab.frame) + 8, CollW - 16, 17);
    self.cellHeight = CGRectGetMaxY(self.desLab.frame) + 8;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    [manager.imageCache queryImageForKey:shiPingModel.Titleimg options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            self.imageView.image = [image cutImageWithSize:self.imageView.size];
        } else {
            UIImage *placeholderImage;
            if (imageH > CollW) {
                // 长
                placeholderImage = [UIImage compositionImageWithBaseImageName:@"logo pic" andFrame: self.imageView.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]];
            }else{
                placeholderImage = [UIImage compositionImageWithBaseImageName:@"logo pic" andFrame: self.imageView.bounds andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]];
            }
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:shiPingModel.Titleimg] placeholderImage:placeholderImage completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:shiPingModel.Titleimg cacheType:SDImageCacheTypeDisk completion:nil];
                    self.imageView.image = [image cutImageWithSize:self.imageView.size];
                }
            }];
        }
    }];
    
}
@end
