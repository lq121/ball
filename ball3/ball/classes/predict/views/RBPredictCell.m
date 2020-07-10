#import "RBPredictCell.h"
#import "RBFloatOption.h"

@interface RBPredictCell ()
/// 线
@property (nonatomic, strong) UIView *line;
/// 内容
@property (nonatomic, strong) UIView *centerView;
/// 赛事名
@property (nonatomic, strong) UILabel *eventNameLab;
/// 比赛时间
@property (nonatomic, strong) UILabel *biSaiTimeLab;
/// 情报
@property (nonatomic, strong) UILabel *infoLab;
/// 主队名
@property (nonatomic, strong) UILabel *hostNameLab;
/// 主队logo
@property (nonatomic, strong) UIImageView *hostLogo;
/// 客队名
@property (nonatomic, strong) UILabel *visitNameLab;
/// 客队logo
@property (nonatomic, strong) UIImageView *visitLogo;
/// 比分
@property (nonatomic, strong) UILabel *scoreLab;
/// 亚盘
@property (nonatomic, strong) UILabel *yaLab;

/// 大小
@property (nonatomic, strong) UILabel *bigLab;
@end

@implementation RBPredictCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIView *line = [[UIView alloc]init];
        self.line = line;
        [self addSubview:line];

        UIView *centerView = [[UIView alloc]init];
        centerView.backgroundColor = [UIColor whiteColor];
        self.centerView = centerView;
        [self addSubview:centerView];

        UILabel *eventNameLab = [[UILabel alloc]init];
        self.eventNameLab = eventNameLab;
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextAlignmentLeft;
        [centerView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        biSaiTimeLab.font = [UIFont systemFontOfSize:12];
        biSaiTimeLab.textAlignment = NSTextAlignmentLeft;
        [centerView addSubview:biSaiTimeLab];

        UILabel *infoLab = [[UILabel alloc]init];
        self.infoLab = infoLab;
        infoLab.text = qingbaoStr;
        infoLab.textColor = [UIColor whiteColor];
        infoLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF4F72"];
        infoLab.font = [UIFont boldSystemFontOfSize:10];
        infoLab.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:infoLab];

        UILabel *hostNameLab = [[UILabel alloc]init];
        hostNameLab.numberOfLines = 0;
        self.hostNameLab = hostNameLab;
        hostNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostNameLab.font = [UIFont boldSystemFontOfSize:14];
        hostNameLab.textAlignment = NSTextAlignmentRight;
        [centerView addSubview:hostNameLab];

        UIImageView *hostLogo = [[UIImageView alloc]init];
        self.hostLogo = hostLogo;
        [centerView addSubview:hostLogo];

        UILabel *visitNameLab = [[UILabel alloc]init];
        visitNameLab.numberOfLines = 0;
        self.visitNameLab = visitNameLab;
        visitNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        visitNameLab.font = [UIFont boldSystemFontOfSize:14];
        visitNameLab.textAlignment = NSTextAlignmentLeft;
        [centerView addSubview:visitNameLab];

        UILabel *scoreLab = [[UILabel alloc]init];
        self.scoreLab = scoreLab;
        scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        scoreLab.font = [UIFont boldSystemFontOfSize:20];
        scoreLab.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:scoreLab];

        UIImageView *visitLogo = [[UIImageView alloc]init];
        self.visitLogo = visitLogo;
        [centerView addSubview:visitLogo];

        UILabel *yaLab = [[UILabel alloc]init];
        self.yaLab = yaLab;
        yaLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        yaLab.backgroundColor = [UIColor colorWithSexadeString:@"#EEEEEE"];
        yaLab.font = [UIFont systemFontOfSize:12];
        yaLab.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:yaLab];

        UILabel *bigLab = [[UILabel alloc]init];
        self.bigLab = bigLab;
        bigLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        bigLab.backgroundColor = [UIColor colorWithSexadeString:@"#EEEEEE"];
        bigLab.font = [UIFont systemFontOfSize:12];
        bigLab.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:bigLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.line.frame = CGRectMake(12, 0, RBScreenWidth - 12, 2);
    self.centerView.frame = CGRectMake(12, 2, RBScreenWidth - 12, 111);
    self.eventNameLab.frame = CGRectMake(8, 4, 120, 17);
    NSString *str = self.biSaiTimeLab.text;
    if (![str containsString:@"'"]) {
        str = [NSString stringWithFormat:@"%@'", str];
    }

    self.biSaiTimeLab.frame = CGRectMake((RBScreenWidth - [str getLineSizeWithFontSize:12].width - 20) * 0.5, 4, [str getLineSizeWithFontSize:12].width + 8, 14);
    self.infoLab.frame = CGRectMake(RBScreenWidth - 52, 4, 28, 16);
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    if (isVip != 2) {
        self.infoLab.hidden = YES;
    }
    CGFloat width = (RBScreenWidth - 204) * 0.5;
    self.hostNameLab.frame = CGRectMake(12, 30, width, 36);
    self.hostLogo.frame = CGRectMake(CGRectGetMaxX(self.hostNameLab.frame) + 8, 28, 40, 40);
    self.scoreLab.frame = CGRectMake(CGRectGetMaxX(self.hostLogo.frame), 41, 64, 18);
    self.visitLogo.frame = CGRectMake(CGRectGetMaxX(self.scoreLab.frame), 28, 40, 40);
    self.visitNameLab.frame = CGRectMake(CGRectGetMaxX(self.visitLogo.frame) + 8, 30, width, 36);

    int count = 0;
    BOOL hasya = false;
    if (self.yaLab.hidden == NO) {
        count += 1;
        hasya = YES;
    }
    if (self.bigLab.hidden == NO) {
        count += 1;
    }
    if (count == 1) {
        if (hasya) {
            self.yaLab.frame = CGRectMake(0, 83, (RBScreenWidth - 12), 28);
        } else {
            self.bigLab.frame = CGRectMake(0, 83, (RBScreenWidth - 12), 28);
        }
    } else if (count == 2) {
        CGFloat width = (RBScreenWidth - 12 - 1) * 0.5;
        self.yaLab.frame = CGRectMake(0, 83, width, 28);
        self.bigLab.frame = CGRectMake(CGRectGetMaxX(self.yaLab.frame) + 1, 83, width, 28);
    }
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBPredictCell";
    RBPredictCell *cell = (RBPredictCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setPredictModel:(RBPredictModel *)predictModel {
    _predictModel = predictModel;
    if (predictModel.state >= 2 && predictModel.state <= 8) {
        self.line.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
        self.scoreLab.text = [NSString stringWithFormat:@"%d:%d", predictModel.zhufen, predictModel.kefen];
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else {
        self.line.backgroundColor = [UIColor colorWithSexadeString:@"#EEEEEE"];
        self.scoreLab.text = @"-";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    }
    self.infoLab.hidden = (predictModel.qingbao != 1);
    NSString *teeTimeStr;
    if (predictModel.state == 2) {
        // 上半场
        teeTimeStr = [NSString stringWithFormat:@"%@%@", shangbanchang, [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:predictModel.startballt]];
    } else if (predictModel.state == 3) {
        teeTimeStr = @"中";
    } else if (predictModel.state >= 4 && predictModel.state <= 7) {
        long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:predictModel.startballt] longLongValue];
        if (timeCount + 45 > 90) {
            teeTimeStr = xiabanchangjia;
        } else {
            teeTimeStr = [NSString stringWithFormat:@"%@%ld", xiabanchang, timeCount + 45];
        }
    } else if (predictModel.state   == 8) {
        teeTimeStr = wan;
    } else if (predictModel.state  == 1) {
        teeTimeStr = [NSString getComperStrWithDateInt:predictModel.startt andFormat:@"HH:mm"];
    } else if (predictModel.state > 8 || predictModel.state == 0) {
        teeTimeStr = yanci;
    }
    self.biSaiTimeLab.text = teeTimeStr;
    if ([self.biSaiTimeLab.text isEqualToString:yanci]) {
        [self.biSaiTimeLab sizeToFit];
        self.biSaiTimeLab.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLab.textColor = [UIColor whiteColor];
        self.biSaiTimeLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLab.layer.masksToBounds = YES;
        self.biSaiTimeLab.layer.cornerRadius = 1;
    } else {
        self.biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLab.backgroundColor = [UIColor clearColor];
        self.biSaiTimeLab.textAlignment = NSTextAlignmentLeft;
        self.biSaiTimeLab.layer.masksToBounds = NO;
        self.biSaiTimeLab.layer.cornerRadius = 0;
    }

    if (predictModel.state == 2 || predictModel.state == 4) {
        if (predictModel.show) {
            if (![teeTimeStr containsString:@"'"]) {
                teeTimeStr = [NSString stringWithFormat:@"%@'", teeTimeStr];
            }
        } else {
            if ([teeTimeStr containsString:@"'"]) {
                teeTimeStr = [teeTimeStr substringToIndex:teeTimeStr.length - 1];
            }
        }
        self.biSaiTimeLab.text = teeTimeStr;
        self.biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
    }

    self.eventNameLab.text = predictModel.name[0];
    self.hostNameLab.text = predictModel.zhuname[0];
    self.visitNameLab.text = predictModel.kename[0];
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
            [self.visitLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.kelogo]] placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.kelogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];

    if (predictModel.rangqiuArr != nil && predictModel.rangqiuArr.count >= 3) {
        self.yaLab.hidden = NO;
        float disCount =  [predictModel.rangqiuArr[1] floatValue];
        if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
            if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                if (disCount > 0) {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 主让 %0.0f", disCount];
                } else if (disCount == 0) {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 %0.0f", disCount];
                } else {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 客让 %0.0f", -disCount];
                }
            } else {
                if (disCount > 0) {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 主让 %0.1f", disCount];
                } else if (disCount == 0) {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 %0.1f", disCount];
                } else {
                    self.yaLab.text = [NSString stringWithFormat:@"亚盘 客让 %0.1f", -disCount];
                }
            }
        } else {
            NSString *str = @"亚盘 ";
            CGFloat bigDisCount;
            if (disCount > 0) {
                str = [str stringByAppendingString:@"主让 "];
                bigDisCount = disCount;
            } else {
                str = [str stringByAppendingString:@"客让 "];
                bigDisCount = -disCount;
            }
            if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.yaLab.text = [NSString stringWithFormat:@"%@%0.0f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.yaLab.text = [NSString stringWithFormat:@"%@%0.0f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                self.yaLab.text = [NSString stringWithFormat:@"%@%0.1f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            } else {
                self.yaLab.text = [NSString stringWithFormat:@"%@%0.1f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
            }
        }
    } else {
        self.yaLab.hidden = YES;
    }
    if (predictModel.daxiao != nil && predictModel.daxiao.count >= 3 && ![predictModel.daxiao[0] isKindOfClass:[NSNull class]]) {
        self.bigLab.hidden = NO;
        self.bigLab.text = [NSString stringWithFormat:@"大小球 %@球",  [NSString formatFloat:[ predictModel.daxiao[1] doubleValue]]];
    } else {
        self.bigLab.hidden = YES;
    }
}

@end
