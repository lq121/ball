#import "SocketRocketUtility.h"

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) \
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) { \
        block(); \
    } else { \
        dispatch_async(dispatch_get_main_queue(), block); \
    }
#endif

NSString *const kNeedPayOrderNote = @"kNeedPayOrderNote";
NSString *const kWebSocketDidOpenNote = @"kWebSocketdidReceiveMessageNote";
NSString *const kWebSocketDidCloseNote = @"kWebSocketDidCloseNote";
NSString *const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";

@interface SocketRocketUtility ()<SRWebSocketDelegate>
{
    int _index;
    NSTimer *heartBeat;
    NSTimeInterval reConnectTime;
}

@property (nonatomic, strong) SRWebSocket *socket;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation SocketRocketUtility

+ (SocketRocketUtility *)instance {
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

#pragma mark - **************** public methods
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString {
    //如果是同一个url return
    if (self.socket) {
        return;
    }

    if (!urlString) {
        return;
    }
    self.urlString = urlString;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    self.socket.delegate = self;   //SRWebSocketDelegate 协议
    [self.socket open];     //开始连接
}

- (void)SRWebSocketClose {
    if (self.socket) {
        [self.socket close];
        self.socket = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidCloseNote object:nil];
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}

#define WeakSelf(ws) __weak __typeof(&*self) weakSelf = self
- (void)sendData:(id)data {
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);

    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据
            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                [self reConnect];
            }
        }
    });
}

#pragma mark - **************** private mothodes
//重连机制
- (void)reConnect {
    [self SRWebSocketClose];

    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlString];
    });

    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    } else {
        reConnectTime *= 2;
    }
}

//取消心跳
- (void)destoryHeartBeat {
    dispatch_main_async_safe(^{
        if (self->heartBeat) {
            if ([self->heartBeat respondsToSelector:@selector(isValid)]) {
                if ([self->heartBeat isValid]) {
                    [self->heartBeat invalidate];
                    self->heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat {
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        __weak typeof(self) weakSelf = self;
        self->heartBeat = [NSTimer timerWithTimeInterval:5 target:weakSelf selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:self->heartBeat forMode:NSRunLoopCommonModes];
    })
}

- (void)sentheart {
    //发送心跳 和后台可以约定发送什么内容  一般可以调用ping  我这里根据后台的要求 发送了data给他
    [self sendData:@"heart"];
}

//pingPong
- (void)ping {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
    [self initHeartBeat];
    if (webSocket == self.socket) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNote object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        _socket = nil;
        //连接失败就重连
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        [self SRWebSocketClose];
    }
}

/*该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@", reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    if (webSocket == self.socket) {
        NSString *jsonStr = message;
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessageNote object:tempDictQueryDiamond];
    }
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState {
    return self.socket.readyState;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
