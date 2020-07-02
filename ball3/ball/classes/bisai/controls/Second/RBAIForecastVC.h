#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBAIForecastVC : UIViewController
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
-(void)clickinde;
@property (nonatomic, strong) UIButton *checkBtn;
@end

NS_ASSUME_NONNULL_END
