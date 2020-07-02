#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const ToolApiAppleDisburse = @"YXBwbGVwYXk="; // 苹果
static NSString * const ToolApiTypeWXH5 = @"d2VjaGF0aDU=";//
static NSString * const ToolApiTypeWX = @"d2VpeGlu";//
typedef enum {
    MoneyStatusSuccess,  // 成功
    MoneyStatusError,   // 失败
    MoneyStatusExit     // 退出
}MoneyStatus;

@interface RBNetworkTool : NSObject
+(instancetype)shareNetwork;
/// get获取数据
+ (void)GetDataWithUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param Success:(void (^)(NSDictionary *backData))success Fail:(void (^)(NSError *error))fail;
/// post获取数据
+ (void)PostDataWithUrlStr:(NSString *)urlStr andParam:(NSDictionary *)param Success:(void (^)(NSDictionary *backData))success Fail:(void (^)(NSError *error))fail;
/// 上传头像返回数据
+ (void)uploadImageWithImage:(UIImage *)image andDict:(NSDictionary *)dic andSuccess:(void (^)(NSDictionary *_Nonnull backData))success Fail:(void (^)(NSError *_Nonnull error))fail;
/// 上传多图获取数据（在发帖中使用）
+ (void)uploadImageWithImages:(NSArray *)images andDict:(NSDictionary *)dic andSuccess:(void (^)(NSDictionary *_Nonnull backData))success Fail:(void (^)(NSError *_Nonnull error))fail;
/// 网络监控
+ (void)netstatusLook;
/// 刷新refershToken
+ (void)refreshTokenSuccess:(void (^)(NSDictionary *_Nonnull backData))success Fail:(void (^)(NSError *_Nonnull error))fail;
+ (void)getcodeWithMobile:(NSString *)mobile AndType:(int)type Result:(void (^)(NSDictionary * backData, NSError * error))result;
+ (void)orderWithJsonDic:(NSDictionary *)jsonDic Type:(NSString *)type andStyle:(int)style Result:(void (^)(NSDictionary *, MoneyStatus, NSError *))result;
@end

NS_ASSUME_NONNULL_END
