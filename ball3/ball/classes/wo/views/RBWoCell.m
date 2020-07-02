#import "RBWoCell.h"

@interface RBWoCell ()
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *tip;
@property (nonatomic, strong) UILabel *tip2;
@end

@implementation RBWoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(12, 0, RBScreenWidth - 24, 48);
        view.tag = 100;
        [self.contentView addSubview:view];

        UIImageView *icon = [[UIImageView alloc]init];
        [view addSubview:icon];
        icon.frame = CGRectMake(8, 12, 24, 24);
        self.icon = icon;

        UILabel *tip = [[UILabel alloc]init];
        self.tip = tip;
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tip.font = [UIFont systemFontOfSize:16];
        [view addSubview:tip];
        tip.frame = CGRectMake(44, 14, 100, 20);

        UILabel *tip2 = [[UILabel alloc]init];
        self.tip2 = tip2;
        tip2.text = @"填邀请码获奖励";
        tip2.textAlignment = NSTextAlignmentRight;
        tip2.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
        tip2.font = [UIFont systemFontOfSize:14];
        [view addSubview:tip2];
        tip2.frame = CGRectMake(RBScreenWidth - 24 - 28 - 110, 14, 110, 20);

        UIImageView *row = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
        [view addSubview:row];
        row.frame = CGRectMake(RBScreenWidth - 24 - 28 - 4, 10, 28, 28);
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(55, 47, RBScreenWidth - 24 - 9 - 55, 1)];
        line.tag = 101;
        line.backgroundColor = [UIColor colorWithSexadeString:@"F2F2F2"];
        [view addSubview:line];
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBWoCell";
    RBWoCell *cell = (RBWoCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setWoModel:(RBWoModel *)woModel {
    _woModel = woModel;
    self.icon.image = [UIImage imageNamed:woModel.image];
    self.tip.text = woModel.tip;
    if ([woModel.tip isEqualToString:@"个人信息"] && woModel.Usedyqcode.length == 0) {
        self.tip2.hidden = NO;
    } else {
        self.tip2.hidden = YES;
    }
}

@end
