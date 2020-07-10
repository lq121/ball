#import "RBForgetPwdVC.h"
#import "RBToast.h"
#import "RBNetworkTool.h"

@interface RBForgetPwdVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *eareField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UIButton *frogetBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeCount;
@end

@implementation RBForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 60;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, RBStatusBarH, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = wangjimima;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:30];
    tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLabel.frame = CGRectMake(20, RBStatusBarH + 56, 150, 42);
    [self.view addSubview:tipLabel];

    self.eareField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105, RBScreenWidth, 73) andText:zhongguo andPlaceholder:nil andLeftView:nil];
    self.phoneField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73, RBScreenWidth, 73) andText:self.phone andPlaceholder:shoujihuoyouxiang andLeftView:nil];
    self.codeField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73 * 2, RBScreenWidth, 73) andText:nil andPlaceholder:shuruyanzhengma andLeftView:@"btn"];
    self.pwdField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73 * 3, RBScreenWidth, 73) andText:nil andPlaceholder:chongzhishezimima andLeftView:nil];

    UIButton *frogetBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBStatusBarH + 105 + 73 * 4 + 64, RBScreenWidth - 32, 48)];
    frogetBtn.layer.masksToBounds = YES;
    frogetBtn.layer.cornerRadius = 24;
    self.frogetBtn = frogetBtn;
    frogetBtn.enabled = NO;
    [frogetBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [frogetBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [frogetBtn setTitle:tijiao forState:UIControlStateNormal];
    frogetBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [frogetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [frogetBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [frogetBtn addTarget:self action:@selector(clickfrogetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:frogetBtn];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)createCodeViewWithFrame:(CGRect)frame andText:(NSString *)text andPlaceholder:(NSString *)placeHolder andLeftView:(NSString *)str {
    UIView *BGView = [[UIView alloc]initWithFrame:frame];
    BGView.backgroundColor = [UIColor whiteColor];

    UITextField *textField = [[UITextField alloc]init];
    textField.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.text = text;
    textField.font = [UIFont systemFontOfSize:16];
    textField.frame = CGRectMake(20, 40, RBScreenWidth - 90 - 16 - 20, 25);
    textField.delegate = self;
    [BGView addSubview:textField];
    if ([text isEqualToString:zhongguo]) {
        UIButton *rowBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 16 - 28, 38, 28, 28)];
        textField.userInteractionEnabled = NO;
        [rowBtn setBackgroundImage:[UIImage imageNamed:@"down black"] forState:UIControlStateNormal];
        [BGView addSubview:rowBtn];
    }
    if ([placeHolder containsString:chongzhishezimima]) {
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:placeHolder];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 6)];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(6, placeHolder.length - 6)];
        textField.attributedPlaceholder = attr;
    } else {
        textField.placeholder = placeHolder;
    }
    if (str != nil) {
        UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), 25, 86, 28)];
        getCodeBtn.enabled = NO;
        self.getCodeBtn = getCodeBtn;
        [getCodeBtn setTitle:huoquyanzhengma forState:UIControlStateNormal];
        getCodeBtn.layer.masksToBounds = YES;
        getCodeBtn.layer.cornerRadius = 4;
        [getCodeBtn addTarget:self action:@selector(clickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
        [getCodeBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
        [BGView addSubview:getCodeBtn];
        [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        textField.frame = CGRectMake(20, 40, RBScreenWidth - 40, 25);
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 72, RBScreenWidth - 40, 1)];
    line.backgroundColor =  [UIColor colorWithSexadeString:@"#F3F3F3"];
    [BGView addSubview:line];
    if (placeHolder == nil) {
        self.line1 = line;
    } else if ([placeHolder isEqualToString:shoujihuoyouxiang]) {
        self.line2 = line;
    } else if ([placeHolder isEqualToString:shuruyanzhengma]) {
        self.line3 = line;
    } else if ([placeHolder containsString:chongzhishezimima]) {
        self.line4 = line;
    }
    [self.view addSubview:BGView];
    return textField;
}

- (void)clickGetCodeBtn:(UIButton *)btn {
    if (![NSString isVaildPhone:self.phoneField.text]) {
        [RBToast showWithTitle:shuruhefashoujihao];
        return;
    }
    [RBNetworkTool getcodeWithMobile:self.phoneField.text AndType:2 Result:^(NSDictionary *_Nonnull backData, NSError *_Nonnull error) {
        if ([backData[@"ok"]intValue] == 1) {
            btn.enabled = NO;
            btn.titleEdgeInsets = UIEdgeInsetsZero;
            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(changeTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)changeTime {
    if (self.timeCount == 0) {
        self.getCodeBtn.enabled = YES;
        self.timeCount = 60;
        [self.timer timeInterval];
        self.timer = nil;
        return;
    }
    [self.getCodeBtn setTitle:[NSString stringWithFormat:chongxinhuoqu, self.timeCount] forState:UIControlStateDisabled];
    self.timeCount--;
}

- (void)clickfrogetBtn {
    if ([self.phoneField.text isEqualToString:@""] || self.phoneField.text.length <= 0) {
        [RBToast showWithTitle:shurushoujihao];
        return;
    }
    if ([self.codeField.text isEqualToString:@""] || self.codeField.text.length <= 0) {
        [RBToast showWithTitle:shuruyanzhengma];
        return;
    }
    if ([self.pwdField.text isEqualToString:@""] || self.pwdField.text.length <= 0) {
        [RBToast showWithTitle:shurumima];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString MD5:self.pwdField.text] forKey:@"newpwd"];
    [dict setValue:self.phoneField.text forKey:@"mobile"];
    [dict setValue:self.codeField.text forKey:@"yzcode"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/verifyresetpwd"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        NSDictionary *dict = backData;
        if (dict[@"ok"] != nil) {
            [RBToast showWithTitle:xiugaimimasuccess];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

    #pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)changedTextField:(UITextField *)textField {
    if (self.timer == nil) {
        self.getCodeBtn.enabled = self.phoneField.text.length > 0;
    }
    self.frogetBtn.enabled = (self.pwdField.text.length > 0 && self.pwdField.text.length > 0 && self.codeField.text.length > 0);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self restBGColor];
    if (textField == self.eareField) {
        self.line1.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    } else if (textField == self.phoneField) {
        self.line2.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    } else if (textField == self.codeField) {
        self.line3.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    } else if (textField == self.pwdField) {
        self.line4.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
    }
    return YES;
}

- (void)restBGColor {
    self.line1.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    self.line2.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    self.line3.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    self.line4.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
