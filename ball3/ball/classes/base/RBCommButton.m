#import "RBCommButton.h"

@interface RBCommButton()
@property (strong, nonatomic) UIView *tip;
@end

@implementation RBCommButton

- (instancetype)initWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andLabelFontSize:(CGFloat)fontSize {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 100, 60);
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        if([title isEqualToString:chongxinbofang]){
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [self setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        }
        self.titleLabel.alpha = 0.8;
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

        self.backgroundColor = [UIColor clearColor];
        CGSize imageSize = self.imageView.frame.size;
        CGSize titleSize = self.titleLabel.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height, 0, 0, -titleSize.width);
        self.frame = frame;
        UIView *tip = [[UIView alloc]init];
        tip.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        tip.frame = CGRectMake(frame.size.width - 15, 5, 10, 10);
        tip.layer.masksToBounds = true;
        tip.layer.cornerRadius = 5;
        [self addSubview:tip];
        tip.hidden = YES;
        self.tip = tip;
    }
    return self;
}

- (instancetype)initWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action{
    return [self initWithImage:image andHeighImage:heightImage andFrame:frame andTitle:title andTarget:target andAction:action andLabelFontSize:12];
}

- (void)setShowTip:(BOOL)showTip{
    _showTip = showTip;
    self.tip.hidden = !showTip;
}


@end
