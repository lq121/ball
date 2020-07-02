#import "UITextField+RBExtension.h"
#import <objc/runtime.h>

NSString *const RBTextFieldDidDeleteBackwardNotification = @"textfield_did_notification";

@implementation UITextField (Extension)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(yx_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)yx_deleteBackward {
    [self yx_deleteBackward];
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <RBTextFieldDelegate> delegate = (id<RBTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:RBTextFieldDidDeleteBackwardNotification object:self];
}

@end

