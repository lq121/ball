#import <UIKit/UIKit.h>
#import "RBWoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBWoCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (strong, nonatomic) RBWoModel *woModel;
@end

NS_ASSUME_NONNULL_END
