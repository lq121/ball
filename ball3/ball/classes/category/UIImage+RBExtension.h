#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RBExtension)
+ (instancetype)imageWithColor:(UIColor *)color;
- (instancetype)fixDirextion;
- (instancetype)cutImageWithSize:(CGSize)size;
+ (instancetype)compositionImageWithBaseImageName:(NSString *)baseImage andFrame:(CGRect)frame andBGColor:(UIColor*)color;
+ (CGSize)getOnlinePictureSizeWithUrl:(NSString *)imageUrl;
@end

NS_ASSUME_NONNULL_END
