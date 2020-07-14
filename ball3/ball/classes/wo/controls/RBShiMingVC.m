#import "RBShiMingVC.h"
#import "RBToast.h"
#import "RBNetworkTool.h"
#import "RBShiMingSuccessVC.h"
#import "RBTipView.h"

@interface RBShiMingVC ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *getCodeBtn;
@property (strong, nonatomic) UIButton *checkBtn;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeCount;
@end

@implementation RBShiMingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.timeCount = 60;
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIView *nameView = [self createViewWithTitle:@"姓名" andPlaceholder:@"请输入您的姓名" andText:self.dict[@"Nickname"]  andFrame:CGRectMake(0, 0, RBScreenWidth, 60) andTag:10];
    [self.view addSubview:nameView];
    UIView *codeView = [self createViewWithTitle:@"身份证号码" andPlaceholder:@"请输入您的身份证号码" andText:self.dict[@"Idnumber"]  andFrame:CGRectMake(0, CGRectGetMaxY(nameView.frame) + 1, RBScreenWidth, 60) andTag:11];
    [self.view addSubview:codeView];
    UIView *phoneView = [self createViewWithTitle:@"手机号码" andPlaceholder:@"请输入您手机号码" andText:self.dict[@"Mobile"]  andFrame:CGRectMake(0, CGRectGetMaxY(codeView.frame) + 8, RBScreenWidth, 60) andTag:12];
    [self.view addSubview:phoneView];

    UIView *getCodeView;
    if (self.dict[@"Idnumber"] != nil && ![self.dict[@"Idnumber"] isEqualToString:@""]) {
        getCodeView = [self createCodeViewWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame) + 1, RBScreenWidth, 60) andType:2];
    } else {
        getCodeView = [self createCodeViewWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame) + 1, RBScreenWidth, 60) andType:1];
    }
    [self.view addSubview:getCodeView];
    UITextField *textField3 = [self.view viewWithTag:12];
    self.getCodeBtn.enabled = textField3.text.length > 0 && ![textField3.text isEqualToString:@" "];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(getCodeView.frame) + 16, RBScreenWidth - 32, 80)];
    tip.text = @"1、1个设备，10分钟内只能获取1次验证码\n2、实名认证提交后，不能修改，平台将对您的资料严格保密\n3、非中国大陆公民或实名认证遇到问题，请联系客服；QQ123456789";
    tip.textAlignment = NSTextAlignmentLeft;
    tip.font = [UIFont systemFontOfSize:12];
    tip.textColor = [UIColor colorWithSexadeString:@"#484848" AndAlpha:0.6];
    tip.backgroundColor = [UIColor clearColor];
    tip.numberOfLines = 0;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:tip.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tip.text length])];
    [tip setAttributedText:attributedString1];
    [tip sizeToFit];
    [self.view addSubview:tip];

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip.frame) + 64, RBScreenWidth - 32, 48)];
    checkBtn.layer.masksToBounds = YES;
    checkBtn.layer.cornerRadius = 24;
    self.checkBtn = checkBtn;
    checkBtn.enabled = NO;
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [checkBtn setTitle:tijiao forState:UIControlStateNormal];
    checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [checkBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
}

- (void)clickCheckBtn {
    UITextField *textField1 = [self.view viewWithTag:10];
    UITextField *textField2 = [self.view viewWithTag:11];
    UITextField *textField3 = [self.view viewWithTag:12];
    if (self.codeTextField.text.length == 0) {
        [RBToast showWithTitle:shuruyanzhengma];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:textField1.text forKey:@"rn"];
    [dict setValue:textField2.text forKey:@"in"];
    [dict setValue:textField3.text forKey:@"m"];
    [dict setValue:self.codeTextField.text forKey:@"c"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/realinfo" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        NSDictionary *dict = backData;
        if (dict[@"ok"] != nil) {
            [RBTipView tipWithTitle:@"认证成功" andExp:[dict[@"addexp"]intValue] andCoin:[dict[@"addcoin"]intValue]];
            RBShiMingSuccessVC *successVC =  [[RBShiMingSuccessVC alloc]init];
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            [data setValue:textField1.text forKey:@"userName"];
            [data setValue:textField2.text forKey:@"userCode"];
            [data setValue:textField3.text forKey:@"phone"];
            successVC.data = data;
            [self.navigationController pushViewController:successVC animated:YES];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (UIView *)createViewWithTitle:(NSString *)title andPlaceholder:(NSString *)placeholder andText:(NSString *)text andFrame:(CGRect)frame andTag:(NSInteger)tag {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(17, 0, 80, 60);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithSexadeString:@"#484848"];
    [view addSubview:label];

    UITextField *textField = [[UITextField alloc]init];
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = placeholder;
    textField.text = text;
    textField.font = [UIFont systemFontOfSize:16];
    [view addSubview:textField];
    textField.frame = CGRectMake(97, 0, RBScreenWidth - 97 - 16, 60);
    textField.delegate = self;
    textField.tag = tag;
    if (self.dict != nil) {
        if ([self.dict[@"Wxid"] isEqualToString:@""] && [title isEqualToString:@"手机号码"]) {
            textField.userInteractionEnabled = NO;
        }
    }
    return view;
}

- (UIView *)createCodeViewWithFrame:(CGRect)frame andType:(int)type {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc]init];
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = @"验证码";
    textField.font = [UIFont systemFontOfSize:16];
    textField.frame = CGRectMake(16, 0, RBScreenWidth - 90 - 16 - 16, 60);
    textField.delegate = self;
    if (self.dict[@"Idnumber"] != nil && ![self.dict[@"Idnumber"] isEqualToString:@""]) {
        textField.userInteractionEnabled = NO;
    }
    self.codeTextField = textField;
    [view addSubview:textField];
    if (type == 1) {
        UIButton *getCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame), 16, 86, 28)];
        [getCodeBtn addTarget:self action:@selector(clickGetCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.getCodeBtn = getCodeBtn;
        getCodeBtn.enabled = NO;
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#E8E8E8"]] forState:UIControlStateDisabled];
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
        [getCodeBtn setTitle:huoquyanzhengma forState:UIControlStateNormal];
        [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getCodeBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
        getCodeBtn.layer.masksToBounds = YES;
        getCodeBtn.layer.cornerRadius = 4;
        [view addSubview:getCodeBtn];
        getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"已验证";
        label.textAlignment = NSTextAlignmentRight;
        label.frame = CGRectMake(CGRectGetMaxX(textField.frame), 16, 90, 28);
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        [view addSubview:label];
    }
    return view;
}

- (void)clickGetCodeBtn:(UIButton *)btn {
    UITextField *textField3 = [self.view viewWithTag:12];
    [RBNetworkTool getcodeWithMobile:textField3.text AndType:4 Result:^(NSDictionary *_Nonnull backData, NSError *_Nonnull error) {
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

#pragma mark -给每个cell中的textfield添加事件，只要值改变就调用此函数
- (void)changedTextField:(UITextField *)textField {
    if (textField.tag == 12) {
        if (self.timer == nil) {
            self.getCodeBtn.enabled = textField.text.length > 0 && ![textField.text isEqualToString:@" "];
        }
    }
    UITextField *textField1 = [self.view viewWithTag:10];
    UITextField *textField2 = [self.view viewWithTag:11];
    UITextField *textField3 = [self.view viewWithTag:12];
    if (self.dict[@"Idnumber"] == nil || [self.dict[@"Idnumber"] isEqualToString:@""]) {
        self.checkBtn.enabled = (textField1.text.length > 0) && (textField2.text.length > 0) && (textField3.text.length > 0);
    }
    self.getCodeBtn.enabled = textField3.text.length > 0 && ![textField3.text isEqualToString:@" "];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
