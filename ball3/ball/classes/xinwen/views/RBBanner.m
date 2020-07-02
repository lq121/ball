#import "RBBanner.h"

@interface RBBanner ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UIButton *actorBtn;
@end

@implementation RBBanner
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImageView = [[UIImageView alloc]init];
        self.bgImageView = bgImageView;
        [self addSubview:self.bgImageView];

        UIButton *btn1 = [[UIButton alloc]init];
        btn1.userInteractionEnabled = NO;
        [btn1 setBackgroundImage:[UIImage imageNamed:@"bai"] forState:UIControlStateNormal];
        [btn1 setTitle:@"话题" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#3B5B20"] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.btn1 = btn1;
        [self addSubview:btn1];

        UIButton *btn2 = [[UIButton alloc]init];
        btn2.userInteractionEnabled = NO;
        [btn2 setBackgroundImage:[UIImage imageNamed:@"touming"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"talk2"] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        self.btn2 = btn2;
        [self addSubview:btn2];

        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont boldSystemFontOfSize:26];
        titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab = titleLab;
        [self addSubview:titleLab];

        UILabel *desLab = [[UILabel alloc]init];
        desLab.textColor = [UIColor whiteColor];
        desLab.font = [UIFont systemFontOfSize:12];
        desLab.textAlignment = NSTextAlignmentLeft;
        self.desLab = desLab;
        [self addSubview:desLab];

        UIButton *actorBtn = [[UIButton alloc]init];
        actorBtn.userInteractionEnabled = NO;
        [actorBtn setBackgroundImage:[UIImage imageNamed:@"canyu"] forState:UIControlStateNormal];
        UILabel *actorLab = [[UILabel alloc]init];
        actorLab.frame = CGRectMake(12, 6, 58, 20);
        actorLab.textColor = [UIColor colorWithSexadeString:@"#3B5B20"];
        actorLab.font = [UIFont boldSystemFontOfSize:14];
        actorLab.textAlignment = NSTextAlignmentLeft;
        actorLab.text = @"立即参与";
        [actorBtn addSubview:actorLab];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jinru"]];
        icon.frame = CGRectMake(CGRectGetMaxX(actorLab.frame), 12, 10, 10);
        [actorBtn addSubview:icon];
        self.actorBtn = actorBtn;
        [self addSubview:actorBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
    self.btn1.frame = CGRectMake(160, 16, 36, 18);
    self.btn2.frame = CGRectMake(CGRectGetMaxX(self.btn1.frame), 16, [self.btn2.currentTitle getLineSizeWithFont:[UIFont boldSystemFontOfSize:10]].width + 26, 18);
    self.titleLab.frame = CGRectMake(160, CGRectGetMaxY(self.btn1.frame) + 8, RBScreenWidth - 174, 28);
    self.desLab.frame = CGRectMake(160, CGRectGetMaxY(self.titleLab.frame) + 2, RBScreenWidth - 174, 15);
    self.actorBtn.frame = CGRectMake(160, CGRectGetMaxY(self.desLab.frame) + 15, 90, 32);
}

- (void)setBannerModel:(RBBannerModel *)bannerModel {
    _bannerModel = bannerModel;
    self.bgImageView.image = [UIImage imageNamed:bannerModel.imageName];
    NSString *str;
    if (bannerModel.number > 999) {
        str = @"999+";
    } else {
        str = [NSString stringWithFormat:@"%d", bannerModel.number];
    }
    [self.btn2 setTitle:str forState:UIControlStateNormal];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:bannerModel.title];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    shadow.shadowOffset = CGSizeMake(0, 2);
    [attrStr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, str.length)];
    self.titleLab.attributedText = attrStr;
    self.desLab.text = bannerModel.desTitle;
}

@end
