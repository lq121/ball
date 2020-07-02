#import "RBCreateID.h"

NSString *const kMyIDKey = @"com.myid";

@implementation RBCreateID

#pragma mark - 获取到UUID后存入系统中的keychain中

+ (NSString *)createMyIDInKeyCH {
    NSString *getMyIDInKeychain = (NSString *)[RBCreateID load:kMyIDKey];
    if (!getMyIDInKeychain || [getMyIDInKeychain isEqualToString:@""] || [getMyIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [RBCreateID save:kMyIDKey data:result];

        getMyIDInKeychain = (NSString *)[RBCreateID load:kMyIDKey];
    }
    return getMyIDInKeychain;
}

+ (void)deleteKey {
    [self delete:kMyIDKey];
}

#pragma mark - 私有方法
+ (NSMutableDictionary *)getMyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, (id)kSecClass, service, (id)kSecAttrService, service, (id)kSecAttrAccount, (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible, nil];
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getMyChainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *exception) {
        } @finally {
        }
    }

    if (keyData) {
        CFRelease(keyData);
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getMyChainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getMyChainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

@end
