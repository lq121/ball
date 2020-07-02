#import "RBLiveCell.h"

@interface RBLiveCell ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBLiveCell
- (void)setLiveModel:(RBLiveModel *)liveModel {
    _liveModel = liveModel;
    NSString *dataStr = [liveModel.data stringByReplacingOccurrencesOfString:@"雷速" withString:@"小应体育"];
    self.dataLabel.text = dataStr;

    self.dataLabel.numberOfLines = 0;
    CGFloat height = [RBLiveCell getCellHeightWithString:self.dataLabel.text];
    self.bgView.frame = CGRectMake(16, 0, RBScreenWidth - 32, height);
    self.dataLabel.frame = CGRectMake(42, 0, RBScreenWidth - 32 - 49, height);
    self.line.frame = CGRectMake(0, height, RBScreenWidth, 4);
    self.btn.centerY = (height) * 0.5;
    self.leftView.frame = CGRectMake(0, 0, 2, height);
    if (liveModel.type == 1 || liveModel.type == 2 || liveModel.type == 3 || liveModel.type == 4 || liveModel.type == 6 || liveModel.type == 7 || liveModel.type == 8) {
        self.leftView.hidden = NO;
        self.bgView.backgroundColor = [UIColor whiteColor];
    } else {
        self.leftView.hidden = YES;
        self.btn.backgroundColor = [UIColor whiteColor];
        self.bgView.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.05];
    }
    if (liveModel.position == 1) {
        self.leftView.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    } else {
        self.leftView.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
    }
    if (liveModel.type == 2) {
        // 角球
        [self.btn setImage:[UIImage imageNamed:@"corner 1"] forState:UIControlStateNormal];
    } else if (liveModel.type == 1  || liveModel.type == 6 || liveModel.type == 7 || liveModel.type == 8) {
        // 进球
        [self.btn setImage:[UIImage imageNamed:@"goal"] forState:UIControlStateNormal];
    } else if (liveModel.type == 3) {
        // 黄牌
        [self.btn setImage:[UIImage imageNamed:@"yellow card 1"] forState:UIControlStateNormal];
    } else if (liveModel.type == 4) {
        // 红牌
        [self.btn setImage:[UIImage imageNamed:@"red card 1"] forState:UIControlStateNormal];
    } else if (liveModel.type == 10) {
        // 裁判
        [self.btn setImage:[UIImage imageNamed:@"whistle"] forState:UIControlStateNormal];
    } else if (liveModel.type == 22 || liveModel.type == 16) {
        // 失球
        [self.btn setImage:[UIImage imageNamed:@"fail"] forState:UIControlStateNormal];
    } else {
        [self.btn setImage:[UIImage imageNamed:@"judge"] forState:UIControlStateNormal];
    }
}

+ (CGFloat)getCellHeightWithString:(NSString *)string {
    
    CGFloat height = [string getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 81].height + 16;
    if (!string) {
        height += 16;
    }
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc]init];
        self.bgView = bgView;
        [self addSubview:bgView];

        UIView *leftView = [[UIView alloc]init];
        self.leftView = leftView;
        [self.bgView addSubview:self.leftView];

        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        btn.frame = CGRectMake(10, 8, 24, 24);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 12;
        self.btn = btn;
        [self.bgView addSubview:btn];

        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.numberOfLines = 0;
        self.dataLabel = dataLabel;
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        dataLabel.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:dataLabel];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

+ (instancetype)createCellByTableView:(UITableView *)tableView{
    static NSString *indentifier = @"RBLiveCell";
    RBLiveCell *cell = (RBLiveCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}


@end
