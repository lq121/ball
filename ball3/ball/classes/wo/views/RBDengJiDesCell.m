#import "RBDengJiDesCell.h"

@interface RBDengJiDesCell ()
@property (strong, nonatomic) UILabel *IdLabel;
@property (strong, nonatomic) UILabel *experienceLabel;
@property (strong, nonatomic) UILabel *iconLabel;
@end

@implementation RBDengJiDesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *IdLabel = [[UILabel alloc]init];
        self.IdLabel = IdLabel;
        IdLabel.textAlignment = NSTextAlignmentLeft;
        IdLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        IdLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:IdLabel];
        IdLabel.frame = CGRectMake(16, 4, 100, 22);

        UILabel *experienceLabel = [[UILabel alloc]init];
        self.experienceLabel = experienceLabel;
        experienceLabel.textAlignment = NSTextAlignmentCenter;
        experienceLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        experienceLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:experienceLabel];
        experienceLabel.frame = CGRectMake((RBScreenWidth - 140) * 0.5, 4, 140, 22);

        UILabel *iconLabel = [[UILabel alloc]init];
        self.iconLabel = iconLabel;
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.textColor = [UIColor colorWithSexadeString:@"FF6459"];
        iconLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:iconLabel];
        iconLabel.frame = CGRectMake(RBScreenWidth - 23 - 35, 4, 35, 18);
        iconLabel.layer.masksToBounds = true;
        iconLabel.layer.cornerRadius = 4;
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView{
    static NSString *indentifier = @"RBDengJiDesCell";
    RBDengJiDesCell *cell = (RBDengJiDesCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setModel:(RBDengJiDesModel *)model {
    _model = model;
    self.IdLabel.text = [NSString stringWithFormat:@"%d", model.ID];
    self.experienceLabel.text = [NSString stringWithFormat:@"%d", model.experience];
    self.iconLabel.text = [NSString stringWithFormat:@"Lv.%d", model.grade];
    self.iconLabel.backgroundColor = model.bgColor;
    self.iconLabel.textColor = [UIColor colorWithSexadeString:model.textColor];
}

@end

