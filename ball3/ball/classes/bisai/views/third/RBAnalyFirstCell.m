#import "RBAnalyFirstCell.h"
#import "RBAnalyzeTitleView.h"
#import "RBProgress.h"
#import "RBNetworkTool.h"
#import "RBToast.h"

@interface RBAnalyFirstCell ()
@property (nonatomic, strong) RBProgress *progress;
@property (nonatomic, strong) UILabel *winDetail;
@property (nonatomic, strong) UILabel *drawDetail;
@property (nonatomic, strong) UILabel *guestDetail;
@property (nonatomic, strong) RBAnalyzeTitleView *titleView;
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation RBAnalyFirstCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalyFirstCell";
    RBAnalyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"猜胜负" andFrame:CGRectMake(0, 0, RBScreenWidth, 46) andSecondTitle:@"" andDetail:@"0人参与" andFirstBtn:@"" andSecondBtn:@"" andClickFirstBtn:^(BOOL selected) {
        } andClickSecondBtn:^(BOOL selected) {
        }];
        self.titleView = titleView;
        [self addSubview:titleView];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, 46, RBScreenWidth - 32, 134)];
        self.whiteView = whiteView;
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 2;
        whiteView.layer.shadowOffset = CGSizeMake(0, 2);
        whiteView.layer.shadowOpacity = 1;
        whiteView.layer.shadowRadius = 10;
        [self addSubview:whiteView];

        RBProgress *progress = [[RBProgress alloc]initWithFrame:CGRectMake(22, 20, RBScreenWidth - 32 - 44, 12) andFirst:0 andSecond:0 andTip:@"" andType:0];
        self.progress = progress;
        [progress changsize];
        [whiteView addSubview:progress];

        CGFloat margin = (RBScreenWidth - 32 - 80 - 180) * 0.5;
        UILabel *winTitle = [[UILabel alloc]init];
        winTitle.text = @"主胜概率";
        winTitle.textAlignment = NSTextAlignmentLeft;
        winTitle.font = [UIFont systemFontOfSize:12];
        winTitle.frame = CGRectMake(30, 67, 50, 17);
        winTitle.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [whiteView addSubview:winTitle];

        UILabel *winDetail = [[UILabel alloc]init];
        self.winDetail = winDetail;
        winDetail.textAlignment = NSTextAlignmentLeft;
        winDetail.font = [UIFont boldSystemFontOfSize:22];
        winDetail.frame = CGRectMake(CGRectGetMaxX(winTitle.frame), 60, 60, 26);
        winDetail.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        [whiteView addSubview:winDetail];

        UILabel *drawTitle = [[UILabel alloc]init];
        drawTitle.text = @"平局";
        drawTitle.textAlignment = NSTextAlignmentLeft;
        drawTitle.font = [UIFont systemFontOfSize:12];
        drawTitle.frame = CGRectMake(40 + 60 + margin, 67, 26, 17);
        drawTitle.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [whiteView addSubview:drawTitle];

        UILabel *drawDetail = [[UILabel alloc]init];
        self.drawDetail = drawDetail;
        drawDetail.textAlignment = NSTextAlignmentLeft;
        drawDetail.font = [UIFont boldSystemFontOfSize:22];
        drawDetail.frame = CGRectMake(CGRectGetMaxX(drawTitle.frame) + 2, 60, 60, 26);
        drawDetail.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
        [whiteView addSubview:drawDetail];

        UILabel *guestTitle = [[UILabel alloc]init];
        guestTitle.text = @"客胜概率";
        guestTitle.textAlignment = NSTextAlignmentLeft;
        guestTitle.font = [UIFont systemFontOfSize:12];
        guestTitle.frame = CGRectMake(RBScreenWidth - 143, 67, 50, 17);
        guestTitle.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [whiteView addSubview:guestTitle];

        UILabel *guestDetail = [[UILabel alloc]init];
        self.guestDetail = guestDetail;
        guestDetail.textAlignment = NSTextAlignmentLeft;
        guestDetail.font = [UIFont boldSystemFontOfSize:22];
        guestDetail.frame = CGRectMake(CGRectGetMaxX(guestTitle.frame) + 2, 60, 60, 26);
        guestDetail.textColor = [UIColor colorWithSexadeString:@"#0FC6A6"];
        [whiteView addSubview:guestDetail];

        NSArray *colors = @[@"#FA7268", @"#FFA500", @"#0FC6A6"];
        for (int i = 0; i < colors.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40 + (margin + 60) * i, 96, 60, 24)];
            btn.tag = 300 + i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 12;
            btn.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:colors[i]]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:@"ding_selected"] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:@"ding"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
            [btn setTitle:@"已顶" forState:UIControlStateSelected];
            [btn setTitle:@"顶" forState:UIControlStateNormal];
            [btn setTitle:@"顶" forState:UIControlStateDisabled];
            [btn addTarget:self  action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:btn];
        }
    }
    return self;
}

- (void)clickTopBtn:(UIButton *)btn {
    UIButton *btn1 = [self.whiteView viewWithTag:300];
    UIButton *btn2 = [self.whiteView viewWithTag:301];
    UIButton *btn3 = [self.whiteView viewWithTag:302];
    if (btn1.selected || btn2.selected || btn3.selected) {
        [RBToast showWithTitle:@"您已经投过票"];
        return;
    }
    if (btn.selected == YES) {
        // 已赞
        return;
    }
    self.clickBtn(btn.tag);
    btn.selected = YES;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    UIButton *btn1 = [self.whiteView viewWithTag:300];
    UIButton *btn2 = [self.whiteView viewWithTag:301];
    UIButton *btn3 = [self.whiteView viewWithTag:302];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        btn1.enabled = NO;
        btn2.enabled = NO;
        btn3.enabled = NO;
    }
    if (dict == nil) return;
    if ([dict[@"guessed"] longValue] != -1 && dict[@"guessed"] != nil) {
        if ([dict[@"guessed"]longValue] == 1) {
            btn1.selected = YES;
            [btn1 setImage:nil forState:UIControlStateNormal];
            [btn1 setImage:nil forState:UIControlStateSelected];
            btn2.enabled = NO;
            btn3.enabled = NO;
        } else if ([dict[@"guessed"] longValue] == 0 && dict[@"guessed"] != nil) {
            btn2.selected = YES;
            [btn2 setImage:nil forState:UIControlStateNormal];
            [btn2 setImage:nil forState:UIControlStateSelected];
            [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"ding_selected"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
            [btn3 setImage:[UIImage imageNamed:@"ding_selected"] forState:UIControlStateNormal];
        } else if ([dict[@"guessed"] longValue] == 2 && dict[@"guessed"] != nil) {
            btn3.selected = YES;
            [btn3 setImage:nil forState:UIControlStateNormal];
            [btn3 setImage:nil forState:UIControlStateSelected];
            [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"ding_selected"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"ding_selected"] forState:UIControlStateNormal];
        }
    } else if (self.gameStatus == 8) {
        btn1.enabled = NO;
        btn2.enabled = NO;
        btn3.enabled = NO;
    }
    NSDictionary *ok = dict[@"ok"];
    float Guesslose = [ok[@"Guesslose"]floatValue];
    float Guesstie = [ok[@"Guesstie"]floatValue];
    float Guesswin = [ok[@"Guesswin"]floatValue];
    self.titleView.detailTitle = [NSString stringWithFormat:@"%0.0f人参与", Guesslose + Guesstie + Guesswin];
    if (Guesswin != 0) {
        self.winDetail.text = [NSString stringWithFormat:@"%0.0f%%", (Guesswin / (Guesswin + Guesstie + Guesslose)) * 100.0];
    } else {
        self.winDetail.text = @"0%";
    }
    if (Guesstie != 0) {
        self.drawDetail.text = [NSString stringWithFormat:@"%0.0f%%", (Guesstie / (Guesswin + Guesstie + Guesslose)) * 100.0];
    } else {
        self.drawDetail.text = @"0%";
    }
    if (Guesslose != 0) {
        self.guestDetail.text = [NSString stringWithFormat:@"%0.0f%%", (Guesslose / (Guesswin + Guesstie + Guesslose)) * 100.0];
    } else {
        self.guestDetail.text = @"0%";
    }

    if (Guesstie == 0 && Guesslose == 0 && Guesswin == 0) {
        self.progress.type = 0;
    } else {
        self.progress.type = 1;
        self.progress.first = ((Guesswin * 100.0) ) / ((Guesswin + Guesstie + Guesslose) * 100.0);
        self.progress.second = ((Guesstie * 100.0)) / ((Guesswin + Guesstie + Guesslose) * 100.0);
    }
    [self.progress changsize];
}

@end
