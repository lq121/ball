#import <UIKit/UIKit.h>
#import "RBChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBTipViewCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBChatModel *chatModel;
@end

NS_ASSUME_NONNULL_END
