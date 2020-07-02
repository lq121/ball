#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"
#import "RBBiSaiDetailHead.h"
#import "RBBaseTabVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBLiveTabVC : RBBaseTabVC
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
@property(nonatomic,strong)RBBiSaiDetailHead *biSaiDetailHead;
@end

NS_ASSUME_NONNULL_END
