#import "RBBiSaiCell.h"
#import "RBBiSaiDetailVC.h"
#import "RBLoginVC.h"

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
@property (nonatomic, strong) UIImageView *attentionView;
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
/// 星期日期（当场比赛的顺序）
@property (nonatomic, strong) UILabel *weekLab;
/// 分析按钮
@property (nonatomic, strong) UIButton *yuceBtn;
///积分赛名字
@property (nonatomic, strong) UILabel *jifenLab;
/// 线
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *shipingLab;
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
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
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

        UIImageView *attentionView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoucang"]];
        self.attentionView = attentionView;
        [self.contentView addSubview:attentionView];

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

        UILabel *cornerLab = [[UILabel alloc]init];
        self.cornerLab = cornerLab;
        cornerLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        cornerLab.textAlignment = NSTextAlignmentCenter;
        cornerLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:cornerLab];

        UILabel *weekLab = [[UILabel alloc]init];
        self.weekLab = weekLab;
        weekLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        weekLab.textAlignment = NSTextAlignmentCenter;
        weekLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:weekLab];

        UIButton *yuceBtn = [[UIButton alloc]init];
        [yuceBtn setTitle:@"小应分析" forState:UIControlStateNormal];
        [yuceBtn addTarget:self action:@selector(clickYuceBtn) forControlEvents:UIControlEventTouchUpInside];
        [yuceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        yuceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [yuceBtn setBackgroundImage:[UIImage imageNamed:@"btn／in yellow"] forState:UIControlStateNormal];
        self.yuceBtn = yuceBtn;
        [self.contentView addSubview:yuceBtn];

        UILabel *jifenLab = [[UILabel alloc]init];
        self.jifenLab = jifenLab;
        jifenLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.1];
        jifenLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        jifenLab.textAlignment = NSTextAlignmentCenter;
        jifenLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:jifenLab];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor =  [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self.contentView addSubview:line];
    }
    return self;
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

    if (visitNameSize.height > 17) {
        // 换行
        self.vyellowLab.y = self.visitNameLab.y;
        self.vredLab.y = self.visitNameLab.y;
    } else {
        self.vyellowLab.centerY = self.visitNameLab.centerY;
        self.vredLab.centerY = self.visitNameLab.centerY;
    }
    self.weekLab.text = [NSString stringWithFormat:@"%@ %d", biSaiModel.week, biSaiModel.index];
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
    self.eventNameLab.frame = CGRectMake(8, 8, 92, 17);
    self.biSaiTimeLab.frame = CGRectMake(100, 8, 65, 17);
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
    CGFloat rigthW = RBScreenWidth - 8;
    self.attentionView.hidden = !self.biSaiModel.hasAttention;
    if(!self.attentionView.hidden){
        rigthW = RBScreenWidth - 20;
    }
    self.attentionView.frame = CGRectMake(rigthW, 8, 16, 15);
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    if (isVip != 2) {
        self.infoLab.hidden = YES;
    }
    if (!self.infoLab.hidden) {
         rigthW -= 32;
    }
    self.infoLab.frame = CGRectMake(rigthW, 8, 28, 16);
    if (!self.shipingLab.hidden) {
        rigthW -= 32;
    }
    self.shipingLab.frame = CGRectMake(rigthW, 8, 28, 16);
    self.cornerLab.frame = CGRectMake(0, 71, RBScreenWidth, 12);
    self.yuceBtn.frame = CGRectMake((RBScreenWidth - 91) * 0.5, 91, 96, 28);
    self.weekLab.frame = CGRectMake(12, 96, [self.weekLab.text getLineSizeWithFontSize:12].width, 17);
    if (self.biSaiModel.stage == nil) {
        self.line.frame = CGRectMake(0, 119, RBScreenWidth, 4);
        self.jifenLab.frame = CGRectZero;
    } else {
        self.line.frame = CGRectMake(0, 143, RBScreenWidth, 4);
        self.jifenLab.frame = CGRectMake(0, 119, RBScreenWidth, 24);
    }
}

@end
