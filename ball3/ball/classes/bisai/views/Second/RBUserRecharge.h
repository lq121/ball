#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBUserRecharge :UIButton
- (instancetype)initWithFrame:(CGRect)frame andCoinCount:(int)coinCount andClickItem:(nonnull void (^)(int))clickitem;
- (void)showWhiteView;
@end

NS_ASSUME_NONNULL_END
