#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"

typedef void (^ClickAttentionBtn)(BOOL);

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiCell : UITableViewCell
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property(nonatomic,strong)RBBiSaiModel *biSaiModel;
@property (copy, nonatomic) ClickAttentionBtn clickAttentionBtn;
@end

NS_ASSUME_NONNULL_END
