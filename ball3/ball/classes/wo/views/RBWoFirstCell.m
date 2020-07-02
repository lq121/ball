#import "RBWoFirstCell.h"
#import "RBCommButton.h"
#import "RBChekLogin.h"
#import "RBXiaoXiVC.h"
#import "RBOptionHuaTiVC.h"
#import "RBChongZhiVC.h"

@interface RBWoFirstCell ()
@property (nonatomic, strong)  RBCommButton *xiaoXiBtn;
@property (nonatomic, strong) RBCommButton *huaTiBtn;
@end

@implementation RBWoFirstCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBWoFirstCell";
    RBWoFirstCell *cell = (RBWoFirstCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(12, 0, RBScreenWidth - 24, 85);
        view.layer.masksToBounds = true;
        view.layer.cornerRadius = 2;
        [self.contentView addSubview:view];
        CGFloat margin = (RBScreenWidth - 24 - 64 - 150) * 0.5;
       RBCommButton *xiaoXiBtn = [[RBCommButton alloc] initWithImage:@"message" andHeighImage:@"message" andFrame:CGRectMake(32, 11, 50, 67) andTitle:@"消息" andTarget:self andAction:@selector(clickMessageBtn)];
        self.xiaoXiBtn = xiaoXiBtn;
        [view addSubview:xiaoXiBtn];

        RBCommButton *walletBtn = [[RBCommButton alloc] initWithImage:@"wallet" andHeighImage:@"wallet" andFrame:CGRectMake(CGRectGetMaxX(xiaoXiBtn.frame) + margin, 11, 50, 67) andTitle:@"钱包" andTarget:self andAction:@selector(clickWalletBtn)];
        [view addSubview:walletBtn];

        RBCommButton *huaTiBtn = [[RBCommButton alloc] initWithImage:@"huati" andHeighImage:@"huati" andFrame:CGRectMake(CGRectGetMaxX(walletBtn.frame) + margin, 11, 50, 67) andTitle:@"互动" andTarget:self andAction:@selector(clickHuatiBtn)];
        self.huaTiBtn = huaTiBtn;
        [view addSubview:huaTiBtn];
    }
    return self;
}

-(void)setShowHuaTiTip:(BOOL)showHuaTiTip{
    _showHuaTiTip = showHuaTiTip;
    self.huaTiBtn.showTip = showHuaTiTip;
}

- (void)setShowXiaoXiTip:(BOOL)showXiaoXiTip{
    _showXiaoXiTip = showXiaoXiTip;
    self.xiaoXiBtn.showTip = showXiaoXiTip;
}


- (void)clickMessageBtn {
    UIViewController *currentVC = [UIViewController getCurrentVC];
    RBXiaoXiVC *xiaoXiVC = [[RBXiaoXiVC alloc]init];
    xiaoXiVC.xiaoXiArr = self.xiaoXiArr;
    [currentVC.navigationController pushViewController:xiaoXiVC animated:YES];
}

- (void)clickHuatiBtn {
    UIViewController *currentVC = [UIViewController getCurrentVC];
    RBOptionHuaTiVC *optionHuaTi = [[RBOptionHuaTiVC alloc]init];
    optionHuaTi.huaTiArr = self.huaTiArr;
    [currentVC.navigationController pushViewController:optionHuaTi animated:YES];
}

- (void)clickWalletBtn {
    if ( [RBChekLogin CheckLogin]) {
        return;
    }
    RBChongZhiVC *chongZhiVC = [[RBChongZhiVC alloc]init];
    int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
    chongZhiVC.coinCount = coinCount;
    [[UIViewController getCurrentVC].navigationController pushViewController:chongZhiVC animated:YES];
}

@end
