#import "RBChekLogin.h"
#import "RBLoginVC.h"
#import "RBActionView.h"
#import "RBDengJiVC.h"

@implementation RBChekLogin
+ (BOOL)CheckLogin {
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if (uid == nil || [uid isEqualToString:@""]) {
        RBLoginVC *loginVC = [[RBLoginVC alloc]init];
        loginVC.fromVC = [UIViewController getCurrentVC];
        [[UIViewController getCurrentVC].navigationController pushViewController:loginVC animated:YES];
        return YES;
    }
    return NO;
}

+ (BOOL)checkWithTitile:(NSString *)title andtype:(NSString *)type andNeedCheck:(BOOL)need {
    if (need) {
        int isVip = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isVip"]intValue];
        int Viplevel = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Viplevel"]intValue];
        NSDictionary *huatilvlimit = [[NSUserDefaults standardUserDefaults]objectForKey:@"huatilvlimit"];
        int typeNum = 5;
        if (huatilvlimit != nil) {
            typeNum = [huatilvlimit[type] intValue];
        }
        if (isVip != 2 && Viplevel < typeNum) {
            RBActionView *actionView = [[RBActionView alloc]initWithFrame:CGRectMake(38, (RBScreenHeight - 150) * 0.5, RBScreenWidth - 38 * 2, 150) andTitle:title andCancel:@"知道了"  andSure:@"如何升级" andClickSureBtn:^{
                int Viplevel = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Viplevel"]intValue];
                int Exp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Exp"]intValue];
                RBDengJiVC *dengJiVC = [[RBDengJiVC alloc]init];
                dengJiVC.lv = Viplevel;
                dengJiVC.exp = Exp;
                [[UIViewController getCurrentVC].navigationController pushViewController:dengJiVC animated:YES];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:actionView];
            return YES;
        }
    } else {
        RBActionView *actionView = [[RBActionView alloc]initWithFrame:CGRectMake(38, (RBScreenHeight - 150) * 0.5, RBScreenWidth - 38 * 2, 150) andTitle:title andCancel:@"知道了"  andSure:@"如何升级" andClickSureBtn:^{
            int Viplevel = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Viplevel"]intValue];
            int Exp = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Exp"]intValue];
            RBDengJiVC *dengJiVC = [[RBDengJiVC alloc]init];
            dengJiVC.lv = Viplevel;
            dengJiVC.exp = Exp;
            [[UIViewController getCurrentVC].navigationController pushViewController:dengJiVC animated:YES];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:actionView];
        return YES;
    }
    return NO;
}


@end
