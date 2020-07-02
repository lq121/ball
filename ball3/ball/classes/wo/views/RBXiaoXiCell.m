
#import "RBXiaoXiCell.h"

@interface RBXiaoXiCell()
@property (nonatomic, strong) UILabel *tip;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *content;
@property(nonatomic,strong)UIView *line;
@end

@implementation RBXiaoXiCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *tip = [[UILabel alloc]init];
        self.tip = tip;
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tip.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:tip];
        tip.frame = CGRectMake(16, 16, RBScreenWidth - 152, 22);

        UILabel *time = [[UILabel alloc]init];
        self.time = time;
        time.textAlignment = NSTextAlignmentCenter;
        time.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.7];
        time.font = [UIFont systemFontOfSize:12];
        time.frame = CGRectMake(RBScreenWidth-136, 19, 120, 17);
        [self.contentView addSubview:time];

        UILabel *content = [[UILabel alloc]init];
        content.numberOfLines = 0;
        self.content = content;
        content.textAlignment = NSTextAlignmentLeft;
        content.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        content.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:content];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [self.contentView addSubview:line];
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBXiaoXiCell";
    RBXiaoXiCell *cell = (RBXiaoXiCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setXiaoxiModel:(RBXiaoXiModel *)xiaoxiModel{
    _xiaoxiModel =xiaoxiModel;
    self.time.text = [NSString getStrWithDateInt:xiaoxiModel.t andFormat:@"yyyy-MM-dd HH:mm"];
    self.tip.text = xiaoxiModel.title;
    self.content.text = xiaoxiModel.txt;
    CGSize size = [xiaoxiModel.txt getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64];
    self.content.frame = CGRectMake(16, 50, RBScreenWidth - 64, size.height);
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.content.frame)+15, RBScreenWidth, 1);
}


@end
