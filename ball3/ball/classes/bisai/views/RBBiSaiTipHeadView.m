#import "RBBiSaiTipHeadView.h"
typedef void (^ClickItem)(NSInteger);

@interface RBBiSaiTipHeadView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) ClickItem clickItem;
@end

@implementation RBBiSaiTipHeadView

- (instancetype)initWithFrame:(CGRect)frame andDates:(NSArray *)dates andType:(int)type andClickItem:(void (^)(NSInteger index))clickitem {
    if (self = [super initWithFrame:frame]) {
        self.clickItem = clickitem;
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        int count = (int)dates.count;
        CGFloat btnW = (RBScreenWidth / count) - 1;
        CGFloat btnH = frame.size.height-1;

        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * (btnW + 1), 0, btnW, btnH)];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#F8F8F8"] ] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] ] forState:UIControlStateNormal];
            [btn setTitle:dates[i] forState:UIControlStateNormal];
            NSString *title = [NSString stringWithFormat:@"%@", dates[i]];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:title];
            [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, title.length)];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#FFA500"] range:NSMakeRange(0, title.length)];
            [btn setAttributedTitle:attriStr forState:UIControlStateSelected];

            NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc]initWithString:title];
            [attriStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, title.length)];
            [attriStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6] range:NSMakeRange(0, title.length)];
            [btn setAttributedTitle:attriStr1 forState:UIControlStateNormal];
            btn.tag = 100 + i;
            [self addSubview:btn];
            [btn addTarget:self  action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (type == 1) {
                if (i == 0) {
                    btn.selected = YES;
                    self.selectBtn = btn;
                }
            } else {
                if (i == 3) {
                    btn.selected = YES;
                    self.selectBtn = btn;
                }
            }
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self addSubview:line];
    }
    return self;
}

- (void)clickFirstBtn {
    UIButton *btn = [self viewWithTag:103];
    [self clickBtn:btn];
}

- (void)clickBtn:(UIButton *)btn {
    int time = (int)btn.tag - 100;
    btn.selected = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = btn;
    self.clickItem(time);
}

@end
