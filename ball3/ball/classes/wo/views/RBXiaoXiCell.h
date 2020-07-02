#import <UIKit/UIKit.h>
#import "RBXiaoXiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBXiaoXiCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBXiaoXiModel *xiaoxiModel;
@end

NS_ASSUME_NONNULL_END
