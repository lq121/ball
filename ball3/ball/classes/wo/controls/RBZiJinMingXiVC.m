#import "RBZiJinMingXiVC.h"
#import "RBJinBiTabVC.h"
#import "RBFuWuTabVC.h"
#import "RBDengjiDesTabVC.h"
#import "RBDaoJuTabVC.h"

@interface RBZiJinMingXiVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) RBJinBiTabVC *jinBiTabVC;
@property (nonatomic, strong) RBFuWuTabVC *fuWuTabVC;
@property (nonatomic, strong) RBDaoJuTabVC *daoJuTabVC;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation RBZiJinMingXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金明细";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [self setupHeadView];
    self.jinBiTabVC = [[RBJinBiTabVC alloc]init];
    self.fuWuTabVC = [[RBFuWuTabVC alloc]init];
    self.daoJuTabVC = [[RBDaoJuTabVC alloc]init];

    NSArray *array = @[self.jinBiTabVC, self.fuWuTabVC, self.daoJuTabVC];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 44)];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(array.count * RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 44);
    [self.view addSubview:scrollView];

    for (int i = 0; i < array.count; i++) {
        UITableViewController *tabViewCtrol = array[i];
        [self addChildViewController:tabViewCtrol];
        UITableView *tableView = tabViewCtrol.tableView;
        tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        tableView.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 44);
        [scrollView addSubview:tableView];
    }
}

- (void)setupHeadView {
    NSArray *titles = @[@"金币充值", @"服务消费", @"道具消费"];
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 44)];
    selectView.backgroundColor = [UIColor whiteColor];
    self.selectView = selectView;
    [self.view addSubview:selectView];
    CGFloat width = (RBScreenWidth - 40) / titles.count;
    CGFloat heigth = 40;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20 + i * width, 0, width, heigth)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.tag = 200 + i;
        if (i == 0) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            btn.selected = YES;
            self.checkBtn = btn;
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(0, 40, 28, 4);
    self.indicateView.x = self.checkBtn.x + (self.checkBtn.frame.size.width - 20) * 0.5;
    [selectView addSubview:self.indicateView];
}

- (void)clickCheckBtn:(UIButton *)btn {
    self.checkBtn.selected = NO;
    self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.selected = YES;
    self.checkBtn = btn;
    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.x = self.checkBtn.x + (self.checkBtn.frame.size.width - 20) * 0.5;
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
