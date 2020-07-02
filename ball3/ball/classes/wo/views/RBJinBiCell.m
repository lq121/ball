#import "RBJinBiCell.h"

@interface RBJinBiCell ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong)  UILabel *orderNo;
@property (nonatomic, strong)  UILabel *createTime;
@property (nonatomic, strong)  UILabel *statusLab;
@property (nonatomic, strong)  UILabel *jinBiLab;
@property (nonatomic, strong)  UILabel *jiaGeLab;
@property (nonatomic, strong)  UIImageView *typeImage;
@property (nonatomic, strong)  UILabel *jinBiTipLab;
@property (nonatomic, strong)  UILabel *jiaGeTipLab;
@property (nonatomic, strong)  UILabel *typeLab;
@end

@implementation RBJinBiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIView *view = [[UIView alloc] init];
        self.view = view;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self.contentView addSubview:view];

        UILabel *orderNo = [[UILabel alloc]init];
        self.orderNo = orderNo;
        orderNo.textAlignment = NSTextAlignmentLeft;
        orderNo.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        orderNo.font = [UIFont systemFontOfSize:12];
        [view addSubview:orderNo];

        UILabel *createTime = [[UILabel alloc]init];
        self.createTime = createTime;
        createTime.textAlignment = NSTextAlignmentLeft;
        createTime.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        createTime.font = [UIFont systemFontOfSize:12];
        [view addSubview:createTime];

        UILabel *statusLab = [[UILabel alloc]init];
        self.statusLab = statusLab;
        statusLab.textAlignment = NSTextAlignmentRight;
        statusLab.textColor = [UIColor colorWithSexadeString:@"FFA500"];
        statusLab.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:statusLab];

        UILabel *jinBiLab = [[UILabel alloc]init];
        self.jinBiLab = jinBiLab;
        jinBiLab.textAlignment = NSTextAlignmentCenter;
        jinBiLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        jinBiLab.font = [UIFont boldSystemFontOfSize:22];
        [view addSubview:jinBiLab];

        UILabel *jiaGeLab = [[UILabel alloc]init];
        self.jiaGeLab = jiaGeLab;
        jiaGeLab.textAlignment = NSTextAlignmentCenter;
        jiaGeLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        jiaGeLab.font = [UIFont boldSystemFontOfSize:22];
        [view addSubview:jiaGeLab];

        UIImageView *typeImage = [[UIImageView alloc]init];
        typeImage.image = [UIImage imageNamed:@"Apple disburse"];
        self.typeImage = typeImage;
        [view addSubview:typeImage];

        UILabel *jinBiTipLab = [[UILabel alloc]init];
        self.jinBiTipLab = jinBiTipLab;
        jinBiTipLab.textAlignment = NSTextAlignmentCenter;
        jinBiTipLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        jinBiTipLab.font = [UIFont systemFontOfSize:12];
        [view addSubview:jinBiTipLab];

        UILabel *jiaGeTipLab = [[UILabel alloc]init];
        self.jiaGeTipLab = jiaGeTipLab;
        jiaGeTipLab.textAlignment = NSTextAlignmentCenter;
        jiaGeTipLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        jiaGeTipLab.font = [UIFont systemFontOfSize:12];
        [view addSubview:jiaGeTipLab];

        UILabel *typeLab = [[UILabel alloc]init];
        self.typeLab = typeLab;
        typeLab.textAlignment = NSTextAlignmentCenter;
        typeLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
        typeLab.font = [UIFont systemFontOfSize:12];
        [view addSubview:typeLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.view.frame = CGRectMake(16, 8, RBScreenWidth - 32, self.height - 8);
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 4;
    self.orderNo.frame = CGRectMake(12, 12, RBScreenWidth - 122, 15);
    self.createTime.frame = CGRectMake(12, CGRectGetMaxY(self.orderNo.frame), RBScreenWidth - 110, 15);
    self.statusLab.frame = CGRectMake(RBScreenWidth - 98-16, 16, 66, 20);
    self.jinBiTipLab.frame = CGRectMake(16, self.height - 31, (RBScreenWidth - 64) / 3, 15);
    self.jiaGeTipLab.frame = CGRectMake(CGRectGetMaxX(self.jinBiTipLab.frame), self.height - 31, (RBScreenWidth - 64) / 3, 15);
    self.typeLab.frame = CGRectMake(CGRectGetMaxX(self.jiaGeTipLab.frame), self.height - 31, (RBScreenWidth - 64) / 3, 15);
    self.jinBiLab.frame = CGRectMake(0, self.height - 62, (RBScreenWidth - 64) / 3, 27);
    self.jiaGeLab.frame = CGRectMake(0, self.height - 62, (RBScreenWidth - 64) / 3, 27);
    self.typeImage.frame = CGRectMake(0, self.height - 62, 26, 26);
    self.jiaGeLab.centerX = self.jiaGeTipLab.centerX;
    self.jinBiLab.centerX = self.jinBiTipLab.centerX;
    self.typeImage.centerX = self.typeLab.centerX;
}

- (void)setJinBiModel:(RBJinBiModel *)jinBiModel {
    _jinBiModel = jinBiModel;
    self.orderNo.text = [NSString stringWithFormat:@"订单编号：%@", jinBiModel.Dealno];
    if (jinBiModel.Dealtype >= 1 && jinBiModel.Dealtype <= 6) {
        // 金币
        self.jinBiTipLab.text = @"金币数";
        self.jinBiLab.text = [NSString stringWithFormat:@"%0.2f", (float)jinBiModel.Gold];
    } else {
        self.jinBiTipLab.text = @"类别";
        if (jinBiModel.Dealtype == 100) {
            self.jinBiLab.text = @"会员购买";
        } else {
            self.jinBiLab.text = @"小应预测";
        }
    }
    if (jinBiModel.State >= 2) {
        self.statusLab.text = @"付款成功";
        self.statusLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
    } else {
        self.statusLab.text = @"未付款";
        self.statusLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
    }

    self.jiaGeLab.text = [NSString stringWithFormat:@"%0.2f", (float)jinBiModel.Money];
    self.createTime.text = [NSString stringWithFormat:@"下单时间：%@", [NSString getStrWithDateInt:jinBiModel.CreateT andFormat:@"yyyy-MM-dd HH:mm:ss"]];
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBJinBiCell";
    RBJinBiCell *cell = (RBJinBiCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

@end
