#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBAnalyThirdCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
