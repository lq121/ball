#import "RBBaseTabVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBAllHuaTiTabVC : RBBaseTabVC
- (void)loadDataWithType:(NSString *)type;
@property (nonatomic, assign) int currentPage;
@end

NS_ASSUME_NONNULL_END
