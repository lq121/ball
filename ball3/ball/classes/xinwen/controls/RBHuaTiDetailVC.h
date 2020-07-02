#import <UIKit/UIKit.h>
#import "RBHuaTiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBHuaTiDetailVC : UIViewController
@property (nonatomic, strong) RBHuaTiModel *huaTiModel;
@property(nonatomic,assign)int huaTiId;
@property(nonatomic,assign)int type;
@end

NS_ASSUME_NONNULL_END
