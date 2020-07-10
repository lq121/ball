#import "RBUserInfoCell.h"

@interface RBUserInfoCell ()
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIImageView *row;
@property (strong, nonatomic) UILabel *desLabel;
@property (strong, nonatomic) UIImageView *head;
@property (strong, nonatomic) UILabel *tip;
@end

@implementation RBUserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *tip = [[UILabel alloc]init];
        tip.textAlignment = NSTextAlignmentLeft;
        tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tip.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:tip];
        tip.frame = CGRectMake(16, 0, 100, 60);
        self.tip = tip;

        UILabel *desLabel = [[UILabel alloc]init];
        desLabel.textAlignment = NSTextAlignmentRight;
        desLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        desLabel.font = [UIFont systemFontOfSize:16];
        desLabel.alpha = 0.7;
        [self.contentView addSubview:desLabel];
        self.desLabel = desLabel;

        UIImageView *head = [[UIImageView alloc]init];
        head.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
        head.layer.masksToBounds = true;
        head.layer.cornerRadius = 20;
        [self.contentView addSubview:head];
        head.frame = CGRectMake(RBScreenWidth - 48 - 40, 10, 40, 40);
        self.head = head;

        UIImageView *row = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
        [self.contentView addSubview:row];
        row.frame = CGRectMake(RBScreenWidth - 16 - 28, 16, 28, 28);
        self.row = row;

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 59, RBScreenWidth - 16 - 15, 1)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"F2F2F2"];
        [self.contentView addSubview:line];
        self.line = line;
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBUserInfoCell";
    RBUserInfoCell *cell = (RBUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setInfoModel:(RBUserInfoModel *)infoModel {
    _infoModel = infoModel;
    self.line.hidden = !infoModel.showLine;
    self.head.hidden = !infoModel.isImage;
    self.row.hidden = !infoModel.showRow;
    self.desLabel.hidden = infoModel.isImage;
    if ([infoModel.tipName isEqualToString:yaoqingma] && !infoModel.hasUsed) {
        self.tip.textColor = [UIColor colorWithSexadeString:@"#FA7268"];
    } else {
        self.tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
    }
    if (!infoModel.showRow) {
        self.desLabel.frame = CGRectMake(RBScreenWidth - 16 - 300, 20, 300, 20);
    } else {
        self.desLabel.frame = CGRectMake(RBScreenWidth - 48 - 300, 20, 300, 20);
    }
    self.tip.text = infoModel.tipName;
    self.desLabel.text = infoModel.desName;
    if ([infoModel.tipName isEqualToString:@"头像"]) {
        if ([infoModel.desName isEqualToString:@"user pic"]) {
            [self.head setImage:[UIImage imageNamed:infoModel.desName]];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:infoModel.desName]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.head.image = [UIImage imageWithData:data];
                });
            });
        }
    }
}

@end
