#import "AppDelegate.h"
#import "RBTabBarVC.h"
#import "RBNavigationVC.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <Bugly/Bugly.h>
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBTipView.h"
#import "RBYinDaoVC.h"
#import <GTSDK/GeTuiSdk.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#import "RBBiSaiDetailVC.h"

#endif

@interface AppDelegate ()<WXApiDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier taskId;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL needShow;
@property (nonatomic, strong) NSDictionary *checkDict;
@end

@implementation AppDelegate
- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (self.checkDict != nil) {
        [self checkre];
    }
}

- (void)checkre {
    [MBProgressHUD showLoading:@"订单确认中请稍后" toView:[UIApplication sharedApplication].keyWindow];
    int style = [self.checkDict[@"style"]intValue];
    [RBNetworkTool PostDataWithUrlStr:@"apis/wxcheckrecharge" andParam:self.checkDict Success:^(NSDictionary *_Nonnull backData) {
        self.checkDict = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
                           if (backData[@"err"] != nil) {
                               [RBToast showWithTitle:zhifufail];
                           } else {
                               [RBToast showWithTitle:zhifusuccess];
                               if (style <= 6) {
                                   int coinCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"coinCount"]intValue];
                                   coinCount += [backData[@"ok"]intValue];
                                   [[NSUserDefaults standardUserDefaults]setValue:@(coinCount) forKey:@"coinCount"];
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"changeCoinCount" object:nil];
                               } else if (style == 100) {
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"changevip" object:backData];
                               } else if (style == 101) {
                                   [[NSNotificationCenter defaultCenter]postNotificationName:@"changeai" object:nil];
                               }
                           }
                           [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                       });
    } Fail:^(NSError *_Nonnull error) {
        self.checkDict = nil;
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // bugly
    [Bugly startWithAppId:buglyID];
    // 个推
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    [RBNetworkTool refreshTokenSuccess:^(NSDictionary *_Nonnull backData) {
    } Fail:^(NSError *_Nonnull error) {
    } ];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [RBNetworkTool netstatusLook];
    // 微信应用注册
    if ([WXApi isWXAppInstalled]) {
        [WXApi registerApp:APPID universalLink:@"https://ytball.com/"];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needShow:) name:@"needShow" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkrecharge:) name:@"checkrecharge" object:nil];
    BOOL answer = [[[NSUserDefaults standardUserDefaults]objectForKey:@"hasAnswer"]boolValue];
    if (!answer) {
        self.window.rootViewController = [[RBYinDaoVC alloc]init];
        [self.window makeKeyAndVisible];
    } else {
        self.window.rootViewController = [[RBTabBarVC alloc]init];
        [self.window makeKeyAndVisible];
    }
    return YES;
}

- (void)registerRemoteNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        return;
    }

    if (@available(iOS 8.0, *)) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)checkrecharge:(NSNotification *)noti {
    self.checkDict = noti.object;
}

- (void)needShow:(NSNotification *)noti {
    self.needShow = [noti.object boolValue];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring> > *_Nullable))restorationHandler {
    return YES;
}

//支付回调9以后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

//支付回调9以前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

//ios9以后的方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (self.needShow) {
            // 分享
            if (resp.errCode == 0) {
                [RBTipView tipWithTitle:fengxiangsuccess andExp:1 andCoin:1];
            } else {
                [RBToast showWithTitle:fengxiangFail];
            }
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 微信登录
        if (resp.errCode == 0) {
            // 成功
            SendAuthResp *aresp = (SendAuthResp *)resp;
            NSString *code = aresp.code;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"wxLogin" object:code];
        } else {
            // 失败
            [RBToast showWithTitle:@"登录失败"];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    //重置应用的角标
    [self resetApplicationIconBadgeNumber];
     __block UIBackgroundTaskIdentifier background_task;
       //注册一个后台任务，告诉系统我们需要向系统借一些事件
    self.taskId = [application beginBackgroundTaskWithExpirationHandler:^ {
           //不管有没有完成，结束background_task任务
           [application endBackgroundTask: background_task];
           background_task = UIBackgroundTaskInvalid;
       }];
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
           while(true){
                sleep(1000);
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                    //我们自己完成任务后，结束background_task任务
                    [application endBackgroundTask: background_task];
                    background_task = UIBackgroundTaskInvalid;
                    return;
               }
           }

       });
    
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceTokenData:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0))
{
    [GeTuiSdk setBadge:0];
    NSDictionary *dict = notification.request.content.userInfo;
    if ([dict objectForKey:@"payload"]) {
        NSString *payload = dict[@"payload"];
        [self userClickWithDict:payload];
    }
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0))
{
    [GeTuiSdk setBadge:0];
    NSDictionary *dict = response.notification.request.content.userInfo;
    if ([dict objectForKey:@"payload"]) {
        NSString *payload = dict[@"payload"];
        [self userClickWithDict:payload];
    }

    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];

    completionHandler();
}

- (void)userClickWithDict:(NSString *)payload {
    NSData *data = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    int style = [dict[@"style"]intValue];
    int matchId = [dict[@"id"]intValue];
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[RBTabBarVC class]]) {
        if (style == 1) {
            RBBiSaiDetailVC *detailTabVC = [[RBBiSaiDetailVC alloc]init];
            RBBiSaiModel *biSaiModel = [[RBBiSaiModel alloc]init];
            biSaiModel.namiId = matchId;
            detailTabVC.biSaiModel = biSaiModel;
            [[UIViewController getCurrentVC].navigationController pushViewController:detailTabVC animated:YES];
        }
    }
}

#endif

//这个方法是为了清除应用的角标，同时又不清除之前发送的通知内容
- (void)resetApplicationIconBadgeNumber {
    [GeTuiSdk setBadge:0];
    //使用这个方法清除角标，如果置为0的话会把之前收到的通知内容都清空；置为-1的话，不但能保留以前的通知内容，还有角标消失动画，iOS10之前这样设置是没有作用的 ，iOS10之后才有效果 。
    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
}


@end
