#import <UIKit/UIKit.h>
typedef void (^ClickItem1)(NSInteger);
typedef void (^ClickItem2)(NSInteger);
NS_ASSUME_NONNULL_BEGIN

@interface RBAnalySixCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *currentHostName;
@property (nonatomic, copy) NSString *currentVisitingName;
@property (nonatomic, copy) NSString *currentHostLogo;
@property (nonatomic, copy) NSString *currentVisitingLogo;
@property (copy, nonatomic) ClickItem1 clickItem1;
@property (copy, nonatomic) ClickItem2 clickItem2;
@property (nonatomic, copy) NSString *competitionName;
+ (instancetype)createCellByTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
