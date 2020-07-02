#import "RBTextView.h"

CGFloat const verticalMargin = 8.0;
CGFloat const horiziontalMargin = 16.0;
@interface RBTextView()
@property (nonatomic, copy) RBTextViewHandler changeHandler;
@property (nonatomic, copy) RBTextViewHandler maxHandler;
@property (nonatomic, strong) UILabel *placeholderLabel;
@end
@implementation RBTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self layoutIfNeeded];
    }
    [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    return resign;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = [super canPerformAction:action withSender:sender];
    if (result) {
        if (![self respondsToSelector:action]) {
            result = NO;
        } else {
            result = _canPerformAction;
        }
    }
    return result;
}

#pragma mark - Private

- (void)initialize {
    // 基本配置 (需判断是否在Storyboard中设置了值)
    _canPerformAction = YES;
    if (_maxLength == 0 || _maxLength == NSNotFound) {
        _maxLength = NSUIntegerMax;
    }
    if (!_placeholderColor) {
        _placeholderColor = [UIColor colorWithSexadeString:@"#C7C7C7"];
    }
    // 基本设定 (需判断是否在Storyboard中设置了值)
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:15.f];
    }
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.text = _placeholder; // 可能在Storyboard中设置了Placeholder
    self.placeholderLabel.textColor = _placeholderColor;
    [self addSubview:self.placeholderLabel];
}

#pragma mark - Getter
/// 返回一个经过处理的 `self.text` 的值, 去除了首位的空格和换行.
- (NSString *)formatText {
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, RBScreenWidth, 30)];
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

#pragma mark - Setter

- (void)setPlaceholderFrame:(CGRect)placeholderFrame {
    _placeholderFrame = placeholderFrame;
    self.placeholderLabel.frame = placeholderFrame;
    [self.placeholderLabel sizeToFit];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.placeholderLabel.hidden = [@(text.length) boolValue];
    // 手动模拟触发通知
    NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
    [self textDidChange:notification];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    _maxLength = fmax(0, maxLength);
    self.text = self.text;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (!borderColor) return;

    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) return;
    _placeholder = [placeholder copy];
    if (_placeholder.length > 0) {
        self.placeholderLabel.text = _placeholder;
    }
    [self.placeholderLabel sizeToFit];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (!placeholderColor) return;
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (!placeholderFont) return;
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = _placeholderFont;
    [self.placeholderLabel sizeToFit];
}

#pragma mark - NSNotification
- (void)textDidChange:(NSNotification *)notification {
    // 通知回调的实例的不是当前实例的话直接返回
    if (notification.object != self) return;
    // 根据字符数量显示或者隐藏 `placeholderLabel`
    self.placeholderLabel.hidden = [@(self.text.length) boolValue];
    // 禁止第一个字符输入空格或者换行
    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }
    // 只有当maxLength字段的值不为无穷大整型也不为0时才计算限制字符数.
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && self.text.length > 0) {
        if (!self.markedTextRange && self.text.length > _maxLength) {
            !_maxHandler ? : _maxHandler(self); // 回调达到最大限制的Block.
            self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
            [self.undoManager removeAllActions]; // 达到最大字符数后清空所有 undoaction, 以免 undo 操作造成crash.
        }
    }
    // 回调文本改变的Block.
    !_changeHandler ? : _changeHandler(self);
}

#pragma mark - Public

+ (instancetype)textView {
    return [[self alloc] init];
}

- (void)textDidChangeHandler:(RBTextViewHandler)changeHandler {
    _changeHandler = [changeHandler copy];
}

- (void)addTextLengthDidMaxHandler:(RBTextViewHandler)maxHandler {
    _maxHandler = [maxHandler copy];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _changeHandler = NULL;
    _maxHandler = NULL;
}

@end
