#import "RBTabBar.h"
#import "RBNavigationVC.h"
#import "RBTabBarVC.h"
#import "RBNetworkTool.h"
#import "RBBiSaiModel.h"
#import "RBCreateID.h"
#import "RBFMDBTool.h"
#import "RBBiSaiDetailVC.h"
#import "RBJqView.h"

@interface RBTabBarVC ()<RBTabBarDelegate>
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, assign) BOOL hasAnimation;
@property (nonatomic, assign) BOOL hasPlayed;
@end

@implementation RBTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildWithName:@"RBXinWenTabVC" andTitle:xinwen andImage:@"xinwen" andSelectedImage:@"xinwen_selected"];
    [self addChildWithName:@"RBShiPingVC" andTitle:shiping andImage:@"shiping" andSelectedImage:@"shiping_selected"];
    if (IS_IPAD) {
        NSString *str = @"                           小应预测";
        CGSize size = [str getLineSizeWithFontSize:10];
        while (size.width < ((RBScreenWidth / 5) * 0.5 + 41)) {
            str = [NSString stringWithFormat:@" %@", str];
            size = [str getLineSizeWithFontSize:10];
        }
        [self addChildWithName:@"RBPredictTabVC" andTitle:str andImage:@"" andSelectedImage:@""];
    } else {
        [self addChildWithName:@"RBPredictTabVC" andTitle:@"小应预测" andImage:@"" andSelectedImage:@""];
    }

    [self addChildWithName:@"RBBiSaisVC" andTitle:bisaiStr andImage:@"bisai" andSelectedImage:@"bisai_selected"];
    [self addChildWithName:@"RBWoTabVC" andTitle:wode andImage:@"wode" andSelectedImage:@"wode_selected"];
    [self.tabBar removeFromSuperview];
    RBTabBar *tabBar = [[RBTabBar alloc] init];
    tabBar.delegate = self;
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    img.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, 60 + RBBottomSafeH);
    img.contentMode = UIViewContentModeScaleToFill;
    [self.tabBar insertSubview:img atIndex:0];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {     //横线的高度为0.5
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    self.tabBar.layer.shadowOpacity = 4;
    self.tabBar.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.06].CGColor;
    self.selectedIndex = 2;

    __weak typeof(self) weakSelf = self;
    self.timer1 = [NSTimer timerWithTimeInterval:10 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSRunLoopCommonModes];
    self.timer2 = [NSTimer timerWithTimeInterval:10 * 60 target:weakSelf selector:@selector(getBiSaiData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer2 forMode:NSRunLoopCommonModes];

    // 打开数据库
    [[RBFMDBTool sharedFMDBTool]openDatabase];
    [[RBFMDBTool sharedFMDBTool]createMagTab];
    [[RBFMDBTool sharedFMDBTool]createAttentionTab];
    [[RBFMDBTool sharedFMDBTool]createBiSaiTab];
    [self youkelogin];
    [self getBiSaiData];
}

- (void)getBiSaiData {
    NSString *str = [NSString getStrWithDate:[NSDate date] andFormat:@"yyyyMMdd"];
    NSDictionary *dict = @{ @"date": str };
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballmatchlistbydate"  andParam:dict Success:^(NSDictionary *_Nonnull backDataDic) {
        if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]] || [[backDataDic allKeys] containsObject:@"message"] || [[backDataDic allKeys] containsObject:@"err"]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        if (backData[@"err"] != nil) {
            [self getBiSaiData];
            return;
        }

        [[RBFMDBTool sharedFMDBTool]deleteTadayBiSaiModel];
        NSDictionary *dic = backData;
        NSArray *matchs = dic[@"matches"];
        NSDictionary *teams = dic[@"teams"];
        NSDictionary *events = dic[@"events"];
        NSDictionary *stages = dic[@"stages"];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (int i = 0; i < matchs.count; i++) {
            NSArray *arr = matchs[i];
            RBBiSaiModel *model = [RBBiSaiModel getBiSaiModelWithArray:arr andTeams:teams andEvents:events andStages:stages];
            model.index = i + 1;
            [mutArr addObject:model];
        }
        [[RBFMDBTool sharedFMDBTool] insertBiSaisUseTransaction:mutArr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"loadDataOver"];
                           [[NSUserDefaults standardUserDefaults]synchronize];
                       });
        // 删除四天前的数据
        [[RBFMDBTool sharedFMDBTool]deleteLongTimeBiSaiModel];
    } Fail:^(NSError *_Nonnull error) {
        [self getBiSaiData];
    }];
}

- (void)youkelogin {
    NSString *myId = [RBCreateID createMyIDInKeyCH];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:myId forKey:@"mac"];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/youkelogin"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)timerRun {
    [UIViewController getCurrentVC];
    NSMutableArray *scoreArr = [NSMutableArray array];
    [RBNetworkTool PostDataWithUrlStr:@"try/go/getfootballlive" andParam:@{} Success:^(NSDictionary *_Nonnull backDataDic) {
        if (backDataDic.allKeys.count == 0 || backDataDic == nil || [backDataDic isKindOfClass:[NSNull class]] || [[backDataDic allKeys] containsObject:@"message"] || [[backDataDic allKeys] containsObject:@"err"]) return;
        NSData *jsonData = [backDataDic[@"ok"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *backData = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
        NSArray *array = (NSArray *)backData;
        NSMutableArray *changeArr = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSArray *arr = array[i];
            NSArray *hostArr = arr[2];
            NSArray *visitArr = arr[3];
            RBBiSaiModel *biSaiModel = [[RBFMDBTool sharedFMDBTool]selectBiSaiModelWithNamiId:[arr[0]intValue]];
            RBBiSaiModel *tempModel = biSaiModel;
            if (tempModel.namiId != 0 && ([arr[1] intValue] == 2 || [arr[1] intValue] == 4) ) {
                if (tempModel.hostScore != [hostArr[0]intValue]) {
                    biSaiModel.hostScore = [hostArr[0] intValue];
                    biSaiModel.scoreType = 1;
                    [scoreArr addObject:biSaiModel];
                } else if (tempModel.visitingScore != [visitArr[0]intValue]) {
                    biSaiModel.visitingScore = [visitArr[0] intValue];
                    biSaiModel.scoreType = 2;
                    [scoreArr addObject:biSaiModel];
                }
            }
            if (biSaiModel.namiId != 0) {
                biSaiModel.status = [arr[1]intValue];
                biSaiModel.hostScore = [hostArr[0] intValue];
                biSaiModel.hostHalfScore = [hostArr[1] intValue];
                biSaiModel.hostRedCard = [hostArr[2] intValue];
                biSaiModel.hostYellowCard = [hostArr[3] intValue];
                biSaiModel.hostCorner = [hostArr[4]intValue];
                biSaiModel.visitingScore = [visitArr[0] intValue];
                biSaiModel.visitingHalfScore = [visitArr[1] intValue];
                biSaiModel.visitingRedCard = [visitArr[2] intValue];
                biSaiModel.visitingYellowCard = [visitArr[3] intValue];
                biSaiModel.visitingCorner = [visitArr[4]intValue];
                biSaiModel.TeeTime = [arr[4]intValue];
                [changeArr addObject:biSaiModel];
                [[RBFMDBTool sharedFMDBTool]updateBiSaiModel:biSaiModel];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gengxinBiSaiModels" object:changeArr];
        UIViewController *vc  = [UIViewController getCurrentVC];
        // 忘记密码，登录注册，聊天页面有进球弹进球
        if (![vc isKindOfClass:NSClassFromString(@"RBForggetPwdVC")] && ![vc isKindOfClass:NSClassFromString(@"RBLoginRegisterVC")] && ![vc isKindOfClass:NSClassFromString(@"RBRegisterVC")]) {
            if ([vc isKindOfClass:NSClassFromString(@"RBBiSaiDetailVC")]) {
                RBBiSaiDetailVC *detail = (RBBiSaiDetailVC *)vc;
                if (detail.index != 1) {
                    [RBJqView showJQWithArray:scoreArr];
                }
            } else {
                [RBJqView showJQWithArray:scoreArr];
            }
        }
    } Fail:^(NSError *_Nonnull error) {
    }];
}

- (void)clickCenterBtn:(RBTabBar *)tabBar {
    self.selectedIndex = 2;
    tabBar.centerButton.selected = YES;
    if (self.hasPlayed) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =  0; i <= 10; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"sleep_weak_%02d.png", i]]];
    }
    [tabBar.centerButton playingWithImgArr:arr andTime:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabBar.centerButton stopAnimation];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i =  0; i <= 20; i++) {
            [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"weak_%02d.png", i]]];
        }
        [tabBar.centerButton playingWithImgArr:arr andTime:2];
    });
    self.hasPlayed = YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([tabBar isKindOfClass:[RBTabBar class]]) {
        RBTabBar *bar = (RBTabBar *)tabBar;
        if (bar.centerButton.selected) {
            // 已经选了
            [bar.centerButton stopAnimation];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i =  0; i <= 10; i++) {
                [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"weak_sleep_%02d.png", i]]];
            }
            [bar.centerButton playingWithImgArr:arr andTime:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [bar.centerButton stopAnimation];
                NSMutableArray *arr = [NSMutableArray array];
                for (int i =  0; i <= 20; i++) {
                    [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"sleep_%02d.png", i]]];
                }
                [bar.centerButton playingWithImgArr:arr andTime:2];
            });
        }
        bar.centerButton.selected = NO;
        self.hasPlayed = NO;
    }
}

- (void)addChildWithName:(NSString *)childName andTitle:(NSString *)title andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage {
    // 根据控制器的名字创建控制器
    Class c = NSClassFromString(childName);
    UIViewController *child = [[c alloc]init];
    child.title = title;
    RBNavigationVC *nav = [[RBNavigationVC alloc]initWithRootViewController:child];
    if (![image isEqualToString:@""]) {
        nav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 禁用图片渲染
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    // 将nav 添加到tabbarController中
    [self addChildViewController:nav];
}

@end
