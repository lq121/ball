#import <UIKit/UIKit.h>
#import "RBInjuredModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBDetailInjuredCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBInjuredModel *injuredModel;
@end

NS_ASSUME_NONNULL_END
