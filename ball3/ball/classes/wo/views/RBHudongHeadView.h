#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBHudongHeadView : UIView
-(instancetype)initWithFrame:(CGRect)frame firstTitle:(NSString *)firstTitle andSecondTitle:(NSString*)secondTitle  andClickItem:(void (^)(NSInteger index))clickitem;
@end

NS_ASSUME_NONNULL_END
