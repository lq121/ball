#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBSendGiftView : UIView
- (instancetype)initWithFrame:(CGRect)frame andViplevel:(int)level andNickName:(NSString *)nickName andGiftId:(int)giftId andCount:(int)count;
- (void)show;
@end

NS_ASSUME_NONNULL_END
