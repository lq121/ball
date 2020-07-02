#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBResultCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
@end

NS_ASSUME_NONNULL_END
