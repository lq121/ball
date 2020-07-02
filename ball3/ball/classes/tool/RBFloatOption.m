#import "RBFloatOption.h"

@implementation RBFloatOption
+ (BOOL)judgeDivisibleWithFirstNumber:(CGFloat)firstNumber andSecondNumber:(CGFloat)secondNumber {
    BOOL isDivisible = YES;
    if (secondNumber == 0) {
        return NO;
    }
    CGFloat result = firstNumber / secondNumber;
    NSString *resultStr = [NSString stringWithFormat:@"%f", result];
    NSRange range = [resultStr rangeOfString:@"."];
    NSString *subStr = [resultStr substringFromIndex:range.location + 1];
    for (NSInteger index = 0; index < subStr.length; index++) {
        unichar ch = [subStr characterAtIndex:index];
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
            isDivisible = NO;
            break;
        }
    }
    return isDivisible;
}
@end
