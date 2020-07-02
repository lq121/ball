#import "RBOptionHuaTiVC.h"
#import "RBZanVC.h"
#import "RBPinLunVC.h"
#import "RBWoHuaTiTabVC.h"

@interface RBOptionHuaTiVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) RBZanVC *zanVC;
@property (nonatomic, strong) RBPinLunVC *pingLunVC;
@property (nonatomic, strong) RBWoHuaTiTabVC *woHuaTiTabVC;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *indicateView;
@end

@implementation RBOptionHuaTiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titles = @[@"赞", @"评论", @"话题"];
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, RBScreenWidth - 160, 44)];
    self.selectView = selectView;
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 4, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 4)];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(titles.count * RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH);
    [self.view addSubview:scrollView];

    self.zanVC = [[RBZanVC alloc]init];
    self.pingLunVC = [[RBPinLunVC alloc]init];
    self.woHuaTiTabVC = [[RBWoHuaTiTabVC alloc]init];
    NSArray *vcArr = @[self.zanVC, self.pingLunVC, self.woHuaTiTabVC];
    for (int i = 0; i < vcArr.count; i++) {
        UITableViewController *allplanVC = vcArr[i];
        [self addChildViewController:allplanVC];
        UIView *collectionView = allplanVC.view;
        collectionView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        collectionView.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH);
        [scrollView addSubview:collectionView];
    }
    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(10, 40, 28, 4);
    self.indicateView.centerX = self.checkBtn.centerX;
    [selectView addSubview:self.indicateView];
    self.navigationItem.titleView = selectView;

    CGFloat width = (RBScreenWidth - 160) / titles.count;
    CGFloat heigth = 44;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, heigth)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [selectView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.tag = 200 + i;
        CGSize size = [titles[i] getLineSizeWithBoldFontSize:18];
        UIView *tip = [[UIView alloc]init];
        tip.tag = 1234 + i;
        tip.backgroundColor = [UIColor colorWithSexadeString:@"#FA7268"];
        tip.frame = CGRectMake(btn.x + (width - size.width) * 0.5 + size.width, (heigth - size.height) * 0.5, 8, 8);
        tip.layer.masksToBounds = true;
        tip.layer.cornerRadius = 4;
        tip.hidden = YES;
        [selectView addSubview:tip];
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            [self clickCheckBtn:btn];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)clickCheckBtn:(UIButton *)btn {
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    [UIView animateWithDuration:durationTime animations:^{
        self.indicateView.centerX = self.checkBtn.centerX;
    }];
    long index = btn.tag - 200;
    switch (index) {
        case 2:
            [self.woHuaTiTabVC.tableView.mj_header beginRefreshing];
            break;
        default:
            break;
    }
    if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
        return;
    } else {
        self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
    }
}

@end
