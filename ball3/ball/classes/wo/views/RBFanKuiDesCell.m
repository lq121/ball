#import "RBFanKuiDesCell.h"

@interface RBFanKuiDesCell ()
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBFanKuiDesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] init];
        self.view = view;
        view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.contentView addSubview:view];

        UILabel *desLab = [[UILabel alloc]init];
        desLab.numberOfLines = 0;
        self.desLab = desLab;
        desLab.textAlignment = NSTextAlignmentLeft;
        desLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        desLab.font = [UIFont systemFontOfSize:14];
        desLab.frame = CGRectMake(16, 8, RBScreenWidth - 64, 17);
        [view addSubview:desLab];

        UIView *line = [[UIView alloc] init];
        self.line = line;
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setDes:(NSString *)des {
    _des = des;
    self.desLab.text = des;
    CGSize size = [des getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64];
    self.view.frame = CGRectMake(16, 0, RBScreenWidth - 32, size.height + 16);
    self.desLab.frame = CGRectMake(16, 8, RBScreenWidth - 64, size.height);
    self.line.frame = CGRectMake(0, size.height + 32, RBScreenWidth, 8);
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBFanKuiDesCell";
    RBFanKuiDesCell *cell = (RBFanKuiDesCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

@end

