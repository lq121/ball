#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBAnimationBtn : UIButton
/** 是否正在动画 */
@property (nonatomic, assign) BOOL isPlaying;
- (void)playingWithImgArr:(NSArray *)imgArr andTime:(CGFloat)time;
- (void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
