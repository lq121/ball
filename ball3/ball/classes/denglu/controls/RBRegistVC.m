#import "RBRegistVC.h"
#import "RBWKWebView.h"
#import "RBToast.h"
#import "RBNetworkTool.h"
#import "RBTabBarVC.h"
#import "RBTipView.h"

@interface RBRegistVC ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITextField *eareField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UITextField *invitationField;
@property (nonatomic, strong) UIButton *registBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeCount;
@end

@implementation RBRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 60;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, RBStatusBarH, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = zhuce;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:30];
    tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLabel.frame = CGRectMake(20, RBStatusBarH + 56, 150, 42);
    [self.view addSubview:tipLabel];

    self.eareField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105, RBScreenWidth, 73) andText:zhongguo andPlaceholder:nil andLeftView:nil];
    self.eareField.userInteractionEnabled = NO;
    self.phoneField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73, RBScreenWidth, 73) andText:nil andPlaceholder:shoujihuoyouxiang andLeftView:nil];
    self.codeField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73 * 2, RBScreenWidth, 73) andText:nil andPlaceholder:shuruyanzhengma andLeftView:@"btn"];
    self.pwdField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73 * 3, RBScreenWidth, 73) andText:nil andPlaceholder:shezhimima andLeftView:nil];
    self.invitationField = [self createCodeViewWithFrame:CGRectMake(0, RBStatusBarH + 105 + 73 * 4, RBScreenWidth, 73) andText:nil andPlaceholder:yaoqingmafeibitian andLeftView:nil];

    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBStatusBarH + 105 + 73 * 5 + 59, RBScreenWidth - 32, 48)];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = 24;
    self.registBtn = registBtn;
    registBtn.enabled = NO;
    [registBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [registBtn setTitle:tijiao forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [registBtn addTarget:self action:@selector(clickregistBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];

    CGSize size = [dengluxieyi getLineSizeWithFontSize:12];
    NSString *str1 = zhucetongyi;
    NSString *str2 = yonghuxieyi;
    NSString *str3 = he;
    NSString *str4 = yinsizhengce;
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@", str1, str2, str3, str4];
    NSRange range1 = [str rangeOfString:str1];
    NSRange range2 = [str rangeOfString:str2];
    NSRange range3 = [str rangeOfString:str3];
    NSRange range4 = [str rangeOfString:str4];
    UITextView *textView = [[UITextView alloc] init];

    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentRight;
    textView.frame = CGRectMake((RBScreenWidth - size.width) * 0.5, RBScreenHeight - RBBottomSafeH - 25 - size.height, size.width, size.height + 15);
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate = self;
    [self.view addSubview:textView];
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:12.0f] }];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6] range:range1];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#2B8AF7"] range:range2];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6] range:range3];
    [mastring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithSexadeString:@"#2B8AF7"] range:range4];
    NSString *valueString1 = [[NSString stringWithFormat:@"first://%@", str2] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString3 = [[NSString stringWithFormat:@"second://%@", str4] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [mastring addAttribute:NSLinkAttributeName value:valueString1 range:range2];
    [mastring addAttribute:NSLinkAttributeName value:valueString3 range:range4];
    textView.attributedText = mastring;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"first"]) {
        RBWKWebView *webVC = [[RBWKWebView alloc]init];
        webVC.title = yonghuxieyi;
        webVC.url = @"hios/user-policy.html";
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"second"]) {
        RBWKWebView *webVC = [[RBWKWebView alloc]init];
        webVC.url = @"hios/privacy-policy.html";
        webVC.title = yinsizhengce;
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    return YES;
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)createCodeViewWithFrame:(CGRect)frame andText:(NSString *)text andPlaceholder:(NSString *)placeHolder andLeftView:(NSString *)str {
    UIView *BGView = [[UIView alloc]initWithFrame:frame];
    BGView.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc]init];
    textField.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    textField.returnKeyType = UIReturnKeyDone;
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
    if ([placeHolder containsString:shezhidenglumima]) {
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:placeHolder];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 6)];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(6, placeHolder.length - 6)];
        textField.attributedPlaceholder = attr;
    } else if ([placeHolder containsString:yaoqingma]) {
        textField.secureTextEntry = YES;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:placeHolder];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 3)];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(3, placeHolder.length - 3)];
        textField.attributedPlaceholder = attr;
    } else {
        textField.placeholder = placeHolder;
    }

    if (str != nil) {
        UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), 25, 86, 28)];
        [getCodeBtn addTarget:self action:@selector(clickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        getCodeBtn.layer.masksToBounds = YES;
        getCodeBtn.layer.cornerRadius = 4;
        getCodeBtn.enabled = NO;
        self.getCodeBtn = getCodeBtn;
        [getCodeBtn setTitle:huoquyanzhengma forState:UIControlStateNormal];
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
    } else if ([placeHolder isEqualToString:shezhidenglumima]) {
        self.line4 = line;
    }

    [self.view addSubview:BGView];
    return textField;
}

- (void)clickGetCodeBtn:(UIButton *)btn {
    [RBNetworkTool getcodeWithMobile:self.phoneField.text AndType:1 Result:^(NSDictionary * _Nonnull backData, NSError * _Nonnull error) {
        if ([backData[@"ok"]intValue] == 1) {
            btn.enabled = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)clickregistBtn {
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *code = [self.codeField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwd = [self.pwdField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *invitationCode = [self.invitationField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length <= 0) {
        [RBToast showWithTitle:shurushoujihao];
        return;
    }
    if (code.length <= 0) {
        [RBToast showWithTitle:shuruyanzhengma];
        return;
    }
    if (pwd.length <= 0) {
        [RBToast showWithTitle:shurumima];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:pwd forKey:@"pwd"];
    [dict setValue:phone forKey:@"mobile"];
    [dict setValue:@(1) forKey:@"loginmode"];
    [dict setValue:@(1001) forKey:@"usrc"];
    [dict setValue:self.codeField.text forKey:@"yzcode"];   
    if (invitationCode.length > 0) {
        [dict setValue:[invitationCode uppercaseString] forKey:@"yqcode"];
    }
    [RBNetworkTool PostDataWithUrlStr:@"try/go/reg" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        NSDictionary *dict = backData;
        if (dict[@"access_token"] != nil && dict[@"refresh_token"] != nil) {
            [RBTipView tipWithTitle:zhucesuccess andExp:[dict[@"addexp"]intValue] andCoin:[dict[@"addcoin"]intValue]];
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"access_token"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"refresh_token"] forKey:@"refresh_token"];
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"userid"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *uid  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
            if (uid != nil && ![uid isEqualToString:@""]) {
                [dic setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
            }
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[RBTabBarVC class]]) {
                [self.navigationController popToViewController:self.fromVC animated:YES];
            } else {
                [UIApplication sharedApplication].keyWindow.rootViewController = [[RBTabBarVC alloc]init];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

    #pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)changedTextField:(UITextField *)textField {
    if (self.timer == nil) {
        self.getCodeBtn.enabled = self.phoneField.text.length > 0;
    }
    self.registBtn.enabled = (self.pwdField.text.length > 0 && self.pwdField.text.length > 0 && self.codeField.text.length > 0);
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
    [self restBGColor];
    return YES;
}

@end
