#import <UIKit/UIKit.h>
#import "RBJinBiModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RBJinBiCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBJinBiModel *jinBiModel;
@end

NS_ASSUME_NONNULL_END
