#import <UIKit/UIKit.h>

typedef void (^ClickItem)(NSInteger);
NS_ASSUME_NONNULL_BEGIN

@interface RBAnalyFiveCell : UITableViewCell
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
@property (nonatomic, strong) NSDictionary *dict;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@property (copy, nonatomic) ClickItem clickItem;
@end

NS_ASSUME_NONNULL_END
