#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBHuiYuanVC : UIViewController
@property (nonatomic, assign) int huiYanType; // 1.未开通 2.已开通 3.已失效
@property (nonatomic, strong) NSDictionary *dict;
@end

NS_ASSUME_NONNULL_END
