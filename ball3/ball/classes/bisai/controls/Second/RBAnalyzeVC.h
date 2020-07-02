#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"
#import "RBBiSaiDetailHead.h"
#import "RBBaseTabVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^Clickcell)(void);

@interface RBAnalyzeVC : RBBaseTabVC
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
@property (nonatomic, copy) Clickcell clickCell;
@property (nonatomic, strong) RBBiSaiDetailHead *biSaiDetailHead;
@end

NS_ASSUME_NONNULL_END
