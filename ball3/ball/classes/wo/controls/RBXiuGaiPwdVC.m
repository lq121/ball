#import "RBXiuGaiPwdVC.h"
#import "RBToast.h"
#import "RBNetworkTool.h"
#import "RBLoginVC.h"
#import "RBNavigationVC.h"

@interface RBXiuGaiPwdVC ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeCount;
@end

@implementation RBXiuGaiPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 60;
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *tips = @[shoujihuoyouxiang, shuruyanzhengma, @"请输入原始密码", @"设置新密码(至少6位数字或英文字母)", @"确认新密码"];

    for (int i = 0; i < tips.count; i++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, i * 61, RBScreenWidth, 61)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:whiteView];

        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, RBScreenWidth - 32, 60)];
        if (i == 0) {
            textField.userInteractionEnabled = NO;
        }
        NSString *str = tips[i];
        if (i == 3) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 5)];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(5, str.length - 5)];
            textField.attributedPlaceholder = attr;
        } else {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
            [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, str.length)];
            textField.attributedPlaceholder = attr;
        }

        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor colorWithSexadeString:@"484848"];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont systemFontOfSize:16];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.tag = 10 + i;
        [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        [whiteView addSubview:textField];

        if (i == 0) {
            textField.text = self.phone;
        }
        if (i == 2 || i == 3 || i == 4) {
            textField.secureTextEntry = YES;
        }
        if (i == 1) {
            textField.frame = CGRectMake(16, 0, RBScreenWidth - 32 - 90, 60);
            UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), 16, 86, 28)];
            self.getCodeBtn = getCodeBtn;
            getCodeBtn.enabled = self.phone.length > 0;
            [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
            [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
            [getCodeBtn setTitle:huoquyanzhengma forState:UIControlStateNormal];
            [getCodeBtn addTarget:self action:@selector(clickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [getCodeBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
            getCodeBtn.layer.masksToBounds = YES;
            getCodeBtn.layer.cornerRadius = 4;
            [whiteView addSubview:getCodeBtn];
            getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (i != tips.count - 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(textField.frame), RBScreenWidth - 32, 1)];
            line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
            [whiteView addSubview:line];
        }
    }

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBNavBarAndStatusBarH + 4 * 61 + 64, RBScreenWidth - 32, 48)];
    self.checkBtn = checkBtn;
    checkBtn.enabled = NO;
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [checkBtn setTitle:@"保存" forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
}

- (void)clickGetCodeBtn:(UIButton *)btn {
    UITextField *textField1 = [self.view viewWithTag:10];
    if (![NSString isVaildPhone:textField1.text]) {
        [RBToast showWithTitle:shuruhefashoujihao];
        return;
    }
    [RBNetworkTool getcodeWithMobile:textField1.text AndType:3 Result:^(NSDictionary *_Nonnull backData, NSError *_Nonnull error) {
        if ([backData[@"ok"]intValue] == 1) {
            btn.enabled = NO;
            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer timerWithTimeInterval:3 target:weakSelf selector:@selector(changeTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)changedTextField:(UITextField *)textField {
    UITextField *textField1 = [self.view viewWithTag:10];
    UITextField *textField2 = [self.view viewWithTag:11];
    UITextField *textField3 = [self.view viewWithTag:12];
    UITextField *textField4 = [self.view viewWithTag:13];
    UITextField *textField5 = [self.view viewWithTag:14];
    self.checkBtn.enabled = (textField1.text.length > 0) && (textField2.text.length > 0) && (textField3.text.length > 0) && (textField4.text.length > 0) && (textField5.text.length > 0);
    if (self.timer == nil) {
        self.getCodeBtn.enabled = textField1.text.length > 0;
    }
}

- (void)clickCheckBtn {
    UITextField *textField2 = [self.view viewWithTag:11];
    UITextField *textField3 = [self.view viewWithTag:12];
    UITextField *textField4 = [self.view viewWithTag:13];
    UITextField *textField5 = [self.view viewWithTag:14];
    if (![textField4.text isEqualToString:textField5.text]) {
        [RBToast showWithTitle:@"两次新密码不一致，请重新设置"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"uid"];
    }
    [dict setValue:[NSString MD5:textField3.text] forKey:@"old"];
    [dict setValue:[NSString MD5:textField4.text] forKey:@"new"];
    [dict setValue:textField2.text forKey:@"yzcode"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/resetpwd" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"修改密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userid"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Packet"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"setMatchArr"];
                               [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"coinCount"];
                               [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"notEditPwd"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"vipDict"];
                               [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"isVip"];
                               [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"seletmatchArr"];
                               [[NSUserDefaults standardUserDefaults]synchronize];
                               RBLoginVC *loginVC = [[RBLoginVC alloc]init];
                               loginVC.fromVC = self;
                               [UIApplication sharedApplication].keyWindow.rootViewController = [[RBNavigationVC alloc]initWithRootViewController:loginVC];
                           });
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

@end
