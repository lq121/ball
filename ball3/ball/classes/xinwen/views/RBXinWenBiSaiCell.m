#import "RBXinWenBiSaiCell.h"
#import "RBLoginVC.h"
#import "RBChekLogin.h"
#import "RBBiSaiDetailVC.h"

@interface RBXinWenBiSaiCell ()
@property (nonatomic, strong) UILabel *eventNameLab;
@property (nonatomic, strong) UILabel *biSaiTimeLab;
@property (nonatomic, strong) UILabel *teamNameLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *yuceBtn;

@end

@implementation RBXinWenBiSaiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UILabel *eventNameLab = [[UILabel alloc]init];
        self.eventNameLab = eventNameLab;
        eventNameLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        eventNameLab.font = [UIFont systemFontOfSize:12];
        eventNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:eventNameLab];

        UILabel *biSaiTimeLab = [[UILabel alloc]init];
        self.biSaiTimeLab = biSaiTimeLab;
        biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        biSaiTimeLab.font = [UIFont systemFontOfSize:12];
        biSaiTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:biSaiTimeLab];

        UILabel *teamNameLab = [[UILabel alloc]init];
        self.teamNameLab = teamNameLab;
        teamNameLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        teamNameLab.font = [UIFont boldSystemFontOfSize:16];
        teamNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:teamNameLab];

        UIButton *yuceBtn = [[UIButton alloc]init];
        [yuceBtn addTarget:self  action:@selector(clickYuceBtn) forControlEvents:UIControlEventTouchUpInside];
        [yuceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
        [yuceBtn setTitle:@"小应预测" forState:UIControlStateNormal];
        [yuceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        yuceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        yuceBtn.layer.masksToBounds = YES;
        yuceBtn.layer.cornerRadius = 2;
        self.yuceBtn = yuceBtn;
        [self.contentView addSubview:yuceBtn];

        UIView *line = [[UIView alloc]init];
        self.line = line;
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXinWenBiSaiCell";
    RBXinWenBiSaiCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.eventNameLab.frame = CGRectMake(12, 10, 88, 17);
    self.biSaiTimeLab.frame = CGRectMake(100, 10, 120, 17);
    self.teamNameLab.frame = CGRectMake(12, CGRectGetMaxY(self.eventNameLab.frame) + 4, RBScreenWidth - 91, 18);
    self.line.frame = CGRectMake(0, 59, RBScreenWidth, 1);
    self.yuceBtn.frame = CGRectMake(RBScreenWidth - 70, 12, 58, 28);
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    self.eventNameLab.text = biSaiModel.eventName;
    self.biSaiTimeLab.text = [NSString getComperStrWithDateInt:biSaiModel.biSaiTime andFormat:@"HH:mm"];
    self.teamNameLab.text = [NSString stringWithFormat:@"%@ VS %@", biSaiModel.hostTeamName, biSaiModel.visitingTeamName];
}

- (void)clickYuceBtn {
    if ([RBChekLogin CheckLogin]) {
        return;
    }else {
        RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
        detailTabVC.biSaiModel = self.biSaiModel;
        detailTabVC.index = 2;
        [[UIViewController getCurrentVC].navigationController pushViewController:detailTabVC animated:YES];
    }
}

@end
