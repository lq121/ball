#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)NSArray *xinWenArr;
@end

NS_ASSUME_NONNULL_END
