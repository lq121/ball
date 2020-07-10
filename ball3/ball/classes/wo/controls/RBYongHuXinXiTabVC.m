#import "RBYongHuXinXiTabVC.h"
#import <AVFoundation/AVFoundation.h>
#import "RBNetworkTool.h"
#import "RBUserInfoModel.h"
#import "RBUserInfoCell.h"
#import "RBActionView.h"
#import "RBToast.h"
#import "RBXiuGaiNiChengVC.h"
#import "RBXiuGaiPwdVC.h"
#import "RBYQMVC.h"
#import "RBShiMingVC.h"
#import "RBDengJiVC.h"
#import "RBChongZhiVC.h"

@interface RBYongHuXinXiTabVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSMutableArray *infos;
@property (nonatomic, strong) NSMutableArray *des;
@property (nonatomic, assign) float coinCount;
@property (nonatomic, assign) BOOL notFirst;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) NSString *Usedyqcode;
/// 等级
@property (nonatomic, assign) int Viplevel;
/// 经验
@property (nonatomic, assign) int exp;
@end

@implementation RBYongHuXinXiTabVC
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        [_imagePicker setAllowsEditing:YES];
    }
    return _imagePicker;
}

- (NSMutableArray *)infos {
    if (_infos == nil) {
        _infos = [NSMutableArray array];
    }
    return _infos;
}

- (NSMutableArray *)des {
    if (_des == nil) {
        _des = [NSMutableArray array];
    }
    return _des;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/getuserdetail" andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        if (backData[@"err"] != nil) {
            return;
        }
        [self.des removeAllObjects];
        NSDictionary *data = backData;
        NSDictionary *dict = data[@"ok"];
        if (dict == nil) return;
        self.infoDict = dict;
        if ([dict[@"Iconurl"] isEqualToString:@""] || dict[@"Iconurl"] == nil) {
            [self.des addObject:@"user pic"];
        } else {
            [self.des addObject:dict[@"Iconurl"]];
        }
        [self.des addObject:dict[@"Nickname"]];
        [self.des addObject:dict[@"Id"]];
        [self.des addObject:dict[@"Yqcode"]];
        self.Usedyqcode = dict[@"Usedyqcode"];

        if (backData[@"Wxid"] != nil && ![backData[@"Wxid"] isEqualToString:@""]) {
            [self.des addObject:@""];
        } else {
            [self.des addObject:@"修改"];
        }

        if (![dict[@"Email"] isEqual:@""]) {
            [self.des addObject:dict[@"Email"]];
        } else {
            [self.des addObject:@""];
        }
        [self.des addObject:dict[@"Mobile"]];
        if ([dict[@"Idnumber"] isEqual:@""]) {
            [self.des addObject:@"未认证"];
        } else {
            [self.des addObject:@"已认证"];
        }
        self.coinCount = [dict[@"Gold"]intValue];
        self.Viplevel = [dict[@"Viplevel"]intValue];
        self.exp = [dict[@"Exp"]intValue];
        [[NSUserDefaults standardUserDefaults]setObject:dict[@"Nickname"] forKey:@"nickname"];
        [[NSUserDefaults standardUserDefaults]setObject:@(self.coinCount) forKey:@"coinCount"];
        [[NSUserDefaults standardUserDefaults]setObject:@([dict[@"Viplevel"]intValue]) forKey:@"Viplevel"];
        [[NSUserDefaults standardUserDefaults]setObject:@([dict[@"Exp"]intValue]) forKey:@"Exp"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.des addObject:[NSString stringWithFormat:@"Lv.%d", [dict[@"Viplevel"]intValue]]];
        [self.des addObject:[NSString stringWithFormat:@"%d", [dict[@"Gold"]intValue]]];
        for (int i = 0; i < self.infos.count; i++) {
            RBUserInfoModel *model = self.infos[i];
            model.hasUsed = self.Usedyqcode.length > 0;
            model.desName = self.des[i];
            if (i == 0) {
                model.isImage = true;
            }
            if (i != 2 && i != 5 && i != 6) {
                model.showRow = YES;
            }
            if (i != 3 && i != 7 && i != 8) {
                model.showLine = YES;
            }
        }
        if ([dict.allKeys containsObject:@"Vip"]) {
            [self.des addObject:dict[@"Vip"]];
            [self.des addObject:dict[@"Vipst"]];
        }
        [self.tableView reloadData];
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.infos = [NSMutableArray array];
    self.title = @"个人信息";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    NSArray *tips = @[@"头像", @"昵称", @"UID", yaoqingma, @"密码", @"邮箱", @"手机号", @"实名认证", @"我的等级", @"我的金币"];
    if (self.des.count == 0) {
        NSArray *des = @[@"user pic", @"", @"", @"", @"修改", @"", @"", @"未认证", @"Lv.0", @"0"];
        [self.des addObjectsFromArray:des];
    }
    for (int i = 0; i < tips.count; i++) {
        RBUserInfoModel *model = [[RBUserInfoModel alloc]init];
        model.tipName = tips[i];
        model.desName = self.des[i];
        model.showRow = NO;
        if (i == 0) {
            model.isImage = true;
        }
        if (i != 2 && i != 5 && i != 6) {
            model.showRow = YES;
        }
        if (i != 3 && i != 7 && i != 9) {
            model.showLine = YES;
        }
        [self.infos addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBUserInfoCell *cell = [RBUserInfoCell createCellByTableView:tableView];
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger index = indexPath.row;
    if (indexPath.section == 1) {
        index = 4 + indexPath.row;
    } else if (indexPath.section == 2) {
        index = 8 + indexPath.row;
    }
    cell.infoModel = self.infos[index];
    BOOL notEditPwd = [[[NSUserDefaults standardUserDefaults]objectForKey:@"notEditPwd"]boolValue];
    if (notEditPwd && indexPath.row == 0 && indexPath.section == 1) {
        return [[UITableViewCell alloc]init];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 8)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL notEditPwd = [[[NSUserDefaults standardUserDefaults]objectForKey:@"notEditPwd"]boolValue];
    if (notEditPwd && indexPath.row == 0 && indexPath.section == 1) {
        return 0;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSArray *arr = @[@"拍照", @"从相册选择"];
            RBActionView *actionView = [[RBActionView alloc]initWithArray:arr andCancelBtnColor:[UIColor colorWithSexadeString:@"#FFA500"] andClickItem:^(NSInteger index) {
                if (index == 0) {
                    [self takePhoto];
                } else {
                    [self localPhoto];
                }
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:actionView];
            // 头像
        } else if (indexPath.row == 1) {
            // 昵称
            RBXiuGaiNiChengVC *xiuGaiNiChengVC = [[RBXiuGaiNiChengVC alloc]init];
            xiuGaiNiChengVC.nickName = self.des[1];
            [self.navigationController pushViewController:xiuGaiNiChengVC animated:YES];
        } else if (indexPath.row == 2) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            RBUserInfoModel *infoModel = self.infos[indexPath.row];
            pasteboard.string = infoModel.desName;
            [RBToast showWithTitle:@"UID已复制到您的粘贴板"];
        } else if (indexPath.row == 3) {
            // 邀请码
            RBYQMVC *yqVC = [[RBYQMVC alloc]init];
            yqVC.Yqcode = self.des[3];
            yqVC.Usedyqcode = self.Usedyqcode;
            [self.navigationController pushViewController:yqVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 密码
            RBXiuGaiPwdVC *xiuGaiPwdVC = [[RBXiuGaiPwdVC alloc]init];
            xiuGaiPwdVC.phone = self.des[6];
            [self.navigationController pushViewController:xiuGaiPwdVC animated:YES];
        } else if (indexPath.row == 3) {
            // 实名认证
            RBShiMingVC *shiMingVC = [[RBShiMingVC alloc]init];
            shiMingVC.dict = self.infoDict;
            [self.navigationController pushViewController:shiMingVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            // 等级
            RBDengJiVC *dengjiVC = [[RBDengJiVC alloc]init];
            dengjiVC.lv = self.Viplevel;
            dengjiVC.exp = self.exp;
            [self.navigationController pushViewController:dengjiVC animated:YES];
        } else if (indexPath.row == 1) {
            // 金币
            RBChongZhiVC *qianVC = [[RBChongZhiVC alloc]init];
            qianVC.coinCount = self.coinCount;
            [self.navigationController pushViewController:qianVC animated:YES];
        }
    }
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
        //上传到服务器
        [self doAddPhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)doAddPhoto:(UIImage *)image {
    [MBProgressHUD showLoading:@"图片上传中" toView:self.view];
    [RBNetworkTool uploadImageWithImage:image andDict:@{} andSuccess:^(NSDictionary *_Nonnull success) {
        RBUserInfoModel *infoModel = self.infos[0];
        infoModel.desName = success[@"ok"];
        self.infos[0] = infoModel;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } Fail:^(NSError *_Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
