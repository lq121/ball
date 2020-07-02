#import "RBBannerView.h"

static const double RBTimerInterval = 3.0;

@interface RBBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;    // 主滑动view
@property (nonatomic, strong) NSTimer *timer;            // 定时器
@property (nonatomic, assign) NSInteger pageCount;       // 页数
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, strong) UIPageControl *pageControl;  // 分页控件

@end

@implementation RBBannerView
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:RBTimerInterval target:self selector:@selector(changePageRight) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.index = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 添加滚动控件和分页控件
    [self addSubview:self.scrollView];
    // 设置初始页面
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    [self addSubview:self.pageControl];
    self.pageControl.currentPage = 0;
}

- (void)setShowPageCotl:(BOOL)showPageCotl {
    _showPageCotl = showPageCotl;
    self.pageControl.hidden = !showPageCotl;
}

#pragma mark - 懒加载控件

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)reloadData {
    [self.timer invalidate];
    self.timer = nil;
    self.pageCount = [self.datasource numberOfCellForBannerView:self];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * (self.pageCount + 2), CGRectGetHeight(self.frame));
    self.scrollView.scrollEnabled = self.pageCount > 1;
    if (self.pageCount == 0) {
        return;
    }
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.pageControl.numberOfPages = self.pageCount;
    if (self.pageCount > 1) {
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    // 添加分页，左右增加一页
    for (int i = 0; i < self.pageCount + 2; i++) {
        // 添加control,设置偏移位置
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        UIView *pageView = nil;
        if (i == 0) {
            // 第一页多余页跟最后一页一样并重新定义
            pageView = [self.datasource bannerView:self cellForIndex:self.pageCount - 1];
        } else if (i == self.pageCount + 1) {
            // 最后多余的一页跟第一页一样并重新定义
            pageView = [self.datasource bannerView:self cellForIndex:0];
        } else {
            pageView = [self.datasource bannerView:self cellForIndex:i - 1];
        }
        // 添加pageview
        pageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        // 将pageview挂在control上
        [self.scrollView addSubview:pageView];
        // 为每个页面添加响应层
        [control addTarget:self action:@selector(pageCliked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:control];
    }
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        // 设置尺寸，坐标，注意纵坐标的起点
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 41, self.frame.size.width, 40)];
        // 设置页面数
        _pageControl.numberOfPages = _pageCount;
        // 设置当前页面索引
        _pageControl.currentPage = 0;
        // 设置未被选中时小圆点颜色
        _pageControl.pageIndicatorTintColor = [UIColor colorWithSexadeString:@"#B8B8B8"];
        // 设置被选中时小圆点颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithSexadeString:@"#333333"];
        // 设置能手动点小圆点条改变页数
        _pageControl.enabled = YES;
        // 设置分页控制器的事件
        int i = 0;
        for (UIImageView *imgV in [_pageControl subviews]) {
            imgV.userInteractionEnabled = YES;      //默认为NO
            UIButton *botButton = [UIButton buttonWithType:UIButtonTypeCustom];
            botButton.frame = CGRectMake(imgV.x * 0.5, imgV.y * 0.5, imgV.width * 2, imgV.height * 2);
            botButton.tag = i;
            botButton.backgroundColor = [UIColor clearColor];
            [botButton addTarget:self action:@selector(tapBotAction:) forControlEvents:UIControlEventTouchUpInside];
            [imgV addSubview:botButton];
            i++;
        }
        [_pageControl addTarget:self action:@selector(pageControlTouched) forControlEvents:UIControlEventValueChanged];
    }

    return _pageControl;
}

- (void)tapBotAction:(id)sender {
    // 点击的时候停止计时
    [self.timer invalidate];
    self.timer = nil;
    int index = (int)[(UIButton *)sender tag];
    self.pageControl.currentPage = index;
    CGFloat offsetX = self.frame.size.width * (index + 1);
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

    // 重新开启定时器
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - pagecontrol事件
// 这个是点击小圆点条进行切换，到边不能循环
- (void)pageControlTouched {
    // 点击的时候停止计时
    [self.timer invalidate];
    self.timer = nil;
    // 滑到指定页面
    NSInteger curPageIdx = _pageControl.currentPage;
    CGFloat offsetX = self.frame.size.width * (curPageIdx + 1);
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

    // 重新开启定时器
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 滚动事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 记录偏移量
    self.offsetX = scrollView.contentOffset.x;
    // 开始手动滑动时暂停定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 左右边界
    CGFloat leftEdgeOffsetX = 0;
    CGFloat rightEdgeOffsetX = self.frame.size.width * (self.pageCount + 1);
    if (scrollView.contentOffset.x < self.offsetX) {
        // 左滑
        if (scrollView.contentOffset.x > leftEdgeOffsetX) {
            self.index = scrollView.contentOffset.x / self.frame.size.width - 1;
            self.pageControl.currentPage = self.index;
        } else if (scrollView.contentOffset.x == leftEdgeOffsetX) {
            self.index = self.pageCount - 1;
            self.pageControl.currentPage = self.index;
        }
        if (scrollView.contentOffset.x == leftEdgeOffsetX) {
            self.scrollView.contentOffset = CGPointMake(self.frame.size.width * self.pageCount, 0);
        }
    } else {
        // 右滑
        if (scrollView.contentOffset.x < rightEdgeOffsetX) {
            self.index = scrollView.contentOffset.x / self.frame.size.width - 1;
            self.pageControl.currentPage = self.index;
        } else if (scrollView.contentOffset.x == rightEdgeOffsetX) {
            self.index = 0;
            self.pageControl.currentPage = self.index;
        }

        // 滑动完了之后从最后多余页赶紧切换到第一页
        if (scrollView.contentOffset.x == rightEdgeOffsetX) {
            self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
    }
    // 结束后又开启定时器
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 定时器控制的滑动
// 往右边滑
- (void)changePageRight {
    // 设置当前需要偏移的量，每次递增一个page宽度
    CGFloat offsetX = _scrollView.contentOffset.x + CGRectGetWidth(self.frame);
    // 根据情况进行偏移
    CGFloat edgeOffsetX = self.frame.size.width * (self.pageCount + 1);  // 最后一个多余页面右边缘偏移量
    // 从多余页往右边滑，赶紧先设置为第一页的位置
    if (offsetX > edgeOffsetX) {
        // 偏移量，不带动画，欺骗视觉
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        // 这里提前改变下一个要滑动到的位置为第二页
        offsetX = self.frame.size.width * 2;
    }
    // 带动画滑动到下一页面
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (offsetX < edgeOffsetX) {
        self.index = offsetX / self.frame.size.width - 1;
        self.pageControl.currentPage = self.index;
    } else if (offsetX == edgeOffsetX) {
        // 最后的多余那一页滑过去之后设置小点为第一个
        self.index = 0;
        self.pageControl.currentPage = self.index;
    }
}

#pragma mark - 触控事件
- (void)pageCliked {
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectedIndex:)]) {
        [self.delegate bannerView:self didSelectedIndex:self.index];
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
