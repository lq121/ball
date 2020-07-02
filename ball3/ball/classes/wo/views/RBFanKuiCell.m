
#import "RBFanKuiCell.h"

@interface RBFanKuiCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *reply;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBFanKuiCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc]init];
        self.title = title;
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor colorWithSexadeString:@"#333333"];
        title.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:title];

        UILabel *reply = [[UILabel alloc]init];
        self.reply = reply;
        reply.textAlignment = NSTextAlignmentRight;
        reply.textColor = [UIColor colorWithSexadeString:@"#333333"];
        reply.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:reply];

        UIView *line = [[UIView alloc] init];
        self.line = line;
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.title.frame = CGRectMake(16, 0, RBScreenWidth - 100, 60);
    self.reply.frame = CGRectMake(RBScreenWidth - 100, 0, 84, 60);
    self.line.frame = CGRectMake(16, 59, RBScreenWidth - 16, 1);
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBFanKuiCell";
    RBFanKuiCell *cell = (RBFanKuiCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

-(void)setFanKuiModel:(RBFanKuiModel *)fanKuiModel{
    _fanKuiModel = fanKuiModel;
    self.title.text = fanKuiModel.Title;
    if (fanKuiModel.Reply.length > 0) {
        self.reply.text = @"已回复";
    } else {
        self.reply.text = @"";
    }
}

@end
