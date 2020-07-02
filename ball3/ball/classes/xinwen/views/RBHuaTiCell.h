#import <UIKit/UIKit.h>
#import "RBHuaTiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBHuaTiCell : UITableViewCell
@property(nonatomic,strong)RBHuaTiModel *huaTiModel;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
