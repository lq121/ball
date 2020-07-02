#import "RBProgress.h"

@interface RBProgress()
@property (nonatomic, strong) UIView *sub1;
@property (nonatomic, strong) UIView *sub2;
@property (nonatomic, strong) UIView *sub3;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *tip;
@end


@implementation RBProgress

- (instancetype)initWithFrame:(CGRect)frame andFirst:(CGFloat)first andSecond:(CGFloat)second andTip:(NSString *)tip andType:(int)type {
    if (self = [super initWithFrame:frame]) {
        self.tip = tip;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height * 0.5;

        self.sub1 = [[UIView alloc]init];
        [self addSubview:self.sub1];
        self.sub1.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];

        self.sub2 = [[UIView alloc]init];
        [self addSubview:self.sub2];
        self.sub2.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];

        self.sub3 = [[UIView alloc]init];
        [self addSubview:self.sub3];
        self.sub3.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];

        self.label = [[UILabel alloc]init];
        self.label.text = tip;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.frame = self.bounds;
        self.label.font = [UIFont  systemFontOfSize:12];
        self.label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        [self addSubview:self.label];
        if (type == 3) {
            self.backgroundColor = [UIColor colorWithSexadeString:@"#2B8AF7" AndAlpha:0.2];
        } else {
            self.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.04];
        }
        if (tip == nil || [tip isEqualToString:@""]) {
            self.label.hidden = YES;
        } else {
            self.label.hidden = NO;
        }
        self.first = first;
        self.second = second;
        self.sub1.frame = CGRectMake(0, 0, 0, frame.size.height);
        self.sub2.frame = CGRectMake(CGRectGetMaxX(self.sub1.frame), 0,0, frame.size.height);
        self.sub3.frame = CGRectMake(CGRectGetMaxX(self.sub2.frame), 0, 0, frame.size.height);
    }
    return self;
}

- (void)changsize {
    self.tip = @"";
    self.label.hidden = YES;
    CGFloat three;
    if (self.type == 0) {
        three = 0;
        self.sub2.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    } else {
        self.sub2.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        three = 1 - self.first - self.second;
    }
    self.sub1.frame = CGRectMake(0, 0, self.frame.size.width * self.first, self.frame.size.height);
    self.sub2.frame = CGRectMake(CGRectGetMaxX(self.sub1.frame), 0, self.frame.size.width * self.second, self.frame.size.height);
    self.sub3.frame = CGRectMake(CGRectGetMaxX(self.sub2.frame), 0, self.frame.size.width * three, self.frame.size.height);
}

- (void)setFirst:(CGFloat)first {
    _first = first;
}

- (void)setSecond:(CGFloat)second {
    _second = second;
}

- (void)setType:(int)type {
    _type = type;
}

@end
