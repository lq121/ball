#import <UIKit/UIKit.h>
#import "RBDengJiDesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RBDengJiDesCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (strong, nonatomic) RBDengJiDesModel *model;
@end

NS_ASSUME_NONNULL_END
