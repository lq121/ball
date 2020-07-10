#import "RBSheZhiTabVC.h"
#import "RBGuanYuPingTaiVC.h"
#import "RBWKWebView.h"
#import "RBNetworkTool.h"
#import "SDImageCache.h"

@interface RBSheZhiTabVC ()
@property (strong, nonatomic) NSArray *sheZhiArr;
@property (copy, nonatomic) NSString *cacheStr;
@property (nonatomic, strong) UILabel *statLab;
@property (nonatomic, strong) UILabel *statLab2;
@end

@implementation RBSheZhiTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用设置";
    self.sheZhiArr = @[@"关于平台", @"进球音效", @"通知开关", @"使用条款和隐私", yonghuxieyi, @"清除缓存"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sheZhiArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifiercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        if (indexPath.row == 1) {
            UILabel *statLab = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 82, 20, 14, 20)];
            UISwitch *shoutDown = [[UISwitch alloc]initWithFrame:CGRectMake(RBScreenWidth - 60, 12, 44, 24)];
            shoutDown.tag = 3;
            statLab.text = @"开";
            [shoutDown setOn:YES];
            BOOL voiceOff = [[[NSUserDefaults standardUserDefaults]objectForKey:@"voiceOff"] boolValue];
            if (voiceOff) {
                statLab.text = @"关";
                [shoutDown setOn:NO];
            }
            statLab.font = [UIFont systemFontOfSize:14];
            self.statLab = statLab;
            [cell addSubview:statLab];
            [shoutDown addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [[UISwitch appearance] setOnTintColor:[UIColor colorWithSexadeString:@"#FFA500"]];
            [cell addSubview:shoutDown];
        } else if (indexPath.row == 2) {
            UILabel *statLab = [[UILabel alloc]initWithFrame:CGRectMake(RBScreenWidth - 82, 20, 14, 20)];
            UISwitch *shoutDown = [[UISwitch alloc]initWithFrame:CGRectMake(RBScreenWidth - 60, 12, 44, 24)];
            shoutDown.tag = 4;
            statLab.text = @"开";
            [shoutDown setOn:YES];
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if (UIUserNotificationTypeNone == setting.types) {
                statLab.text = @"关";
                [shoutDown setOn:NO];
            }
            statLab.font = [UIFont systemFontOfSize:14];
            self.statLab2 = statLab;
            [cell addSubview:statLab];
            [shoutDown addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [[UISwitch appearance] setOnTintColor:[UIColor colorWithSexadeString:@"#FFA500"]];
            [cell addSubview:shoutDown];
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 59, RBScreenWidth - 16 - 15, 1)];
        line.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        [cell.contentView addSubview:line];
        cell.textLabel.textColor =  [UIColor colorWithSexadeString:@"#333333"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.sheZhiArr[indexPath.row];
    if (indexPath.row == 5) {
        self.cacheStr = [NSString stringWithFormat:@"%0.2fM", [self filePath]];
        cell.detailTextLabel.text = self.cacheStr;
    }
    return cell;
}

- (void)switchAction:(UISwitch *)switchs {
    if (switchs.tag == 3) {
        if (switchs.isOn) {
            self.statLab.text = @"开";
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"voiceOff"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } else {
            self.statLab.text = @"关";
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"voiceOff"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } else {
        if (switchs.isOn) {
            NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
            switchs.on = NO;
            NSURL *openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"App-Prefs:root=NOTIFICATIONS_ID&path=%@", identifier]];
            if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
                //在iOS应用程序中打开设备设置界面及其中某指定的选项界面-通知界面
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        } else {
            self.statLab2.text = @"关";
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        return 0;
    } else {
        return 68;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        return [[UIView alloc]init];
    } else {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 68)];
        view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, RBScreenWidth, 60)];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#484848"] forState:UIControlStateNormal];
        [btn addTarget:self  action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // y关于直播平台
        [self.navigationController pushViewController:[[RBGuanYuPingTaiVC alloc]init] animated:YES];
    } else if (indexPath.row == 3) {
        // 使用条款和隐私
        RBWKWebView *webVc = [[RBWKWebView alloc]init];
        webVc.url = @"hios/privacy-policy.html";
        webVc.title = yinsizhengce;
        [self.navigationController pushViewController:webVc animated:YES];
    } else if (indexPath.row == 4) {
        // 使用条款和隐私
        RBWKWebView *webVc = [[RBWKWebView alloc]init];
        webVc.url = @"hios/user-policy.html";
        webVc.title = yonghuxieyi;
        [self.navigationController pushViewController:webVc animated:YES];
    } else if (indexPath.row == 5) {
        // 清除缓存
        [self clearCacheDidSelected];
    }
}

// 退出登录
- (void)clickBtn {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [RBNetworkTool PostDataWithUrlStr:@"apis/logout"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
        NSDictionary *dict = backData;
        if (dict[@"err"] == nil) {
            NSString *uid  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
            if (uid != nil && ![uid isEqualToString:@""]) {
                [dict setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"oldUid"];
            }
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"refresh_token"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"Packet"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"setMatchArr"];
            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"coinCount"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"vipDict"];
            [[NSUserDefaults standardUserDefaults]setValue:@(0) forKey:@"isVip"];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"seletmatchArr"];
            [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"notEditPwd"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (float)filePath {
    NSString *cachPath = [ NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject ];
    return [ self folderSizeAtPath:cachPath];
}

//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil && ![fileName containsString:@"sqlite"]) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //SDWebImage框架自身计算缓存的实现
    folderSize += [[SDImageCache sharedImageCache] totalDiskSize];

    return folderSize / (1024.0 * 1024.0);
}

- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (void)clearCacheDidSelected {
    if ([self.cacheStr isEqualToString:@"0.00M"]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tishi message:[NSString stringWithFormat:@"缓存大小为%@,确定要清理缓存吗？", self.cacheStr] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:quxiao style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:queding style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        weakSelf.cacheStr = @"0.00M";
        [weakSelf.tableView reloadData];
        [weakSelf clearCache];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearCache {
    NSString *cachPath = [ NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachPath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachPath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [cachPath stringByAppendingPathComponent:fileName];
            if (![absolutePath containsString:@"sqlite"]) {
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
