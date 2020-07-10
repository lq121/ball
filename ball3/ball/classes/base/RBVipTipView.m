#import "RBVipTipView.h"
@interface RBVipTipView()
@property (nonatomic, strong) UIView *whiteVeiw;
@end

@implementation RBVipTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big gift"]];
        imageView.frame = CGRectMake((RBScreenWidth - 120) * 0.5, (RBScreenHeight - 180) * 0.5 - 60, 120, 100);

        UIView *whiteVeiw = [[UIView alloc]initWithFrame:CGRectMake(28, (RBScreenHeight - 180) * 0.5, RBScreenWidth - 56, 180)];
        whiteVeiw.layer.masksToBounds = YES;
        whiteVeiw.layer.cornerRadius = 4;
        whiteVeiw.backgroundColor = [UIColor colorWithSexadeString:@"E6E6E6"];
        self.whiteVeiw = whiteVeiw;
        [self addSubview:whiteVeiw];

        UILabel *tipLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 47, RBScreenWidth - 56, 80)];
        tipLabel2.numberOfLines = 0;
        tipLabel2.text = huiyuantishi;
        tipLabel2.textAlignment = NSTextAlignmentCenter;
        tipLabel2.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tipLabel2.font = [UIFont systemFontOfSize:16];
        [whiteVeiw addSubview:tipLabel2];

        UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 180 - 36,  RBScreenWidth - 56, 22)];
        [buyBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitleColor:[UIColor colorWithSexadeString:@"#2B8AF7"] forState:UIControlStateNormal];
        [buyBtn setTitle:@"zhidaole" forState:UIControlStateNormal];

        buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [whiteVeiw addSubview:buyBtn];

        [self addSubview:imageView];
    }
    return self;
}

- (void)clickCancelBtn {
    [self removeFromSuperview];
}

@end
