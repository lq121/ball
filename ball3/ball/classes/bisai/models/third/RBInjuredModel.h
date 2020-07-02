#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBInjuredModel : NSObject
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) BOOL isLast;
@end

NS_ASSUME_NONNULL_END
