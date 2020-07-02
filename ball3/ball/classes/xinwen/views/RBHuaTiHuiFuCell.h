#import <UIKit/UIKit.h>
#import "RBHuaTiHuiFuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBHuaTiHuiFuCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView andClickCellCloseBtn:(void (^)(RBHuaTiHuiFuModel *) )clickCloseBtn;
@property (nonatomic, strong) RBHuaTiHuiFuModel *huaTiHuiFuModel;
@end

NS_ASSUME_NONNULL_END
