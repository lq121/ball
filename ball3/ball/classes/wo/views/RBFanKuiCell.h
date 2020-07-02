#import <UIKit/UIKit.h>
#import "RBFanKuiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBFanKuiCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBFanKuiModel *fanKuiModel;
@end

NS_ASSUME_NONNULL_END
