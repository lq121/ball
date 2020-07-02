#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBProgress : UIView
@property (nonatomic, assign) CGFloat first;
@property (nonatomic, assign) CGFloat second;
@property (nonatomic, assign) int type;
- (instancetype)initWithFrame:(CGRect)frame andFirst:(CGFloat)first andSecond:(CGFloat)second andTip:(NSString *)tip andType:(int)type;
- (void)changsize;
@end

NS_ASSUME_NONNULL_END
