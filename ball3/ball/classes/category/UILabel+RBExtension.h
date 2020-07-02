#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger, NSTextAlignmentExpand) {
    NSTextAlignmentTop            = 5,    // Visually top aligned
    NSTextAlignmentBottom         = 6,    // Visually bottom aligned
    NSTextAlignmentLeftTop        = 7,    // Visually left and top aligned
    NSTextAlignmentRightTop       = 8,    // Visually right and top aligned
    NSTextAlignmentLeftBottom     = 9,    // Visually left and bottom aligned
    NSTextAlignmentRightBottom    = 10,   // Visually right and bottom aligned
    NSTextVerticalAlignmentTop    = 11, // default
    NSTextVerticalAlignmentMiddle = 12,
    NSTextVerticalAlignmentBottom = 13,
} NS_ENUM_AVAILABLE_IOS (6_0);
@interface UILabel (RBExtension)

@end

NS_ASSUME_NONNULL_END
