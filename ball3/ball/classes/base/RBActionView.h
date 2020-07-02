#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBActionView : UIButton
- (instancetype)initWithArray:(NSArray *)array andCancelBtnColor:(UIColor*)cancelColor andClickItem:(nonnull void (^)(NSInteger))clickitem;
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure andClickSureBtn:(void (^)(void))clickSureBtn;
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andSure:(NSString *)sure andClickSureBtn:(void (^)(void))clickSureBtn;
- (instancetype)initWithFrame:(CGRect)frame andLeft:(NSString *)left andRight:(NSString *)right andClickLeftBtn:(void (^)(void))clickLeftBtn andClickSureBtn:(void (^)(void))clickSureBtn;
@end

NS_ASSUME_NONNULL_END
