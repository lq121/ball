#import <UIKit/UIKit.h>
#import "RBLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBLiveCell : UITableViewCell
+ (CGFloat)getCellHeightWithString:(NSString *)string;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBLiveModel *liveModel;
@end

NS_ASSUME_NONNULL_END
