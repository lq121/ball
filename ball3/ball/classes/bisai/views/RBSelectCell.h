#import <UIKit/UIKit.h>
#import "RBSelectModel.h"
typedef void (^ClickBtn)(RBSelectModel *_Nullable);
NS_ASSUME_NONNULL_BEGIN

@interface RBSelectCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) ClickBtn clickBtn;
@end

NS_ASSUME_NONNULL_END
