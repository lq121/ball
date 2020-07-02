#import <UIKit/UIKit.h>
typedef void (^ClickBtn)(NSInteger);
NS_ASSUME_NONNULL_BEGIN

@interface RBAnalyFirstCell : UITableViewCell
@property(nonatomic,assign)int gameStatus;
@property (nonatomic, strong) NSDictionary *dict;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (copy, nonatomic) ClickBtn clickBtn;
@end

NS_ASSUME_NONNULL_END
