#import "RBBiSaisVC.h"
#import "RBBiSaiTabVC.h"
#import "RBScheduleBiSaiVC.h"
#import "RBResultBiSaiVC.h"
#import "RBSearchVC.h"
#import "RBHistoryVC.h"
#import "RBSelectedVC.h"

@interface RBBiSaisVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *rightBtn;
@property(nonatomic,assign)BOOL needChange;
@end

@implementation RBBiSaisVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.needChange) {
        [self clickCheckBtn:self.checkBtn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self setupHead];
}

- (void)setupHead {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 84 + RBStatusBarH)];
    headView.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];

    UIView *searchBarView = [[UIView alloc]initWithFrame:CGRectMake(12, 4 + RBStatusBarH, RBScreenWidth - 72, 32)];
    [headView addSubview:searchBarView];
    searchBarView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1172];
    searchBarView.layer.masksToBounds = YES;
    searchBarView.layer.cornerRadius = 16;
    UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    searchIcon.frame = CGRectMake(12, 8, 16, 16);
    [searchBarView addSubview:searchIcon];

    UILabel *searLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 6, 80, 20)];
    searLab.text = lainsaiqiudui;
    searLab.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    searLab.font = [UIFont systemFontOfSize:14];
    searLab.textAlignment = NSTextAlignmentLeft;
    [searchBarView addSubview:searLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearchBar)];
    [searchBarView addGestureRecognizer:tap];

    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchBarView.frame) + 6, RBStatusBarH, 42, 40)];
    self.rightBtn = rightBtn;
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitle:shuaixuan forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithSexadeString:@"#36C8B9"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];

    NSArray *titles = @[@"全部", @"进行中", @"赛程", @"赛果", @"关注"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 84 + RBStatusBarH, RBScreenWidth, RBScreenHeight - 84 - RBStatusBarH - RBTabBarH)];
    scrollView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(titles.count * RBScreenWidth, RBScreenHeight - 44 - RBNavBarAndStatusBarH);
    [self.view addSubview:scrollView];

    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + RBStatusBarH, RBScreenWidth, 40)];
    self.selectView = selectView;
    [headView addSubview:selectView];
    CGFloat width = (RBScreenWidth) / titles.count;
    CGFloat heigth = 40;
    for (int i = 0; i < titles.count; i++) {
        if (i == 2) {
            RBScheduleBiSaiVC *scheduleBiSaiVC = [[RBScheduleBiSaiVC alloc]init];
            [self addChildViewController:scheduleBiSaiVC];
            UIView *view = scheduleBiSaiVC.view;
            view.frame =  CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, self.scrollView.height);
            [self.scrollView addSubview:view];
        } else if (i == 3) {
            RBResultBiSaiVC *resultBiSaiVC = [[RBResultBiSaiVC alloc]init];
           
            [self addChildViewController:resultBiSaiVC];
            UIView *view = resultBiSaiVC.view;
            view.frame =  CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, self.scrollView.height);
            [self.scrollView addSubview:view];
        } else {
            RBBiSaiTabVC *biSaiabVC = [[RBBiSaiTabVC alloc]init];
            biSaiabVC.biSaiType = i;
            [self addChildViewController:biSaiabVC];
            UITableView *view = biSaiabVC.tableView;
            view.frame =  CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, self.scrollView.height);
            [self.scrollView addSubview:view];
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, heigth)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        btn.tag = 200 + i;
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            RBBiSaiTabVC *biSaiabVC = (RBBiSaiTabVC *)self.childViewControllers[0];
            [biSaiabVC  getLocalBiSaiData];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(0, 36, width, 4);
    self.indicateView.centerX = self.checkBtn.centerX;
    [selectView addSubview:self.indicateView];
    [self.view addSubview:headView];
}

/// 点击搜索按钮
- (void)clickSearchBar {
    for (RBBiSaiTabVC *BiSaiTabVC in self.childViewControllers) {
        BiSaiTabVC.hasSelect = YES;
    }
    [self.navigationController pushViewController:[[RBSearchVC alloc]init] animated:YES];
}

/// 点击筛选/历史按钮
- (void)clickRightBtn:(UIButton *)btn {
    if ([btn.currentTitle isEqualToString:shuaixuan]) {
        [self.navigationController pushViewController:[[RBSelectedVC alloc]init] animated:YES];
        self.needChange = YES;
    } else {
        [self.navigationController pushViewController:[[RBHistoryVC alloc]init] animated:YES];
    }
}

- (void)clickCheckBtn:(UIButton *)btn {
    if (self.checkBtn != btn) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"seletmatchArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    if (btn.tag - 200 == 2) {
        RBScheduleBiSaiVC *schudleBiSaiVC = (RBScheduleBiSaiVC *)self.childViewControllers[btn.tag - 200];
        schudleBiSaiVC.hasSelect = self.needChange;
        [schudleBiSaiVC getBiSaiData];
    } else if (btn.tag - 200 == 3) {
        RBResultBiSaiVC *resultBiSaiVC = (RBResultBiSaiVC *)self.childViewControllers[btn.tag - 200];
        resultBiSaiVC.hasSelect = self.needChange;
        [resultBiSaiVC getBiSaiData];
    } else {
        RBBiSaiTabVC *tableVC = (RBBiSaiTabVC *)self.childViewControllers[btn.tag - 200];
        tableVC.hasSelect = self.needChange;
        [tableVC getLocalBiSaiData];
    }
    self.needChange = NO;
    if (btn.tag - 200 == 4) {
        [self.rightBtn setTitle:@"历史" forState:UIControlStateNormal];
    } else {
        [self.rightBtn setTitle:shuaixuan forState:UIControlStateNormal];
    }

    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.centerX = self.checkBtn.centerX;
    }];
    long index = btn.tag - 200;
    if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
        return;
    } else {
        self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIButton *btn = [self.selectView viewWithTag:200 + scrollView.contentOffset.x / RBScreenWidth];
    [self clickCheckBtn:btn];
}


@end
