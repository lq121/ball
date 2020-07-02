#import "RBNearCollectionCell.h"

@interface RBNearCollectionCell()
/// 赛事名
@property (nonatomic, strong) UILabel *eventNameLab;
/// 比赛时间
@property (nonatomic, strong) UILabel *biSaiTimeLab;
/// 球队名
@property (nonatomic, strong) UILabel *teamNameLab;
/// 预测view
@property (nonatomic, strong) UIView *predictView;
/// 预测类型
@property (nonatomic, strong) UILabel *predictLab;
/// 预测结果
@property (nonatomic, strong) UILabel *resultLab;
@end


@implementation RBNearCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor =  [UIColor colorWithSexadeString:@"#EAEAEA"].CGColor;

        UILabel *eventNameLab = [[UILabel alloc]init];
        self.eventNameLab = eventNameLab;
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        biSaiTimeLab.font = [UIFont systemFontOfSize:12];
        biSaiTimeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:biSaiTimeLab];

        UILabel *teamNameLab = [[UILabel alloc]init];
        teamNameLab.numberOfLines = 0;
        self.teamNameLab = teamNameLab;
        teamNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        teamNameLab.font = [UIFont boldSystemFontOfSize:14];
        teamNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:teamNameLab];

        UIView *predictView = [[UIView alloc]init];
        self.predictView = predictView;
        [self.contentView addSubview:predictView];

        UILabel *predictLab = [[UILabel alloc]init];
        self.predictLab = predictLab;
        predictLab.textColor = [UIColor whiteColor];
        predictLab.font = [UIFont systemFontOfSize:12];
        predictLab.textAlignment = NSTextAlignmentLeft;
        [predictView addSubview:predictLab];
        UILabel *resultLab = [[UILabel alloc]init];

        self.resultLab = resultLab;
        resultLab.textColor = [UIColor whiteColor];
        resultLab.font = [UIFont systemFontOfSize:12];
        resultLab.textAlignment = NSTextAlignmentRight;
        [predictView addSubview:resultLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.eventNameLab.frame = CGRectMake(8, 8, 150, 17);

    self.teamNameLab.frame = CGRectMake(8, CGRectGetMaxY(self.eventNameLab.frame) + 4, self.width - 16, 34);
    self.predictView.frame = CGRectMake(0, CGRectGetMaxY(self.teamNameLab.frame) + 8, self.width, 28);
    self.predictLab.frame = CGRectMake(8, 6, self.width - 40, 17);
    self.resultLab.frame = CGRectMake(self.width - 32, 6, 24, 17);
}

- (void)setPredictModel:(RBPredictModel *)predictModel{
    _predictModel = predictModel;
    self.eventNameLab.text = predictModel.name[0];
    self.teamNameLab.text = [NSString stringWithFormat:@"%@ VS %@", predictModel.zhuname[0], predictModel.kename[0]];
    self.biSaiTimeLab.text = [NSString getComperStrWithDateInt:predictModel.startt andFormat:@"HH:mm"];
    self.biSaiTimeLab.frame = CGRectMake(self.width - [self.biSaiTimeLab.text getLineSizeWithFontSize:12].width - 8, 10, [self.biSaiTimeLab.text getLineSizeWithFontSize:12].width, 14);
    if (predictModel.Result == 1 || predictModel.Result == 11 || predictModel.Result == 21) {
        int negative = ([predictModel.rangqiu[0]floatValue] * 100) / (([predictModel.rangqiu[0]floatValue] + [predictModel.rangqiu[2]floatValue]) * 100) * 100;

        int win = 100 - negative;
        if (win == 50) {
            if (negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }
        if (win > negative) {
            self.predictLab.text = [NSString stringWithFormat:@"让球-主胜：%d%%", win];
        } else {
            self.predictLab.text = [NSString stringWithFormat:@"让球-客胜：%d%%", negative];
        }
        if (predictModel.Result == 1) {
            self.resultLab.text = @"准";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        } else if (predictModel.Result == 11) {
            self.resultLab.text = @"走";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        } else {
            self.resultLab.text = @"错";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#BEBEBE"];
        }
    } else if (predictModel.Result == 2 || predictModel.Result == 22) {
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
        int max2 = MAX(MAX(win, flat), negative);
        int min2 =  MIN(MIN(win, flat), negative);
        self.predictLab.text = [NSString stringWithFormat:@"首选：%d%% 次选：%d%%", max2, 100 - max2 - min2];
        if (predictModel.Result == 2) {
            self.resultLab.text = @"准";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        } else {
            self.resultLab.text = @"错";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#BEBEBE"];
        }
    } else if (predictModel.Result == 3 || predictModel.Result == 23) {
        int negative = ([predictModel.daxiao[0]floatValue] * 100) / (([predictModel.daxiao[0]floatValue] + [predictModel.daxiao[2]floatValue]) * 100) * 100;
        int win = 100 - negative;
        if (win == 50) {
            if (negative > 50.0) {
                win = 49;
            } else {
                win = 51;
            }
        }
        if (win > negative) {
            self.predictLab.text = [NSString stringWithFormat:@"大小球-大球：%d%%", win];
        } else {
            self.predictLab.text = [NSString stringWithFormat:@"大小球-小球：%d%%", negative];
        }
        if (predictModel.Result == 3) {
            self.resultLab.text = @"准";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        } else {
            self.resultLab.text = @"错";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#BEBEBE"];
        }
    }
}


@end
