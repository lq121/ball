#import "RBYQMView.h"

@interface RBYQMView()<UITextFieldDelegate, RBTextFieldDelegate>

@property (nonatomic, weak) UILabel *label1;
@property (nonatomic, weak) UILabel *label2;
@property (nonatomic, weak) UILabel *label3;
@property (nonatomic, weak) UILabel *label4;
@property (nonatomic, weak) UILabel *label5;
@property (nonatomic, weak) UILabel *label6;
@property (nonatomic, copy) OnFinishedEnterCode onFinishedEnterCode;
@property(nonatomic,copy)DeleteCode deleteCode;
@end

@implementation RBYQMView

- (instancetype)initWithFrame:(CGRect)frame onFinishedEnterCode:(OnFinishedEnterCode)onFinishedEnterCode  andDeleteCode:(DeleteCode)deleteCode{
    if (self = [super initWithFrame:frame]) {
        CGFloat labWidth = 32;
        CGFloat labHeight = 40;
        CGFloat margin = (RBScreenWidth - 32 - 112 - 6 * 32) / 5;
        if (onFinishedEnterCode) {
            _onFinishedEnterCode = [onFinishedEnterCode copy];
        }
        if (deleteCode) {
                   _deleteCode = [deleteCode copy];
               }

        for (NSInteger i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(56 + (32 + margin) * i, 0, labWidth, labHeight)];
            label.userInteractionEnabled = YES;
            label.tag = 100 + i;
            label.textColor = [UIColor colorWithSexadeString:@"333333"];
            label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.04];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont boldSystemFontOfSize:22];
            [self addSubview:label];
            if (i == 0) {
                _label1 = label;
                _label1.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
                _label1.layer.borderWidth = 2;
            } else if (i == 1) {
                _label2 = label;
            } else if (i == 2) {
                _label3 = label;
            } else if (i == 3) {
                _label4 = label;
            } else if (i == 4) {
                _label5 = label;
            } else if (i == 5) {
                _label6 = label;
            }
        }

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(56, 0, labWidth, labHeight)];
        textField.textColor = [UIColor colorWithSexadeString:@"333333"];
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        _codeTextField = textField;
        [textField becomeFirstResponder];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!self.label1.text.length) {
        self.label1.text = string;
        _label1.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label1.layer.borderWidth = 0;
        _label2.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label2.layer.borderWidth = 2;
        _codeTextField.x = _label2.x;
    } else if (!self.label2.text.length) {
        self.label2.text = string;
        _codeTextField.x = _label3.x;
        _label2.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label2.layer.borderWidth = 0;
        _label3.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label3.layer.borderWidth = 2;
    } else if (!self.label3.text.length) {
        self.label3.text = string;
        _label3.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label3.layer.borderWidth = 0;
        _label4.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label4.layer.borderWidth = 2;
        _codeTextField.x = _label4.x;
    } else if (!self.label4.text.length) {
        self.label4.text = string;
        _label4.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label4.layer.borderWidth = 0;
        _label5.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label5.layer.borderWidth = 2;
        _codeTextField.x = _label5.x;
    } else if (!self.label5.text.length) {
        self.label5.text = string;
        _label5.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label5.layer.borderWidth = 0;
        _label6.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label6.layer.borderWidth = 2;
        _codeTextField.x = _label6.x;
    } else {
        self.label6.text = string;
        _codeTextField.x = _label6.x;
        if (_onFinishedEnterCode) {
            NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@", _label1.text, _label2.text, _label3.text, _label4.text, _label5.text, _label6.text];
            _onFinishedEnterCode(code);
        }
    }
    return NO;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (_deleteCode) {
        NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@", _label1.text, _label2.text, _label3.text, _label4.text, _label5.text, _label6.text];
        _deleteCode(code);
    }
    if (self.label6.text.length) {
        self.label6.text = @"";
        self.codeTextField.x = self.label6.x;
        _label6.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label6.layer.borderWidth = 2;
    } else if (self.label5.text.length) {
        self.label5.text = @"";
        self.codeTextField.x = self.label5.x;
        _label5.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label5.layer.borderWidth = 2;
        _label6.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label6.layer.borderWidth = 0;
    } else if (self.label4.text.length) {
        self.label4.text = @"";
        self.codeTextField.x = self.label4.x;
        _label4.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label4.layer.borderWidth = 2;
        _label5.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label5.layer.borderWidth = 0;
    } else if (self.label3.text.length) {
        self.label3.text = @"";
        self.codeTextField.x = self.label3.x;
        _label3.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label3.layer.borderWidth = 2;
        _label4.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label4.layer.borderWidth = 0;
    } else if (self.label2.text.length) {
        self.label2.text = @"";
        self.codeTextField.x = self.label2.x;
        _label2.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label2.layer.borderWidth = 2;
        _label3.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label3.layer.borderWidth = 0;
    } else if (self.label1.text.length) {
        self.label1.text = @"";
        self.codeTextField.x = self.label1.x;
        _label1.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label1.layer.borderWidth = 2;
        _label2.layer.borderColor = [UIColor colorWithSexadeString:@"#333333"].CGColor;
        _label2.layer.borderWidth = 0;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
