#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (RBExtension)
+ (instancetype)itemWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andTarget:(id)target andAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
