#import "RBCompensateCell.h"
@interface RBCompensateCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *firstHostLab;
@property (weak, nonatomic) IBOutlet UILabel *firstCenterLab;
@property (weak, nonatomic) IBOutlet UILabel *firstVistitingLab;
@property (weak, nonatomic) IBOutlet UILabel *secondHostLab;
@property (weak, nonatomic) IBOutlet UILabel *seconCenterLab;
@property (weak, nonatomic) IBOutlet UILabel *secondVisitingLab;

@end

@implementation RBCompensateCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBCompensateCell";
    RBCompensateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RBCompensateCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    return cell;
}

- (void)setAiDataModel:(RBAiDataModel *)aiDataModel {
    _aiDataModel = aiDataModel;
    self.companyLab.text = aiDataModel.company;
    if ([aiDataModel.company isEqualToString:@"最高值"] || [aiDataModel.company isEqualToString:@"最低值"] || [aiDataModel.company isEqualToString:@"平均值"]) {
        self.companyLab.font = [UIFont boldSystemFontOfSize:14];
    } else {
        self.companyLab.font = [UIFont systemFontOfSize:12];
    }
    self.firstHostLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.firstHostBall];
    self.firstCenterLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.firstCenterBall];
    self.firstVistitingLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.firstVisiterBall];
    self.secondHostLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.secondHostBall];
    self.seconCenterLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.secondCenterBall];
    self.secondVisitingLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.secondVisiterBall];
    if (aiDataModel.firstHostBall > aiDataModel.secondHostBall) {
        self.secondHostLab.textColor = [UIColor colorWithSexadeString:@"#009904"];
    } else if (aiDataModel.firstHostBall < aiDataModel.secondHostBall) {
        self.secondHostLab.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    }
    if (aiDataModel.firstCenterBall > aiDataModel.secondCenterBall) {
        self.seconCenterLab.textColor = [UIColor colorWithSexadeString:@"#009904"];
    } else if (aiDataModel.firstCenterBall < aiDataModel.secondCenterBall) {
        self.seconCenterLab.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    }
    if (aiDataModel.firstVisiterBall > aiDataModel.secondVisiterBall) {
        self.secondVisitingLab.textColor = [UIColor colorWithSexadeString:@"#009904"];
    } else if (aiDataModel.firstVisiterBall < aiDataModel.secondVisiterBall) {
        self.secondVisitingLab.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    }
}

@end
