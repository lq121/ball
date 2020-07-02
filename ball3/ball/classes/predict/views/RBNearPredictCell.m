#import "RBNearPredictCell.h"


@interface RBNearPredictCell()
/// 线
@property (nonatomic, strong) UIView *line;
/// 赛事名
@property (nonatomic, strong) UILabel *eventNameLab;
/// 比赛时间
@property (nonatomic, strong) UILabel *biSaiTimeLab;
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
/// 预测view
@property (nonatomic, strong) UIView *predictView;
/// 预测类型  亚盘/ 欧盘/大小
@property (nonatomic, strong) UILabel *predictLab;
/// 预测结果
@property (nonatomic, strong) UILabel *resultLab;
@end

@implementation RBNearPredictCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self addSubview:line];

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
        biSaiTimeLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:biSaiTimeLab];

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
        visitNameLab.textAlignment = NSTextAlignmentLeft;
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
    self.line.frame = CGRectMake(0, 108, RBScreenWidth, 4);
    self.contentView.frame = CGRectMake(0, 0, RBScreenWidth, 108);
    self.eventNameLab.frame = CGRectMake(8, 4, 120, 17);
    self.biSaiTimeLab.frame = CGRectMake((RBScreenWidth - 80) * 0.5, 4, 80, 17);
    CGFloat width = (RBScreenWidth - 184) * 0.5;
    self.hostNameLab.frame = CGRectMake(12, 30, width, 36);
    self.hostLogo.frame = CGRectMake(CGRectGetMaxX(self.hostNameLab.frame) + 8, 28, 40, 40);
    self.scoreLab.frame = CGRectMake((RBScreenWidth - 64) * 0.5, 41, 64, 18);
    self.visitLogo.frame = CGRectMake(CGRectGetMaxX(self.scoreLab.frame), 28, 40, 40);
    self.visitNameLab.frame = CGRectMake(CGRectGetMaxX(self.visitLogo.frame) + 8, 30, width, 36);
    self.predictView.frame = CGRectMake(0, CGRectGetMaxY(self.visitNameLab.frame) + 13, RBScreenWidth, 28);
    self.predictLab.frame = CGRectMake(8, 6, self.width - 40, 17);
    self.resultLab.frame = CGRectMake(self.width - 32, 6, 24, 17);
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBNearPredictCell";
    RBNearPredictCell *cell = (RBNearPredictCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}



-(void)setPredictModel:(RBPredictModel *)predictModel{
    _predictModel = predictModel;
    if (predictModel.state >= 2 && predictModel.state <= 8) {
        self.scoreLab.text = [NSString stringWithFormat:@"%d:%d", predictModel.zhufen, predictModel.kefen];
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else {
        self.scoreLab.text = @"-";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    }
    self.biSaiTimeLab.text = [NSString getStrWithDateInt:predictModel.startt andFormat:@"H:mm"];
    self.eventNameLab.text = predictModel.name[0];
    self.hostNameLab.text = predictModel.zhuname[0];
    self.visitNameLab.text = predictModel.kename[0];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.zhulogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            self.hostLogo.image = image;
        } else {
            [self.hostLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, predictModel.zhulogo] ] placeholderImage:[UIImage imageNamed:@"user pic"]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
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
    if (predictModel.Result == 1 || predictModel.Result == 11 || predictModel.Result == 21)  {
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
        }else{
            self.resultLab.text = @"错";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#BEBEBE"];
        }
       
    } else if (predictModel.Result == 3 || predictModel.Result == 13) {
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
        }else{
            self.resultLab.text = @"错";
            self.predictView.backgroundColor = [UIColor colorWithSexadeString:@"#BEBEBE"];
        }
            
        
    }
}

@end
