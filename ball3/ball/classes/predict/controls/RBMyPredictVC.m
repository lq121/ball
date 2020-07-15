#import "RBMyPredictVC.h"
#import "RBMyPredictTabVC.h"

@interface RBMyPredictVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation RBMyPredictVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"hasgoumai"];
               [[NSUserDefaults standardUserDefaults]synchronize];
    self.title = @"我购买的比赛";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *titles = @[@"未赛", @"已赛"];

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, RBScreenWidth, RBScreenHeight - 44 - RBNavBarAndStatusBarH)];
    scrollView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(titles.count * RBScreenWidth, RBScreenHeight - 44 - RBNavBarAndStatusBarH);
    [self.view addSubview:scrollView];

    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    self.selectView = selectView;
    selectView.layer.shadowOffset = CGSizeMake(0, 2);
    selectView.layer.shadowOpacity = 1;
    selectView.layer.shadowRadius = 10;
    selectView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];

    CGFloat width = RBScreenWidth / titles.count;
    CGFloat heigth = 44;
    for (int i = 0; i < titles.count; i++) {
        RBMyPredictTabVC *myPredictTabVC = [[RBMyPredictTabVC alloc]init];
        [self addChildViewController:myPredictTabVC];
        myPredictTabVC.status = i;
        UITableView *tableView = myPredictTabVC.tableView;
        tableView.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, self.scrollView.height);
        [self.scrollView addSubview:tableView];

        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, heigth)];
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
            [myPredictTabVC getPredictData];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(0, 40, 28, 4);
    self.indicateView.centerX = self.checkBtn.centerX;
    [selectView addSubview:self.indicateView];
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
        RBMyPredictTabVC *myPredictTabVC = self.childViewControllers[index];
        [myPredictTabVC getPredictData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIButton *btn = [self.selectView viewWithTag:200 + scrollView.contentOffset.x / RBScreenWidth];
    [self clickCheckBtn:btn];
}

@end
