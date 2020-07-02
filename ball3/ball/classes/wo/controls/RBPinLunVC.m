#import "RBPinLunVC.h"
#import "RBPinLunTabVC.h"
#import "RBHudongHeadView.h"

@interface RBPinLunVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RBPinLunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 48, RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH - 48)];
    self.scrollView = scrollView;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(2 * RBScreenWidth, RBScreenHeight - RBNavBarAndStatusBarH);
    [self.view addSubview:scrollView];

    for (int i = 0; i < 2; i++) {
        RBPinLunTabVC *pinLunTabVC = [[RBPinLunTabVC alloc]init];
        [self addChildViewController:pinLunTabVC];
        UITableView *tabView = pinLunTabVC.tableView;
        pinLunTabVC.type = i;
        tabView.frame = CGRectMake(i * RBScreenWidth, 0, RBScreenWidth, scrollView.height);
        [self.scrollView addSubview:tabView];
        if (i == 0) {
            [tabView.mj_header beginRefreshing];
        }
    }

    RBHudongHeadView *secondHeadView = [[RBHudongHeadView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 48) firstTitle:@"话题的评论" andSecondTitle:@"视频的评论" andClickItem:^(NSInteger index) {
        if (self.scrollView.contentOffset.x == RBScreenWidth * index) {
            return;
        } else {
            RBPinLunTabVC *pinLunTabVC = self.childViewControllers[index];
            UITableView *tableView = pinLunTabVC.tableView;
            [tableView.mj_header beginRefreshing];
            self.scrollView.contentOffset = CGPointMake(RBScreenWidth * index, 0);
        }
    }];
    [self.view addSubview:secondHeadView];
}

@end
