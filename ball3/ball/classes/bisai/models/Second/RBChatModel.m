#import "RBChatModel.h"

@implementation RBChatModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"vipLevel": @"viplevel", @"nickName": @"nickname", @"isVip": @"isvip", @"isStar": @"isstar", @"giftNum": @"giftnum" };
}

@end
