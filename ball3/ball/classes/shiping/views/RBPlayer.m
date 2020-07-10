#import "RBPlayer.h"
#import "RBSlider.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const barAnimateSpeed = 0.5f;
static CGFloat const barShowDuration = 5.0f;
static CGFloat const opacity = 0.7f;
static CGFloat const bottomBaHeight = 40.0f;
static CGFloat const playBtnSideLength = 60.0f;

@interface RBPlayer()
/**videoPlayer superView*/
@property (nonatomic, strong) UIView *playSuprView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UILabel *totalDurationLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) RBSlider *slider;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGRect playerOriginalFrame;
@property (nonatomic, strong) UIButton *zoomScreenBtn;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/**video player*/
@property (nonatomic, strong) AVPlayer *player;
/**video total duration*/
@property (nonatomic, assign) CGFloat totalDuration;
@property (nonatomic, assign) CGFloat current;
@property (nonatomic, strong) UITableView *bindTableView;
@property (nonatomic, assign) CGRect currentPlayCellRect;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) BOOL isOriginalFrame;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) BOOL barHiden;
@property (nonatomic, assign) BOOL inOperation;
@property (nonatomic, assign) BOOL smallWinPlaying;
@property(nonatomic,assign)int type;
@end

@implementation RBPlayer
- (instancetype)init {
    if (self = [super init]) {
        self.keyWindow = [UIApplication sharedApplication].keyWindow;

        //screen orientation change
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        //show or hiden gestureRecognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHidenBar)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appwillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.totalDuration = 0;
        self.barHiden = YES;
    }
    return self;
}

-(void)setShiPingUrl:(NSString *)shipingUrl andType:(int)type{
    _shipingUrl = shipingUrl;
    self.type = type;
    [self.layer addSublayer:self.playerLayer];
    [self insertSubview:self.activityIndicatorView belowSubview:self.playOrPauseBtn];
    [self.activityIndicatorView startAnimating];
    //play from start
    [self playOrPause:self.playOrPauseBtn];
    [self addSubview:self.bottomBar];
    [self insertSubview:self.playOrPauseBtn aboveSubview:self.activityIndicatorView];
}


- (void)playPause {
    [self playOrPause:self.playOrPauseBtn];
}

-(void)pause{
    self.player.rate = 1;
    [self playPause];
}

- (void)destroyPlayer {
    [self.player pause];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.slider removeFromSuperview];
    self.slider = nil;
    [self removeFromSuperview];
}

- (void)playerBindTableView:(UITableView *)bindTableView currentIndexPath:(NSIndexPath *)currentIndexPath {
    self.bindTableView = bindTableView;
    self.currentIndexPath = currentIndexPath;
}

- (void)playerScrollIsSupportSmallWindowPlay:(BOOL)support {
    self.currentPlayCellRect = [self.bindTableView rectForRowAtIndexPath:self.currentIndexPath];
    self.currentIndexPath = self.currentIndexPath;

    CGFloat cellBottom = self.currentPlayCellRect.origin.y + self.currentPlayCellRect.size.height;
    CGFloat cellUp = self.currentPlayCellRect.origin.y;

    if (self.bindTableView.contentOffset.y > cellBottom) {
        if (!support) {
            [self destroyPlayer];
            return;
        }
        [self smallWindowPlay];
        return;
    }

    if (cellUp > self.bindTableView.contentOffset.y + self.bindTableView.frame.size.height) {
        if (!support) {
            [self destroyPlayer];
            return;
        }
        [self smallWindowPlay];
        return;
    }

    if (self.bindTableView.contentOffset.y < cellBottom) {
        if (!support) return;
        [self returnToOriginView];
        return;
    }

    if (cellUp < self.bindTableView.contentOffset.y + self.bindTableView.frame.size.height) {
        if (!support) return;
        [self returnToOriginView];
        return;
    }
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    if (!self.isOriginalFrame) {
        self.playerOriginalFrame = self.frame;
        self.playSuprView = self.superview;
        self.bottomBar.frame = CGRectMake(0, self.playerOriginalFrame.size.height - bottomBaHeight, self.self.playerOriginalFrame.size.width, bottomBaHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.playerOriginalFrame.size.width - playBtnSideLength) / 2, (self.playerOriginalFrame.size.height - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
        self.activityIndicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2);
        self.isOriginalFrame = YES;
    }
}

#pragma mark - Screen Orientation

- (void)statusBarOrientationChange:(NSNotification *)notification {
    if (self.smallWinPlaying) return;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        [self orientationLeftFullScreen];
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        [self orientationRightFullScreen];
    } else if (orientation == UIDeviceOrientationPortrait) {
        [self smallScreen];
    }
}

- (void)actionFullScreen {
    if (!self.isFullScreen) {
        [self orientationLeftFullScreen];
    } else {
        UIButton *backBtn = [[UIApplication sharedApplication].keyWindow viewWithTag:1111];
        UIButton *shareBtn = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
        UIButton *attentionBtn = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:backBtn];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:shareBtn];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:attentionBtn];
        [self smallScreen];
    }
}

- (void)orientationLeftFullScreen {
    self.isFullScreen = YES;
    self.zoomScreenBtn.selected = YES;
    [self.keyWindow addSubview:self];

    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = self.keyWindow.bounds;
        self.bottomBar.frame = CGRectMake(0, self.keyWindow.bounds.size.width - bottomBaHeight, self.keyWindow.bounds.size.height, bottomBaHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.keyWindow.bounds.size.height - playBtnSideLength) / 2, (self.keyWindow.bounds.size.width - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
        self.activityIndicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    }];
}

- (void)orientationRightFullScreen {
    self.isFullScreen = YES;
    self.zoomScreenBtn.selected = YES;
    [self.keyWindow addSubview:self];

    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];

    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.frame = self.keyWindow.bounds;
        self.bottomBar.frame = CGRectMake(0, self.keyWindow.bounds.size.width - bottomBaHeight, self.keyWindow.bounds.size.height, bottomBaHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.keyWindow.bounds.size.height - playBtnSideLength) / 2, (self.keyWindow.bounds.size.width - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
        self.activityIndicatorView.center = CGPointMake(self.keyWindow.bounds.size.height / 2, self.keyWindow.bounds.size.width / 2);
    }];
}

- (void)smallScreen {
    self.isFullScreen = NO;
    self.zoomScreenBtn.selected = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];

    if (self.bindTableView) {
        UITableViewCell *cell = [self.bindTableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell.contentView addSubview:self];
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        CGRect temp;
        if (!self.bindTableView) {
            if (RB_iPhoneX) {
                temp= CGRectMake(0, 0, self.playerOriginalFrame.size.width, self.playerOriginalFrame.size.height);
            }else{
                 temp= CGRectMake(0, -RBStatusBarH, self.playerOriginalFrame.size.width, self.playerOriginalFrame.size.height);
            }
        }else{
           temp= CGRectMake(0, 0, self.playerOriginalFrame.size.width, self.playerOriginalFrame.size.height);
        }
         
        self.playerOriginalFrame = temp;
        self.frame =  self.playerOriginalFrame;
        self.bottomBar.frame = CGRectMake(0, self.playerOriginalFrame.size.height - bottomBaHeight, self.self.playerOriginalFrame.size.width, bottomBaHeight);
        self.playOrPauseBtn.frame = CGRectMake((self.playerOriginalFrame.size.width - playBtnSideLength) / 2, (self.playerOriginalFrame.size.height - playBtnSideLength) / 2, playBtnSideLength, playBtnSideLength);
        self.activityIndicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2);
        [self updateConstraintsIfNeeded];
    }];
}

#pragma mark - app notif
- (void)appwillResignActive:(NSNotification *)note {
    self.player.rate = 1.0f;
    [self playOrPause:self.playOrPauseBtn];
}

- (void)appBecomeActive:(NSNotification *)note {

}

#pragma mark - button action

- (void)playOrPause:(UIButton *)btn {
    if (self.player.rate == 0.0) {     //pause
        btn.selected = YES;
        [self.player play];
    } else if (self.player.rate == 1.0f) { //playing
        [self.player pause];
        btn.selected = NO;
    }
}

- (void)showOrHidenBar {
    if (self.barHiden) {
        [self show];
    } else {
        [self hiden];
    }
}

- (void)show {
    [UIView animateWithDuration:barAnimateSpeed animations:^{
        self.bottomBar.layer.opacity = opacity;
        self.playOrPauseBtn.layer.opacity = opacity;
    } completion:^(BOOL finished) {
        if (finished) {
            self.barHiden = !self.barHiden;
            [self performBlock:^{
                if (!self.barHiden && !self.inOperation) {
                    [self hiden];
                }
            } afterDelay:barShowDuration];
        }
    }];
}

- (void)hiden {
    self.inOperation = NO;
    [UIView animateWithDuration:barAnimateSpeed animations:^{
        self.bottomBar.layer.opacity = 0.0f;
        self.playOrPauseBtn.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.barHiden = !self.barHiden;
        }
    }];
}

#pragma mark - call back

- (void)sliderValueChange:(RBSlider *)slider {
    self.progressLabel.text = [self timeFormatted:slider.value * self.totalDuration];
}

- (void)finishChange {
    self.inOperation = NO;
    [self performBlock:^{
        if (!self.barHiden && !self.inOperation) {
            [self hiden];
        }
    } afterDelay:barShowDuration];

    [self.player pause];

    CMTime currentCMTime = CMTimeMake(self.slider.value * self.totalDuration, 1);
    if (self.slider.middleValue) {
        [self.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
            [self.player play];
            self.playOrPauseBtn.selected = YES;
        }];
    }
}

//Dragging the thumb to suspend video playback

- (void)dragSlider {
    self.inOperation = YES;
    [self.player pause];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(callBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)callBlockAfterDelay:(void (^)(void))block {
    block();
}

#pragma mark - monitor video playing course

- (void)addProgressObserver {
    //get current playerItem object
    AVPlayerItem *playerItem = self.player.currentItem;
    __weak typeof(self) weakSelf = self;

    //Set once per second
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1f, NSEC_PER_SEC)  queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        weakSelf.current = current;
        float total = CMTimeGetSeconds([playerItem duration]);
        weakSelf.progressLabel.text = [weakSelf timeFormatted:current];
        if (current) {
            if (!weakSelf.inOperation) {
                weakSelf.slider.value = current / total;
            }
            if (weakSelf.slider.value == 1.0f) {      //complete block
                if (weakSelf.playingOverBlock) {
                    if (weakSelf.playingOverBlock) {
                        weakSelf.playingOverBlock(weakSelf);
                    }
                    weakSelf.playingOverBlock = nil;
                } else {
                    weakSelf.playOrPauseBtn.selected = NO;
                    [weakSelf showOrHidenBar];
                    CMTime currentCMTime = CMTimeMake(0, 1);
                    [weakSelf.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
                        weakSelf.slider.value = 0.0f;
                    }];
                }
            }
        }
    }];
}

#pragma mark - PlayerItem （status，loadedTimeRanges）

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //network loading progress
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  通过KVO监控播放器状态
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            self.totalDuration = CMTimeGetSeconds(playerItem.duration);
            self.totalDurationLabel.text = [self timeFormatted:self.totalDuration];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        self.slider.middleValue = totalBuffer / CMTimeGetSeconds(playerItem.duration);

        //loading animation
        if (self.slider.middleValue  <= self.slider.value || (totalBuffer - 1.0) < self.current) {
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
        } else {
            self.activityIndicatorView.hidden = YES;
            if (self.playOrPauseBtn.selected) {
                [self.player play];
            }
        }
    }
}

#pragma mark - timeFormat

- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - animation smallWindowPlay

- (void)smallWindowPlay {
    if ([self.superview isKindOfClass:[UIWindow class]]) return;
    self.smallWinPlaying = YES;
    self.playOrPauseBtn.hidden = YES;
    self.bottomBar.hidden = YES;

    CGRect tableViewframe = [self.bindTableView convertRect:self.bindTableView.bounds toView:self.keyWindow];
    self.frame = [self convertRect:self.frame toView:self.keyWindow];
    [self.keyWindow addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        CGFloat w = self.playerOriginalFrame.size.width * 0.5;
        CGFloat h = self.playerOriginalFrame.size.height * 0.5;
        CGRect smallFrame = CGRectMake(tableViewframe.origin.x + tableViewframe.size.width - w, tableViewframe.origin.y + tableViewframe.size.height - h, w, h);
        self.frame = smallFrame;
        self.playerLayer.frame = self.bounds;
        self.activityIndicatorView.center = CGPointMake(w / 2.0, h / 2.0);
    }];
}

- (void)returnToOriginView {
    self.smallWinPlaying = NO;
    self.playOrPauseBtn.hidden = NO;
    self.bottomBar.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(self.currentPlayCellRect.origin.x, self.currentPlayCellRect.origin.y, self.playerOriginalFrame.size.width, self.playerOriginalFrame.size.height);
        self.playerLayer.frame = self.bounds;
        self.activityIndicatorView.center = CGPointMake(self.playerOriginalFrame.size.width / 2, self.playerOriginalFrame.size.height / 2);
    } completion:^(BOOL finished) {
        self.frame = self.playerOriginalFrame;
        UITableViewCell *cell = [self.bindTableView cellForRowAtIndexPath:self.currentIndexPath];
        [cell.contentView addSubview:self];
    }];
}

#pragma mark - lazy loading

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [self getAVPlayItem];
        self.playerItem = playerItem;
        _player = [AVPlayer playerWithPlayerItem:playerItem];

        [self addProgressObserver];

        [self addObserverToPlayerItem:playerItem];

        // 解决8.1系统播放无声音问题，8.0、9.0以上未发现此问题
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
    }
    return _player;
}

- (AVPlayerItem *)getAVPlayItem {
    NSAssert(self.shipingUrl != nil, @"必须先传入视频url！！！");

    if ([self.shipingUrl rangeOfString:@"http"].location != NSNotFound) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.shipingUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        return playerItem;
    } else {
        AVAsset *movieAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.shipingUrl] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        return playerItem;
    }
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self insertSubview:_activityIndicatorView aboveSubview:self.playOrPauseBtn];
    }
    return _activityIndicatorView;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [UIColor blackColor];
        _bottomBar.layer.opacity = 0.0f;

        UILabel *label1 = [[UILabel alloc] init];
        label1.translatesAutoresizingMaskIntoConstraints = NO;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"00:00:00";
        label1.font = [UIFont systemFontOfSize:12.0f];
        label1.textColor = [UIColor whiteColor];
        [_bottomBar addSubview:label1];
        self.progressLabel = label1;

        NSLayoutConstraint *label1Left = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Top = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Bottom = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        NSLayoutConstraint *label1Width = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65];
        [_bottomBar addConstraints:@[label1Left, label1Top, label1Bottom, label1Width]];

        UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullScreenBtn.translatesAutoresizingMaskIntoConstraints = NO;
        fullScreenBtn.contentMode = UIViewContentModeCenter;
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_zoom_out"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_zoom_out"] forState:UIControlStateSelected];
        [fullScreenBtn addTarget:self action:@selector(actionFullScreen) forControlEvents:UIControlEventTouchDown];
        [_bottomBar addSubview:fullScreenBtn];
        self.zoomScreenBtn = fullScreenBtn;
        CGFloat width = 0;
        if (self.type == 1|| self.type==3) {
            width = 40.0;
        }
        NSLayoutConstraint *btnWidth = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:width];
        NSLayoutConstraint *btnHeight = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:40.0f];
        NSLayoutConstraint *btnRight = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        NSLayoutConstraint *btnCenterY = [NSLayoutConstraint constraintWithItem:fullScreenBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        [_bottomBar addConstraints:@[btnWidth, btnHeight, btnRight, btnCenterY]];

        UILabel *label2 = [[UILabel alloc] init];
        label2.translatesAutoresizingMaskIntoConstraints = NO;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"00:00:00";
        label2.font = [UIFont systemFontOfSize:12.0f];
        label2.textColor = [UIColor whiteColor];
        [_bottomBar addSubview:label2];
        self.totalDurationLabel = label2;

        NSLayoutConstraint *label2Right = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:fullScreenBtn attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        NSLayoutConstraint *label2Top = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        NSLayoutConstraint *label2Bottom = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        NSLayoutConstraint *label2Width = [NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:65.0f];
        [_bottomBar addConstraints:@[label2Right, label2Top, label2Bottom, label2Width]];

        RBSlider *slider = [[RBSlider alloc] init];
        slider.value = 0.0f;
        slider.middleValue = 0.0f;
        slider.sliderColor = [UIColor whiteColor];
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomBar addSubview:slider];
        self.slider = slider;
        __weak typeof(self) weakSelf = self;
        slider.valueChangeBlock = ^(RBSlider *slider) {
            [weakSelf sliderValueChange:slider];
        };
        slider.finishChangeBlock = ^(RBSlider *slider) {
            [weakSelf finishChange];
        };
        slider.draggingSliderBlock = ^(RBSlider *slider) {
            [weakSelf dragSlider];
        };

        NSLayoutConstraint *sliderLeft = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        sliderLeft.priority = UILayoutPriorityDefaultLow;
        NSLayoutConstraint *sliderRight = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
        NSLayoutConstraint *sliderTop = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        NSLayoutConstraint *sliderBottom = [NSLayoutConstraint constraintWithItem:slider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bottomBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [_bottomBar addConstraints:@[sliderLeft, sliderRight, sliderTop, sliderBottom]];
        if(self.type == 3){
            slider.hidden = YES;
            label1.hidden = YES;
            label2.hidden = YES;
        }

        [self updateConstraintsIfNeeded];
    }
    return _bottomBar;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.layer.opacity = 0.0f;
        _playOrPauseBtn.contentMode = UIViewContentModeCenter;
        [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"btn／action"] forState:UIControlStateNormal];
        [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"btn／stop"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchDown];
    }
    return _playOrPauseBtn;
}

#pragma mark - dealloc

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


@end
