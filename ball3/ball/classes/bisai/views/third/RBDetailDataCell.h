#import <UIKit/UIKit.h>
#import "RBBiSaiDatailCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBDetailDataCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBBiSaiDatailCellModel *detailModel;
@end

NS_ASSUME_NONNULL_END
