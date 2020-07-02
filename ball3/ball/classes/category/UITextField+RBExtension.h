#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RBTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end

@interface UITextField (RBExtension)
@property (weak, nonatomic) id <RBTextFieldDelegate> delegate;
@end

/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const RBTextFieldDidDeleteBackwardNotification;

NS_ASSUME_NONNULL_END
