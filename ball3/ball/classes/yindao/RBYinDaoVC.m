#import "RBYinDaoVC.h"
#import "RBTabBarVC.h"


#define pageSize 3

@interface RBYinDaoVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIView *detailView1;
@property (nonatomic, strong) UIView *detailView2;
@property (nonatomic, strong) UIView *detailView3;
@end

@implementation RBYinDaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(RBScreenWidth * pageSize, RBScreenWidth);

    UIView *detailView1 = [[UIView alloc]init];
    self.detailView1 = detailView1;
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.tag = 100;
    imageView1.userInteractionEnabled = YES;
    imageView1.image = [UIImage imageNamed:@"guide1"];
    imageView1.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight);
    [detailView1 addSubview:imageView1];
    UIButton *nextBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(14, 240 + RBNavBarAndStatusBarH, RBScreenWidth - 26, 132)];
    nextBtn1.tag = 101;
    [nextBtn1 addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn1 setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [detailView1 addSubview:nextBtn1];
    UILabel *detailLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nextBtn1.frame) + 15, RBScreenWidth, 28)];
    detailLab1.tag = 102;
    detailLab1.text = @"点击进入比赛详情";
    detailLab1.textColor = [UIColor whiteColor];
    detailLab1.textAlignment = NSTextAlignmentCenter;
    detailLab1.font = [UIFont systemFontOfSize:20];
    [detailView1 addSubview:detailLab1];

    UIView *detailView2 = [[UIView alloc]init];
    self.detailView2 = detailView2;
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.tag = 100;
    imageView2.userInteractionEnabled = YES;
    imageView2.image = [UIImage imageNamed:@"guide2"];
    imageView2.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight);
    [detailView2 addSubview:imageView2];
    UILabel *detailLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 260 + RBNavBarAndStatusBarH + RBBottomSafeH, RBScreenWidth - 10, 28)];
    detailLab2.tag = 101;
    detailLab2.text = @"点击购买预测";
    detailLab2.textColor = [UIColor whiteColor];
    detailLab2.textAlignment = NSTextAlignmentRight;
    detailLab2.font = [UIFont systemFontOfSize:20];
    [detailView2 addSubview:detailLab2];
    UIButton *nextBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 113, CGRectGetMaxY(detailLab2.frame) + 15, 103, 107)];
    nextBtn2.tag = 102;
    [nextBtn2 addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn2 setBackgroundImage:[UIImage imageNamed:@"point 2"] forState:UIControlStateNormal];
    [detailView2 addSubview:nextBtn2];

    UIView *detailView3 = [[UIView alloc]init];
    self.detailView3 = detailView3;
    UIImageView *imageView3 = [[UIImageView alloc]init];
    imageView3.tag = 100;
    imageView3.userInteractionEnabled = YES;
    imageView3.image = [UIImage imageNamed:@"guide3"];
    imageView3.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight);
    [detailView3 addSubview:imageView3];
    UILabel *detailLab31 = [[UILabel alloc]initWithFrame:CGRectMake(0, 216 + RBNavBarAndStatusBarH + RBBottomSafeH, RBScreenWidth - 12, 28)];
    detailLab31.text = @"可以使用优惠券购买";
    detailLab31.tag = 101;
    detailLab31.textColor = [UIColor whiteColor];
    detailLab31.textAlignment = NSTextAlignmentRight;
    detailLab31.font = [UIFont systemFontOfSize:20];
    [detailView3 addSubview:detailLab31];
    UIButton *nextBtn31 = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 110, CGRectGetMaxY(detailLab31.frame) + 10, 54, 28)];
    nextBtn31.tag = 102;
    [detailView3 addSubview:nextBtn31];
    [nextBtn31 setBackgroundImage:[UIImage imageNamed:@"choose count"] forState:UIControlStateNormal];
    nextBtn31.userInteractionEnabled = NO;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"tick rule"];
    imageView.frame = CGRectMake(15, RBScreenHeight - 110 - 61, 28, 28);
    [self.scrollView addSubview:imageView];
    UILabel *detailLab32 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, 0, RBScreenWidth - 100, 28)];
    detailLab32.tag = 103;
    detailLab32.centerY = imageView.centerY;
    detailLab32.text = @"勾选须知并确认支付订单";
    detailLab32.textColor = [UIColor whiteColor];
    detailLab32.textAlignment = NSTextAlignmentLeft;
    detailLab32.font = [UIFont systemFontOfSize:20];
    [detailView3 addSubview:detailLab32];

    UIButton *nextBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 193, RBScreenHeight - 82, 189, 82)];
    nextBtn3.tag = 104;
    [nextBtn3 addTarget:self  action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn3 setBackgroundImage:[UIImage imageNamed:@"pay ctn"] forState:UIControlStateNormal];
    [detailView3 addSubview:nextBtn3];

    NSArray *arr = @[detailView1, detailView2, detailView3];
    for (int i = 0; i < arr.count; i++) {
        UIView *view = arr[i];
        UIImageView *imageView = [view viewWithTag:100];
        view.frame = CGRectMake(RBScreenWidth * i, 0, RBScreenWidth, RBScreenHeight);
        UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
        cover.tag = 200;
        cover.backgroundColor = [UIColor colorWithSexadeString:@"#000000" AndAlpha:0.7];
        [view insertSubview:cover aboveSubview:imageView];
        [scrollView addSubview:view];
    }
    [self.view addSubview:scrollView];

    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 52 + RBStatusBarH, RBScreenWidth, 33)];
    tipLab.text = @"- 新手指引 -";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:tipLab];

    UIButton *skipBtn = [[UIButton alloc]initWithFrame:CGRectMake((RBScreenWidth - 170) * 0.5, RBScreenHeight - 56 - 32 - RBBottomSafeH, 170, 56)];
    [skipBtn addTarget:self action:@selector(clickSkipBtn) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setBackgroundImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
    [skipBtn setTitle:@"跳过指引" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor colorWithSexadeString:@"#494949"] forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.skipBtn = skipBtn;
    [self.view addSubview:skipBtn];

    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(14, 142 + RBNavBarAndStatusBarH, RBScreenWidth - 28, 215)];
    UIImageView *imageTipView = [[UIImageView alloc]init];
    tipView.hidden = YES;
    self.tipView = tipView;
    [self.view addSubview:tipView];
    imageTipView.userInteractionEnabled = YES;
    imageTipView.image = [UIImage imageNamed:@"pass all"];
    imageTipView.frame = tipView.bounds;
    [tipView addSubview:imageTipView];
    UILabel *skiptipLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, RBScreenWidth - 28, 28)];
    skiptipLab1.text = @"确定要跳过全部指引吗？";
    skiptipLab1.textColor = [UIColor colorWithSexadeString:@"#4C4C4C"];
    skiptipLab1.textAlignment = NSTextAlignmentCenter;
    skiptipLab1.font = [UIFont systemFontOfSize:20];
    [tipView addSubview:skiptipLab1];
    UILabel *skiptipLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(skiptipLab1.frame) + 1, RBScreenWidth - 28, 28)];
    skiptipLab2.text = @"跳过指引后将直接进入App";
    skiptipLab2.textColor = [UIColor colorWithSexadeString:@"#4C4C4C"];
    skiptipLab2.textAlignment = NSTextAlignmentCenter;
    skiptipLab2.font = [UIFont systemFontOfSize:14];
    [tipView addSubview:skiptipLab2];

    UIButton *skipCancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(86, 146, 40, 28)];
    [skipCancelBtn addTarget:self action:@selector(clickskipCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [skipCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [skipCancelBtn setTitleColor:[UIColor colorWithSexadeString:@"#494949"] forState:UIControlStateNormal];
    skipCancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [tipView addSubview:skipCancelBtn];

    UIButton *skipSureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(skipCancelBtn.frame) + 97, 146, 40, 28)];
    [skipSureBtn addTarget:self action:@selector(clickskipSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [skipSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [skipSureBtn setTitleColor:[UIColor colorWithSexadeString:@"#494949"] forState:UIControlStateNormal];
    skipSureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [tipView addSubview:skipSureBtn];
}

- (void)clickskipCancelBtn {
    self.tipView.hidden = YES;
    int index = self.scrollView.contentOffset.x / RBScreenWidth;
    if (index == 0) {
        for (UIView *child in self.detailView1.subviews) {
            child.hidden = NO;
        }
    } else if (index == 1) {
        for (UIView *child in self.detailView2.subviews) {
            child.hidden = NO;
        }
    } else if (index == 2) {
        for (UIView *child in self.detailView3.subviews) {
            child.hidden = NO;
        }
    }
}

- (void)clickskipSureBtn {
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"hasAnswer"];
    [[NSUserDefaults standardUserDefaults]synchronize]; \
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[RBTabBarVC alloc]init];
    });
}

- (void)clickSkipBtn {
    self.tipView.hidden = NO;
    int index = self.scrollView.contentOffset.x / RBScreenWidth;
    if (index == 0) {
        for (UIView *child in self.detailView1.subviews) {
            if (child.tag != 100 && child.tag != 200) {
                child.hidden = YES;
            }
        }
    } else if (index == 1) {
        for (UIView *child in self.detailView2.subviews) {
            if (child.tag != 100 && child.tag != 200) {
                child.hidden = YES;
            }
        }
    } else if (index == 2) {
        for (UIView *child in self.detailView3.subviews) {
            if (child.tag != 100 && child.tag != 200) {
                child.hidden = YES;
            }
        }
    }
}

- (void)clickBtn {
    int currentIndex = self.scrollView.contentOffset.x / RBScreenWidth;
    currentIndex += 1;
    self.scrollView.contentOffset = CGPointMake(RBScreenWidth * currentIndex, 0);
}

- (void)clickBtn3 {
    for (UIView *child in self.view.subviews) {
        [child removeFromSuperview];
    }
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    UIImageView *imageTipView = [[UIImageView alloc]init];
    [self.view addSubview:tipView];
    imageTipView.image = [UIImage imageNamed:@"guide4"];
    imageTipView.frame = tipView.bounds;
    [tipView addSubview:imageTipView];
    UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)];
    cover.backgroundColor = [UIColor colorWithSexadeString:@"#000000" AndAlpha:0.7];
    [tipView addSubview:cover];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhiyin"]];
    icon.frame = CGRectMake((RBScreenWidth - 88) * 0.5, RBNavBarAndStatusBarH + 174, 88, 88);
    [tipView addSubview:icon];

    UILabel *detailLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame) + 20, RBScreenWidth, 33)];
    detailLab1.text = @"欢迎来到小应体育";
    detailLab1.textColor = [UIColor whiteColor];
    detailLab1.textAlignment = NSTextAlignmentCenter;
    detailLab1.font = [UIFont systemFontOfSize:24];
    [tipView addSubview:detailLab1];

    UILabel *detailLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(detailLab1.frame), RBScreenWidth, 20)];
    detailLab2.text = @"Welcome to 小应体育";
    detailLab2.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    detailLab2.textAlignment = NSTextAlignmentCenter;
    detailLab2.font = [UIFont systemFontOfSize:14];
    [tipView addSubview:detailLab2];
    [self.view addSubview:tipView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickskipSureBtn];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentIndex = scrollView.contentOffset.x / RBScreenWidth;
    if (currentIndex == 2) {
        self.skipBtn.y = RBNavBarAndStatusBarH + 68;
    } else {
        self.skipBtn.y = RBScreenHeight - 56 - 32 - RBBottomSafeH;
    }
}

//改变pagecontrol中圆点样式
- (void)changePageControlImage:(UIPageControl *)pageControl {
    static UIImage *currentImage = nil;
    static UIImage *otherImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentImage = [UIImage imageNamed:@"currentpageIndicator"];
        otherImage = [UIImage imageNamed:@"pageIndicator"];
    });

    [pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [pageControl setValue:otherImage forKey:@"_pageImage"];
}

@end
