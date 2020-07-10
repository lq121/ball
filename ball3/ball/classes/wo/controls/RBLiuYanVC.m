#import "RBLiuYanVC.h"
#import "RBTextView.h"
#import "RBActionView.h"
#import "RBToast.h"
#import <AVFoundation/AVFoundation.h>
#import "RBNetworkTool.h"

@interface RBLiuYanVC ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *currentSelectBtn;
@property (nonatomic, strong) RBTextView *textView;
@property (nonatomic, strong) NSArray *minTitles;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIImage *choseImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation RBLiuYanVC
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        [_imagePicker setAllowsEditing:YES];
    }
    return _imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"留言反馈";
   
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - 74 - RBBottomSafeH - RBNavBarAndStatusBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

    UILabel *tip2 = [[UILabel alloc]init];
    tip2.text = @"问题分类";
    tip2.frame = CGRectMake(16, 16, 120, 22);
    tip2.font = [UIFont boldSystemFontOfSize:16];
    tip2.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip2 sizeToFit];
    [scrollView addSubview:tip2];

    self.minTitles = @[@"账号问题", @"性能问题", @"充值问题", @"功能建议", @"其他问题"];
    CGFloat width = (RBScreenWidth - 32 - 16) / 3;
    CGFloat height = 32;
    for (int i = 0; i < self.minTitles.count; i++) {
        CGFloat x = 16 + (i % 3) * (width + 8);
        CGFloat y = CGRectGetMaxY(tip2.frame) + 16 + (i / 3) * (16 + height);
        UIButton *btn;
        if (i == self.selectIndex) {
            btn = [self cretaMinBtnWithFrame:CGRectMake(x, y - 5, width, height) andTitle:self.minTitles[i]];
            btn.selected = YES;
            self.currentSelectBtn = btn;
        } else {
            btn = [self cretaMinBtnWithFrame:CGRectMake(x, y, width, height) andTitle:self.minTitles[i]];
        }

        btn.tag = 400 + i;
        [scrollView addSubview:btn];
    }

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 142, RBScreenWidth, 8)];
    line1.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [scrollView addSubview:line1];

    UILabel *tip = [[UILabel alloc]init];
    tip.text = @"标题";
    tip.frame = CGRectMake(16, CGRectGetMaxY(line1.frame) + 16, 120, 22);
    tip.font = [UIFont boldSystemFontOfSize:16];
    tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip sizeToFit];
    [scrollView addSubview:tip];

    UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip.frame) + 16, RBScreenWidth - 32, 44)];
    self.textField2 = textField2;
    textField2.delegate = self;
    textField2.placeholder = @"请输入反馈标题";
    textField2.returnKeyType = UIReturnKeyDone;
    textField2.font = [UIFont systemFontOfSize:16];
    textField2.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:textField2];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip.frame) + 16 + 42, RBScreenWidth - 32, 2)];
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [scrollView addSubview:line];

    UILabel *tip3 = [[UILabel alloc]init];
    tip3.text = @"反馈内容";
    tip3.frame = CGRectMake(16, CGRectGetMaxY(textField2.frame) + 16, 120, 22);
    tip3.font = [UIFont boldSystemFontOfSize:16];
    tip3.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip3 sizeToFit];
    [scrollView addSubview:tip3];

    RBTextView *textView = [RBTextView textView];
    textView.textContainerInset = UIEdgeInsetsMake(8, 16, 0, 0);
    textView.font = [UIFont systemFontOfSize:14];
    textView.returnKeyType = UIReturnKeyDone;
    self.textView = textView;
    textView.delegate = self;
    textView.frame = CGRectMake(15, CGRectGetMaxY(tip3.frame) + 16, RBScreenWidth - 30, 100);
    textView.placeholder = @"请详细描述您的问题…";
    textView.placeholderColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    textView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    [scrollView addSubview:textView];

    UILabel *tip4 = [[UILabel alloc]init];
    tip4.text = @"图片";
    tip4.frame = CGRectMake(16, CGRectGetMaxY(textView.frame) + 16, 120, 22);
    tip4.font = [UIFont boldSystemFontOfSize:16];
    tip4.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip4 sizeToFit];
    [scrollView addSubview:tip4];

    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip4.frame) + 9, 68, 68)];
    [photoBtn addTarget:self  action:@selector(clickPhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn = photoBtn;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"add pic"] forState:UIControlStateNormal];
    [scrollView addSubview:photoBtn];

    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(photoBtn.frame) + 16, RBScreenWidth, 8)];
    line2.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [scrollView addSubview:line2];

    UILabel *tip5 = [[UILabel alloc]init];
    tip5.text = @"联系方式";
    tip5.frame = CGRectMake(16, CGRectGetMaxY(line2.frame) + 24, 120, 22);
    tip5.font = [UIFont boldSystemFontOfSize:16];
    tip5.textColor = [UIColor colorWithSexadeString:@"#333333"];
    [tip5 sizeToFit];
    [scrollView addSubview:tip5];

    UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(RBScreenWidth - (RBScreenWidth - 32 - tip5.width - 16) - 16, CGRectGetMaxY(line2.frame), RBScreenWidth - 32 - tip5.width - 16, 52)];
    self.textField1 = textField1;
    textField1.delegate = self;
    textField1.placeholder = @"手机号码/QQ号码";
    textField1.returnKeyType = UIReturnKeyDone;
    textField1.font = [UIFont systemFontOfSize:16];
    textField1.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:textField1];

    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(RBScreenWidth - (RBScreenWidth - 32 - tip5.width - 16) - 16, CGRectGetMaxY(line2.frame) + 52, RBScreenWidth - 32 - tip5.width - 16, 2)];
    line3.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [scrollView addSubview:line3];

    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBScreenHeight - 74 - RBBottomSafeH - RBNavBarAndStatusBarH, RBScreenWidth - 32, 48)];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"btn keep_enabled"] forState:UIControlStateDisabled];
    [backbtn setTitle:tijiao forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5] forState:UIControlStateDisabled];
    [backbtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}

#pragma mark  - - - --  监听，键盘显示获得键盘的高度 － － － － －－ － － －

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardY = keyboardRect.origin.y;
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat editMaxY = 0;
    if ([self.textField2 isEditing]) {
        editMaxY = CGRectGetMaxY(self.textField2.frame);
    } else if ([self.textView isEditable]) {
        editMaxY = CGRectGetMaxY(self.textView.frame);
    } else if ([self.textField1 isEditing]) {
        editMaxY = CGRectGetMaxY(self.textField1.frame);
    }
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(0, -(RBScreenHeight - editMaxY - keyboardY - RBNavBarAndStatusBarH));
    }];
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

- (void)clickPhotoBtn {
    NSArray *arr = @[@"拍照", @"从相册选择"];
    RBActionView *actionView = [[RBActionView alloc]initWithArray:arr  andCancelBtnColor:[UIColor colorWithSexadeString:@"#FFA500"] andClickItem:^(NSInteger index) {
        if (index == 0) {
            [self takePhoto];
        } else {
            [self localPhoto];
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
}

- (UIButton *)cretaMinBtnWithFrame:(CGRect)frame andTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn addTarget:self action:@selector(clickMinBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"game selected"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"game selected"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"game normal"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#FFA500"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}

- (void)clickMinBtn:(UIButton *)btn {
    self.currentSelectBtn.selected = NO;
    btn.selected = YES;
    self.currentSelectBtn = btn;
    self.selectIndex = (int)btn.tag - 400;
}



// 提交按钮
- (void)clickBackBtn {
    NSString *titleStr = [self.textField2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (titleStr.length <= 0) {
        [RBToast showWithTitle:@"请输入反馈标题"];
        return;
    }
    NSString *textViewStr = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textViewStr.length <= 0) {
        [RBToast showWithTitle:@"请输入反馈内容"];
        return;
    }
    NSString *textFieldStr = [self.textField1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textViewStr.length <= 0) {
        [RBToast showWithTitle:@"请输入联系方式"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.textField2.text forKey:@"title"];
    [dict setValue:@(self.selectIndex + 1) forKey:@"style"];
    [dict setValue:textViewStr forKey:@"txt"];
    [dict setValue:textFieldStr forKey:@"contact"];
    [MBProgressHUD showLoading:@"提交中" toView:self.view];
    [RBNetworkTool uploadImageWithImage:self.choseImage andDict:dict andSuccess:^(NSDictionary *_Nonnull backDict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (backDict[@"ok"] != nil) {
            [RBToast showWithTitle:@"提交反馈成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(myDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self.navigationController popToRootViewControllerAnimated:YES];
                           });
        } else {
            [RBToast showWithTitle:@"提交反馈失败"];
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [RBToast showWithTitle:@"提交反馈失败"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        NSString *key = nil;
        if (picker.allowsEditing) {
            key = UIImagePickerControllerEditedImage;
        } else {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // 固定方向
            image = [image fixDirextion];//这个方法是UIImage+Extras.h中方法
        }
        self.choseImage = image;
        [self.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

// 开始拍照
- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //先检查相机可用是否
        BOOL cameraIsAvailable = [self checkCamera];
        if (YES == cameraIsAvailable) {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tishi message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
            [alert show];
        }
    }
}

// 打开本地相册
- (void)localPhoto {
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//检查相机是否可用
- (BOOL)checkCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (AVAuthorizationStatusRestricted == authStatus ||
        AVAuthorizationStatusDenied == authStatus) {
        //相机不可用
        return NO;
    }
    //相机可用
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop)
        {
            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

@end
