#import "RBBiSaiCell.h"
#import "RBBiSaiDetailVC.h"
#import "RBLoginVC.h"
#import "RBChekLogin.h"
#import "RBNetworkTool.h"
#import "RBFMDBTool.h"
#import "RBFloatOption.h"

@interface RBBiSaiCell ()
/// 赛事名
@property (nonatomic, strong) UILabel *eventNameLab;
/// 开赛时间
@property (nonatomic, strong) UILabel *biSaiTimeLab;
/// 比赛时间
@property (nonatomic, strong) UILabel *statLab;
/// 情报
@property (nonatomic, strong) UILabel *infoLab;
/// 关注
@property (nonatomic, strong) UIButton *attentionBtn;
/// 主队黄牌
@property (nonatomic, strong) UILabel *yellowLab;
/// 主队红牌
@property (nonatomic, strong) UILabel *redLab;
/// 客队黄牌
@property (nonatomic, strong) UILabel *vyellowLab;
/// 客队红牌
@property (nonatomic, strong) UILabel *vredLab;
/// 主队名称
@property (nonatomic, strong) UILabel *hostNameLab;
/// 比分
@property (nonatomic, strong) UILabel *scoreLab;
/// 客队名称
@property (nonatomic, strong) UILabel *visitNameLab;
/// 半球，角球，点球信息
@property (nonatomic, strong) UILabel *cornerLab;
/// 分析按钮
@property (nonatomic, strong) UIButton *yuceBtn;
///积分赛名字
@property (nonatomic, strong) UILabel *jifenLab;
/// 线
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *shipingLab;
@property (nonatomic, strong) UILabel *dataLab;
@end

@implementation RBBiSaiCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBBiSaiCell";
    RBBiSaiCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *eventNameLab = [[UILabel alloc]init];
        self.eventNameLab = eventNameLab;
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#213A4B" AndAlpha:0.5];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#213A4B" AndAlpha:0.5];
        biSaiTimeLab.font = [UIFont systemFontOfSize:12];
        biSaiTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:biSaiTimeLab];

        UILabel *statLab = [[UILabel alloc]init];
        self.statLab = statLab;
        statLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
        statLab.font = [UIFont systemFontOfSize:12];
        statLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:statLab];

        UILabel *infoLab = [[UILabel alloc]init];
        infoLab.text = qingbaoStr;
        self.infoLab = infoLab;
        infoLab.textColor = [UIColor whiteColor];
        infoLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF4F72"];
        infoLab.font = [UIFont boldSystemFontOfSize:10];
        infoLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:infoLab];

        UILabel *shipingLab = [[UILabel alloc]init];
        shipingLab.text = shiping;
        self.shipingLab = shipingLab;
        shipingLab.textColor = [UIColor whiteColor];
        shipingLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF4F72"];
        shipingLab.font = [UIFont boldSystemFontOfSize:10];
        shipingLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:shipingLab];

        UIButton *attentionBtn = [[UIButton alloc]init];
        [attentionBtn addTarget:self action:@selector(clickAttentionBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.attentionBtn = attentionBtn;
        [attentionBtn setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
        [attentionBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateSelected];
        [self.contentView addSubview:attentionBtn];

        UILabel *yellowLab = [[UILabel alloc]init];
        self.yellowLab = yellowLab;
        yellowLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        yellowLab.textColor = [UIColor whiteColor];
        yellowLab.textAlignment = NSTextAlignmentCenter;
        yellowLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:yellowLab];
        yellowLab.hidden = YES;

        UILabel *redLab = [[UILabel alloc]init];
        self.redLab = redLab;
        redLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF3924"];
        redLab.textColor = [UIColor whiteColor];
        redLab.textAlignment = NSTextAlignmentCenter;
        redLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:redLab];
        redLab.hidden = YES;

        UILabel *hostNameLab = [[UILabel alloc]init];
        hostNameLab.numberOfLines = 0;
        self.hostNameLab = hostNameLab;
        hostNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostNameLab.textAlignment = NSTextAlignmentCenter;
        hostNameLab.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:hostNameLab];

        UILabel *scoreLab = [[UILabel alloc]init];
        self.scoreLab = scoreLab;
        scoreLab.textColor = [UIColor whiteColor];
        scoreLab.textAlignment = NSTextAlignmentCenter;
        scoreLab.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:scoreLab];

        UILabel *visitNameLab = [[UILabel alloc]init];
        visitNameLab.numberOfLines = 0;
        self.visitNameLab = visitNameLab;
        visitNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        visitNameLab.textAlignment = NSTextVerticalAlignmentMiddle;
        visitNameLab.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:visitNameLab];

        UILabel *vyellowLab = [[UILabel alloc]init];
        self.vyellowLab = vyellowLab;
        vyellowLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        vyellowLab.textColor = [UIColor whiteColor];
        vyellowLab.textAlignment = NSTextAlignmentCenter;
        vyellowLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:vyellowLab];
        vyellowLab.hidden = YES;

        UILabel *vredLab = [[UILabel alloc]init];
        self.vredLab = vredLab;
        vredLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF3924"];
        vredLab.textColor = [UIColor whiteColor];
        vredLab.textAlignment = NSTextAlignmentCenter;
        vredLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:vredLab];
        vredLab.hidden = YES;

        UILabel *jifenLab = [[UILabel alloc]init];
        self.jifenLab = jifenLab;
        jifenLab.textColor = [UIColor colorWithSexadeString:@"#213A4B" AndAlpha:0.5];
        jifenLab.textAlignment = NSTextAlignmentCenter;
        jifenLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:jifenLab];

        UILabel *cornerLab = [[UILabel alloc]init];
        self.cornerLab = cornerLab;
        cornerLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        cornerLab.textAlignment = NSTextAlignmentLeft;
        cornerLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:cornerLab];

        UILabel *dataLab = [[UILabel alloc]init];
        self.dataLab = dataLab;
        dataLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        dataLab.textAlignment = NSTextAlignmentRight;
        dataLab.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:dataLab];

        UIButton *yuceBtn = [[UIButton alloc]init];
        [yuceBtn setTitle:xiaoyingfengxi forState:UIControlStateNormal];
        [yuceBtn addTarget:self action:@selector(clickYuceBtn) forControlEvents:UIControlEventTouchUpInside];
        [yuceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        yuceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [yuceBtn setBackgroundImage:[UIImage imageNamed:@"btn／in yellow"] forState:UIControlStateNormal];
        self.yuceBtn = yuceBtn;
        [self.contentView addSubview:yuceBtn];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor =  [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)clickAttentionBtn:(UIButton *)btn {
    if ([RBChekLogin NotLogin]) {
        return;
    } else {
        self.clickAttentionBtn(self.biSaiModel.hasAttention);
    }
}

- (void)clickYuceBtn {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        RBLoginVC *loginVC = [[RBLoginVC alloc]init];
        loginVC.fromVC = [UIViewController getCurrentVC];
        [[UIViewController getCurrentVC].navigationController pushViewController:loginVC animated:YES];
    } else {
        RBBiSaiDetailVC *biSaiDeatilVC = [[RBBiSaiDetailVC alloc]init];
        biSaiDeatilVC.biSaiModel = self.biSaiModel;
        biSaiDeatilVC.index = 2;
        [[UIViewController getCurrentVC].navigationController pushViewController:biSaiDeatilVC animated:YES];
    }
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    self.attentionBtn.selected = biSaiModel.hasAttention;
    self.attentionBtn.userInteractionEnabled = (biSaiModel.status != 8);
    self.eventNameLab.text = biSaiModel.eventName;
    self.biSaiTimeLab.text = [NSString getStrWithDateInt:biSaiModel.biSaiTime andFormat:@"HH:mm"];
    self.statLab.text = biSaiModel.TeeTimeStr;
    self.infoLab.hidden = !biSaiModel.hasIntelligence;
    self.shipingLab.hidden = !biSaiModel.hasShiPing;
    self.scoreLab.text = [NSString stringWithFormat:@"%d:%d", biSaiModel.hostScore, biSaiModel.visitingScore];
    NSString *labStr = @"";
    labStr = [labStr stringByAppendingString:[NSString stringWithFormat:@"半:%d-%d", biSaiModel.hostHalfScore, biSaiModel.visitingHalfScore]];
    if (biSaiModel.hostCorner != -1 || biSaiModel.visitingCorner != -1) {
        labStr = [labStr stringByAppendingString:[NSString stringWithFormat:@" 角:%d-%d", biSaiModel.hostCorner, biSaiModel.visitingCorner]];
    }
    if (biSaiModel.hostPointScore != 0 && biSaiModel.visitingPointScore != 0) {
        labStr = [labStr stringByAppendingString:[NSString stringWithFormat:@" 点:%d-%d", biSaiModel.hostPointScore, biSaiModel.visitingPointScore]];
    }
    self.cornerLab.text = labStr;
    self.statLab.backgroundColor = [UIColor whiteColor];
    if (biSaiModel.status == 1) {
        self.statLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.cornerLab.hidden = YES;
        self.scoreLab.text = @"-";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.2];
    } else if (biSaiModel.status >= 2 && biSaiModel.status <= 7) {
        self.statLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
        self.cornerLab.hidden = NO;
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else if (biSaiModel.status == 8) {
        self.statLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.cornerLab.hidden = NO;
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else {
        self.statLab.textColor = [UIColor whiteColor];
        self.statLab.textAlignment = NSTextAlignmentCenter;
        self.statLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333"];
        self.cornerLab.hidden = YES;
        self.scoreLab.text = @"-";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.2];
    }
    self.scoreLab.frame = CGRectMake((RBScreenWidth - 67) * 0.5, 36, 67, 20);
    CGFloat width = (RBScreenWidth - 91) * 0.5;
    if (biSaiModel.hostYellowCard != 0) {
        width = width - 18;
        self.yellowLab.hidden = NO;
        self.yellowLab.text = [NSString stringWithFormat:@"%d", biSaiModel.hostYellowCard];
    } else {
        self.yellowLab.hidden = YES;
    }
    if (biSaiModel.hostRedCard != 0) {
        width = width - 18;
        self.redLab.hidden = NO;
        self.redLab.text = [NSString stringWithFormat:@"%d", biSaiModel.hostRedCard];
    } else {
        self.redLab.hidden = YES;
    }
    self.hostNameLab.text = biSaiModel.hostTeamName;
    self.visitNameLab.text = biSaiModel.visitingTeamName;
    CGSize hostNameSize = [self.hostNameLab.text getSizeWithFont:[UIFont boldSystemFontOfSize:14] andMaxWidth:width];
    self.hostNameLab.frame = CGRectMake((RBScreenWidth - 67) * 0.5 - hostNameSize.width, 29, hostNameSize.width, 36);
    if (biSaiModel.hostRedCard != 0) {
        self.redLab.frame = CGRectMake((RBScreenWidth - 67) * 0.5 - hostNameSize.width - 18, 0, 14, 18);
    } else {
        self.redLab.frame = CGRectMake((RBScreenWidth - 67) * 0.5 - hostNameSize.width, 0, 14, 18);
    }
    self.yellowLab.frame = CGRectMake(self.redLab.x - 20, 0, 14, 18);
    if (hostNameSize.height > 17) {
        // 换行
        self.yellowLab.y = self.hostNameLab.y;
        self.redLab.y = self.hostNameLab.y;
    } else {
        self.yellowLab.centerY = self.hostNameLab.centerY;
        self.redLab.centerY = self.hostNameLab.centerY;
    }

    CGFloat width2 = (RBScreenWidth - 91) * 0.5;
    if (biSaiModel.visitingYellowCard != 0) {
        width2 = width2 - 18;
        self.vyellowLab.hidden = NO;
        self.vyellowLab.text = [NSString stringWithFormat:@"%d", biSaiModel.visitingYellowCard];
    } else {
        self.vyellowLab.hidden = YES;
    }
    if (biSaiModel.visitingRedCard != 0) {
        width2 = width2 - 18;
        self.vredLab.hidden = NO;
        self.vredLab.text = [NSString stringWithFormat:@"%d", biSaiModel.visitingRedCard];
    } else {
        self.vredLab.hidden = YES;
    }
    CGSize visitNameSize = [self.visitNameLab.text getSizeWithFont:[UIFont boldSystemFontOfSize:14] andMaxWidth:width2];
    self.visitNameLab.frame = CGRectMake(CGRectGetMaxX(self.scoreLab.frame), 29, visitNameSize.width, 36);

    if (biSaiModel.visitingRedCard != 0) {
        self.vredLab.frame = CGRectMake(CGRectGetMaxX(self.visitNameLab.frame) + 2, 29, 14, 18);
    } else {
        self.vredLab.frame = CGRectMake(CGRectGetMaxX(self.visitNameLab.frame), 29, 0, 18);
    }
    self.vyellowLab.frame = CGRectMake(CGRectGetMaxX(self.vredLab.frame) + 4, 29, 14, 18);
    if (biSaiModel.ballData != nil && ![biSaiModel.ballData isKindOfClass:[NSNull class]] && biSaiModel.ballData.length > 0) {
        NSData *jsonData = [biSaiModel.ballData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSArray *D = (NSArray *)dic[@"d"];
        NSArray *R = (NSArray *)dic[@"r"];

        NSString *dataStr;
        if (![R isKindOfClass:[NSNull class]] && R != nil  && R != NULL && R.count >= 3) {
            CGFloat disCount = [R[1]floatValue];
            if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
                if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
                    if (disCount > 0) {
                        dataStr = [NSString stringWithFormat:@"主让 %0.0f", disCount];
                    } else if (disCount == 0) {
                        dataStr = [NSString stringWithFormat:@"%0.0f", disCount];
                    } else {
                        dataStr = [NSString stringWithFormat:@"客让 %0.0f", -disCount];
                    }
                } else {
                    if (disCount > 0) {
                        dataStr = [NSString stringWithFormat:@"主让 %0.1f", disCount];
                    } else if (disCount == 0) {
                        dataStr = [NSString stringWithFormat:@"%0.1f", disCount];
                    } else {
                        dataStr = [NSString stringWithFormat:@"客让 %0.1f", -disCount];
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
                    dataStr = [NSString stringWithFormat:@"%@%0.0f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    dataStr = [NSString stringWithFormat:@"%@%0.0f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    dataStr = [NSString stringWithFormat:@"%@%0.1f/%0.0f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    dataStr = [NSString stringWithFormat:@"%@%0.1f/%0.1f", str, bigDisCount - 0.25, bigDisCount + 0.25];
                }
            }
        }
        if (![D isKindOfClass:[NSNull class]] && D != nil  && D != NULL && D.count >= 3) {
            if (dataStr.length == 0) {
                dataStr = @"";
            }
            if ([RBFloatOption judgeDivisibleWithFirstNumber:[D[1]floatValue] andSecondNumber:0.5]) {
                dataStr = [NSString stringWithFormat:@"%@  %@球", dataStr, [NSString formatFloat:[D[1]floatValue]]];
            } else {
                CGFloat bigDisCount = [D[1]floatValue];
                if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    dataStr = [NSString stringWithFormat:@"%@  %0.0f/%0.0f球", dataStr, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    dataStr = [NSString stringWithFormat:@"%@  %0.0f/%0.1f球", dataStr, bigDisCount - 0.25, bigDisCount + 0.25];
                } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
                    dataStr = [NSString stringWithFormat:@"%@  %0.1f/%0.0f球", dataStr, bigDisCount - 0.25, bigDisCount + 0.25];
                } else {
                    dataStr = [NSString stringWithFormat:@"%@  %0.1f/%0.1f球", dataStr, bigDisCount - 0.25, bigDisCount + 0.25];
                }
            }
           
        }
        self.dataLab.text = dataStr;
    }
    if (visitNameSize.height > 17) {
        // 换行
        self.vyellowLab.y = self.visitNameLab.y;
        self.vredLab.y = self.visitNameLab.y;
    } else {
        self.vyellowLab.centerY = self.visitNameLab.centerY;
        self.vredLab.centerY = self.visitNameLab.centerY;
    }
    if (biSaiModel.stage != nil) {
        self.jifenLab.hidden = NO;
        NSString *str;
        if ([biSaiModel.stage[@"mode"] intValue] == 1) {
            // 积分
            str = @"积分赛-";
        } else {
            str = @"淘汰赛-";
        }
        if ([biSaiModel.stage[@"group_count"] intValue] != 0) {
            str = [NSString stringWithFormat:@"%@第%d组-", str, [biSaiModel.stage[@"group_count"] intValue]];
        }
        if ([biSaiModel.stage[@"round_count"] intValue] != 0) {
            str = [NSString stringWithFormat:@"%@第%d轮-", str, [biSaiModel.stage[@"round_count"] intValue]];
        }
        str = [NSString stringWithFormat:@"%@%@", str, biSaiModel.stage[@"name_zh"]];
        self.jifenLab.text = str;
    } else {
        self.jifenLab.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.eventNameLab.frame = CGRectMake(12, 8, 92, 17);
    [self.eventNameLab sizeToFit];
    self.biSaiTimeLab.frame = CGRectMake(CGRectGetMaxX(self.eventNameLab.frame) + 8, 6, 65, 17);
    NSString *str = self.statLab.text;
    if (self.biSaiModel.status == 2 || self.biSaiModel.status == 4) {
        if (![str containsString:@"'"]) {
            str = [NSString stringWithFormat:@"%@'", str];
        }
    }
    CGSize size = [str getLineSizeWithFontSize:12];
    if ([self.statLab.text isEqualToString:yanci]) {
        self.statLab.frame = CGRectMake((RBScreenWidth - size.width) * 0.5, 8, size.width + 8, 14);
        self.statLab.layer.masksToBounds = YES;
        self.statLab.layer.cornerRadius = 1;
        self.statLab.textAlignment = NSTextAlignmentCenter;
    } else {
        self.statLab.frame = CGRectMake((RBScreenWidth - size.width) * 0.5, 8, size.width, 14);
        self.statLab.textAlignment = NSTextAlignmentLeft;
        self.statLab.layer.masksToBounds = NO;
        self.statLab.layer.cornerRadius = 0;
    }

    self.attentionBtn.frame = CGRectMake(RBScreenWidth - 32, 4, 24, 24);
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    if (isVip != 2) {
        self.infoLab.hidden = YES;
    }

    self.infoLab.frame = CGRectMake(RBScreenWidth - 68, 8, 28, 16);
    if (!self.infoLab.hidden) {
        self.shipingLab.frame = CGRectMake(RBScreenWidth - 100, 8, 28, 16);
    } else {
        self.shipingLab.frame = CGRectMake(RBScreenWidth - 68, 8, 28, 16);
    }
    self.cornerLab.frame = CGRectMake(12, 88, (RBScreenWidth - 95) * 0.5, 12);
    self.dataLab.frame = CGRectMake((RBScreenWidth + 71) * 0.5, 88, (RBScreenWidth - 95) * 0.5, 12);
    self.jifenLab.frame = CGRectMake(0, 67, RBScreenWidth, 12);
    self.yuceBtn.frame = CGRectMake((RBScreenWidth - 71) * 0.5, 87, 71, 20);
    self.line.frame = CGRectMake(0, 107, RBScreenWidth, 4);
}

@end
