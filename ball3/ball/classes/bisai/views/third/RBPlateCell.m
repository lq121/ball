#import "RBPlateCell.h"
#import "RBFloatOption.h"

@interface RBPlateCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *firstHostLab;
@property (weak, nonatomic) IBOutlet UILabel *firstCenterLab;
@property (weak, nonatomic) IBOutlet UILabel *firstVistitingLab;
@property (weak, nonatomic) IBOutlet UILabel *secondHostLab;
@property (weak, nonatomic) IBOutlet UILabel *seconCenterLab;
@property (weak, nonatomic) IBOutlet UILabel *secondVisitingLab;
@property (weak, nonatomic) IBOutlet UIView *BGView;

@end

@implementation RBPlateCell
+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBPlateCell";
    RBPlateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RBPlateCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    return cell;
}

- (void)setAiDataModel:(RBAiDataModel *)aiDataModel {
    _aiDataModel = aiDataModel;
    self.backgroundColor = aiDataModel.bgColor;
    self.BGView.backgroundColor = aiDataModel.bgColor;
    self.companyLab.text = aiDataModel.company;
    self.firstHostLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.firstHostBall];

    float disCount =  (float)aiDataModel.firstCenterBall;
    float disCount2 =  (float)aiDataModel.secondCenterBall;

    if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:0.5]) {
        if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.0f", disCount];
        } else {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.1f", disCount];
        }
    } else if (disCount > 0) {
        CGFloat bigDisCount = disCount;
        if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else {
            self.firstCenterLab.text = [NSString stringWithFormat:@"%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        }
    } else {
        CGFloat bigDisCount = -disCount;
        if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"-%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"-%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.firstCenterLab.text = [NSString stringWithFormat:@"-%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else {
            self.firstCenterLab.text = [NSString stringWithFormat:@"-%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        }
    }

    if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount2 andSecondNumber:0.5]) {
        if ([RBFloatOption judgeDivisibleWithFirstNumber:disCount2 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.0f", disCount2];
        } else {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.1f", disCount2];
        }
    } else if (disCount2 > 0) {
        CGFloat bigDisCount = disCount2;
        if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else {
            self.seconCenterLab.text = [NSString stringWithFormat:@"%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        }
    } else {
        CGFloat bigDisCount = -disCount2;
        if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"-%0.0f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if ([RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && ![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"-%0.0f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else if (![RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount - 0.25 andSecondNumber:1] && [RBFloatOption judgeDivisibleWithFirstNumber:bigDisCount + 0.25 andSecondNumber:1]) {
            self.seconCenterLab.text = [NSString stringWithFormat:@"-%0.1f/%0.0f", bigDisCount - 0.25, bigDisCount + 0.25];
        } else {
            self.seconCenterLab.text = [NSString stringWithFormat:@"-%0.1f/%0.1f", bigDisCount - 0.25, bigDisCount + 0.25];
        }
    }

    self.firstVistitingLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.firstVisiterBall];
    self.secondHostLab.text = [NSString stringWithFormat:@"%0.2f", aiDataModel.secondHostBall];

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
