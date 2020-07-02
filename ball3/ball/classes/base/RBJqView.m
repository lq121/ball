#import "RBJqView.h"
#import <AVFoundation/AVFoundation.h>
#import "RBBiSaiModel.h"

@interface RBJqView ()
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *biSaiTime;
@property (nonatomic, strong) UILabel *hostName;
@property (nonatomic, strong) UILabel *visitName;
@property (nonatomic, strong) UIButton *tip;
@property (nonatomic, strong) UILabel *hostScore;
@property (nonatomic, strong) UILabel *visitScore;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
@end

@implementation RBJqView

- (instancetype)init {
    if (self = [super init]) {
        UIView *bgView = [[UIView alloc]init];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 8;
        bgView.backgroundColor = [UIColor colorWithSexadeString:@"#08990B"];
        self.bgView = bgView;
        [self addSubview:bgView];

        UILabel *biSaiTime = [[UILabel alloc]init];
        self.biSaiTime = biSaiTime;
        biSaiTime.textColor = [UIColor whiteColor];
        biSaiTime.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:biSaiTime];

        UILabel *hostName = [[UILabel alloc]init];
        hostName.textAlignment = NSTextAlignmentLeft;
        self.hostName = hostName;
        hostName.textColor = [UIColor whiteColor];
        hostName.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:hostName];

        UILabel *visitName = [[UILabel alloc]init];
        self.visitName = visitName;
        visitName.textAlignment = NSTextAlignmentLeft;
        visitName.textColor = [UIColor whiteColor];
        visitName.font = [UIFont systemFontOfSize:16];
        [visitName sizeToFit];
        [bgView addSubview:visitName];

        UIButton *tip = [[UIButton alloc]init];
        self.tip = tip;
        [tip setBackgroundImage:[UIImage imageNamed:@"tip"] forState:UIControlStateNormal];
        [tip setTitle:@"进球" forState:UIControlStateNormal];
        tip.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 2);
        [tip setTitleColor:[UIColor colorWithSexadeString:@"#FA7268"] forState:UIControlStateNormal];
        tip.titleLabel.font = [UIFont systemFontOfSize:12];
        tip.userInteractionEnabled = NO;
        [bgView addSubview:tip];

        UILabel *hostScore = [[UILabel alloc]init];
        self.hostScore = hostScore;
        hostScore.textColor = [UIColor whiteColor];
        hostScore.textAlignment = NSTextAlignmentRight;
        hostScore.font = [UIFont boldSystemFontOfSize:16];
        [bgView addSubview:hostScore];

        UILabel *visitScore = [[UILabel alloc]init];
        visitScore.textColor = [UIColor whiteColor];
        self.visitScore = visitScore;
        visitScore.textAlignment = NSTextAlignmentRight;
        visitScore.font = [UIFont boldSystemFontOfSize:16];
        [bgView addSubview:visitScore];

        UIImageView *animationView = [[UIImageView alloc]init];
        self.animationView = animationView;
        [self addSubview:animationView];
    }
    return self;
}

- (void)playVoice {
    /* 获取本地文件 */
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *urlString = [bundle pathForResource:@"jq" ofType:@"mp3"];
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:urlString];
    /* 初始化音频文件 */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.volume = 1;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    /* 加载缓冲 */
    [self.player prepareToPlay];
    [self.player play];
}

//结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

//解析错误调用
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    if (biSaiModel.status == 2) {
        // 上半场
        biSaiModel.TeeTimeStr = [NSString stringWithFormat:@"上半场 %@", @"34"];
    } else if (biSaiModel.status >= 4 && biSaiModel.status <= 7) {
        long timeCount =  30;
        if (timeCount + 45 > 90) {
            biSaiModel.TeeTimeStr = @"下半场 90+";
        } else {
            biSaiModel.TeeTimeStr = [NSString stringWithFormat:@"下半场 %ld", timeCount + 45];
        }
    }
    if (biSaiModel.TeeTimeStr.length > 4) {
        self.biSaiTime.text = [NSString stringWithFormat:@"%@'", [biSaiModel.TeeTimeStr substringFromIndex:4]];
    } else {
        self.biSaiTime.text = [NSString stringWithFormat:@"%@'", biSaiModel.TeeTimeStr];
    }
    self.hostName.text = biSaiModel.hostTeamName;
    self.visitName.text = biSaiModel.visitingTeamName;
    self.hostScore.text = [NSString stringWithFormat:@"%d", biSaiModel.hostScore];
    self.visitScore.text = [NSString stringWithFormat:@"%d", biSaiModel.visitingScore];
    if (biSaiModel.scoreType == 1) {
        self.visitName.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.visitScore.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.hostName.textColor = [UIColor whiteColor];
        self.hostScore.textColor = [UIColor whiteColor];
        self.tip.centerY = self.hostScore.centerY;
    } else {
        self.hostName.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.hostScore.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.visitName.textColor = [UIColor whiteColor];
        self.visitScore.textColor = [UIColor whiteColor];
        self.tip.centerY = self.visitScore.centerY;
    }
}

- (void)playAnimation {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =  2; i <= 38; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"jq_%02d.png", i]]];
    }
    [UIView animateWithDuration:0.75 animations:^{
        self.alpha = 1;             // 显示
    } completion:^(BOOL finished) {
        // 播放动画
        self.animationView.animationImages = arr;
        // 设置动画的播放次数
        self.animationView.animationRepeatCount = 1;
        // 设置播放时长
        self.animationView.animationDuration = 2;
        // 开始动画
        [self.animationView startAnimating];
        BOOL voiceOff = [[[NSUserDefaults standardUserDefaults]objectForKey:@"voiceOff"] boolValue];
        if (voiceOff == NO) {
            // 播放音频
            [self playVoice];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           [UIView animateWithDuration:0.75 animations:^{
                               self.alpha = 0;
                               [self removeFromSuperview];
                           }];
                       });
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.animationView.frame = CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height);
    self.bgView.frame = CGRectMake(16, 0, self.bounds.size.width - 32, self.bounds.size.height);

    CGSize hostSize = [self.hostScore.text getLineSizeWithBoldFontSize:16];
    CGSize visitSize = [self.visitScore.text getLineSizeWithBoldFontSize:16];
    self.biSaiTime.frame = CGRectMake(70, 25.5, 40, 22);
    self.hostName.frame = CGRectMake(110, 10, [self.hostName.text getLineSizeWithFontSize:16].width, 22);
    self.visitName.frame = CGRectMake(110, CGRectGetMaxY(self.hostName.frame) + 4, [self.visitName.text getLineSizeWithFontSize:16].width, 22);
    self.hostScore.frame = CGRectMake(RBScreenWidth - 41 - hostSize.width - 24, 10, hostSize.width + 8, 22);
    self.visitScore.frame = CGRectMake(RBScreenWidth - 41 - visitSize.width - 24, CGRectGetMaxY(self.hostScore.frame) + 4, visitSize.width + 8, 22);
    CGFloat width = MAX(hostSize.width, visitSize.width);
    self.tip.frame = CGRectMake(RBScreenWidth - 41 - width - 20 - 42, 0, 40, 20);
    if (self.biSaiModel.scoreType == 1) {
        self.tip.centerY = self.hostScore.centerY;
    } else {
        self.tip.centerY = self.visitScore.centerY;
    }
}

+ (void)showJQWithArray:(NSArray *)array {
    if (array == nil || array.count <= 0) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (@available(iOS 13.0, *)) {
        window = [UIApplication sharedApplication].windows[0];
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    for (int i = 0; i < array.count; i++) {
        RBBiSaiModel *biSaiModel = array[i];
        RBJqView *jqView = [[RBJqView alloc]init];
        CGFloat y = RBScreenHeight - 125 - RBBottomSafeH;
        CGFloat time = 0;
        if (i  % 2 != 0) {
            y = RBScreenHeight - 190 - RBBottomSafeH;
        }
        time = i / 2;
        jqView.frame = CGRectMake(0, y, RBScreenWidth, 60);
        jqView.biSaiModel = biSaiModel;
        jqView.alpha = 0;
        [window addSubview:jqView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [jqView playAnimation];
        });
    }
}

@end
