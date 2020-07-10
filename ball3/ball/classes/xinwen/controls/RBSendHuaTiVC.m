#import "RBSendHuaTiVC.h"
#import "RBTextView.h"
#import "RBActionView.h"
#import "RBToast.h"
#import "RBNetworkTool.h"
#import <AVFoundation/AVFoundation.h>
#import "LYFPhotosManager.h"
#import "LYFPhotoModel.h"
#import "RBChekLogin.h"
#import "RBSelectImage.h"

@interface RBSendHuaTiVC ()<UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) RBTextView *textView;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UIButton *typeBtn;

@end

@implementation RBSendHuaTiVC
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        [_imagePicker setAllowsEditing:YES];
    }
    return _imagePicker;
}

- (NSMutableArray *)imagesArr {
    if (_imagesArr == nil) {
        _imagesArr = [NSMutableArray array];
    }
    return _imagesArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UILabel *label = [[UILabel alloc] init];
    label.text = @"请遵守法律规范，违规者封号处理";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(0, 0, RBScreenWidth, 24);
    [self.view addSubview:label];

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(RBScreenWidth - 80, RBStatusBarH + 10, 64, 24)];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 5;
    [sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FFA500"]] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightButton;

    UIView *whiteView = [[UIView alloc]init];
    self.whiteView = whiteView;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];

    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(16,  16, RBScreenWidth - 32, 38)];
    field.tintColor = [UIColor colorWithSexadeString:@"#FFA500"];
    self.field = field;
    field.delegate = self;
    field.placeholder = @"标题…";
    field.returnKeyType = UIReturnKeyDone;
    field.font = [UIFont systemFontOfSize:16];
    field.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:field];

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(field.frame), RBScreenWidth - 32, 2)];
    line1.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [whiteView addSubview:line1];

    RBTextView *textView = [RBTextView textView];
    textView.font = [UIFont systemFontOfSize:14];
    textView.returnKeyType = UIReturnKeyDone;
    self.textView = textView;
    textView.delegate = self;
    textView.frame = CGRectMake(16, CGRectGetMaxY(line1.frame) + 8, RBScreenWidth - 32, 160);
    textView.placeholder = @"这一刻想法…";
    textView.placeholderColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    textView.placeholderFrame = CGRectMake(0, 8, 100, 20);
    [whiteView addSubview:textView];

    UIView *imagesView = [[UIView alloc]init];
    self.imagesView = imagesView;
    [whiteView addSubview:self.imagesView];

    UIView *line = [[UIView alloc]init];
    self.line = line;
    line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    [whiteView addSubview:line];

    UIButton *typeBtn = [[UIButton alloc]init];
    self.typeBtn = typeBtn;
    [typeBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [typeBtn setImage:[UIImage imageNamed:@"choose disagree2"] forState:UIControlStateNormal];
    [typeBtn setImage:[UIImage imageNamed:@"choose agree-selected"] forState:UIControlStateSelected];
    [typeBtn setTitle:@"锁定帖子（别人不能回复）" forState:UIControlStateNormal];
    [typeBtn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    typeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    [whiteView addSubview:typeBtn];
    [self setImages];
}

- (void)clickTypeBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)setImages {
    for (UIView *view in self.imagesView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat height = 0;
    CGFloat width = 68;
    if (self.imagesArr.count % 3 > 0) {
        height += (width + 4);
    }
    height += (((self.imagesArr.count) / 3) * (width + 4));
    for (int i = 0; i < self.imagesArr.count; i++) {
        CGFloat row = i % 3;
        CGFloat col = i / 3;
        CGFloat x = 16 + (width + 4) * row;
        CGFloat y = (width + 4) * col;
        RBSelectImage *selectImage = [[RBSelectImage alloc]initWithFrame:CGRectMake(x, y, width, width) andImage:self.imagesArr[i] andClickCloseBtn:^(UIImage *_Nonnull image) {
            [self.imagesArr removeObject:image];
            [self setImages];
        } andClickBgImage:^(UIImage *_Nonnull image) {
        }];
        [self.imagesView addSubview:selectImage];
    }
    if ((self.imagesArr.count) % 3 != 0 && self.imagesArr.count != 0) {
        self.imagesView.frame = CGRectMake(0, 16 + CGRectGetMaxY(self.textView.frame), RBScreenWidth, height);
    } else {
        self.imagesView.frame = CGRectMake(0, 16 + CGRectGetMaxY(self.textView.frame), RBScreenWidth, height + width + 4);
    }
    if (self.imagesArr.count >= 9) {
        self.line.frame = CGRectMake(16, height + 16 + CGRectGetMaxY(self.textView.frame), RBScreenWidth - 32, 2);
        self.typeBtn.frame = CGRectMake(16, CGRectGetMaxY(self.line.frame) + 16, 164, 17);
        self.whiteView.frame = CGRectMake(0, 24, RBScreenWidth, CGRectGetMaxY(self.line.frame) + 48);
        return;
    }
    UIButton *photoBtn = [[UIButton alloc]init];
    self.photoBtn = photoBtn;
    [photoBtn setBackgroundImage:[UIImage imageNamed:@"add pic"] forState:UIControlStateNormal];

    if (self.imagesArr.count % 3 == 0) {
        if (self.imagesArr.count == 0) {
            // 没有图片
            photoBtn.frame = CGRectMake(16, 0, 68, 68);
        } else {
            // 已经是3张图需要换行
            photoBtn.frame = CGRectMake(16, height + 4, 68, 68);
        }
    } else {
        CGFloat row = ((self.imagesArr.count) % 3);
        photoBtn.frame = CGRectMake(16 + (width + 4) * row, (((self.imagesArr.count) / 3) * (width + 4)), 68, 68);
    }
    [photoBtn addTarget:self action:@selector(clickAddPictureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.imagesView addSubview:photoBtn];

    self.line.frame = CGRectMake(16, CGRectGetMaxY(self.imagesView.frame) + 16, RBScreenWidth - 32, 2);
    self.typeBtn.frame = CGRectMake(16, CGRectGetMaxY(self.line.frame) + 16, 164, 17);
    self.whiteView.frame = CGRectMake(0, 24, RBScreenWidth, CGRectGetMaxY(self.line.frame) + 48);
}

- (void)clickCheckBtn {
    [self.view endEditing:YES];
    [self.field resignFirstResponder];
    NSString *title = self.field.text;
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (title.length == 0) {
        [RBToast showWithTitle:@"请输入标题"];
        return;
    }
    NSString *content = self.textView.text;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (content.length == 0 && self.imagesArr.count == 0) {
        [RBToast showWithTitle:@"请输入内容"];
        return;
    }
    [MBProgressHUD showLoading:@"发布中" toView:self.view];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid != nil && ![uid isEqualToString:@""]) {
        [dict setValue:uid forKey:@"uid"];
    }
    [dict setValue:self.field.text forKey:@"title"];
    [dict setValue:self.textView.text forKey:@"txt"];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd-hh:mm:ss:SSS";
    NSString *str = [formatter stringFromDate:[NSDate date]];

    NSMutableArray *names = [NSMutableArray array];
    for (int i = 0; i < self.imagesArr.count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%@%d.jpg", str, uid, i];
        [names addObject:fileName];
    }
    [dict setValue:names forKey:@"imgs"];
    if (self.typeBtn.selected) {
        [dict setValue:@(1) forKey:@"clock"];
    } else {
        [dict setValue:@(0) forKey:@"clock"];
    }
    
    [RBNetworkTool uploadImageWithImages:self.imagesArr andDict:dict andSuccess:^(NSDictionary *_Nonnull backData) {
        [MBProgressHUD hidHUDFromView:self.view];
        if ([backData[@"err"]intValue] == 50002) {
            [RBChekLogin checkWithTitile:xuyao5ji andtype:@"pushlv" andNeedCheck:NO];
        } else if (backData[@"ok"] != nil) {
            [RBToast showWithTitle:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hidHUDFromView:self.view];
        [RBToast showWithTitle:@"发布失败"];
    }];
}

- (void)clickAddPictureBtn {
    [self.view endEditing:YES];
    NSArray *arr = @[@"拍照", @"从相册选择"];
    RBActionView *actionView = [[RBActionView alloc]initWithArray:arr andCancelBtnColor:[UIColor colorWithSexadeString:@"#FFA500"] andClickItem:^(NSInteger index) {
        if (index == 0) {
            [self takePhoto];
        } else {
            [self localPhoto];
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
}

// 开始拍照
- (void)takePhoto{
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
- (void)localPhoto{
    [LYFPhotosManager showPhotosManager:self withMaxImageCount:9 andLastChoseImageCount:self.imagesArr.count withAlbumArray:^(NSMutableArray<LYFPhotoModel *> *albumArray) {
        for (LYFPhotoModel *model in albumArray) {
            [self.imagesArr addObject:model.highDefinitionImage];
        }
        [self setImages];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
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
        [self.imagesArr addObject:image];
        [self setImages];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

//检查相机是否可用
- (BOOL)checkCamera{
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
