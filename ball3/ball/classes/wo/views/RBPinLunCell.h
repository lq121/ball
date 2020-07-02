#import <UIKit/UIKit.h>
#import "RBHuaTiHuiFuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBPinLunCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBHuaTiHuiFuModel *huiFuModel;
@end

NS_ASSUME_NONNULL_END
