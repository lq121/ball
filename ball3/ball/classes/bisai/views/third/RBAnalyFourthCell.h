#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBAnalyFourthCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
@property (nonatomic, copy) NSString *currentHostLogo;
@property (nonatomic, copy) NSString *currentVisitingLogo;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
