#import "RBDaoJuCell.h"

@interface RBDaoJuCell ()
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *anchorName;
@property (nonatomic, strong) UILabel *game;
@property (nonatomic, strong) UILabel *propNae;
@property (nonatomic, strong) UILabel *coin;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBDaoJuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      UILabel *time = [[UILabel alloc]init];
        self.time = time;
        time.textAlignment = NSTextAlignmentLeft;
        time.textColor = [UIColor colorWithSexadeString:@"#333333"];
        time.font = [UIFont systemFontOfSize:12];
        [self addSubview:time];

        UILabel *anchorName = [[UILabel alloc]init];
        self.anchorName = anchorName;
        anchorName.textAlignment = NSTextAlignmentCenter;
        anchorName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        anchorName.font = [UIFont systemFontOfSize:12];
        [self addSubview:anchorName];

        UILabel *game = [[UILabel alloc]init];
        self.game = game;
        game.textAlignment = NSTextAlignmentLeft;
        game.textColor = [UIColor colorWithSexadeString:@"#333333"];
        game.font = [UIFont systemFontOfSize:12];
        [self addSubview:game];

        UILabel *propNae = [[UILabel alloc]init];
        self.propNae = propNae;
        propNae.textAlignment = NSTextAlignmentCenter;
        propNae.textColor = [UIColor colorWithSexadeString:@"#333333"];
        propNae.font = [UIFont systemFontOfSize:12];
        [self addSubview:propNae];

        UILabel *coin = [[UILabel alloc]init];
        self.coin = coin;
        coin.textAlignment = NSTextAlignmentRight;
        coin.textColor = [UIColor colorWithSexadeString:@"#333333"];
        coin.font = [UIFont systemFontOfSize:12];
        [self addSubview:coin];

        UIView *line = [[UIView alloc]init];
        self.line = line;
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.time.frame = CGRectMake(16, 0, 80, self.height);
    self.anchorName.frame = CGRectMake(CGRectGetMaxX(self.time.frame), 0, (RBScreenWidth - 112) / 4, self.height);
    self.game.frame = CGRectMake(CGRectGetMaxX(self.anchorName.frame), 0, (RBScreenWidth - 112) / 4, self.height);
    self.propNae.frame = CGRectMake(CGRectGetMaxX(self.game.frame), 0, (RBScreenWidth - 112) / 4, self.height);
    self.coin.frame = CGRectMake(CGRectGetMaxX(self.propNae.frame), 0, (RBScreenWidth - 112) / 4, self.height);
    self.line.frame = CGRectMake(0, self.height - 1, RBScreenWidth, 1);
}

- (void)setDaoJuModel:(RBDaoJuModel *)daoJuModel {
    _daoJuModel = daoJuModel;
    self.time.text = [ daoJuModel.CreateT substringToIndex:10];
    self.game.text =  daoJuModel.Game;
    self.anchorName.text =  daoJuModel.Anchorname;
    self.coin.text = [NSString stringWithFormat:@"%d金币",  daoJuModel.Cost];
    NSArray *titles = @[@"UFO", @"冲天火箭", @"超级跑车", @"双彩虹", @"82年雪碧", @"玫瑰花", @"棒棒糖", @"赞", @"优惠券"];
    if (daoJuModel.Propid > 1000) {
        self.propNae.text = [titles lastObject];
    } else {
        self.propNae.text = titles[ daoJuModel.Propid - 1];
    }
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBDaoJuCell";
    RBDaoJuCell *cell = (RBDaoJuCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

@end
