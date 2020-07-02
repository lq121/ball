
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBFanKuiDesCell : UITableViewCell
@property (nonatomic, copy) NSString *des;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
