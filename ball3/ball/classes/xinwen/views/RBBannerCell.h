#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBannerCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)NSArray *bannerArr;
@end

NS_ASSUME_NONNULL_END
