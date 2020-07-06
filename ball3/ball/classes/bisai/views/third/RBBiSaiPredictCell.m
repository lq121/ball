#import "RBBiSaiPredictCell.h"
#import "RBProgress.h"

@interface RBBiSaiPredictCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) RBProgress *progress;
@property (nonatomic, strong) UILabel *winLabel;
@property (nonatomic, strong) UILabel *flatLabel;
@property (nonatomic, strong) UILabel *negativeLabel;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *buyBtn;
@property (strong, nonatomic) UIView *line;
@property (nonatomic, strong) UIView *lockView;
@property (nonatomic, strong) UIButton *firstChose;
@property (nonatomic, strong) UIButton *secondChose;
@property (nonatomic, strong) UILabel *leftLabe;
/// 胜标识
@property (nonatomic, strong) UIView *winTip;
/// 平标识
@property (nonatomic, strong) UIView *flatTip;
/// 负标识
@property (nonatomic, strong) UIView *negativeTip;
@property (nonatomic, strong) UILabel *rightLab;
@property(nonatomic,strong)UIImageView *icon;
@end

@implementation RBBiSaiPredictCell

+ (instancetype)createCellByTableView:(UITableView *)tableView{
    static NSString *indentifier = @"RBBiSaiPredictCell";
    RBBiSaiPredictCell *cell = (RBBiSaiPredictCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.frame = CGRectMake(16, 16, RBScreenWidth * 0.5, 22);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];

        UIImageView *img = [[UIImageView alloc]init];
        img.frame = CGRectMake(RBScreenWidth - 33, 0, 33, 36);
        [self addSubview:img];
        self.img = img;

        UILabel *topLabel = [[UILabel alloc]init];
        topLabel.font = [UIFont systemFontOfSize:12];
        topLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        topLabel.textAlignment = NSTextAlignmentRight;
        self.topLabel = topLabel;
        [self addSubview:topLabel];

        UIButton *firstChose = [[UIButton alloc]init];
        firstChose.hidden = YES;
        self.firstChose = firstChose;
        [firstChose setBackgroundImage:[UIImage imageNamed:@"tip blue 1"] forState:UIControlStateNormal];
        firstChose.titleLabel.font = [UIFont systemFontOfSize:12];
        [firstChose setTitle:@"首选" forState:UIControlStateNormal];
        firstChose.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
        firstChose.frame = CGRectMake(0, 35, 37, 25);
        [firstChose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:firstChose];

        UIButton *secondChose = [[UIButton alloc]init];
        secondChose.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
        secondChose.hidden = YES;
        self.secondChose = secondChose;
        secondChose.titleLabel.font = [UIFont systemFontOfSize:12];
        [secondChose setBackgroundImage:[UIImage imageNamed:@"tip blue 2"] forState:UIControlStateNormal];
        [secondChose setTitle:@"次选" forState:UIControlStateNormal];
        secondChose.frame = CGRectMake(0, 35, 37, 25);
        [secondChose setTitleColor:[UIColor colorWithSexadeString:@"#213A4B"] forState:UIControlStateNormal];
        [self addSubview:secondChose];

        self.progress =  [[RBProgress alloc]initWithFrame:CGRectMake(16, 62, RBScreenWidth - 32, 12) andFirst:0 andSecond:0 andTip:@"暂无预测结果" andType:0];
        [self addSubview:self.progress];

        UILabel *winLabel = [[UILabel alloc]init];
        winLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        winLabel.font = [UIFont systemFontOfSize:12];
        winLabel.textAlignment = NSTextAlignmentLeft;
        self.winLabel = winLabel;
        [self addSubview:winLabel];

        UIView *winTip = [[UIView alloc]init];
        winTip.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        self.winTip = winTip;
        winTip.layer.masksToBounds = YES;
        winTip.layer.cornerRadius = 3;
        [self addSubview:winTip];

        UILabel *flatLabel = [[UILabel alloc]init];
        flatLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        flatLabel.font = [UIFont systemFontOfSize:12];
        flatLabel.textAlignment = NSTextAlignmentLeft;
        self.flatLabel = flatLabel;
        [self addSubview:flatLabel];

        UIView *flatTip = [[UIView alloc]init];
        flatTip.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        self.flatTip = flatTip;
        flatTip.layer.masksToBounds = YES;
        flatTip.layer.cornerRadius = 3;
        [self addSubview:flatTip];

        UILabel *negativeLabel = [[UILabel alloc]init];
        negativeLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        negativeLabel.font = [UIFont systemFontOfSize:12];
        negativeLabel.textAlignment = NSTextAlignmentLeft;
        self.negativeLabel = negativeLabel;
        [self addSubview:negativeLabel];

        UIView *negativeTip = [[UIView alloc]init];
        negativeTip.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
        self.negativeTip = negativeTip;
        negativeTip.layer.masksToBounds = YES;
        negativeTip.layer.cornerRadius = 3;
        [self addSubview:negativeTip];

        UIView *lockView = [[UIView alloc]initWithFrame:CGRectMake(16, 52, RBScreenWidth - 122, 40)];
        self.lockView = lockView;
        UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 14, RBScreenWidth - 122, 12)];
        progress.layer.masksToBounds = YES;
        progress.layer.cornerRadius = 6;
        progress.backgroundColor = [UIColor colorWithSexadeString:@"#EEEEEE"];
        [lockView addSubview:progress];

        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake((RBScreenWidth - 164) * 0.5, 0, 40, 40)];
        self.icon = icon;
        icon.image = [UIImage imageNamed:@"lock"];
        [lockView addSubview:icon];
        [self addSubview:lockView];

        UIButton *buyBtn = [[UIButton alloc]init];
        [buyBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        buyBtn.backgroundColor = [UIColor colorWithSexadeString:@"#EEEEEE"];
        self.buyBtn = buyBtn;
        [buyBtn addTarget:self action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
        buyBtn.frame = CGRectMake(RBScreenWidth - 96, 52, 82, 32);
        buyBtn.layer.masksToBounds = true;
        buyBtn.layer.cornerRadius = 4;
        
        UILabel *leftLabe = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 41, 32)];
        leftLabe.textAlignment = NSTextAlignmentLeft;
        leftLabe.font = [UIFont boldSystemFontOfSize:16];
        leftLabe.textColor = [UIColor colorWithSexadeString:@"#FF8C00"];
        leftLabe.backgroundColor = [UIColor colorWithSexadeString:@"#FFF0D6"];
        self.leftLabe = leftLabe;
        [buyBtn addSubview:leftLabe];

        UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(41, 0, 41, 32)];
        self.rightLab = rightLab;
        rightLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        rightLab.textAlignment = NSTextAlignmentCenter;
        rightLab.text = @"购";
        rightLab.font = [UIFont boldSystemFontOfSize:16];
        rightLab.textColor = [UIColor whiteColor];
        [buyBtn addSubview:rightLab];
        [self addSubview:buyBtn];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F2F2F2"];
        self.line = line;
        [self addSubview:line];
    }
    return self;
}



- (void)clickBuyBtn {
    if ([self.biSaiPredictModel.titleName isEqualToString:@"让球"]) {
        self.clickBtn(2);
    } else if ([self.biSaiPredictModel.titleName isEqualToString:@"胜平负"]) {
        self.clickBtn(1);
    } else if ([self.biSaiPredictModel.titleName isEqualToString:@"大小球"]) {
        self.clickBtn(3);
    }
}

- (void)setBiSaiPredictModel:(RBBISaiPredictModel *)biSaiPredictModel {
    _biSaiPredictModel = biSaiPredictModel;
    self.titleLabel.text = biSaiPredictModel.titleName;
    self.topLabel.text = biSaiPredictModel.desTitle;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.frame = CGRectMake(16, 19, RBScreenWidth - 32, 17);
    self.line.frame = CGRectMake(0, 115, RBScreenWidth, 1);
    self.line.hidden = !biSaiPredictModel.showLine;
    self.leftLabe.text = [NSString stringWithFormat:@" ¥%d", biSaiPredictModel.coin];
    self.buyBtn.enabled = YES;
    if ([biSaiPredictModel.titleName isEqualToString:@"让球"]) {
        int win = 100 - (int)biSaiPredictModel.negative;
        if (win == 50) {
            if (biSaiPredictModel.negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }
        self.winLabel.text = [NSString stringWithFormat:@"主胜概率 %d%%", win];
        self.negativeLabel.text = [NSString stringWithFormat:@"客胜概率 %d%%", 100 - win];
    } else if ([biSaiPredictModel.titleName isEqualToString:@"胜平负"]) {
        NSMutableArray *mutArr = [NSMutableArray array];
        [mutArr addObject:@(biSaiPredictModel.win)];
        [mutArr addObject:@(biSaiPredictModel.flat)];
        [mutArr addObject:@(100 - (biSaiPredictModel.win + biSaiPredictModel.flat))];
        CGFloat min =  MIN(MIN(biSaiPredictModel.win, biSaiPredictModel.flat), 100 - (biSaiPredictModel.win + biSaiPredictModel.flat));
        NSMutableArray *result = [NSMutableArray array];
        CGFloat minR = 100.0;
        int m = 0;
        for (int i = 0; i < 3; i++) {
            if (min == [mutArr[i]floatValue]) {
                [result addObject:@((int)floor([mutArr[i]floatValue]))];
                m = i;
            } else {
                minR = minR - (int)ceil([mutArr[i]floatValue]);
                [result addObject:@((int)ceil([mutArr[i]floatValue]))];
            }
        }
        result[m] = @(minR);
        self.winLabel.text = [NSString stringWithFormat:@"胜 %d%%", [result[0] intValue]];
        self.flatLabel.text = [NSString stringWithFormat:@"平 %d%%", [result[1] intValue]];
        self.negativeLabel.text = [NSString stringWithFormat:@"负 %d%%", [result[2] intValue]];
    } else {
        int win = 100 - (int)biSaiPredictModel.negative;
        if (win == 50) {
            if (biSaiPredictModel.negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }
        self.winLabel.text = [NSString stringWithFormat:@"大球概率 %d%%", win];
        self.negativeLabel.text = [NSString stringWithFormat:@"小球概率 %d%%", 100 - win];
    }

    NSRange range = [self.winLabel.text rangeOfString:@" "];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.winLabel.text];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(range.location, self.winLabel.text.length - range.location)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(range.location, self.winLabel.text.length - range.location - 1)];
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.winLabel.text.length - 1, 1)];
    self.winLabel.attributedText = AttributedStr;

    if (biSaiPredictModel.flat != -1) {
        NSRange range2 = [self.flatLabel.text rangeOfString:@" "];
        NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.flatLabel.text];
        [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(range2.location, self.flatLabel.text.length - range2.location)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(range.location, self.flatLabel.text.length - range2.location - 1)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.flatLabel.text.length - 1, 1)];
        self.flatLabel.attributedText = AttributedStr2;
    }

    NSRange range3 = [self.negativeLabel.text rangeOfString:@" "];
    NSMutableAttributedString *AttributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.negativeLabel.text];
    [AttributedStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(range.location, self.negativeLabel.text.length - range3.location)];
    [AttributedStr3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(range3.location, self.negativeLabel.text.length - range3.location - 1)];
    [AttributedStr3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.negativeLabel.text.length - 1, 1)];
    self.negativeLabel.attributedText = AttributedStr3;

    if (biSaiPredictModel.flat == -1) {
        // 没有平局数据
        CGFloat width = (RBScreenWidth - 122) * 0.5;
        self.winTip.frame = CGRectMake(41, 96, 6, 6);
        self.winLabel.frame = CGRectMake(CGRectGetMaxX(self.winTip.frame) + 4, 82, width, 26);
        self.flatLabel.hidden = YES;
        self.flatTip.hidden = YES;
        self.negativeTip.frame = CGRectMake(RBScreenWidth - 145, 96, 6, 6);
        self.negativeLabel.frame =  CGRectMake(CGRectGetMaxX(self.negativeTip.frame) + 4, 82, width, 26);
    } else {
        CGFloat width = (RBScreenWidth - 102) / 3;
        self.winTip.frame = CGRectMake(41, 96, 6, 6);
        self.winLabel.frame = CGRectMake(CGRectGetMaxX(self.winTip.frame) + 4, 82, width, 26);
        self.flatTip.frame = CGRectMake(156, 96, 6, 6);
        self.flatLabel.frame = CGRectMake(CGRectGetMaxX(self.flatTip.frame) + 4, 82, width, 26);
        self.negativeTip.frame = CGRectMake(RBScreenWidth - 105, 96, 6, 6);
        self.negativeLabel.frame =  CGRectMake(CGRectGetMaxX(self.negativeTip.frame) + 4, 82, width, 26);
    }

    if (!biSaiPredictModel.noData && biSaiPredictModel.status == 1) {
        // 未购买
        self.leftLabe.hidden = NO;
        self.rightLab.hidden = NO;
        [self.buyBtn setTitle:@"" forState:UIControlStateNormal];
        self.progress.hidden = YES;
        self.winTip.hidden = YES;
        self.flatTip.hidden = YES;
        self.negativeTip.hidden = YES;
        self.winLabel.hidden = YES;
        self.flatLabel.hidden = YES;
        self.negativeLabel.hidden = YES;
        self.img.hidden = YES;
        self.lockView.hidden = NO;
        self.icon.hidden = NO;
        self.buyBtn.hidden = NO;
    } else if (!biSaiPredictModel.noData && (biSaiPredictModel.status == 2 || biSaiPredictModel.status == 3)) {
        self.leftLabe.hidden = NO;
        self.rightLab.hidden = NO;
        [self.buyBtn setTitle:@"" forState:UIControlStateNormal];
        // 已购买
        self.progress.hidden = NO;
        if (biSaiPredictModel.flat == -1) {
            self.progress.second = biSaiPredictModel.negative / 100.0;
            self.progress.first = 1 - (biSaiPredictModel.negative / 100.0);
        } else {
            self.progress.first = (biSaiPredictModel.win / 100.0);
            self.progress.second = biSaiPredictModel.flat / 100.0;
            self.progress.type = 1;
            self.firstChose.hidden = NO;
            self.secondChose.hidden = NO;
            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:@(biSaiPredictModel.win)];
            [mutArr addObject:@(biSaiPredictModel.flat)];
            [mutArr addObject:@(100 - (biSaiPredictModel.win + biSaiPredictModel.flat))];

            CGFloat max = MAX(MAX(biSaiPredictModel.win, biSaiPredictModel.flat), 100 - (biSaiPredictModel.win + biSaiPredictModel.flat));
            CGFloat min =  MIN(MIN(biSaiPredictModel.win, biSaiPredictModel.flat), 100 - (biSaiPredictModel.win + biSaiPredictModel.flat));

            int m = 0, c = 0;
            for (int i = 0; i < 3; i++) {
                if (max <= [mutArr[i]floatValue] + 0.00001 && max >= [mutArr[i]floatValue] - 0.00001) {
                    m = i;
                } else if (min <= [mutArr[i]floatValue] + 0.00001 && min >= [mutArr[i]floatValue] - 0.00001) {
                } else {
                    c = i;
                }
            }
            if (m == 0) {
                self.firstChose.centerX = ((RBScreenWidth - 32) * self.progress.first) * 0.5 + 16;
            } else if (m == 1) {
                self.firstChose.centerX = ((RBScreenWidth - 32) * self.progress.second) * 0.5 + 16 + (RBScreenWidth - 32) * self.progress.first;
            } else {
                self.firstChose.centerX = ((RBScreenWidth - 32) * (1 - self.progress.second - self.progress.first)) * 0.5 + 16 + (RBScreenWidth - 32) * (self.progress.first + self.progress.second);
            }
            if (c == 0) {
                self.secondChose.centerX = ((RBScreenWidth - 32) * self.progress.first) * 0.5 + 16;
            } else if (c == 1) {
                self.secondChose.centerX = ((RBScreenWidth - 32) * self.progress.second) * 0.5 + 16 + (RBScreenWidth - 32) * self.progress.first;
            } else {
                self.secondChose.centerX = ((RBScreenWidth - 32) * (1 - self.progress.second - self.progress.first)) * 0.5 + 16 + (RBScreenWidth - 32) * (self.progress.first + self.progress.second);
            }
        }
        [self.progress changsize];
        self.winLabel.hidden = NO;
        self.winTip.hidden = NO;
        self.flatTip.hidden = !(biSaiPredictModel.flat != -1);
        self.flatLabel.hidden = !(biSaiPredictModel.flat != -1);
        self.negativeLabel.hidden = NO;
        self.negativeTip.hidden = NO;
        self.lockView.hidden = YES;
        self.buyBtn.hidden = YES;
        if (biSaiPredictModel.status == 3) {
            self.img.hidden = NO;
            if (biSaiPredictModel.zhunqueType == 1) {
                // 准
                self.img.image = [UIImage imageNamed:@"correct"];
            } else if (biSaiPredictModel.zhunqueType == 2) {
                // 错
                self.img.image = [UIImage imageNamed:@"error"];
            } else if (biSaiPredictModel.zhunqueType == 3) {
                // 走
                self.img.image = [UIImage imageNamed:@"wrong"];
            }
        }
    } else {
        self.leftLabe.hidden = YES;
        self.rightLab.hidden = YES;
        [self.buyBtn setTitle:@"暂无预测" forState:UIControlStateDisabled];
        self.buyBtn.enabled = NO;
        // 暂无预测结果
        self.progress.hidden = YES;
        self.lockView.hidden = NO;
        self.icon.hidden = YES;
        self.buyBtn.hidden = NO;
        self.topLabel.hidden = YES;
        self.winLabel.hidden = YES;
        self.flatLabel.hidden = YES;
        self.negativeLabel.hidden = YES;
        self.winTip.hidden = YES;
        self.flatTip.hidden = YES;
        self.negativeTip.hidden = YES;
    }
}

@end
