#import "RBAnalyzeTitleView.h"
typedef void (^ClickBtn)(BOOL);

@interface RBAnalyzeTitleView ()
@property (nonatomic, copy) ClickBtn clickItem1;
@property (nonatomic, copy) ClickBtn clickItem2;
@property (nonatomic, strong) UILabel *detailLabel;
@end
@implementation RBAnalyzeTitleView

- (RBAnalyzeTitleView *)initWithTitle:(NSString *)title andFrame:(CGRect)frame andSecondTitle:(NSString *)secondTitle andDetail:(NSString *)detail andFirstBtn:(NSString *)fristBtn andSecondBtn:(NSString *)secondBtn andClickFirstBtn:(void (^)(BOOL))clickitem1 andClickSecondBtn:(void (^)(BOOL))clickitem2 {
    if (self = [super initWithFrame:frame]) {
        self.clickItem1 = clickitem1;
        self.clickItem2 = clickitem2;
        self.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 12, 100, 22)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];

        UILabel *secondTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, 100, 46)];
        secondTitleLabel.text = secondTitle;
        secondTitleLabel.textAlignment = NSTextAlignmentLeft;
        secondTitleLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        secondTitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondTitleLabel];

        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 136, 0, 120, 46)];
        self.detailLabel = detailLabel;
        detailLabel.text = detail;
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        detailLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:detailLabel];

        UIButton *btn1 = [[UIButton alloc]init];
        [btn1 setTitle:fristBtn forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.1]] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#213A4B"]] forState:UIControlStateSelected];
        btn1.layer.masksToBounds = YES;
        btn1.layer.cornerRadius = 11;
        btn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn1.frame = CGRectMake(RBScreenWidth - 80, 12, 64, 22);
        [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];

        UIButton *btn2 = [[UIButton alloc]init];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn2 setTitle:secondBtn forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.1]] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#213A4B"]] forState:UIControlStateSelected];
        btn2.layer.masksToBounds = YES;
        btn2.layer.cornerRadius = 11;
        [self addSubview:btn2];
        btn2.frame = CGRectMake(RBScreenWidth - 80 - 64 - 8, 12, 64, 22);
        secondTitleLabel.hidden = secondTitle.length <= 0;
        detailLabel.hidden = detail.length <= 0;
        btn1.hidden = fristBtn.length <= 0;
        btn2.hidden = secondBtn.length <= 0;
        [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickBtn1:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.clickItem1(btn.selected);
}

- (void)clickBtn2:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.clickItem2(btn.selected);
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    self.detailLabel.text = detailTitle;
}

@end
