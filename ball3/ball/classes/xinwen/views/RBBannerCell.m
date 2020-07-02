#import "RBBannerCell.h"
#import "RBBannerView.h"
#import "RBBanner.h"
#import "RBHuaTiTabVC.h"

@interface RBBannerCell ()<BannerDataSource, BannerDelegate>
@property (nonatomic, strong) RBBannerView *bannerView;
@end

@implementation RBBannerCell

- (RBBannerView *)bannerView {
    if (_bannerView == nil) {
        _bannerView = [[RBBannerView alloc]initWithFrame:CGRectMake(12, 8, RBScreenWidth - 24, 146)];
        _bannerView.delegate = self;
        _bannerView.datasource = self;
        _bannerView.showPageCotl = NO;
    }
    return _bannerView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bannerView];
    }
    return self;
}

- (void)setBannerArr:(NSArray *)bannerArr {
    _bannerArr = bannerArr;
    [self.bannerView reloadData];
}

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBBannerCell";
    RBBannerCell *cell = (RBBannerCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (NSInteger)numberOfCellForBannerView:(RBBannerView *)bannerView {
    return self.bannerArr.count;
}

- (UIView *)bannerView:(RBBannerView *)bannerView cellForIndex:(NSInteger)index {
    RBBanner *banner = [[RBBanner alloc]initWithFrame:CGRectMake(12, 0, RBScreenWidth - 24, 146)];
    banner.bannerModel = self.bannerArr[index];
    return banner;
}

- (void)bannerView:(RBBannerView *)bannerView didSelectedIndex:(NSInteger)index {
    [[UIViewController getCurrentVC].navigationController pushViewController:[[RBHuaTiTabVC alloc]init] animated:YES];
}

@end
