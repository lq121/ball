#import <UIKit/UIKit.h>
#import "RBBaseTabVC.h"
#import "RBBiSaiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBPredictTableVC : RBBaseTabVC
@property (nonatomic, assign) int matchId;
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
@end

NS_ASSUME_NONNULL_END
