#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenBiSaiViewCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)NSArray *biSaiArr;
@end

NS_ASSUME_NONNULL_END
