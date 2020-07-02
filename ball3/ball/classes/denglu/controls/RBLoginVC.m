#import "RBLoginVC.h"
#import "WXApi.h"
#import "RBNetworkTool.h"
#import "RBToast.h"
#import "RBTabBarVC.h"
#import "RBNavigationVC.h"
#import "RBWoTabVC.h"
#import "RBRegistVC.h"
#import "RBForgetPwdVC.h"

@interface RBLoginVC ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UITextField *pwdField;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *registBtn;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@end

@implementation RBLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, RBStatusBarH, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"登录";
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:30];
    tipLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tipLabel.frame = CGRectMake(20, RBStatusBarH + 56, RBScreenWidth - 40, 42);
    [self.view addSubview:tipLabel];

    UITextField *textfield1 = [[UITextField alloc]initWithFrame:CGRectMake(20, RBStatusBarH + 146, RBScreenWidth - 40, 25)];
    [textfield1 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    textfield1.delegate = self;
    self.phoneField = textfield1;
    textfield1.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    textfield1.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield1.returnKeyType = UIReturnKeyDone;
    textfield1.placeholder = @"手机号码/邮箱地址";
    [self.view addSubview:textfield1];

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textfield1.frame) + 8, RBScreenWidth - 40, 1)];
    line1.backgroundColor =  [UIColor colorWithSexadeString:@"#F3F3F3"];
    [self.view addSubview:line1];
    self.line1 = line1;

    UITextField *textfield2 = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(line1.frame) + 40, RBScreenWidth - 40 - 40, 25)];
    textfield2.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    [textfield2 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    textfield2.placeholder = @"输入密码";
    textfield2.secureTextEntry = YES;
    textfield2.delegate = self;
    textfield2.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield2.returnKeyType = UIReturnKeyDone;
    self.pwdField = textfield2;
    [self.view addSubview:textfield2];

    UIButton *showPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 60, CGRectGetMaxY(line1.frame) + 36, 40, 40)];
    [showPwdBtn setImage:[UIImage imageNamed:@"eyes1"] forState:UIControlStateNormal];
    [showPwdBtn setImage:[UIImage imageNamed:@"eyes2"] forState:UIControlStateSelected];
    [showPwdBtn addTarget:self  action:@selector(clickShowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPwdBtn];

    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textfield2.frame) + 8, RBScreenWidth - 40, 1)];
    line2.backgroundColor =  [UIColor colorWithSexadeString:@"#F3F3F3"];
    [self.view addSubview:line2];
    self.line2 = line2;

    UIButton *foggertBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 80, CGRectGetMaxY(line2.frame) + 12, 60, 22)];
    foggertBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [foggertBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [foggertBtn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateNormal];
    [foggertBtn addTarget:self action:@selector(clickFoggertBtn) forControlEvents:UIControlEventTouchUpInside];
    foggertBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:foggertBtn];

    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(line2.frame) + 64, RBScreenWidth - 32, 48)];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 24;
    self.loginBtn = loginBtn;
    loginBtn.enabled = NO;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [loginBtn addTarget:self action:@selector(clickloginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(loginBtn.frame) + 10, RBScreenWidth - 32, 48)];
    self.registBtn = registBtn;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [registBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(clickRegistBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];

    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(loginBtn.frame) + 156, (RBScreenWidth - 100 - 80 - 32) * 0.5, 1)];
    leftLine.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    [self.view addSubview:leftLine];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((RBScreenWidth - 100) * 0.5, CGRectGetMaxY(loginBtn.frame) + 146, 100, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"其他登录方式";
    [self.view addSubview:label];

    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 16, CGRectGetMaxY(loginBtn.frame) + 156, (RBScreenWidth - 100 - 80 - 32) * 0.5, 1)];
    rightLine.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    [self.view addSubview:rightLine];

    UIButton *WXBtn = [[UIButton alloc]initWithFrame:CGRectMake((RBScreenWidth - 48) * 0.5, CGRectGetMaxY(label.frame) + 28, 48, 48)];
    [WXBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [WXBtn addTarget:self action:@selector(clickWXBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WXBtn];
    WXBtn.hidden = ![WXApi isWXAppInstalled];
    leftLine.hidden = ![WXApi isWXAppInstalled];
    label.hidden = ![WXApi isWXAppInstalled];
    rightLine.hidden = ![WXApi isWXAppInstalled];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxLogin:) name:@"wxLogin" object:nil];
}

// 微信
- (void)clickWXBtn {
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req completion:^(BOOL success) {
    }];
}

// 微信登录成功
- (void)wxLogin:(NSNotification *)noti {
    [MBProgressHUD showLoading:@"加载中" toView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:noti.object forKey:@"code"];
    [dict setValue:@(1001) forKey:@"usrc"]; 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RBNetworkTool PostDataWithUrlStr:@"try/go/weixinapplogin"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = backData;
            if (dict[@"access_token"] != nil && dict[@"refresh_token"] != nil) {
                [[NSUserDefaults standardUserDefaults]setValue:dict[@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults]setValue:dict[@"refresh_token"] forKey:@"refresh_token"];
                [[NSUserDefaults standardUserDefaults]setValue:dict[@"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"notEditPwd"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *uid  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
                if (uid != nil && ![uid isEqualToString:@""]) {
                    [dic setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
                }

                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[RBTabBarVC class]]) {
                    [self getUserInfo];
                    [self.navigationController popToViewController:self.fromVC animated:YES];
                } else {
                    [UIApplication sharedApplication].keyWindow.rootViewController = [[RBTabBarVC alloc]init];
                }
            }
        } Fail:^(NSError *_Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    });
}

- (void)getUserInfo {
    // 获取个人信息
    RBTabBarVC *tabBarVC = (RBTabBarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
    RBNavigationVC *nav = tabBarVC.childViewControllers[4];
    RBWoTabVC *woTabVC =  [nav.childViewControllers firstObject];
    [woTabVC getUserInfo];
}

// 密码的显示
- (void)clickShowBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.pwdField.secureTextEntry = !btn.selected;
}

// 登录
- (void)clickloginBtn {
    if ([self.phoneField.text isEqualToString:@""] || self.phoneField.text.length <= 0) {
        [RBToast showWithTitle:@"请输入手机号或邮箱"];
        return;
    }
    if ([self.pwdField.text isEqualToString:@""] || self.pwdField.text.length <= 0) {
        [RBToast showWithTitle:@"请输入密码"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSString MD5:self.pwdField.text] forKey:@"pwd"];
    [dict setValue:self.phoneField.text forKey:@"un"];
    [dict setValue:@"1234" forKey:@"code"];
    [dict setValue:@(1) forKey:@"loginmode"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/login"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        NSDictionary *dict = backData;
        if (dict[@"access_token"] != nil && dict[@"refresh_token"] != nil) {
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"access_token"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"refresh_token"] forKey:@"refresh_token"];
            [[NSUserDefaults standardUserDefaults]setValue:dict[@"userid"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[RBTabBarVC class]]) {
                [self.navigationController popToViewController:self.fromVC animated:YES];
            } else {
                [UIApplication sharedApplication].keyWindow.rootViewController = [[RBTabBarVC alloc]init];
            }
            [self getUserInfo];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

// 注册
- (void)clickRegistBtn {
    RBRegistVC *registVC = [[RBRegistVC alloc]init];
    registVC.fromVC = self.fromVC;
    [self.navigationController pushViewController:registVC animated:YES];
}

// 忘记密码
- (void)clickFoggertBtn {
    RBForgetPwdVC *forgetPwdVC = [[RBForgetPwdVC alloc]init];
    forgetPwdVC.phone = self.phoneField.text;
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

    #pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneField) {
        self.line1.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
        self.line2.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    } else if (textField == self.pwdField) {
        self.line2.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
        self.line1.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    }
    return YES;
}

- (void)changedTextField:(UITextField *)textField {
    self.loginBtn.enabled = (self.phoneField.text.length > 0 && self.pwdField.text.length > 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    self.line1.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    self.line2.backgroundColor = [UIColor colorWithSexadeString:@"#F3F3F3"];
    return YES;
}

@end
