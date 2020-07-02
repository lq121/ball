#import <UIKit/UIKit.h>
#import "RBPredictModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBPredictCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBPredictModel *predictModel;
@end

NS_ASSUME_NONNULL_END
