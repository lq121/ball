#import "RBDetailDataCell.h"
@interface RBDetailDataCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *team1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *allScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *halfScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishLabel;

@end

@implementation RBDetailDataCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBDetailDataCell";
    RBDetailDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RBDetailDataCell" owner:self options:nil]lastObject];
    }
    return cell;
}

- (void)setDetailModel:(RBBiSaiDatailCellModel *)detailModel {
    _detailModel = detailModel;
    self.timeLabel.text = detailModel.dataTime;
    self.eventNameLabel.text = detailModel.eventName;
    self.team1NameLabel.text = detailModel.team1Name;
    self.team2NameLabel.text = detailModel.team2Name;
    self.allScoreLabel.text = [NSString stringWithFormat:@"%d-%d", detailModel.hostAllScore, detailModel.visitingAllScore];
    self.halfScoreLabel.text = [NSString stringWithFormat:@"(%d-%d)", detailModel.hostHalfScore, detailModel.visitingHalfScore];
    self.dishLabel.text = detailModel.dish;
    if ([self.dishLabel.text containsString:@"赢"]) {
        self.dishLabel.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    } else if ([self.dishLabel.text containsString:@"输"]) {
        self.dishLabel.textColor = [UIColor colorWithSexadeString:@"#009904"];
    } else {
        self.dishLabel.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
    }
    if (detailModel.type == 0) {
        if ([detailModel.currentHostName isEqualToString:detailModel.team1Name]) {
            // 左边是主队
            if (detailModel.hostAllScore > detailModel.visitingAllScore) {
                // 胜利
                self.team1NameLabel.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
                NSRange range = [self.allScoreLabel.text rangeOfString:@"-"];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.allScoreLabel.text];
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#FFA500"] range:NSMakeRange(0, range.location)];
                self.allScoreLabel.attributedText = AttributedStr;
            } else if (detailModel.hostAllScore == detailModel.visitingAllScore) {
                self.allScoreLabel.textColor = [UIColor colorWithSexadeString:@"#36C8B9"];
            }
        } else if ([detailModel.currentHostName isEqualToString:detailModel.team2Name]) {
            // 右边是主队
            if (detailModel.visitingAllScore > detailModel.hostAllScore) {
                // 胜利
                self.team2NameLabel.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
                NSRange range = [self.allScoreLabel.text rangeOfString:@"-"];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.allScoreLabel.text];
                [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#FFA500"] range:NSMakeRange(range.location, self.allScoreLabel.text.length - 1)];
                self.allScoreLabel.attributedText = AttributedStr;
            } else if (detailModel.hostAllScore == detailModel.visitingAllScore) {
                self.allScoreLabel.textColor = [UIColor colorWithSexadeString:@"#36C8B9"];
            }
        }
    }else if (detailModel.type == 1){
        if ([detailModel.currentVisitingName isEqualToString:detailModel.team1Name]) {
                   // 左边是主队
                   if (detailModel.hostAllScore > detailModel.visitingAllScore) {
                       // 胜利
                       self.team1NameLabel.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
                       NSRange range = [self.allScoreLabel.text rangeOfString:@"-"];
                       NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.allScoreLabel.text];
                       [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#FFA500"] range:NSMakeRange(0, range.location)];
                       self.allScoreLabel.attributedText = AttributedStr;
                   } else if (detailModel.hostAllScore == detailModel.visitingAllScore) {
                       self.allScoreLabel.textColor = [UIColor colorWithSexadeString:@"#36C8B9"];
                   }
               } else if ([detailModel.currentVisitingName isEqualToString:detailModel.team2Name]) {
                   // 右边是主队
                   if (detailModel.visitingAllScore > detailModel.hostAllScore) {
                       // 胜利
                       self.team2NameLabel.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
                       NSRange range = [self.allScoreLabel.text rangeOfString:@"-"];
                       NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.allScoreLabel.text];
                       [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#FFA500"] range:NSMakeRange(range.location, self.allScoreLabel.text.length - 1)];
                       self.allScoreLabel.attributedText = AttributedStr;
                   } else if (detailModel.hostAllScore == detailModel.visitingAllScore) {
                       self.allScoreLabel.textColor = [UIColor colorWithSexadeString:@"#36C8B9"];
                   }
               }
    }
}

@end
