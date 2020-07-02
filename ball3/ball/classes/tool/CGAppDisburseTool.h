#import <Foundation/Foundation.h>

@interface CGAppDisburseTool : NSObject
//单例实现
+ (instancetype)sharedAppDisburse;

- (void)requestProductID:(NSString *)productID andOrderId:(NSString *)orderId andCreateTime:(int)createTime andAitype:(int)index andMatchId:(NSString *)matchId andMark:(NSString*)mark;

@end
