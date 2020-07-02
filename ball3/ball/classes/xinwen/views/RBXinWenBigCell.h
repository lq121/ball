#import <UIKit/UIKit.h>
#import "RBXinWenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenBigCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) RBXinWenModel *xinWenModel;
@end

NS_ASSUME_NONNULL_END
