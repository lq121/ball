#import <UIKit/UIKit.h>
#import "RBChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RBChatCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBChatModel *chatModel;
- (CGFloat)getCellHeight;
@end

NS_ASSUME_NONNULL_END
