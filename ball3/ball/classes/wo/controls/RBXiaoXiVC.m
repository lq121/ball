#import "RBXiaoXiVC.h"
#import "RBTongZhiTabVC.h"
#import "RBXiaoXiTabVC.h"


@interface RBXiaoXiVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) RBTongZhiTabVC *tongZhiTabVC;
@property (nonatomic, strong) RBXiaoXiTabVC *xiaoXiTabVC;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *selectView;
@end

@implementation RBXiaoXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *titles = @[@"通知", @"消息"];
    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake((RBScreenWidth - 160) * 0.5, 0, 160, 44)];
    self.selectView = selectView;
    selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH)];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(titles.count * RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH);
    [self.view addSubview:scrollView];

    self.tongZhiTabVC = [[RBTongZhiTabVC alloc]init];
    self.xiaoXiTabVC = [[RBXiaoXiTabVC alloc]init];
    NSArray *vcArr = @[self.tongZhiTabVC, self.xiaoXiTabVC];
    for (int i = 0; i < vcArr.count; i++) {
        UITableViewController *allplanVC = vcArr[i];
        [self addChildViewController:allplanVC];
        UITableView *collectionView = allplanVC.tableView;
        collectionView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        collectionView.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - RBBottomSafeH);
        [scrollView addSubview:collectionView];
    }
    self.indicateView = [[UIView alloc]init];
    self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
    self.indicateView.frame = CGRectMake(10, 40, 28, 4);
    self.indicateView.centerX = self.checkBtn.centerX;
    [selectView addSubview:self.indicateView];

    CGFloat width = 160 / titles.count;
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
        if (self.xiaoXiArr != nil && self.xiaoXiArr.count != 0) {
            int cout = 0;
            if (i == 0) {
                cout = [self.xiaoXiArr[0] intValue];
            } else {
                cout = [self.xiaoXiArr[2] intValue];
            }

            if (cout > 0) {
                tip.hidden = NO;
            } else {
                tip.hidden = YES;
            }
        }
        if (i == 0) {
            btn.selected = YES;
            self.checkBtn = btn;
            [self clickCheckBtn:btn];
        }
        [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.titleView = selectView;
}

- (void)clickCheckBtn:(UIButton *)btn {
    UIView *tip = [self.selectView viewWithTag:1234 + (btn.tag - 200)];
    if (tip != nil) {
        tip.hidden = YES;
    }
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
    switch (index) {
        case 0:
            [self.tongZhiTabVC.tableView.mj_header beginRefreshing];
            break;
        case 1:
            [self.xiaoXiTabVC.tableView.mj_header beginRefreshing];
            break;
        default:
            break;
    }
}

@end
