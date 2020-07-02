#import "RBAnalySecondCell.h"
#import "RBAnalyzeTitleView.h"

@interface RBAnalySecondCell ()
@property (nonatomic, strong) UIButton *whiteBtn1;
@property (nonatomic, strong) UIButton *whiteBtn2;
@end

@implementation RBAnalySecondCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalySecondCell";
    RBAnalySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"预测" andFrame:CGRectMake(0, 0, RBScreenWidth, 46) andSecondTitle:@"(大数据锦囊)" andDetail:@"" andFirstBtn:@"" andSecondBtn:@"" andClickFirstBtn:^(BOOL selected) {
        } andClickSecondBtn:^(BOOL selected) {
        }];
        [self addSubview:titleView];

        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(16, 46, RBScreenWidth - 32, 76)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 2;
        whiteView.layer.shadowOffset = CGSizeMake(0, 2);
        whiteView.layer.shadowOpacity = 1;
        whiteView.layer.shadowRadius = 10;

        UIView *gayView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, RBScreenWidth - 48, 60)];
        gayView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [whiteView addSubview:gayView];

        UILabel *tipLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, RBScreenWidth - 48, 22)];
        tipLab1.text = @"AI预测 胜负优选";
        tipLab1.textAlignment = NSTextAlignmentCenter;
        tipLab1.font = [UIFont boldSystemFontOfSize:16];
        tipLab1.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [gayView addSubview:tipLab1];

        UILabel *tipLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLab1.frame) + 4, RBScreenWidth - 48, 17)];
        tipLab2.text = @"以专业的大数据视角解读比赛胜负";
        tipLab2.textAlignment = NSTextAlignmentCenter;
        tipLab2.font = [UIFont systemFontOfSize:12];
        tipLab2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        [gayView addSubview:tipLab2];
        [self addSubview:whiteView];
    }
    return self;
}



@end
