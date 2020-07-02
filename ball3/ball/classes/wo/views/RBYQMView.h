

#import <UIKit/UIKit.h>
typedef void(^OnFinishedEnterCode)(NSString * _Nullable code);
typedef void(^DeleteCode)(NSString * _Nullable code);
NS_ASSUME_NONNULL_BEGIN

@interface RBYQMView : UIView
- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode  andDeleteCode:(DeleteCode)deleteCode;
@property (nonatomic, weak) UITextField *codeTextField;
@end

NS_ASSUME_NONNULL_END
