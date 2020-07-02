#import <UIKit/UIKit.h>
#import "RBXinWenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenSmallCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBXinWenModel *xinwenModel;
@end

NS_ASSUME_NONNULL_END
