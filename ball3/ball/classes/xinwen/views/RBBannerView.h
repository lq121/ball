#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RBBannerView;

@protocol BannerDataSource <NSObject>
// 轮播图的个数
- (NSInteger)numberOfCellForBannerView:(RBBannerView *)bannerView;
// 轮播图填充
- (UIView *)bannerView:(RBBannerView *)bannerView cellForIndex:(NSInteger)index;
@end

@protocol BannerDelegate <NSObject>

@optional
// 选中轮播图项
- (void)bannerView:(RBBannerView *)bannerView didSelectedIndex:(NSInteger)index;
@end

@interface RBBannerView : UIView
@property (nonatomic, weak) id<BannerDelegate> delegate;
@property (nonatomic, weak) id<BannerDataSource> datasource;
- (void)reloadData;
@property(nonatomic,assign)BOOL showPageCotl;
@end

NS_ASSUME_NONNULL_END
