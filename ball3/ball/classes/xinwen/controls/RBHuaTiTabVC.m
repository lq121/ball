#import "RBHuaTiTabVC.h"
#import "RBAllHuaTiTabVC.h"
#import "RBJinXuanHuaTiTabVC.h"
#import "RBNetworkTool.h"
#import "RBChekLogin.h"
#import "RBSendHuaTiVC.h"

@interface RBHuaTiTabVC ()
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) RBAllHuaTiTabVC *allHuaTiTabVC;
@property (nonatomic, strong) RBJinXuanHuaTiTabVC *jinXuanHuaTiTabVC;
@property (nonatomic, strong) UIButton *sendHuaTiBtn;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UIButton *huaTiBtn;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation RBHuaTiTabVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *backBtn = [[UIButton alloc]init];
    self.backBtn = backBtn;
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(20, RBStatusBarH + 2, 40, 40);
    [[UIApplication sharedApplication].keyWindow addSubview:backBtn];
    self.navigationController.navigationBarHidden = YES;

    self.sendHuaTiBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 80, (RBScreenHeight - 100), 64, 64)];
    [self.sendHuaTiBtn addTarget:self  action:@selector(clickSendTopicBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.sendHuaTiBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [self.sendHuaTiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendHuaTiBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.sendHuaTiBtn setBackgroundImage:[UIImage imageNamed:@"fatie"] forState:UIControlStateNormal];
    self.sendHuaTiBtn.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self.sendHuaTiBtn];
    [self clickNewReplyBtn:self.huaTiBtn];
    [self.jinXuanHuaTiTabVC loadNewData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.backBtn removeFromSuperview];
    [self.sendHuaTiBtn removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

- (void)clickBackBtn {
    [self.backBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSendTopicBtn {
    if ([RBChekLogin CheckLogin]) {
        return;
    }
    if (![RBChekLogin checkWithTitile:@"等级需到达5级以上\n或者会员才可以发帖" andtype:@"pushlv" andNeedCheck:YES]) {
        [self.navigationController pushViewController:[[RBSendHuaTiVC alloc]init] animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self gethuatilvlimit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(btnType:) name:@"btnType" object:nil];
    [self setupHeadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 165 + 44, RBScreenWidth, RBScreenHeight - 165 - 44 - RBStatusBarH - RBBottomSafeH)];
    scrollView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(2 * RBScreenWidth, RBScreenHeight - 165 - 44 - RBStatusBarH - RBBottomSafeH);
    [self.view addSubview:scrollView];

    self.allHuaTiTabVC = [[RBAllHuaTiTabVC alloc]init];
    self.jinXuanHuaTiTabVC = [[RBJinXuanHuaTiTabVC alloc]init];
    NSArray *arr = @[self.allHuaTiTabVC, self.jinXuanHuaTiTabVC];
    for (int i = 0; i < arr.count; i++) {
        UIViewController *viewCtrl = arr[i];
        [self addChildViewController:viewCtrl];
        UIView *view = viewCtrl.view;
        view.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - 165 - 44 - RBStatusBarH - RBBottomSafeH);
        [scrollView addSubview:view];
    }
}

- (void)gethuatilvlimit {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/gethuatilvlimit"andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        [[NSUserDefaults standardUserDefaults]setValue:backData[@"ok"] forKey:@"huatilvlimit"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)btnType:(NSNotification *)noti {
    BOOL type = [noti.object boolValue];
    self.backBtn.hidden = type;
    self.sendHuaTiBtn.hidden = type;
}

- (void)setupHeadView {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, -RBStatusBarH, RBScreenWidth, 165)];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIImageView *BGView = [[UIImageView alloc]init];
    BGView.image = [UIImage imageNamed:@"huati bg2"];
    BGView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, 136 + RBStatusBarH);
    BGView.userInteractionEnabled = YES;
    [headView addSubview:BGView];

    UILabel *titLab = [[UILabel alloc]init];
    titLab.text = @"#足球# 话题讨论区";
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:22];
    titLab.textColor = [UIColor whiteColor];
    titLab.frame = CGRectMake(80,  7, RBScreenWidth - 160, 30);
    [headView addSubview:titLab];

    UILabel *desLab = [[UILabel alloc]init];
    desLab.text = @"关于足球你有什么猛料或者想法吗？\n欢迎在这里和大家一起讨论哦！";
    desLab.numberOfLines = 0;
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.font = [UIFont systemFontOfSize:14];
    desLab.textColor = [UIColor whiteColor];
    CGSize size = [desLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 80];
    desLab.frame = CGRectMake(40,  CGRectGetMaxY(titLab.frame) + 8, RBScreenWidth - 80, size.height);
    [headView addSubview:desLab];

    UIView *whiteView = [[UIView alloc] init];
    whiteView.frame = CGRectMake(8, 113, RBScreenWidth - 16, 44);
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.shadowColor = [UIColor colorWithWhite:1 alpha:0.04].CGColor;
    whiteView.layer.shadowOffset = CGSizeMake(0, 2);
    whiteView.layer.shadowOpacity = 1;
    whiteView.layer.shadowRadius = 10;
    [headView addSubview:whiteView];

    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top"]];
    icon.frame = CGRectMake(8, 7, 21, 29);
    [whiteView addSubview:icon];

    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"xiaoxi tiao"] forState:UIControlStateNormal];
    [btn setTitle:@"（以免封禁，请阅读规范）外围和社交封号处理" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 2, 5, RBScreenWidth - 16 - 31 - 8, 34);
    [whiteView addSubview:btn];
    self.tableView.tableHeaderView = headView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGPoint offset = self.tableView.contentOffset;
        if (offset.y <= -RBStatusBarH) {
            offset.y = -RBStatusBarH;
        }
        self.tableView.contentOffset = offset;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"全部", @"精选"];
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    self.selectView = selectView;
    selectView.layer.shadowOffset = CGSizeMake(0, 2);
    selectView.layer.shadowOpacity = 1;
    selectView.layer.shadowRadius = 10;
    selectView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];

    UIButton *huaTiBtn = [[UIButton alloc]init];
    [huaTiBtn addTarget:self action:@selector(clickNewReply:) forControlEvents:UIControlEventTouchUpInside];
    huaTiBtn.backgroundColor = [UIColor colorWithSexadeString:@"#FFF6E5"];
    huaTiBtn.frame = CGRectMake(RBScreenWidth - 86, 11, 70, 22);
    huaTiBtn.layer.masksToBounds = YES;
    huaTiBtn.layer.cornerRadius = 11;
    self.huaTiBtn = huaTiBtn;
    [selectView addSubview:huaTiBtn];

    UILabel *titLab = [[UILabel alloc]init];
    self.titLab = titLab;
    titLab.text = @"最新发帖";
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:12];
    titLab.textColor = [UIColor colorWithSexadeString:@"#FF8C00"];
    titLab.frame = CGRectMake(5,  2, 50, 18);
    [huaTiBtn addSubview:titLab];

    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xunhuan"]];
    icon.frame = CGRectMake(CGRectGetMaxX(titLab.frame), 5, 12, 12);
    [huaTiBtn addSubview:icon];

    CGFloat width = 200 / titles.count;
    CGFloat heigth = 44;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((RBScreenWidth - 200) * 0.5 + i * width, 0, width, heigth)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.tag = 200 + i;
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            [self clickCheckBtn:btn];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(0, 40, 28, 4);
    self.indicateView.centerX = self.checkBtn.centerX;
    [selectView addSubview:self.indicateView];

    return selectView;
}

- (void)clickNewReply:(UIButton *)btn {
    btn.selected =  !btn.selected;
    [self clickNewReplyBtn:btn];
}

- (void)clickNewReplyBtn:(UIButton *)btn {
    if (btn.selected) {
        self.titLab.text = @"最新回复";
        self.allHuaTiTabVC.currentPage = 0;
        [self.allHuaTiTabVC loadDataWithType:@"gethuatibycomment"];
    } else {
        self.titLab.text = @"最新发帖";
        self.allHuaTiTabVC.currentPage = 0;
        [self.allHuaTiTabVC loadDataWithType:@"gethuati"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)clickCheckBtn:(UIButton *)btn {
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.centerX = self.checkBtn.centerX;
    }];
    long index = btn.tag - 200;
    if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
        return;
    } else {
        self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
    }
    self.huaTiBtn.hidden = (index == 1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIButton *btn = [self.selectView viewWithTag:200 + scrollView.contentOffset.x / RBScreenWidth];
    [self clickCheckBtn:btn];
}

@end
