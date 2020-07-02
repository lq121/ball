#import <UIKit/UIKit.h>
#import "RBAiDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBCompensateCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;

@property (nonatomic, strong) RBAiDataModel *aiDataModel;
@end

NS_ASSUME_NONNULL_END
