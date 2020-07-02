#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBAnalyzeTitleView : UIView
- (RBAnalyzeTitleView *)initWithTitle:(NSString *)title andFrame:(CGRect)frame andSecondTitle:(NSString *)secondTitle andDetail:(NSString *)detail andFirstBtn:(NSString *)fristBtn andSecondBtn:(NSString *)secondBtn andClickFirstBtn:(void (^)(BOOL))clickitem1 andClickSecondBtn:(void (^)(BOOL))clickitem2;
@property (nonatomic, copy) NSString *detailTitle;
@end

NS_ASSUME_NONNULL_END
