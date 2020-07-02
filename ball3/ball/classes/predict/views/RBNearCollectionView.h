#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBNearCollectionView : UICollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout andmodels:(NSArray *)models andClickItem:(void (^)(NSInteger index))clickitem;
@end

NS_ASSUME_NONNULL_END
