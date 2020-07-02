#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBSelectImage : UIView
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andClickCloseBtn:(void (^)(UIImage *))clickCloseBtn andClickBgImage:(void (^)(UIImage *))clickBgImage;
@end

NS_ASSUME_NONNULL_END
