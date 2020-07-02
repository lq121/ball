#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBFenXiangView : UIButton
- (instancetype)initWithCopy:(BOOL)nocopy andClickItem:(void (^)(NSInteger index))clickitem;
- (instancetype)initWithClickItem:(void (^)(NSInteger index))clickitem;
- (void)clickCancelBtn;
@end

NS_ASSUME_NONNULL_END
