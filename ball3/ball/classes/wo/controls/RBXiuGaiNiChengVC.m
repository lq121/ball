#import "RBXiuGaiNiChengVC.h"
#import "RBNetworkTool.h"
#import "RBToast.h"

@interface RBXiuGaiNiChengVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation RBXiuGaiNiChengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 60)];
    whiteView.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, RBScreenWidth - 32, 60)];
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.textField = textField;
    textField.placeholder = @"请输入昵称";
    textField.text = self.nickName;
    [textField becomeFirstResponder];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor colorWithSexadeString:@"484848"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:whiteView];
    [whiteView addSubview:textField];

    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(textField.frame) + 28, RBScreenWidth - 32, 48)];
    self.saveBtn = saveBtn;
    if (textField.text.length == 0 || [textField.text isEqualToString:@" "]) {
        saveBtn.enabled = NO;
    } else {
        saveBtn.enabled = YES;
    }
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(clickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)clickSaveBtn {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.textField.text forKey:@"name"];
    [RBNetworkTool PostDataWithUrlStr:@"apis/changename" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        NSDictionary *dic = backData;
        if (dic[@"ok"] != nil) {
            [MBProgressHUD showSuccess:@"修改成功" toView:[UIApplication sharedApplication].keyWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(myDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self.navigationController popViewControllerAnimated:YES];
                           });
        } else {
            [RBToast showWithTitle:@"该昵称已被占用，请重新填写"];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)changedTextField:(UITextField *)textField {
    self.saveBtn.enabled = textField.text.length > 0 && ![textField.text isEqualToString:@" "];
}

@end
