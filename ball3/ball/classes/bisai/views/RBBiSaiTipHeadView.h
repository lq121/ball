#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiTipHeadView : UIView
- (instancetype)initWithFrame:(CGRect)frame andDates:(NSArray *)dates andType:(int)type andClickItem:(void (^)(NSInteger index))clickitem;
- (void)clickFirstBtn;
@end

NS_ASSUME_NONNULL_END
