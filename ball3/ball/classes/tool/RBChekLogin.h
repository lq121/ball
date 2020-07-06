#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBChekLogin : NSObject
+ (BOOL)NotLogin;
+ (BOOL)checkWithTitile:(NSString *)title andtype:(NSString*)type andNeedCheck:(BOOL)need;
@end

NS_ASSUME_NONNULL_END
