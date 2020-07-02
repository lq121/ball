#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBGiftView : UIButton
- (instancetype)initWithFrame:(CGRect)frame andCoinCount:(int)coinCount andClickItem:(nonnull void (^)(NSDictionary *))clickitem;
- (void)showWhiteView;
@end

NS_ASSUME_NONNULL_END
