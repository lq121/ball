#import "RBResultCell.h"
@interface RBResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *eventNameLab;
@property (weak, nonatomic) IBOutlet UILabel *biSaiDateLab;
@property (weak, nonatomic) IBOutlet UILabel *biSaiTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *hostTeamLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *visitTeamLab;
@property (weak, nonatomic) IBOutlet UIButton *interBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *interRight;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end

@implementation RBResultCell


+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBResultCell";
    RBResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RBResultCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    self.interBtn.hidden = !biSaiModel.hasIntelligence;
    self.eventNameLab.text = biSaiModel.eventName;
    self.biSaiDateLab.text = [NSString getStrWithDateInt:biSaiModel.biSaiTime andFormat:@"HH:mm"];
    self.hostTeamLab.text = biSaiModel.hostTeamName;
    self.visitTeamLab.text = biSaiModel.visitingTeamName;
    CGFloat width = (RBScreenWidth - self.scoreLab.width - 8 - 28) * 0.5;
    CGSize hostNameSize = [self.hostTeamLab.text getSizeWithFontSize:15 andMaxWidth:width - 44];
    self.hostTeamLab.frame = CGRectMake(width - hostNameSize.width - 2, 30, hostNameSize.width + 2, hostNameSize.height);

    CGFloat width2 = (RBScreenWidth - self.scoreLab.width - 8 - 28) * 0.5;
    CGSize visitNameSize = [self.visitTeamLab.text getSizeWithFontSize:15 andMaxWidth:width2 - 44];
    self.visitTeamLab.frame = CGRectMake(RBScreenWidth * 0.5 + 29, 30, visitNameSize.width + 2, visitNameSize.height);
    self.biSaiTimeLab.text = [NSString getStrWithDateInt:biSaiModel.biSaiTime andFormat:@"HH:mm"];
    self.scoreLab.text = [NSString stringWithFormat:@"%d-%d", biSaiModel.hostScore, biSaiModel.visitingScore];
    self.attentionBtn.hidden = !biSaiModel.hasAttention;
    if (self.attentionBtn.hidden == NO) {
        self.interRight.constant = 40;
    }else{
        self.interRight.constant = 16;
    }
    int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
    if (isVip != 2) {
        self.interBtn.hidden = YES;
    }
    if (biSaiModel.status == 1) {
        self.scoreLab.text = @"VS";
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.2];
    } else {
        self.scoreLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    }
    if (biSaiModel.status == 2) {
        // 上半场
        biSaiModel.TeeTimeStr =   [NSString stringWithFormat:@"上半场 %@", [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:biSaiModel.TeeTime]];
    } else if (biSaiModel.status == 3) {
        biSaiModel.TeeTimeStr = @"中";
    } else if (biSaiModel.status >= 4 && biSaiModel.status <= 7) {
        long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:biSaiModel.TeeTime] longLongValue];
        if (timeCount + 45 > 90) {
            biSaiModel.TeeTimeStr = @"下半场 90+";
        } else {
            biSaiModel.TeeTimeStr = [NSString stringWithFormat:@"下半场 %ld", timeCount + 45];
        }
    } else if (biSaiModel.status  == 8) {
        biSaiModel.TeeTimeStr = @"完";
    } else if (biSaiModel.status == 1) {
        biSaiModel.TeeTimeStr = @"未";
    } else if (biSaiModel.status > 8 || biSaiModel == 0) {
        biSaiModel.TeeTimeStr = @"延迟";
    }
    self.biSaiTimeLab.text = biSaiModel.TeeTimeStr;
    if ([self.biSaiTimeLab.text isEqualToString:@"延迟"]) {
        [self.biSaiTimeLab sizeToFit];
        self.biSaiTimeLab.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLab.textColor = [UIColor whiteColor];
        self.biSaiTimeLab.backgroundColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLab.layer.masksToBounds = YES;
        self.biSaiTimeLab.layer.cornerRadius = 1;
    } else {
        self.biSaiTimeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLab.backgroundColor = [UIColor clearColor];
        self.biSaiTimeLab.layer.masksToBounds = NO;
        self.biSaiTimeLab.layer.cornerRadius = 0;
        self.biSaiTimeLab.textAlignment = NSTextAlignmentLeft;
    }
    CGSize size = [biSaiModel.TeeTimeStr getLineSizeWithFontSize:12];
    self.biSaiTimeLab.frame = CGRectMake((RBScreenWidth - size.width - 8) * 0.5, 4, size.width + 8, 14);
}

@end
