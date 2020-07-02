#import "RBSendGiftView.h"

@interface RBSendGiftView ()
@property (nonatomic, strong) UILabel *lvLabel;
@end

@implementation RBSendGiftView

- (instancetype)initWithFrame:(CGRect)frame andViplevel:(int)level andNickName:(NSString *)nickName andGiftId:(int)giftId andCount:(int)count {
    if (self = [super initWithFrame:frame]) {
        NSArray *imgs = @[@"gift／ufo", @"gift／rocket", @"gift／sport car", @"gift／double_rainbow", @"gift／drink", @"gift／rose", @"gift／lollipop", @"gift／good"];
        NSArray *titles = @[@"UFO", @"冲天火箭", @"超级跑车", @"双彩虹", @"82年雪碧", @"玫瑰花", @"棒棒糖", @"赞"];

        UILabel *giftCountLab = [[UILabel alloc]init];
        giftCountLab.text = [NSString stringWithFormat:@"×%d", count];
        CGSize size = [giftCountLab.text getLineSizeWithBoldFontSize:36];
        giftCountLab.textAlignment = NSTextAlignmentRight;
        giftCountLab.textColor = [UIColor colorWithSexadeString:@"#FF4F72"];
        giftCountLab.font = [UIFont boldSystemFontOfSize:36];
        giftCountLab.frame = CGRectMake(frame.size.width - size.width - 20, 28, size.width + 5, size.height);
        [self addSubview:giftCountLab];

        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, frame.size.width - size.width - 20, frame.size.height - 44)];
        bgView.backgroundColor = [UIColor colorWithSexadeString:@"#000000" AndAlpha:0.6];
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(28, 28)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        bgView.layer.mask = maskLayer;
        [self addSubview:bgView];

        self.lvLabel = [[UILabel alloc]init];
        self.lvLabel.textAlignment = NSTextAlignmentCenter;
        self.lvLabel.text = @"Lv.0";
        self.lvLabel.font = [UIFont systemFontOfSize:10];
        self.lvLabel.textColor = [UIColor whiteColor];
        self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#2B8AF7" AndAlpha:0.1];
        [self addSubview:self.lvLabel];
        self.lvLabel.frame = CGRectMake(16, 12, 35, 18);
        self.lvLabel.layer.masksToBounds = true;
        self.lvLabel.layer.cornerRadius = 4;
        self.lvLabel.text = [NSString stringWithFormat:@"Lv.%d", level];
        if (level < 10) {
            self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
        } else if (level < 20) {
            self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
        } else if (level < 30) {
            self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#98D1B2"];
        } else if (level < 40) {
            self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#FFC57F"];
        } else {
            self.lvLabel.backgroundColor = [UIColor colorWithSexadeString:@"#FF9D95"];
        }
        [bgView addSubview:self.lvLabel];

        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = nickName;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.frame = CGRectMake(CGRectGetMaxX(self.lvLabel.frame) + 4, 8, 68, 22);
        [nameLabel sizeToFit];
        [bgView addSubview:nameLabel];

        UILabel *giftLab = [[UILabel alloc]init];
        giftLab.text = [NSString stringWithFormat:@"送出%@", titles[giftId - 1]];
        giftLab.textAlignment = NSTextAlignmentLeft;
        giftLab.textColor = [UIColor whiteColor];
        giftLab.font = [UIFont systemFontOfSize:12];
        giftLab.frame = CGRectMake(16, 31, 68, 22);
        [giftLab sizeToFit];
        [bgView addSubview:giftLab];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgs[giftId - 1]]];
        imageView.frame = CGRectMake(bgView.width - 100, 0, 100, 100);
        [self addSubview:imageView];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.x = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [UIView animateWithDuration:0.5 animations:^{
                                   self.x = -RBScreenWidth + 68;
                               } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                           });
        }
    }];
}

@end
