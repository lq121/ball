#import <UIKit/UIKit.h>
#import "RBShiPingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBShiPingCollectionCell : UICollectionViewCell
@property(nonatomic,strong)RBShiPingModel *shiPingModel;
@property(nonatomic,assign)CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
