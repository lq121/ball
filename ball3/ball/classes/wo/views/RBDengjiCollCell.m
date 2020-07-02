#import "RBDengjiCollCell.h"

@interface RBDengjiCollCell ()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *desLab;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation RBDengjiCollCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *subView in self.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIView *whiteView = [[UIView alloc]init];
        self.whiteView = whiteView;
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 4;
        whiteView.layer.masksToBounds = true;
        whiteView.layer.borderWidth = 2;
        whiteView.layer.borderColor = [UIColor colorWithSexadeString:@"#F8F8F8"].CGColor;
        [self addSubview:self.whiteView];

        UIImageView *icon = [[UIImageView alloc]init];
        self.icon = icon;
        [whiteView addSubview:icon];

        UILabel *titleLab = [[UILabel alloc]init];
        self.titleLab = titleLab;
        titleLab.font = [UIFont boldSystemFontOfSize:14];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [whiteView addSubview:titleLab];

        UILabel *desLab = [[UILabel alloc]init];
        self.desLab = desLab;
        desLab.font = [UIFont systemFontOfSize:12];
        desLab.textAlignment = NSTextAlignmentCenter;
        desLab.backgroundColor = [UIColor clearColor];
        desLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7];
        [whiteView addSubview:desLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.whiteView.frame = self.bounds;

    self.icon.frame = CGRectMake((self.contentView.width - 28) * 0.5, 12, 28, 28);
    self.titleLab.frame = CGRectMake(0, CGRectGetMaxY(self.icon.frame) + 8, self.contentView.width, 20);
    self.desLab.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), self.contentView.width, 17);
}

- (void)setModel:(RBDengJiModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    if (model.isOther == true) {
        self.icon.hidden = YES;
        self.desLab.hidden = YES;
    } else {
        self.icon.hidden = NO;
        self.desLab.hidden = NO;
        self.icon.image = [UIImage imageNamed:model.icon];
        self.desLab.text = model.des;
    }
}

@end

