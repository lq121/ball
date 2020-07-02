#import <UIKit/UIKit.h>
#import "RBDaoJuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBDaoJuCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBDaoJuModel *daoJuModel;
@end

NS_ASSUME_NONNULL_END
