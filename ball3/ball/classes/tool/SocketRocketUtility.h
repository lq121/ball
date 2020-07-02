
#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString *const kNeedPayOrderNote;
extern NSString *const kWebSocketDidOpenNote;
extern NSString *const kWebSocketDidCloseNote;
extern NSString *const kWebSocketdidReceiveMessageNote;

@interface SocketRocketUtility : NSObject

// 获取连接状态
@property (nonatomic, assign, readonly) SRReadyState socketReadyState;

+ (SocketRocketUtility *)instance;

- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;//开启连接
- (void)SRWebSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据
- (void)reConnect;

@end
