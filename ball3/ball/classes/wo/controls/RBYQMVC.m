#import "RBYQMVC.h"
#import "RBYQMView.h"
#import "RBToast.h"
#import "RBNetworkTool.h"

@interface RBYQMVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *whiteView2;
@property (nonatomic, strong) NSMutableArray <UILabel *> *labelArray;
@property (nonatomic, copy) NSString *codeString;
@property (nonatomic, strong) UIButton *saveBtn;
@property(nonatomic,strong)RBYQMView *code;
@end

@implementation RBYQMVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelArray = [NSMutableArray array];
    self.title = @"邀请码";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - 74 - RBBottomSafeH - RBNavBarAndStatusBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    UIView *whiteView1 = [[UIView alloc]initWithFrame:CGRectMake(16, 16, RBScreenWidth - 32, 228)];
    whiteView1.backgroundColor = [UIColor whiteColor];
    whiteView1.layer.masksToBounds = YES;
    whiteView1.layer.cornerRadius = 2;
    [scrollView addSubview:whiteView1];

    UILabel *tip1Lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, RBScreenWidth - 32, 25)];
    tip1Lab1.text = @"- 我的邀请码 -";
    tip1Lab1.textColor = [UIColor colorWithSexadeString:@"#333333"];
    tip1Lab1.textAlignment = NSTextAlignmentCenter;
    tip1Lab1.font = [UIFont boldSystemFontOfSize:18];
    [whiteView1 addSubview:tip1Lab1];

    UILabel *tip1Lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tip1Lab1.frame) + 2, RBScreenWidth - 32, 17)];
    tip1Lab2.text = @"请把以下号码告知你想邀请的用户";
    tip1Lab2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
    tip1Lab2.textAlignment = NSTextAlignmentCenter;
    tip1Lab2.font = [UIFont systemFontOfSize:12];
    [whiteView1 addSubview:tip1Lab2];
    CGFloat margin = (RBScreenWidth - 32 - 112 - 6 * 32) / 5;
    for (int i = 0; i < self.Yqcode.length; i++) {
        NSString *c = [self.Yqcode substringWithRange:NSMakeRange(i, 1)];
        UILabel *label = [[UILabel alloc]init];
        label.text = c;
        label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.04];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithSexadeString:@"#333333"];
        label.font = [UIFont boldSystemFontOfSize:22];
        label.frame = CGRectMake(56 + (32 + margin) * i, CGRectGetMaxY(tip1Lab2.frame) + 24, 32, 40);
        [whiteView1 addSubview:label];
    }

    UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 150, RBScreenWidth - 48, 48)];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView1 addSubview:copyBtn];
    [copyBtn addTarget:self action:@selector(clickCopyBtn) forControlEvents:UIControlEventTouchUpInside];

    if(self.Usedyqcode.length <= 0){
        UIView *whiteView2 = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(whiteView1.frame) + 16, RBScreenWidth - 32, 228)];
        self.whiteView2 = whiteView2;
        whiteView2.backgroundColor = [UIColor whiteColor];
        whiteView2.layer.masksToBounds = YES;
        whiteView2.layer.cornerRadius = 2;
        [scrollView addSubview:whiteView2];
        
        UILabel *tip2Lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, RBScreenWidth - 32, 25)];
        tip2Lab1.text = @"- 填写邀请码 -";
        tip2Lab1.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tip2Lab1.textAlignment = NSTextAlignmentCenter;
        tip2Lab1.font = [UIFont boldSystemFontOfSize:18];
        [whiteView2 addSubview:tip2Lab1];
        
        UILabel *tip2Lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tip2Lab1.frame) + 2, RBScreenWidth - 32, 17)];
        tip2Lab2.text = @"新用户填写邀请码可获得奖励";
        tip2Lab2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6];
        tip2Lab2.textAlignment = NSTextAlignmentCenter;
        tip2Lab2.font = [UIFont systemFontOfSize:12];
        [whiteView2 addSubview:tip2Lab2];
        UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 150, RBScreenWidth - 48, 48)];
        self.saveBtn = saveBtn;
        [whiteView2 addSubview:saveBtn];
        saveBtn.enabled = NO;
        saveBtn.height = 48;
        saveBtn.layer.masksToBounds = YES;
        saveBtn.layer.cornerRadius = 24;
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
        [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
        [saveBtn addTarget:self action:@selector(clickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
        RBYQMView *code = [[RBYQMView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tip2Lab2.frame) + 24, 231, 40) onFinishedEnterCode:^(NSString *code) {
            self.codeString = code;
            self.saveBtn.enabled = YES;
        } andDeleteCode:^(NSString *_Nullable code) {
            self.codeString = code;
            self.saveBtn.enabled = NO;
        }];
        self.code = code;
        [whiteView2 addSubview:code];
        [code.codeTextField becomeFirstResponder];
    }
}

- (void)clickCopyBtn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.Yqcode;
    [RBToast showWithTitle:@"邀请码已复制到您的粘贴板"];
}

- (void)clickSaveBtn {
    [self.code.codeTextField resignFirstResponder];
    if ([[_codeString uppercaseString] isEqualToString:[self.Yqcode uppercaseString]]) {
        [RBToast showWithTitle:@"请填写正确的邀请码"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[_codeString uppercaseString] forKey:@"code"];

    [RBNetworkTool PostDataWithUrlStr:@"apis/useyqcode" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"ok"] != nil) {
            self.whiteView2.hidden = YES;
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

#pragma mark  - - - --  监听，键盘显示获得键盘的高度 － － － － －－ － － －
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
     [UIView animateWithDuration:duration animations:^{
           self.scrollView.contentOffset = CGPointMake(0, 100);
       }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark  - - - --  监听，键盘消失时 － － － － －－ － － －
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
