#import "RBMyPredictCell.h"
#import "RBProgress.h"
#import "RBFloatOption.h"

@interface RBMyPredictCell ()
/// 线
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
/// 赛事名
@property (nonatomic, strong) UILabel *eventNameLab;
/// 比赛时间
@property (nonatomic, strong) UILabel *biSaiTimeLab;
/// 主标志
@property (nonatomic, strong) UILabel *hostTip;
/// 主队名
@property (nonatomic, strong) UILabel *hostNameLab;
/// 主队logo
@property (nonatomic, strong) UIImageView *hostLogo;
/// 客标志
@property (nonatomic, strong) UILabel *visitTip;
/// 客队名
@property (nonatomic, strong) UILabel *visitNameLab;
/// 客队logo
@property (nonatomic, strong) UIImageView *visitLogo;
/// 比分
@property (nonatomic, strong) UILabel *scoreLab;
/// 亚盘
@property (nonatomic, strong) UILabel *yaLab;
/// 欧盘
@property (nonatomic, strong) UILabel *ouLab;
/// 大小
@property (nonatomic, strong) UILabel *bigLab;

/// 标题（大小球）
@property (nonatomic, strong) UILabel *titleLabel;
/// 走准图片
@property (nonatomic, strong) UIImageView *img;
/// 盘口数据
@property (nonatomic, strong) UILabel *topLabel;
/// 首选
@property (nonatomic, strong) UIButton *firstChose;
/// 次选
@property (nonatomic, strong) UIButton *secondChose;
/// 进度条
@property (nonatomic, strong) RBProgress *progress;
/// 胜
@property (nonatomic, strong) UILabel *winLabel;
/// 平
@property (nonatomic, strong) UILabel *flatLabel;
/// 负
@property (nonatomic, strong) UILabel *negativeLabel;
/// 胜标识
@property (nonatomic, strong) UIView *winTip;
/// 平标识
@property (nonatomic, strong) UIView *flatTip;
/// 负标识
@property (nonatomic, strong) UIView *negativeTip;
@end

@implementation RBMyPredictCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *line1 = [[UIView alloc]init];
        self.line1 = line1;
        line1.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self.contentView addSubview:line1];

        UILabel *eventNameLab = [[UILabel alloc]init];
        self.eventNameLab = eventNameLab;
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextVerticalAlignmentMiddle;
        [self.contentView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        biSaiTimeLab.font = [UIFont systemFontOfSize:12];
        biSaiTimeLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:biSaiTimeLab];

        UILabel *hostTip = [[UILabel alloc]init];
        hostTip.text = @"主";
        self.hostTip = hostTip;
        hostTip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostTip.font = [UIFont boldSystemFontOfSize:8];
        hostTip.layer.borderWidth = 0.5;
        hostTip.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        hostTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:hostTip];

        UILabel *visitTip = [[UILabel alloc]init];
        visitTip.text = @"客";
        self.visitTip = visitTip;
        visitTip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        visitTip.font = [UIFont boldSystemFontOfSize:8];
        visitTip.layer.borderWidth = 0.5;
        visitTip.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        visitTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:visitTip];

        UILabel *hostNameLab = [[UILabel alloc]init];
        hostNameLab.numberOfLines = 0;
        self.hostNameLab = hostNameLab;
        hostNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostNameLab.font = [UIFont boldSystemFontOfSize:14];
        hostNameLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:hostNameLab];

        UIImageView *hostLogo = [[UIImageView alloc]init];
        self.hostLogo = hostLogo;
        [self.contentView addSubview:hostLogo];

        UILabel *visitNameLab = [[UILabel alloc]init];
        visitNameLab.numberOfLines = 0;
        self.visitNameLab = visitNameLab;
        visitNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        visitNameLab.font = [UIFont boldSystemFontOfSize:14];
        visitNameLab.textAlignment = NSTextVerticalAlignmentMiddle;
        [self.contentView addSubview:visitNameLab];

        UILabel *scoreLab = [[UILabel alloc]init];
        self.scoreLab = scoreLab;
        scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        scoreLab.font = [UIFont boldSystemFontOfSize:20];
        scoreLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:scoreLab];

        UIImageView *visitLogo = [[UIImageView alloc]init];
        self.visitLogo = visitLogo;
        [self.contentView addSubview:visitLogo];

        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line2 = line2;
        [self.contentView addSubview:line2];

        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];

        UIImageView *img = [[UIImageView alloc]init];
        [self addSubview:img];
        self.img = img;

        UILabel *topLabel = [[UILabel alloc]init];
        topLabel.font = [UIFont systemFontOfSize:12];
        topLabel.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        topLabel.textAlignment = NSTextAlignmentLeft;
        self.topLabel = topLabel;
        [self addSubview:topLabel];

        self.progress = [[RBProgress alloc]initWithFrame:CGRectMake(16, 146, RBScreenWidth - 32, 12) andFirst:0 andSecond:0 andTip:@"" andType:0];
        self.progress.type = 0;
        [self addSubview:self.progress];

        UIButton *firstChose = [[UIButton alloc]init];
        firstChose.hidden = YES;
        self.firstChose = firstChose;
        [firstChose setBackgroundImage:[UIImage imageNamed:@"tip blue 1"] forState:UIControlStateNormal];
        firstChose.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [firstChose setTitle:@"首选" forState:UIControlStateNormal];
        firstChose.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
        [firstChose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:firstChose];

        UIButton *secondChose = [[UIButton alloc]init];
        secondChose.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 6, 0);
        secondChose.hidden = YES;
        self.secondChose = secondChose;
        secondChose.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [secondChose setBackgroundImage:[UIImage imageNamed:@"tip blue 2"] forState:UIControlStateNormal];
        [secondChose setTitle:@"次选" forState:UIControlStateNormal];
        [secondChose setTitleColor:[UIColor colorWithSexadeString:@"#213A4B"] forState:UIControlStateNormal];
        [self addSubview:secondChose];

        UILabel *winLabel = [[UILabel alloc]init];
        winLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        winLabel.font = [UIFont systemFontOfSize:12];
        winLabel.textAlignment = NSTextAlignmentLeft;
        winLabel.textAlignment = NSTextVerticalAlignmentMiddle;
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
        flatLabel.textAlignment = NSTextVerticalAlignmentMiddle;
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
        negativeLabel.textAlignment = NSTextVerticalAlignmentMiddle;
        self.negativeLabel = negativeLabel;
        [self addSubview:negativeLabel];

        UIView *negativeTip = [[UIView alloc]init];
        negativeTip.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
        self.negativeTip = negativeTip;
        negativeTip.layer.masksToBounds = YES;
        negativeTip.layer.cornerRadius = 3;
        [self addSubview:negativeTip];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.line1.frame = CGRectMake(0, 0, RBScreenWidth, 4);
    self.eventNameLab.frame = CGRectMake(8, 8, 120, 17);
    self.biSaiTimeLab.frame = CGRectMake((RBScreenWidth - 84) * 0.5, 8, [self.biSaiTimeLab.text getLineSizeWithFontSize:12].width, 17);
    self.hostTip.frame = CGRectMake(CGRectGetMinX(self.biSaiTimeLab.frame) - 24, 11, 12, 12);
    self.visitTip.frame = CGRectMake(CGRectGetMaxX(self.biSaiTimeLab.frame) + 12, 11, 12, 12);
    CGFloat width = (RBScreenWidth - 160) * 0.5;
    self.hostNameLab.frame = CGRectMake(0, 34, width, 36);
    self.hostLogo.frame = CGRectMake(CGRectGetMaxX(self.hostNameLab.frame) + 8, 32, 40, 40);
    self.scoreLab.frame = CGRectMake(CGRectGetMaxX(self.hostLogo.frame), 45, 64, 18);
    self.visitLogo.frame = CGRectMake(CGRectGetMaxX(self.scoreLab.frame), 32, 40, 40);
    self.visitNameLab.frame = CGRectMake(CGRectGetMaxX(self.visitLogo.frame) + 8, 34, width, 36);
    self.line2.frame = CGRectMake(16, CGRectGetMaxY(self.visitNameLab.frame) + 14, RBScreenWidth - 32, 1);
    self.firstChose.frame = CGRectMake(0, CGRectGetMaxY(self.line2.frame) + 35, 37, 25);
    self.secondChose.frame = CGRectMake(0, CGRectGetMaxY(self.line2.frame) + 35, 37, 25);
    self.img.frame = CGRectMake(RBScreenWidth - 33, CGRectGetMaxY(self.line2.frame), 33, 36);
    self.titleLabel.frame = CGRectMake(16, CGRectGetMaxY(self.line2.frame) + 16, 60, 22);
    [self.titleLabel sizeToFit];
    self.topLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 8, CGRectGetMaxY(self.line2.frame) + 16, RBScreenWidth - 120, 17);
    if (self.predictModel.style == 2) {
        self.winTip.frame = CGRectMake(41, 180, 6, 6);
        self.winLabel.frame = CGRectMake(CGRectGetMaxX(self.winTip.frame) + 4, 166, 110, 28);
        self.flatTip.frame = CGRectMake(156, 180, 6, 6);
        self.flatLabel.frame = CGRectMake(CGRectGetMaxX(self.flatTip.frame) + 4, 166, RBScreenWidth - 265, 28);
        self.negativeTip.frame = CGRectMake(RBScreenWidth - 105, 180, 6, 6);
        self.negativeLabel.frame = CGRectMake(CGRectGetMaxX(self.negativeTip.frame) + 4, 166, 95, 28);

        CGFloat w0 = [self.predictModel.shengps[0]floatValue];
        CGFloat w1 = [self.predictModel.shengps[1]floatValue];
        CGFloat w2 = [self.predictModel.shengps[2]floatValue];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:self.predictModel.shengps];
        CGFloat max = MAX(MAX(w0, w1), w2);
        CGFloat min = MIN(MIN(w0, w1), w2);
        int m = 0, n = 0;
        for (int i = 0; i < 3; i++) {
            if (max == [self.predictModel.shengps[i]floatValue]) {
                m = i;
            }
            if (min == [self.predictModel.shengps[i]floatValue]) {
                n = i;
            }
        }
        NSString *temp = mutArr[m];
        mutArr[m] = mutArr[n];
        mutArr[n] = temp;
        int win        = ([mutArr[0]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
        int flat = ([mutArr[1]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
        self.progress.first = (win / 100.0);
        self.progress.second = flat / 100.0;
        self.progress.type = 1;
        [self.progress changsize];
        NSMutableArray *mutArr2 = [NSMutableArray array];
        [mutArr2 addObject:@(win)];
        [mutArr2 addObject:@(flat)];
        [mutArr2 addObject:@(100 - (win + flat))];

        CGFloat max2 = MAX(MAX(win, flat), 100 - (win + flat));
        CGFloat min2 =  MIN(MIN(win, flat), 100 - (win + flat));

        int m2 = 0, c2 = 0;
        for (int i = 0; i < 3; i++) {
            if (max2 <= [mutArr2[i]floatValue] + 0.00001 && max2 >= [mutArr2[i]floatValue] - 0.00001) {
                m2 = i;
            } else if (min2 <= [mutArr2[i]floatValue] + 0.00001 && min2 >= [mutArr2[i]floatValue] - 0.00001) {
            } else {
                c2 = i;
            }
        }
        if (m2 == 0) {
            self.firstChose.centerX = ((RBScreenWidth - 32) * self.progress.first) * 0.5 + 16;
        } else if (m2 == 1) {
            self.firstChose.centerX = ((RBScreenWidth - 32) * self.progress.second) * 0.5 + 16 + (RBScreenWidth - 32) * self.progress.first;
        } else {
            self.firstChose.centerX = ((RBScreenWidth - 32) * (1 - self.progress.second - self.progress.first)) * 0.5 + 16 + (RBScreenWidth - 32) * (self.progress.first + self.progress.second);
        }
        if (c2 == 0) {
            self.secondChose.centerX = ((RBScreenWidth - 32) * self.progress.first) * 0.5 + 16;
        } else if (c2 == 1) {
            self.secondChose.centerX = ((RBScreenWidth - 32) * self.progress.second) * 0.5 + 16 + (RBScreenWidth - 32) * self.progress.first;
        } else {
            self.secondChose.centerX = ((RBScreenWidth - 32) * (1 - self.progress.second - self.progress.first)) * 0.5 + 16 + (RBScreenWidth - 32) * (self.progress.first + self.progress.second);
        }
    } else {
        self.winTip.frame = CGRectMake(41, 180, 6, 6);
        self.winLabel.frame = CGRectMake(CGRectGetMaxX(self.winTip.frame) + 4, 166, RBScreenWidth - 190, 28);
        self.negativeTip.frame = CGRectMake(RBScreenWidth - 145, 180, 6, 6);
        self.negativeLabel.frame = CGRectMake(CGRectGetMaxX(self.negativeTip.frame) + 4, 166, 140, 28);
        if (self.predictModel.style == 1) {
            int negative = ([self.predictModel.rangqiuArr[0]floatValue] * 100) / (([self.predictModel.rangqiuArr[0]floatValue] + [self.predictModel.rangqiuArr[2]floatValue]) * 100) * 100;
            int win = 100 - negative;
            if (win == 50) {
                if (negative > 50.0) {
                    win = 49;
                } else {
                    win = 51;
                }
            }
            self.progress.second = 1 - win / 100.0;
            self.progress.first = win / 100.0;
            self.progress.type = 0;
            [self.progress changsize];
        } else {
            int negative = ([self.predictModel.daxiao[0]floatValue] * 100) / (([self.predictModel.daxiao[0]floatValue] + [self.predictModel.daxiao[2]floatValue]) * 100) * 100;
            int win = 100 - negative;
            if (win == 50) {
                if (negative > 50.0) {
                    win = 49;
                } else {
                    win = 51;
                }
            }
            self.progress.second = 1 - win / 100.0;
            self.progress.first = win / 100.0;
            self.progress.type = 0;
            [self.progress changsize];
        }
    }
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBMyPredictCell";
    RBMyPredictCell *cell = (RBMyPredictCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setPredictModel:(RBPredictModel *)predictModel {
    _predictModel = predictModel;
    if (predictModel.state >= 2 && predictModel.state <= 8) {
        self.scoreLab.text = [NSString stringWithFormat:@"%d:%d", predictModel.zhufen, predictModel.kefen];
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else {
        self.scoreLab.text = @"-";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    }
    self.eventNameLab.text = predictModel.name[0];
    self.biSaiTimeLab.text = [NSString getStrWithDateInt:predictModel.startt andFormat:@"M月d日 HH:mm"];
    self.hostNameLab.text = predictModel.zhuname[0];
    self.visitNameLab.text = predictModel.kename[0];
    self.flatLabel.hidden = (predictModel.style != 2);
    self.flatTip.hidden = (predictModel.style != 2);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.zhulogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            self.hostLogo.image = image;
        } else {
            [self.hostLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.zhulogo] ] placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.zhulogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];

    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.kelogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            self.visitLogo.image = image;
        } else {
            [self.visitLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.kelogo]] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.kelogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];

    self.img.hidden = (predictModel.state != 8);
    self.firstChose.hidden = (predictModel.style != 2);
    self.secondChose.hidden =  (predictModel.style != 2);
    if (predictModel.style == 1) {
        self.titleLabel.text = rangqiu;
        if (predictModel.rqresult == 1) {
            self.img.image = [UIImage imageNamed:@"correct"];
        } else if (predictModel.rqresult == 2) {
            self.img.image = [UIImage imageNamed:@"error"];
        } else if (predictModel.rqresult == 3) {
            self.img.image = [UIImage imageNamed:@"wrong"];
        }
        self.topLabel.text = @"";
        int negative = ([predictModel.rangqiuArr[0]floatValue] * 100) / (([predictModel.rangqiuArr[0]floatValue] + [predictModel.rangqiuArr[2]floatValue]) * 100) * 100;
        int win = 100 - negative;
        if (win == 50) {
            if (negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }

        self.winLabel.text = [NSString stringWithFormat:@"主胜概率 %d%%", win];
        self.negativeLabel.text = [NSString stringWithFormat:@"客胜概率 %d%%", negative];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.winLabel.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(4, self.winLabel.text.length - 4)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(4, self.winLabel.text.length - 5)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.negativeLabel.text.length - 1, 1)];
        self.winLabel.attributedText = AttributedStr;

        NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.negativeLabel.text];
        [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(4, self.negativeLabel.text.length - 4)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(4, self.negativeLabel.text.length - 5)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.negativeLabel.text.length - 1, 1)];
        self.negativeLabel.attributedText = AttributedStr2;
    } else if (predictModel.style == 2) {
        if (predictModel.spsresult == 1) {
            self.img.image = [UIImage imageNamed:@"correct"];
        } else if (predictModel.spsresult == 2) {
            self.img.image = [UIImage imageNamed:@"error"];
        } else if (predictModel.spsresult == 3) {
            self.img.image = [UIImage imageNamed:@"wrong"];
        }

        CGFloat w0 = [predictModel.shengps[0]floatValue];
        CGFloat w1 = [predictModel.shengps[1]floatValue];
        CGFloat w2 = [predictModel.shengps[2]floatValue];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:predictModel.shengps];
        CGFloat max = MAX(MAX(w0, w1), w2);
        CGFloat min = MIN(MIN(w0, w1), w2);
        int m = 0, n = 0;
        for (int i = 0; i < 3; i++) {
            if (max == [predictModel.shengps[i]floatValue]) {
                m = i;
            }
            if (min == [predictModel.shengps[i]floatValue]) {
                n = i;
            }
        }
        NSString *temp = mutArr[m];
        mutArr[m] = mutArr[n];
        mutArr[n] = temp;
        int win        = ([mutArr[0]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
        int flat = ([mutArr[1]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
        int negative = ([mutArr[2]floatValue] * 100) / (([mutArr[0]floatValue] + [mutArr[1]floatValue] + [mutArr[2]floatValue]) * 100) * 100;
        int min2 =  MIN(MIN(win, flat), negative);

        NSMutableArray *mutArr2 = [NSMutableArray array];
        [mutArr2 addObject:@(win)];
        [mutArr2 addObject:@(flat)];
        [mutArr2 addObject:@(100 - (win + flat))];

        NSMutableArray *result = [NSMutableArray array];
        CGFloat minR = 100.0;
        int m2 = 0;
        for (int i = 0; i < 3; i++) {
            if (min2 == [mutArr2[i]floatValue]) {
                [result addObject:@((int)floor([mutArr2[i]floatValue]))];
                m2 = i;
            } else {
                minR = minR - (int)ceil([mutArr2[i]floatValue]);
                [result addObject:@((int)ceil([mutArr2[i]floatValue]))];
            }
        }
        result[m2] = @(minR);

        self.winLabel.text = [NSString stringWithFormat:@"胜 %@%%", result[0]];
        self.flatLabel.text = [NSString stringWithFormat:@"平 %@%%", result[1]];
        self.negativeLabel.text = [NSString stringWithFormat:@"负 %@%%", result[2]];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.winLabel.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(1, self.winLabel.text.length - 1)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1, self.winLabel.text.length - 2)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.winLabel.text.length - 1, 1)];
        self.winLabel.attributedText = AttributedStr;

        NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.flatLabel.text];
        [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(1, self.flatLabel.text.length - 1)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1, self.flatLabel.text.length - 2)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.flatLabel.text.length - 1, 1)];
        self.flatLabel.attributedText = AttributedStr2;

        NSMutableAttributedString *AttributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.negativeLabel.text];
        [AttributedStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(1, self.negativeLabel.text.length - 1)];
        [AttributedStr3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1, self.negativeLabel.text.length - 2)];
        [AttributedStr3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.negativeLabel.text.length - 1, 1)];
        self.negativeLabel.attributedText = AttributedStr3;
        self.titleLabel.text = shengpingfu;
        CGFloat disCount = [predictModel.shengps[1] doubleValue];
        if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
            if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                if (disCount > 0) {
                    self.topLabel.text = [NSString stringWithFormat:@"主让 %0.0f", disCount];
                } else if (disCount == 0) {
                    self.topLabel.text = [NSString stringWithFormat:@"%0.0f", disCount];
                } else {
                    self.topLabel.text = [NSString stringWithFormat:@"客让 %0.0f", -disCount];
                }
            } else {
                if (disCount > 0) {
                    self.topLabel.text = [NSString stringWithFormat:@"主让 %0.1f", disCount];
                } else if (disCount == 0) {
                    self.topLabel.text = [NSString stringWithFormat:@"%0.1f", disCount];
                } else {
                    self.topLabel.text = [NSString stringWithFormat:@"客让 %0.1f", -disCount];
                }
            }
        } else {
            CGFloat bigDisCount;
            NSString *str = @"";
            if (disCount > 0) {
                str = [str stringByAppendingString:@"主让 "];
                bigDisCount = disCount;
            } else {
                str = [str stringByAppendingString:@"客让 "];
                bigDisCount = -disCount;
            }
            if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"%@%0.0f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"%@%0.0f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"%@%0.1f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else {
                self.topLabel.text = [NSString stringWithFormat:@"%@%0.1f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            }
        }
    } else {
        int negative = ([predictModel.daxiao[0]floatValue] * 100) / (([predictModel.daxiao[0]floatValue] + [predictModel.daxiao[2]floatValue]) * 100) * 100;
        int win = 100 - negative;
        if (win == 50) {
            if (negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }
        if (predictModel.dxresult == 1) {
            self.img.image = [UIImage imageNamed:@"correct"];
        } else if (predictModel.dxresult == 2) {
            self.img.image = [UIImage imageNamed:@"error"];
        } else if (predictModel.dxresult == 3) {
            self.img.image = [UIImage imageNamed:@"wrong"];
        }
        self.winLabel.text = [NSString stringWithFormat:@"大球概率 %d%%", win];
        self.negativeLabel.text = [NSString stringWithFormat:@"小球概率 %d%%", negative];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.winLabel.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(4, self.winLabel.text.length - 4)];
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(4, self.winLabel.text.length - 4)];
        self.winLabel.attributedText = AttributedStr;

        NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.negativeLabel.text];
        [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#213A4B"] range:NSMakeRange(4, self.negativeLabel.text.length - 4)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(4, self.negativeLabel.text.length - 5)];
        [AttributedStr2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(self.negativeLabel.text.length - 1, 1)];
        self.negativeLabel.attributedText = AttributedStr2;
        self.titleLabel.text = daxiaoqiu;
        if ([RBFloatOption judgeDivisibleWithFirstNumber:[predictModel.daxiao[1] doubleValue] andSecondNumber:0.5]) {
            self.topLabel.text = [NSString stringWithFormat:@"大小球 %@球", [NSString formatFloat:[predictModel.daxiao[1] doubleValue]]];
        } else {
            CGFloat bigDisCount = [predictModel.daxiao[1] doubleValue];
            if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"大小球 %0.0f/%0.0f球", bigDisCount - 0.25, bigDisCount + 0.25];
            } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"大小球 %0.0f/%0.1f球", bigDisCount - 0.25, bigDisCount + 0.25];
            } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.topLabel.text = [NSString stringWithFormat:@"大小球 %0.1f/%0.0f球", bigDisCount - 0.25, bigDisCount + 0.25];
            } else {
                self.topLabel.text = [NSString stringWithFormat:@"大小球 %0.1f/%0.1f球", bigDisCount - 0.25, bigDisCount + 0.25];
            }
        }
    }
}

@end
