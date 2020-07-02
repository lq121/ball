#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBCommButton : UIButton
@property (assign, nonatomic, readwrite) BOOL showTip;

- (instancetype)initWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action;
- (instancetype)initWithImage:(NSString *)image andHeighImage:(NSString *)heightImage andFrame:(CGRect)frame andTitle:(NSString *)title andTarget:(id)target andAction:(SEL)action andLabelFontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
