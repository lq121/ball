#import "RBAnimationBtn.h"

@interface RBAnimationBtn ()
@property (nonatomic, strong) UIImageView *animationView;

@end

@implementation RBAnimationBtn
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *animationView = [[UIImageView alloc]init];
        animationView.userInteractionEnabled = YES;
        self.animationView = animationView;
        [self addSubview:animationView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationView.frame = self.bounds;
}

- (void)playingWithImgArr:(NSArray *)imgArr andTime:(CGFloat)time {
    [self.animationView setAnimationImages:imgArr];
    self.animationView.animationDuration = time;
    self.animationView.animationRepeatCount = 0;
    self.isPlaying = YES;
    if (!self.animationView.isAnimating) {
        [self.animationView startAnimating];
    }
}

- (void)stopAnimation {
    self.isPlaying = NO;
    [self.animationView stopAnimating];
    self.animationView.animationImages = nil;
}

@end
