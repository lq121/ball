#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBWoFirstCell : UITableViewCell
@property (nonatomic, assign) BOOL showXiaoXiTip;
@property (nonatomic, assign) BOOL showHuaTiTip;
@property (nonatomic, strong) NSArray *xiaoXiArr;
@property(nonatomic,strong)NSArray *huaTiArr;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
