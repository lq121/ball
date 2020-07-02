#import "RBTipViewCell.h"

@interface RBTipViewCell ()
@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *rightLab;
@end

@implementation RBTipViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, RBScreenWidth, 24);
        UILabel *leftLab = [[UILabel alloc]init];
        self.leftLab = leftLab;
        leftLab.textAlignment = NSTextAlignmentRight;
        leftLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        leftLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:leftLab];

        UILabel *rightLab = [[UILabel alloc]init];
        self.rightLab = rightLab;
        rightLab.textAlignment = NSTextAlignmentLeft;
        rightLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        rightLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:rightLab];

        UIImageView *icon = [[UIImageView alloc]init];
        self.icon = icon;
        icon.image = [UIImage imageNamed:@"vip kim"];
        [self addSubview:icon];
    }
    return self;
}

- (void)setChatModel:(RBChatModel *)chatModel {
    _chatModel = chatModel;
    if (chatModel.vip <= 0) {
        self.icon.hidden = YES;
        self.rightLab.hidden = YES;
        self.leftLab.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F0F0F0"];
        self.leftLab.frame = self.bounds;
        if (chatModel.c == 3) {
            NSString *str = [NSString stringWithFormat:@"欢迎 %@ 光临直播间", chatModel.nickName];
            NSRange range = NSMakeRange(3, str.length - 9);
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
            [attr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#2B8AF7"] } range:range];
            self.leftLab.attributedText = attr;
        } else if (chatModel.c == 4) {
            NSString *str = [NSString stringWithFormat:@"%@ 离开直播间", chatModel.nickName];
            NSRange range = NSMakeRange(0, str.length - 6);
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
            [attr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#2B8AF7"] } range:range];
            self.leftLab.attributedText = attr;
        }
    } else {
        self.icon.hidden = NO;
        self.rightLab.hidden = NO;
        self.leftLab.textAlignment = NSTextAlignmentRight;
        self.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268" AndAlpha:0.1];
        self.leftLab.text = @"欢迎 ";
        NSString *str = [NSString stringWithFormat:@"%@ 光临直播间", chatModel.nickName];
        NSRange range = NSMakeRange(0, str.length - 6);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#FA7268"] } range:range];
        self.rightLab.attributedText = attr;
        
        CGSize size1 = [@"欢迎 " getLineSizeWithFontSize:14];
        CGSize size2 = [str getLineSizeWithFontSize:14];
        CGFloat width = size1.width + size2.width + 34;
        self.leftLab.frame = CGRectMake((RBScreenWidth - width) * 0.5, 0, size1.width, self.height);
        self.icon.frame = CGRectMake(CGRectGetMaxX(self.leftLab.frame)+4, (self.height - 16) * 0.5, 35, 16);
        self.rightLab.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+4, 0, size2.width, self.height);
    }
}

+ (instancetype)createCellByTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"RBTipViewCell";
    RBTipViewCell *cell = (RBTipViewCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

@end
