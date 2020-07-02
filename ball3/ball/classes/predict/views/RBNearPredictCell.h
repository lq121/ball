#import <UIKit/UIKit.h>
#import "RBPredictModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBNearPredictCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBPredictModel *predictModel;
@end

NS_ASSUME_NONNULL_END
