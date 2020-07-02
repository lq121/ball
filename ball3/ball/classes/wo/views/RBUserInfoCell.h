#import <UIKit/UIKit.h>
#import "RBUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBUserInfoCell : UITableViewCell
@property (strong, nonatomic) RBUserInfoModel *infoModel;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
