#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RBExtension)
/// 根据字体获取大小（字体可以自定义）
- (CGSize)getLineSizeWithFont:(UIFont *)font;
/// 根据字体大小获取大小（字体为系统自带的）
- (CGSize)getLineSizeWithFontSize:(CGFloat)fontSize;
/// 根据粗体字体大小获取大小（字体为系统自带的粗体）
- (CGSize)getLineSizeWithBoldFontSize:(CGFloat)fontSize;
/// 根据字体和最大宽度获取多行文字的大小
- (CGSize)getSizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)width;
/// 根据字体大小（字体为系统自带的）和最大宽度获取多行文字的大小
- (CGSize)getSizeWithFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)width;

///获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)shouZiMu:(NSString *)aString;
/// 字符串MD5
+ (NSString *)MD5:(NSString *)str;
/// 是否是合法的电话号码
+ (BOOL)isVaildPhone:(NSString *)mobile;
+ (BOOL)isVaildUserCard:(NSString *)userCard;

/// 两个时间差(秒)转字符串
+ (NSString *)comperTime:(int)fromTime andToTime:(int)toTime;
/// 根据时间获得对应的星期
+ (NSString *)weekdayStringFromDate:(int)time;
/// 时间格式化
+ (NSString *)getStrWithDate:(NSDate *)date andFormat:(NSString *)format;
/// 时间戳格式化
+ (NSString *)getStrWithDateInt:(int)dateInt andFormat:(NSString *)format;
/// 时间格式化
+ (NSString *)getComperStrWithDateInt:(int)dateInt andFormat:(NSString *)format;
/// 时间戳返回刚刚，几分钟前
+ (NSString *)getTimeWithTimeTamp:(int)timeTamp;
+ (NSDate *)stringToDate:(NSString *)str;

+ (NSString *)formatFloat:(double)f;
@end

NS_ASSUME_NONNULL_END
