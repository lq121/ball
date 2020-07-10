#import "RBNetworkTool.h"
#import "AFNetworking.h"
#import "RBLoginVC.h"
#import "RBToast.h"
#import "CGAppDisburseTool.h"

@interface RBNetworkTool ()
@property (strong, nonatomic) AFURLSessionManager *manager;
@property (nonatomic, assign) BOOL hasRefresh;
@property (strong, nonatomic) NSDictionary *jsonDic;
@property (strong, nonatomic) NSString *moneyType;
@end

@implementation RBNetworkTool
+ (instancetype)shareNetwork {
    static RBNetworkTool *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[RBNetworkTool alloc] init];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/octet-stream", @"image/jpeg", @"text/plain", @"multipart/form-data", nil];
        manager.responseSerializer = responseSerializer;
        Instance.manager = manager;
    });
    return Instance;
}

+ (void)netstatusLook {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                break;
        }
    }];

    // 3.开始监控
    [manager startMonitoring];
}

+ (void)GetDataWithUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param Success:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    [[RBNetworkTool shareNetwork]netToolGetDataWithType:@"GET" andUrlStr:[NSString stringWithFormat:@"%@%@", BASEURL, urlStr]  andParam:param Success:^(NSDictionary *_Nonnull dict) {
        NSString *str = dict[@"data"];
        if ([str containsString:@"The access token is invalid or has expired"]) {
            [RBNetworkTool refreshTokenSuccess:^(NSDictionary *_Nonnull backdata) {
            } Fail:^(NSError *_Nonnull error) {
            }];

            [[RBNetworkTool shareNetwork]netToolGetDataWithType:@"GET" andUrlStr:[NSString stringWithFormat:@"%@%@", BASEURL, urlStr]  andParam:param Success:^(NSDictionary *_Nonnull dict) {
                success(dict);
            } Fail:^(NSError *_Nonnull error) {
                fail(error);
            }];
        } else {
            success(dict);
        }
    } Fail:^(NSError *_Nonnull error) {
        fail(error);
    }];
}

+ (void)PostDataWithUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param Success:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:param];
    if ([urlStr containsString:@"apis/"]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        if (uid != nil && ![uid isEqualToString:@""]) {
            [mDict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
        } else {
            success(@{});
            return;
        }
    }
    [[RBNetworkTool shareNetwork]netToolGetDataWithType:@"POST" andUrlStr:[NSString stringWithFormat:@"%@%@", BASEURL, urlStr]  andParam:mDict Success:^(NSDictionary *_Nonnull dict) {
        NSError *error;
        if (dict == nil) {
            success(@{});
            return;
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (!jsonData) {
            fail(error);
        } else {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        if ([jsonString containsString:@"The access token is invalid or has expired"]) {
            // token 无效
            [RBNetworkTool refreshTokenSuccess:^(NSDictionary *_Nonnull data) {
                [[RBNetworkTool shareNetwork]netToolGetDataWithType:@"POST" andUrlStr:[NSString stringWithFormat:@"%@%@", BASEURL, urlStr]  andParam:mDict Success:^(NSDictionary *_Nonnull dict) {
                    if ([dict.allKeys containsObject:@"error"]) {
                        NSString *er = dict[@"error"];
                        if ([er containsString:@"invalid_request"]) {
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userid"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Packet"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"setMatchArr"];
                            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"coinCount"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"vipDict"];
                            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"isVip"];
                            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"seletmatchArr"];
                            [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"notEditPwd"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            if ([[UIViewController getCurrentVC] isKindOfClass:[RBLoginVC class]]) {
                                return;
                            }
                            RBLoginVC *loginVC = [[RBLoginVC alloc]init];
                            loginVC.fromVC = [UIViewController getCurrentVC];
                            [[UIViewController getCurrentVC].navigationController pushViewController:loginVC animated:YES];
                        }
                    }
                    success(dict);
                } Fail:^(NSError *_Nonnull error) {
                    if (error != nil) {
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userid"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Packet"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"setMatchArr"];
                        [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"coinCount"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"vipDict"];
                        [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"isVip"];
                        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"seletmatchArr"];
                        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"notEditPwd"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        if ([[UIViewController getCurrentVC] isKindOfClass:[RBLoginVC class]]) {
                            return;
                        }
                        RBLoginVC *loginVC = [[RBLoginVC alloc]init];
                        loginVC.fromVC = [UIViewController getCurrentVC];
                        [[UIViewController getCurrentVC].navigationController pushViewController:loginVC animated:YES];
                    }
                    fail(error);
                }];
            } Fail:^(NSError *_Nonnull error) {
                fail(error);
                if (error != nil) {
                    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userid"];
                    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
                    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    RBLoginVC *loginVC = [[RBLoginVC alloc]init];
                    loginVC.fromVC = [UIViewController getCurrentVC];
                    [[UIViewController getCurrentVC].navigationController pushViewController:loginVC animated:YES];
                }
            }];
        } else {
            success(dict);
        }
    } Fail:^(NSError *_Nonnull error) {
        fail(error);
    }];
}

/// 刷新refershToken
+ (void)refreshTokenSuccess:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *refresh_token = [[NSUserDefaults standardUserDefaults]objectForKey:@"refresh_token"];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || ([uid isEqualToString:@""]) || ([refresh_token isEqualToString:@""] || refresh_token == nil)) {
        fail([NSError errorWithDomain:@""
                                 code:-101
                             userInfo:nil]);
        return;
    } else if ([RBNetworkTool shareNetwork].hasRefresh) {
        success(@{ @"success": @"yes" });
        return;
    }
    [dict setValue:refresh_token forKey:@"refresh_token"];
    [dict setValue:uid forKey:@"uid"];
    [RBNetworkTool shareNetwork].hasRefresh = YES;
    [RBNetworkTool PostDataWithUrlStr:@"try/go/rtoken" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        NSDictionary *dic = backData;
        [[NSUserDefaults standardUserDefaults]setValue:dic[@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults]setValue:dic[@"refresh_token"] forKey:@"refresh_token"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [RBNetworkTool shareNetwork].hasRefresh = NO;
        success(@{ @"success": @"yes" });
    } Fail:^(NSError *_Nonnull error) {
        fail(error);
        [RBNetworkTool shareNetwork].hasRefresh = NO;
    }];
}

- (void)netToolGetDataWithType:(NSString *)type andUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param Success:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:type URLString:urlStr parameters:nil error:nil];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (token != nil && ![token isEqualToString:@""] && (![request.URL.absoluteString containsString:@"try/go"])) {
        token = [NSString stringWithFormat:@"Bearer %@", token];
        [mutableRequest addValue:token forHTTPHeaderField:@"Authorization"];
        request = [mutableRequest copy];
    }
    request.timeoutInterval = 10;
    [request setValue:@"Keep-alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:data];

    [[self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
        if (responseObject != nil) {
            NSData *data = responseObject;
            NSString *str =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = nil;
            NSError *err;
            jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSDictionary *backDic;
            backDic = dic;

            if ([backDic isKindOfClass:[NSDictionary class]] && backDic[@"err"] != nil) {
                int errCode = [backDic[@"err"]intValue];
                [self showToastWithErrCode:errCode andString:urlStr];
            }
            success(backDic);
        } else {
            [RBToast showWithTitle:@"请检查网络连接是否正常"];
            fail(error);
        }
    }] resume];
}

/// Unicode转中文
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if (unicodeStr == nil) return @"";
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (void)uploadImageWithImages:(NSArray *)images andDict:(NSDictionary *)dic andSuccess:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //将token封装入请求头
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (token != nil && ![token isEqualToString:@""]) {
        token = [NSString stringWithFormat:@"Bearer %@", token];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        [dic setValue:token forKey:@"Authorization"];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASEURL, @"apis/ht/addhuati"];
    [manager POST:urlString parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 我这里的imgFile是对应后台给你url里面的图片参数，别瞎带。
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        NSArray *names = dic[@"imgs"];
        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData;
            if (image != nil) {
                imageData = [[RBNetworkTool shareNetwork] compressQualityWithImage:image];
            }
            if (imageData != nil) {
                [formData appendPartWithFileData:imageData name:names[i] fileName:names[i] mimeType:@"image/jpeg"];
            }
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:names
                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                         error:nil];
        NSString *string = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];

        [formData appendPartWithFormData:[string dataUsingEncoding:NSUTF8StringEncoding]  name:@"imgs"];
    } progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        fail(error);
    }];
}

+ (void)uploadImageWithImage:(UIImage *)image andDict:(NSDictionary *)dic andSuccess:(void (^)(NSDictionary *_Nonnull))success Fail:(void (^)(NSError *_Nonnull))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //调出请求头
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //将token封装入请求头
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"];
    if (token != nil && ![token isEqualToString:@""]) {
        token = [NSString stringWithFormat:@"Bearer %@", token];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        [dict setValue:token forKey:@"Authorization"];
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        fail([NSError errorWithDomain:@""
                                 code:-101
                             userInfo:nil]);
    }
    [dict setValue:uid forKey:@"uid"];
    NSData *imageData;
    if (image != nil) {
        imageData = [[RBNetworkTool shareNetwork] compressQualityWithImage:image];
    }
    if ([dic isEqual:@{}]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", BASEURL, @"apis/ca/changeavatar"];

        [manager POST:urlString parameters:dict headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat   = @"YYYY-MM-dd-hh:mm:ss:SSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 我这里的imgFile是对应后台给你url里面的图片参数，别瞎带。
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */

            [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            int errCode = [responseObject[@"err"]intValue];
            [[RBNetworkTool shareNetwork] showToastWithErrCode:errCode andString:@"apis/ca/changeavatar"];
            success(responseObject);
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            fail(error);
        }];
    } else {
        [dic setValue:uid forKey:@"uid"];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", BASEURL, @"apis/fk/addfeedback"];
        [manager POST:urlString parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat   = @"YYYY-MM-dd-hh:mm:ss:SSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 我这里的imgFile是对应后台给你url里面的图片参数，别瞎带。
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            if (imageData != nil) {
                [formData appendPartWithFileData:imageData name:@"img" fileName:fileName mimeType:@"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            fail(error);
        }];
    }
}

/// 压缩图片质量
- (NSData *)compressQualityWithImage:(UIImage *)image {
    CGFloat maxByetLimit = 1000 * 1000;
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    while (data.length > maxByetLimit) {
        CGFloat compression = 0.3;
        for (int i = 0; i < 5; ++i) {
            data = UIImageJPEGRepresentation(image, compression);
        }
    }
    return data;
}

/// 根据数据返回的errcode提示对应错误信息
- (void)showToastWithErrCode:(int)errCode andString:(NSString *)string {
    if ([string containsString:@"guanggaoactive"] || [string containsString:@"youkelogin"]) {
        return;
    }
    switch (errCode) {
        case 300:
            [RBToast showWithTitle:@"参数解析错误"];
            break;
        case 301:
            [RBToast showWithTitle:@"用户不存在"];
            break;
        case 302:
            [RBToast showWithTitle:@"缺失验证码"];
            break;
        case 303:
            [RBToast showWithTitle:@"密码错误"];
            break;
        case 304:
            [RBToast showWithTitle:@"token获取错误"];
            break;
        case 305:
            [RBToast showWithTitle:@"用户不存在"];
            break;
        case 306:
            [RBToast showWithTitle:@"用户已注册"];
            break;
        case 307: {
            [RBToast showWithTitle:@"token refresh错误"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Packet"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"setMatchArr"];
            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"coinCount"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"vipDict"];
            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"isVip"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"seletmatchArr"];
            [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"notEditPwd"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[UIViewController getCurrentVC].navigationController pushViewController:[[RBLoginVC alloc]init] animated:YES];
            break;
        }
        case 309:
            [RBToast showWithTitle:@"验证码错误"];
            break;
        case 310:
            [RBToast showWithTitle:@"重置密码错误"];
            break;
        case 311:
            [RBToast showWithTitle:@"记录不存在"];
            break;
        case 313:
            [RBToast showWithTitle:@"提现信息未登录"];
            break;
        case 321:
            [RBToast showWithTitle:@"关注目标和源是同一个人"];
            break;
        case 322:
            [RBToast showWithTitle:@"修改的昵称不能为空"];
            break;
        case 323:
            [RBToast showWithTitle:@"修改的昵称钱不够"];
            break;
        case 324:
            [RBToast showWithTitle:@"您已经投过票"];
            break;
        case 325:
            [RBToast showWithTitle:@"没有ai预测数据"];
            break;
        case 326:
            [RBToast showWithTitle:@"你已经买过预测结果"];
            break;
        case 327:
            [RBToast showWithTitle:@"金币不够"];
            break;
        case 328:
            [RBToast showWithTitle:@"已关注过"];
            break;
        case 5002:
            [RBToast showWithTitle:@"视频不存在"];
            break;
        case 5004:
            [RBToast showWithTitle:@"验证码不正确"];
            break;
        case 5005:
            [RBToast showWithTitle:@"验证码过期"];
            break;
        case 50004:
            [RBToast showWithTitle:@"你已经点赞过"];
            break;
        case 50005:
            [RBToast showWithTitle:@"该贴不能评论"];
            break;
        case 50006:
            [RBToast showWithTitle:@"今日举报次数已达上限"];
            break;
        case 50007:
            [RBToast showWithTitle:@"该号码已绑定其他账号，请更换"];
            break;
        case 50008:
            [RBToast showWithTitle:@"评论内容违法"];
            break;
        case 50009:
            [RBToast showWithTitle:@"已使用过邀请码"];
            break;
        case 50010:
            [RBToast showWithTitle:@"邀请码无效"];
            break;
        case 50011:
            [RBToast showWithTitle:@"比赛不存在"];
            break;
        default:
            break;
    }
}

+ (void)getcodeWithMobile:(NSString *)mobile AndType:(int)type Result:(void (^)(NSDictionary *, NSError *))result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:mobile forKey:@"mobile"];
    [dict setValue:@(type) forKey:@"style"];
    [self PostDataWithUrlStr:@"try/go/sendyz" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        result(backData, nil);
        if ([backData[@"ok"]intValue] == 1) {
            [RBToast showWithTitle:@"验证码已发送" andY:RBScreenHeight * 0.5];
        }
    } Fail:^(NSError *_Nonnull error) {
        result(nil, error);
        [RBToast showWithTitle:@"验证码发送失败" andY:RBScreenHeight * 0.5];
    }];
}

/**
 用户支付
 */
+ (void)orderWithJsonDic:(NSDictionary *)jsonDic Type:(NSString *)type andStyle:(int)style Result:(void (^)(NSDictionary *, MoneyStatus, NSError *))result {
    [RBNetworkTool shareNetwork].jsonDic = jsonDic;
    [RBNetworkTool shareNetwork].moneyType = type;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:jsonDic];
    if (style >= 7) {
        style = style + 93;
    }
    [dic setValue:@(style) forKey:@"style"];
    // 苹果支付
    [self PostDataWithUrlStr:@"apis/iosrecharge2" andParam:dic Success:^(NSDictionary *_Nonnull backData) {
        NSString *dealno = backData[@"ok"][@"dealno"];
        int createTime = [backData[@"ok"][@"tm"] intValue];
        int disbursestyle = [dic[@"style"]intValue];
        NSString *matchId = dic[@"matchid"];
        NSString *mark = dic[@"mark"];
        int aitype = [dic[@"aitype"]intValue];
        if (disbursestyle >= 100) {
            [[CGAppDisburseTool sharedAppDisburse] requestProductID:[NSString stringWithFormat:@"%d", 50000 + disbursestyle - 93] andOrderId:dealno andCreateTime:createTime andAitype:aitype andMatchId:matchId andMark:mark];
        } else {
            [[CGAppDisburseTool sharedAppDisburse] requestProductID:[NSString stringWithFormat:@"%d", 50000 + disbursestyle] andOrderId:dealno andCreateTime:createTime andAitype:aitype andMatchId:matchId andMark:mark];
        }
        result(backData, MoneyStatusSuccess, nil);
    } Fail:^(NSError *_Nonnull error) {
        result(nil, MoneyStatusError, error);
    }];
}

@end
