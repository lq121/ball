#import <UIKit/UIKit.h>
#import "RBRenWuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBRenWuCell : UITableViewCell
@property(nonatomic,strong)RBRenWuModel *renWuModel;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
