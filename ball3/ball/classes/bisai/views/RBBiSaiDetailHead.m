#import "RBBiSaiDetailHead.h"
#import "RBChekLogin.h"
#import "UIButton+WebCache.h"

typedef void (^ClickBtnIndex)(int index);

@interface RBBiSaiDetailHead ()
@property (nonatomic, strong) UILabel *teamLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *biSaiTimeLabel;
@property (nonatomic, strong) UIButton *team1;
@property (nonatomic, strong) UILabel *team1Label;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIButton *team2;
@property (nonatomic, strong) UILabel *team2Label;
@property (nonatomic, strong) UILabel *biSaiTimeLabel2;
@property (nonatomic, strong) UIButton *team12;
@property (nonatomic, strong) UILabel *scoreLabel1;
@property (nonatomic, strong) UILabel *scoreLabel2;
@property (nonatomic, strong) UIButton *team22;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIImageView *BGView;
@property (nonatomic, assign) int index;
@property (nonatomic, copy) ClickBtnIndex clickBtnIndex;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RBBiSaiDetailHead

- (instancetype)initWithFrame:(CGRect)frame andIndex:(int)index andClickBtn:(void (^)(int index))clickIndex {
    if (self = [super initWithFrame:frame]) {
        self.clickBtnIndex = clickIndex;
        self.index = index;

        UIImageView *BGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"game bg"]];
        self.BGView = BGView;
        BGView.userInteractionEnabled = YES;
        [self addSubview:BGView];

        UIView *bigView = [[UIView alloc]init];
        self.bigView = bigView;
        [self addSubview:bigView];

        UIView *smallView = [[UIView alloc]init];
        self.smallView = smallView;
        smallView.hidden = YES;
        [self addSubview:smallView];

        UILabel *teamLabel = [[UILabel alloc]init];
        self.teamLabel = teamLabel;
        teamLabel.textAlignment = NSTextAlignmentCenter;
        teamLabel.textColor = [UIColor whiteColor];
        teamLabel.font = [UIFont systemFontOfSize:14];
        [bigView addSubview:teamLabel];

        UILabel *timeLabel = [[UILabel alloc]init];
        self.timeLabel = timeLabel;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [bigView addSubview:timeLabel];

        UILabel *biSaiTimeLabel = [[UILabel alloc]init];
        self.biSaiTimeLabel = biSaiTimeLabel;
        biSaiTimeLabel.textColor = [UIColor whiteColor];
        biSaiTimeLabel.font = [UIFont systemFontOfSize:12];
        [bigView addSubview:biSaiTimeLabel];

        UIButton *team1 = [[UIButton alloc]init];
        self.team1 = team1;
        [team1 setImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        team1.layer.masksToBounds = YES;
        team1.layer.cornerRadius = 30;
        [bigView addSubview:team1];

        UILabel *team1Label = [[UILabel alloc]init];
        self.team1Label = team1Label;
        team1Label.textAlignment = NSTextAlignmentCenter;
        team1Label.textColor = [UIColor whiteColor];
        team1Label.font = [UIFont systemFontOfSize:14];
        [bigView addSubview:team1Label];

        UILabel *scoreLabel = [[UILabel alloc]init];
        self.scoreLabel = scoreLabel;
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.textColor = [UIColor whiteColor];
        scoreLabel.text = @"VS";
        scoreLabel.font = [UIFont boldSystemFontOfSize:22];
        [bigView addSubview:scoreLabel];

        UIButton *team2 = [[UIButton alloc]init];
        self.team2 = team2;
        [team2 setImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        team2.layer.masksToBounds = YES;
        team2.layer.cornerRadius = 30;
        [bigView addSubview:team2];

        UILabel *team2Label = [[UILabel alloc]init];
        self.team2Label = team2Label;
        team2Label.textAlignment = NSTextAlignmentCenter;
        team2Label.textColor = [UIColor whiteColor];
        team2Label.font = [UIFont systemFontOfSize:14];
        [bigView addSubview:team2Label];

        UILabel *biSaiTimeLabel2 = [[UILabel alloc]init];
        self.biSaiTimeLabel2 = biSaiTimeLabel2;
        biSaiTimeLabel2.textColor = [UIColor whiteColor];
        biSaiTimeLabel2.font = [UIFont systemFontOfSize:12];
        [smallView addSubview:biSaiTimeLabel2];

        UIButton *team12 = [[UIButton alloc]init];
        self.team12 = team12;
        [team12 setImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        team12.layer.masksToBounds = YES;
        team12.layer.cornerRadius = 16;
        [smallView addSubview:team12];

        UILabel *scoreLabel1 = [[UILabel alloc]init];
        self.scoreLabel1 = scoreLabel1;
        scoreLabel1.textAlignment = NSTextAlignmentCenter;
        scoreLabel1.textColor = [UIColor whiteColor];
        scoreLabel1.text = @"0";
        scoreLabel1.font = [UIFont boldSystemFontOfSize:22];
        [smallView addSubview:scoreLabel1];

        UILabel *scoreLabel2 = [[UILabel alloc]init];
        self.scoreLabel2 = scoreLabel2;
        scoreLabel2.textAlignment = NSTextAlignmentCenter;
        scoreLabel2.textColor = [UIColor whiteColor];
        scoreLabel2.text = @"0";
        scoreLabel2.font = [UIFont boldSystemFontOfSize:22];
        [smallView addSubview:scoreLabel2];

        UIButton *team22 = [[UIButton alloc]init];
        self.team22 = team22;
        [team22 setImage:[UIImage imageNamed:@"user pic"] forState:UIControlStateNormal];
        team22.layer.masksToBounds = YES;
        team22.layer.cornerRadius = 16;
        [smallView addSubview:team22];

        NSArray *titles = @[@"直播", @"聊天", @"小应预测", @"分析", @"会员"];
        UIView *selectView = [[UIView alloc]init];
        self.selectView = selectView;
        [self addSubview:self.selectView];
        selectView.backgroundColor = [UIColor whiteColor];
        selectView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.04].CGColor;
        selectView.layer.shadowOffset = CGSizeMake(0, 2);
        selectView.layer.shadowOpacity = 1;
        selectView.layer.shadowRadius = 10;
        CGFloat width = (RBScreenWidth - 162) / (titles.count - 1);
        CGFloat heigth = 44;
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [[UIButton alloc]init];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [selectView addSubview:btn];
            [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333" AndAlpha:0.6] forState:UIControlStateNormal];

            btn.tag = 200 + i;
            [btn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 2) {
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                btn.frame = CGRectMake(RBScreenWidth * 0.5 - 65, 0, 130, 38);
                [btn setBackgroundImage:[UIImage imageNamed:@"yuce_normal"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"yuce_selected"] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else if (i < 2) {
                btn.frame = CGRectMake(16 + i * width, 0, width, heigth);
            } else if (i > 2) {
                btn.frame = CGRectMake(RBScreenWidth - 16 - (titles.count - i) * width, 0, width, heigth);
            }
            if (i == 0 || i == 3) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            } else if (i == 1 || i == 4) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }

        self.indicateView = [[UIView alloc]init];
        self.indicateView.hidden = YES;
        self.indicateView.backgroundColor = [UIColor colorWithSexadeString:@"#36C8B9"];
        [selectView addSubview:self.indicateView];
        [self clickIndex:index];
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:1 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)clickIndex:(int)index {
    UIButton *btn = [self.selectView viewWithTag:200 + index];
    [self clickCheckBtn:btn];
}

- (void)clickCheckBtn:(UIButton *)btn {
    if (btn == self.checkBtn) {
        return;
    }
    self.checkBtn.selected = NO;
    btn.selected = YES;
    self.checkBtn = btn;
    UIView *chatToolBar = [[UIApplication sharedApplication].keyWindow viewWithTag:5001];
    if (btn.tag != 201) {
        // 删除发送礼物view
        UIView *sendView = [[UIApplication sharedApplication].keyWindow viewWithTag:999];
        if (sendView != nil) {
            [sendView removeFromSuperview];
        }
        if (chatToolBar != nil) {
            chatToolBar.hidden = YES;
        }
    } else {
        if (chatToolBar != nil) {
            chatToolBar.hidden = NO;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickfirstToolBarBtn" object:@(btn.tag)];
    self.indicateView.hidden = (btn.tag == 202);
    [UIView animateWithDuration:durationTime animations:^{
        if (btn.tag - 200 == 0 || btn.tag - 200 == 3) {
            self.indicateView.x = self.checkBtn.x;
        } else if (btn.tag - 200 == 1 || btn.tag - 200  == 4) {
            self.indicateView.x = self.checkBtn.x + self.checkBtn.width - self.indicateView.width;
        }
    }];
    int index = (int)btn.tag - 200;
    self.bigView.hidden = NO;
    self.smallView.hidden = YES;
    UIButton *btn2 = [[UIApplication sharedApplication].keyWindow viewWithTag:888];
    if (btn2 != nil) {
        btn2.hidden = NO;
    }
    UIButton *btn3 = [[UIApplication sharedApplication].keyWindow viewWithTag:777];
    if (btn3 != nil) {
        btn3.hidden = (self.biSaiModel.status == 8);
    }
    self.clickBtnIndex(index);
    if (index != 0 && index != 3) {
        [RBChekLogin CheckLogin];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.BGView.frame = CGRectMake(0, -RBStatusBarH, RBScreenWidth, self.height  - 44 + RBStatusBarH);
    NSString *str = self.biSaiTimeLabel.text;
    if (self.biSaiModel.status == 2 || self.biSaiModel.status == 4) {
        if (![str containsString:@"'"]) {
            str = [NSString stringWithFormat:@"%@'", str];
        }
    }
    CGSize size = [str getLineSizeWithFontSize:12];
    if (RB_iPhoneX) {
        self.teamLabel.frame = CGRectMake(75, 5 - RBStatusBarH, RBScreenWidth - 150, 20);
    } else {
        self.teamLabel.frame = CGRectMake(75, 5, RBScreenWidth - 150, 20);
    }
    self.timeLabel.frame = CGRectMake(75, CGRectGetMaxY(self.teamLabel.frame), RBScreenWidth - 150, 20);
    if (self.biSaiModel.status != 2 && self.biSaiModel.status != 4) {
        self.biSaiTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLabel2.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLabel2.frame = CGRectMake((RBScreenWidth - size.width - 8) * 0.5, RBNavBarAndStatusBarH - 29, size.width + 8, 14);
        self.biSaiTimeLabel.frame = CGRectMake((RBScreenWidth - size.width - 8) * 0.5, CGRectGetMaxY(self.timeLabel.frame) + 29, size.width + 8, 14);
    } else {
        self.biSaiTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.biSaiTimeLabel2.textAlignment = NSTextAlignmentLeft;
        self.biSaiTimeLabel.frame = CGRectMake((RBScreenWidth - size.width) * 0.5, CGRectGetMaxY(self.timeLabel.frame) + 29, size.width, 14);
        self.biSaiTimeLabel2.frame = CGRectMake((RBScreenWidth - size.width) * 0.5, RBNavBarAndStatusBarH - 29, size.width, 14);
    }
    self.scoreLabel.frame = CGRectMake((RBScreenWidth - 50) * 0.5, CGRectGetMaxY(self.timeLabel.frame) + 49, 50, 27);
    self.team1.frame = CGRectMake((RBScreenWidth * 0.5 - 25 - 60) * 0.5, CGRectGetMaxY(self.timeLabel.frame) + 28, 60, 60);
    self.team2.frame = CGRectMake((RBScreenWidth * 0.5 + 25 - 60) * 0.5 + RBScreenWidth * 0.5, CGRectGetMaxY(self.timeLabel.frame) + 28, 60, 60);
    self.team1Label.frame = CGRectMake(100, CGRectGetMaxY(self.team1.frame) + 4, 180, 20);
    self.team2Label.frame = CGRectMake(100, CGRectGetMaxY(self.team1.frame) + 4, 180, 20);
    self.team1Label.centerX = self.team1.centerX;
    self.team2Label.centerX = self.team2.centerX;
    self.bigView.frame = CGRectMake(0, RBStatusBarH, RBScreenWidth, self.height  - 44);

    self.smallView.frame = CGRectMake(0, self.height - RBNavBarAndStatusBarH * 2 + RBStatusBarH, RBScreenWidth, RBNavBarAndStatusBarH);
    if (RB_iPhoneX) {
        self.team12.frame = CGRectMake(66, RBNavBarAndStatusBarH - 40, 32, 32);
        self.team22.frame = CGRectMake(RBScreenWidth - 66 - 32, RBNavBarAndStatusBarH - 40, 32, 32);
        self.scoreLabel1.frame = CGRectMake(CGRectGetMaxX(self.team12.frame) + 16, RBNavBarAndStatusBarH - 39, 30, 30);
        self.scoreLabel2.frame = CGRectMake(RBScreenWidth - 66 - 32 - 46, RBNavBarAndStatusBarH - 39, 30, 30);
    } else {
        self.team12.frame = CGRectMake(66, RBNavBarAndStatusBarH - 40, 32, 32);
        self.team22.frame = CGRectMake(RBScreenWidth - 66 - 32, RBNavBarAndStatusBarH - 40, 32, 32);
        self.scoreLabel1.frame = CGRectMake(CGRectGetMaxX(self.team12.frame) + 16, RBNavBarAndStatusBarH - 39, 30, 30);
        self.scoreLabel2.frame = CGRectMake(RBScreenWidth - 66 - 32 - 46, RBNavBarAndStatusBarH - 39, 30, 30);
    }

    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.BGView.frame), RBScreenWidth, 44);
    self.indicateView.frame = CGRectMake(16, 40, 28, 4);
    if (self.checkBtn.tag - 200 == 0 || self.checkBtn.tag - 200 == 3) {
        self.indicateView.x = self.checkBtn.x;
    } else if (self.checkBtn.tag - 200 == 1 || self.checkBtn.tag - 200  == 4) {
        self.indicateView.x = self.checkBtn.x + self.checkBtn.width - self.indicateView.width;
    }
}

- (void)timerRun {
    self.show = !self.show;
    NSString *str = [[NSString alloc]init];
    if (self.biSaiModel.status == 2 || self.biSaiModel.status == 4) {
        if (self.biSaiModel.status   == 2) {
            str = [NSString stringWithFormat:@"上半场 %@", [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:self.biSaiModel.TeeTime]];
        }
        if (self.biSaiModel.status   >= 4 && self.biSaiModel.status   <= 7) {
            long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:self.biSaiModel.TeeTime] longLongValue];
            if (timeCount + 45 > 90) {
                str = @"下半场 90+";
            } else {
                str = [NSString stringWithFormat:@"下半场 %ld", timeCount + 45];
            }
        }
        if (self.show) {
            if (![str containsString:@"'"]) {
                self.biSaiTimeLabel.text = [NSString stringWithFormat:@"%@'", str];
                self.biSaiTimeLabel2.text = [NSString stringWithFormat:@"%@'", str];
            }
        } else {
            if ([str containsString:@"'"]) {
                str = [str substringToIndex:str.length - 1];
            }
            self.biSaiTimeLabel.text = [NSString stringWithFormat:@"%@", str];
            self.biSaiTimeLabel2.text = [NSString stringWithFormat:@"%@", str];
        }
        if (![str containsString:@"'"]) {
            str = [NSString stringWithFormat:@"%@'", str];
        }
        CGSize size = [str getLineSizeWithFontSize:12];
        self.biSaiTimeLabel.x = (RBScreenWidth - size.width) * 0.5;
        self.biSaiTimeLabel2.x = (RBScreenWidth - size.width) * 0.5;
        self.biSaiTimeLabel.width = size.width;
        self.biSaiTimeLabel2.width = size.width;
    }
}

- (void)setBiSaiModel:(RBBiSaiModel *)biSaiModel {
    _biSaiModel = biSaiModel;
    if (biSaiModel == nil) {
        return;
    }
    self.biSaiTimeLabel.backgroundColor = [UIColor clearColor];
    if (biSaiModel.status <= 7 && biSaiModel.status >= 1 && self.index == 0) {
        // 比赛中进直播
        UIButton *btn = [self.selectView viewWithTag:200];
        [self clickCheckBtn:btn];
    }
    self.teamLabel.text = self.biSaiModel.eventLongName;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            [self.team1 setImage:image forState:UIControlStateNormal];
        } else {
            [self.team1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            [self.team2 setImage:image forState:UIControlStateNormal];
        } else {
            [self.team2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];

    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            [self.team12 setImage:image forState:UIControlStateNormal];
        } else {
            [self.team12 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.hostLogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];
    [manager.imageCache queryImageForKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo] options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
        if (image != nil) {
            [self.team22 setImage:image forState:UIControlStateNormal];
        } else {
            [self.team22 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user pic"] completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                if (image != nil) {
                    [manager.imageCache storeImage:image imageData:nil forKey:[NSString stringWithFormat:@"%@%@", IMAGETEAMBASEURL, self.biSaiModel.visitingLogo] cacheType:SDImageCacheTypeDisk completion:nil];
                }
            }];
        }
    }];

    self.team1Label.text = self.biSaiModel.hostTeamName;
    self.team2Label.text = self.biSaiModel.visitingTeamName;
    self.timeLabel.text = [NSString getStrWithDateInt:self.biSaiModel.biSaiTime andFormat:@"yyyy年MM月dd日 HH:mm"];
    if (self.biSaiModel.status <= 8 && self.biSaiModel.status  > 1) {
        // 已比赛
        self.scoreLabel.text = [NSString stringWithFormat:@"%d : %d", self.biSaiModel.hostScore, self.biSaiModel.visitingScore];
        self.scoreLabel1.text = [NSString stringWithFormat:@"%d", self.biSaiModel.hostScore];
        self.scoreLabel2.text = [NSString stringWithFormat:@"%d", self.biSaiModel.visitingScore];
    } else {
        self.scoreLabel.text = @"VS";
        self.scoreLabel1.text = @"0";
        self.scoreLabel2.text = @"0";
    }
    NSString *str = [[NSString alloc]init];
    if (self.biSaiModel.status == 3) {
        str =  @"中";
    } else if (self.biSaiModel.status == 8) {
        str =  @"完";
    } else if (self.biSaiModel.status == 1) {
        str =  @"未";
    } else if (self.biSaiModel.status == 2 || self.biSaiModel.status == 4) {
        if (self.biSaiModel.status   == 2) {
            str = [NSString stringWithFormat:@"上半场 %@", [NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:self.biSaiModel.TeeTime]];
        }
        if (self.biSaiModel.status   >= 4 && self.biSaiModel.status   <= 7) {
            long timeCount =  (long)[[NSString comperTime:[[NSDate date] timeIntervalSince1970] andToTime:biSaiModel.TeeTime] longLongValue];
            if (timeCount + 45 > 90) {
                str = @"下半场 90+";
            } else {
                str = [NSString stringWithFormat:@"下半场 %ld", timeCount + 45];
            }
        }
        if (self.show) {
            if (![str containsString:@"'"]) {
                self.biSaiTimeLabel.text = [NSString stringWithFormat:@"%@'", str];
                self.biSaiTimeLabel2.text = [NSString stringWithFormat:@"%@'", str];
            }
        } else {
            if ([str containsString:@"'"]) {
                str = [str substringToIndex:str.length - 1];
            }
            self.biSaiTimeLabel.text = [NSString stringWithFormat:@"%@", str];
            self.biSaiTimeLabel2.text = [NSString stringWithFormat:@"%@", str];
        }
        if (![str containsString:@"'"]) {
            str = [NSString stringWithFormat:@"%@'", str];
        }
    } else if (self.biSaiModel.status == 0 || self.biSaiModel.status > 8) {
        str = @"延迟";
        str = @"延迟";
    }
    self.biSaiTimeLabel.text = [NSString stringWithFormat:@"%@", str];
    self.biSaiTimeLabel2.text = [NSString stringWithFormat:@"%@", str];
    if ([self.biSaiTimeLabel.text isEqualToString:@"延迟"]) {
        [self.biSaiTimeLabel sizeToFit];
        self.biSaiTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLabel.textColor = [UIColor whiteColor];
        self.biSaiTimeLabel.backgroundColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLabel.layer.masksToBounds = YES;
        self.biSaiTimeLabel.layer.cornerRadius = 1;
        [self.biSaiTimeLabel2 sizeToFit];
        self.biSaiTimeLabel2.textAlignment = NSTextAlignmentCenter;
        self.biSaiTimeLabel2.textColor = [UIColor whiteColor];
        self.biSaiTimeLabel2.backgroundColor = [UIColor colorWithSexadeString:@"#333333"];
        self.biSaiTimeLabel2.layer.masksToBounds = YES;
        self.biSaiTimeLabel2.layer.cornerRadius = 1;
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
