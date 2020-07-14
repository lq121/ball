
#import "RBRenWuCell.h"
#import "RBTabBarVC.h"
#import "RBHuiYuanVC.h"
#import "RBShiMingVC.h"
#import "RBRenWuVC.h"

@interface RBRenWuCell()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *useHead;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *coinLab;
@property (nonatomic, strong) UIButton *huiFuBtn;
@property (nonatomic, strong) UIView *line;
@end

@implementation RBRenWuCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"RBRenWuCell";
    RBRenWuCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView = whiteView;
        [self addSubview:whiteView];

        UIImageView *useHead = [[UIImageView alloc]init];
        self.useHead = useHead;
        [whiteView addSubview:useHead];

        UILabel *userName = [[UILabel alloc]init];
        userName.font = [UIFont systemFontOfSize:16];
        userName.textColor = [UIColor colorWithSexadeString:@"#333333"];
        userName.textAlignment = NSTextAlignmentLeft;
        self.userName = userName;
        [whiteView addSubview:userName];

        UILabel *tipLab = [[UILabel alloc]init];
        tipLab.font = [UIFont systemFontOfSize:12];
        tipLab.textColor = [UIColor colorWithSexadeString:@"#9E9E9E"];
        tipLab.textAlignment = NSTextAlignmentLeft;
        self.tipLab = tipLab;
        [whiteView addSubview:tipLab];

        UILabel *coinLab = [[UILabel alloc]init];
        coinLab.textColor = [UIColor colorWithSexadeString:@"#FFA500"];
        self.coinLab = coinLab;
        coinLab.textAlignment = NSTextAlignmentLeft;
        coinLab.font = [UIFont systemFontOfSize:12];
        [whiteView addSubview:coinLab];

        UIButton *huiFuBtn = [[UIButton alloc]init];
        [huiFuBtn addTarget:self action:@selector(clickReplyBtn) forControlEvents:UIControlEventTouchUpInside];
        [huiFuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [huiFuBtn setTitleColor:[UIColor colorWithSexadeString:@"#8D8D8D"] forState:UIControlStateDisabled];
        [huiFuBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FA7268"]] forState:UIControlStateNormal];
        [huiFuBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#EAEAEA"]] forState:UIControlStateDisabled];
        huiFuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.huiFuBtn = huiFuBtn;
        [whiteView addSubview:self.huiFuBtn];

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.line = line;
        [whiteView addSubview:line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.whiteView.frame = CGRectMake(8, 0, RBScreenWidth - 16, 60);
    self.useHead.frame = CGRectMake(16, 18, 24, 24);
    self.huiFuBtn.frame = CGRectMake(RBScreenWidth - 80 - 16, 19, 64, 22);
    self.huiFuBtn.layer.cornerRadius = 11;
    self.huiFuBtn.layer.masksToBounds = YES;
    self.line.frame = CGRectMake(0, 59, RBScreenWidth - 16, 1);
}

-(void)setRenWuModel:(RBRenWuModel *)renWuModel{
    _renWuModel = renWuModel;
    self.useHead.image = [UIImage imageNamed:[NSString stringWithFormat:@"renwu／%@", renWuModel.imageName]];
    self.userName.text = renWuModel.tip;
    if (renWuModel.Daynum != -1) {
        self.tipLab.hidden = NO;
        self.tipLab.text = [NSString stringWithFormat:@"(%d/%d)", renWuModel.Num, renWuModel.Daynum];
        self.huiFuBtn.enabled = renWuModel.Num < renWuModel.Daynum;
    } else if (renWuModel.Allnum != -1) {
        self.tipLab.hidden = NO;
        self.tipLab.text = [NSString stringWithFormat:@"(%d/%d)", renWuModel.Num, renWuModel.Allnum];
        self.huiFuBtn.enabled = renWuModel.Num < renWuModel.Allnum;
    } else {
        self.tipLab.hidden = YES;
        self.huiFuBtn.enabled = YES;
    }
    if (renWuModel.Addexp > 0) {
        self.coinLab.hidden = NO;
        self.coinLab.text = [NSString stringWithFormat:@"经验 +%d", renWuModel.Addexp];
        CGSize size = [renWuModel.tip getLineSizeWithFontSize:16];
        self.userName.frame = CGRectMake(48, 10, size.width, 22);
        self.tipLab.frame = CGRectMake(CGRectGetMaxX(self.userName.frame) + 8, 13, 100, 17);
        self.coinLab.frame = CGRectMake(48, CGRectGetMaxY(self.userName.frame), 150, 17);
    } else {
        self.coinLab.hidden = YES;
        CGSize size = [renWuModel.tip getLineSizeWithFontSize:16];
        self.userName.frame = CGRectMake(48, 18, size.width, 22);
        self.tipLab.frame = CGRectMake(CGRectGetMaxX(self.userName.frame) + 8, 21, 100, 17);
    }
    [self.huiFuBtn setTitle:renWuModel.btnTitle forState:UIControlStateNormal];
    [self.huiFuBtn setTitle:@"完成" forState:UIControlStateDisabled];
}

- (void)clickReplyBtn {
    UIView *backBtn = [[UIApplication sharedApplication].keyWindow viewWithTag:1010];
    if (backBtn != nil) {
        [backBtn removeFromSuperview];
    }
    UIViewController *currentVC =  [UIViewController getCurrentVC];
    if (self.renWuModel.Id == 3) {
        // 每日签到
        [currentVC.navigationController popViewControllerAnimated:YES];
    } else if (self.renWuModel.Id == 1) {
        // 观看视频
        [currentVC.navigationController popViewControllerAnimated:NO];
        RBTabBarVC *tabBarVC = (RBTabBarVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        tabBarVC.selectedIndex = 1;
    } else if (self.renWuModel.Id == 4 || self.renWuModel.Id == 7) {
        // 消费分析，充值会员
        [currentVC.navigationController popViewControllerAnimated:NO];
        RBTabBarVC *tabBarVC = (RBTabBarVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        tabBarVC.selectedIndex = 2;
    } else if (self.renWuModel.Id == 5) {
        //发表评论或留言
        [currentVC.navigationController popViewControllerAnimated:NO];
        RBTabBarVC *tabBarVC = (RBTabBarVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        tabBarVC.selectedIndex = 0;
    } else if (self.renWuModel.Id == 8) {
        // 会员权益
        UIViewController *currentVC = [UIViewController getCurrentVC];
        RBHuiYuanVC *huiYuanVC = [[RBHuiYuanVC alloc]init];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"vipDict"];
        if (dict != nil) {
            huiYuanVC.dict = dict;
        }
        [currentVC.navigationController pushViewController:huiYuanVC animated:YES];
    } else if (self.renWuModel.Id == 6) {
        // 实名认证
        RBRenWuVC *currentVC = (RBRenWuVC *)[UIViewController getCurrentVC];
        RBShiMingVC *shiMingVC = [[RBShiMingVC alloc]init];
        shiMingVC.dict = currentVC.dict[@"ok"];
        [[UIViewController getCurrentVC].navigationController pushViewController:shiMingVC animated:YES];
    }
}

@end
