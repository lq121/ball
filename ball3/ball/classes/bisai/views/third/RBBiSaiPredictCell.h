#import <UIKit/UIKit.h>
#import "RBBISaiPredictModel.h"
typedef void (^ClickBtn)(NSInteger);
NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiPredictCell : UITableViewCell
@property (nonatomic, strong) RBBISaiPredictModel *biSaiPredictModel;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (copy, nonatomic) ClickBtn clickBtn;
@end

NS_ASSUME_NONNULL_END
