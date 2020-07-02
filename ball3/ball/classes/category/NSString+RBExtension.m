#import "NSString+RBExtension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (RBExtension)
/// 根据字体获取大小（字体可以自定义）
- (CGSize)getLineSizeWithFont:(UIFont *)font {
    if (self == nil || [self length] == 0) return CGSizeZero;
    return [self sizeWithAttributes:@{ NSFontAttributeName: font }];
}

/// 根据字体大小获取大小（字体为系统自带的）
- (CGSize)getLineSizeWithFontSize:(CGFloat)fontSize {
    if (self == nil || [self length] == 0) return CGSizeZero;
    return [self sizeWithAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize] }];
}

/// 根据粗体字体大小获取大小（字体为系统自带的粗体）
- (CGSize)getLineSizeWithBoldFontSize:(CGFloat)fontSize {
    if (self == nil || [self length] == 0) return CGSizeZero;
    return [self sizeWithAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize] }];
}

/// 根据字体和最大宽度获取多行文字的大小
- (CGSize)getSizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)width {
    if (self == nil || [self length] == 0) return CGSizeZero;
    NSDictionary *attribute = @{ NSFontAttributeName: font };
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
}

/// 根据字体大小（字体为系统自带的）和最大宽度获取多行文字的大小
- (CGSize)getSizeWithFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)width {
    if (self == nil || [self length] == 0) return CGSizeZero;
    NSDictionary *attribute = @{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize] };
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
}

+ (NSString *)MD5:(NSString *)str {
    //不管何种问题，如果传入参数有误则返回@“”
    if (str == nil) {
        return @"";
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

+ (BOOL)isVaildPhone:(NSString *)mobile {
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        return NO;
    } else {
        // 移动号段正则表达式
        NSString *CM_NUM = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
        //联通号段正则表达式
        NSString *CU_NUM2 = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        // 电信号段正则表达式
        NSString *CT_NUM3 = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM2];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM3];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        } else {
            return NO;
        }
    }
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)shouZiMu:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

+ (BOOL)isVaildUserCard:(NSString *)userCard {
    //长度不为18的都排除掉
    if (userCard.length != 18) {
        return NO;
    }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:userCard];

    if (!flag) {
        return flag;    //格式错误
    } else {
        //格式正确在判断是否合法
        //将前17位加权因子保存在数组里
        NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for (int i = 0; i < 17; i++) {
            NSInteger subStrIndex = [[userCard substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum += subStrIndex * idCardWiIndex;
        }
        //计算出校验码所在数组的位置
        NSInteger idCardMod = idCardWiSum % 11;
        //得到最后一位身份证号码
        NSString *idCardLast = [userCard substringWithRange:NSMakeRange(17, 1)];
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if (idCardMod == 2) {
            if ([idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"]) {
                return YES;
            } else {
                return NO;
            }
        } else {
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if ([idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]]) {
                return YES;
            } else {
                return NO;
            }
        }
    }
}



+ (NSString *)comperTime:(int)fromTime andToTime:(int)toTime {
    return [NSString stringWithFormat:@"%d", (fromTime - toTime) / 60 + 1];
}

+ (NSString *)getTimeWithTimeTamp:(int)timeTamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeTamp)];
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:date toDate:now options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (delta.year >= 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    } else if (delta.month >= 1) {
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date];
    } else if (delta.day > 1) {
        [dateFormatter setDateFormat:@"MM-dd HH:MM"];
        return [dateFormatter stringFromDate:date];
    } else if (delta.day == 1) {
        [dateFormatter setDateFormat:@" HH:MM"];
        return [NSString stringWithFormat:@"昨天:%@", [dateFormatter stringFromDate:date]];
    } else if (delta.hour >= 1) {
        return [NSString stringWithFormat:@"%d小时前", (int)delta.hour];
    } else if (delta.minute >= 1) {
        return [NSString stringWithFormat:@"%d分钟前", (int)delta.minute];
    } else {
        return @"刚刚";
    }
}

+ (NSString *)weekdayStringFromDate:(int)time {
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time];
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",  nil];
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [myCalendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [myCalendar components:calendarUnit fromDate:nd];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)getComperStrWithDateInt:(int)dateInt andFormat:(NSString *)format {
    NSString *str = [self getStrWithDateInt:dateInt andFormat:format];
    NSString *resultStr = [[NSString alloc]init];
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    NSDateComponents *components = [myCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *components2 = [myCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:dateInt]];
    NSDate *zeroDate = [myCalendar dateFromComponents:components];
    NSDate *toData = [myCalendar dateFromComponents:components2];
    NSDateComponents *theComponents = [myCalendar components:calendarUnit fromDate:zeroDate toDate:toData options:0];
    if (theComponents.day == 0) {
        if ([format containsString:@"/"]) {
            resultStr = [[NSString alloc]initWithFormat:@"%@ 今天", str];
        } else {
            resultStr = [[NSString alloc]initWithFormat:@"今天 %@", str];
        }
    } else if (theComponents.day >= 1) {
        if ([format containsString:@"/"]) {
            resultStr = [[NSString alloc]initWithFormat:@"%@ %@", str, [self getStrWithDateInt:dateInt andFormat:@"yyyy-M-d"]];
        } else {
            resultStr = [[NSString alloc]initWithFormat:@"%@ %@", [self getStrWithDateInt:dateInt andFormat:@"M月d日 "], str];
        }
    } else if (theComponents.day == -1) {
        if ([format containsString:@"/"]) {
            resultStr = [[NSString alloc]initWithFormat:@"%@ 昨天", str];
        } else {
            resultStr = [[NSString alloc]initWithFormat:@"昨天 %@", str];
        }
    } else if (theComponents.day < -1) {
        if ([format containsString:@"/"]) {
            resultStr = [[NSString alloc]initWithFormat:@"%@",[self getStrWithDateInt:dateInt andFormat:@"M月d日 HH:mm"]];
        } else {
            resultStr = [[NSString alloc]initWithFormat:@"%@",[self getStrWithDateInt:dateInt andFormat:@"M月d日 HH:mm"]];
        }
    }
    return resultStr;
}

+ (NSDate *)stringToDate:(NSString *)str {
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // created_at(NSString) --> NSDate
    fmt.dateFormat = @"yyyyMMdd";
    // 设置时间所属的区域
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 发布时间
    NSDate *date = [fmt dateFromString:str];
    return date;
}

/// 时间格式化
+ (NSString *)getStrWithDate:(NSDate *)date andFormat:(NSString *)format {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    fmt.dateFormat = format;
    return [fmt stringFromDate:date];
}

/// 时间戳格式化
+ (NSString *)getStrWithDateInt:(int)dateInt andFormat:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    return [NSString getStrWithDate:date andFormat:format];
}

/// double数字原样输出（几位小数点输出几位）
+ (NSString *)formatFloat:(double)f {
    if (fmodf(f, 1) == 0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f", f];
    } else if (fmodf(f * 10, 1) == 0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f", f];
    } else {
        return [NSString stringWithFormat:@"%.2f", f];
    }
}

@end
