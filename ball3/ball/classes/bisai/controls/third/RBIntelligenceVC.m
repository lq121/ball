#import "RBIntelligenceVC.h"
#import "RBNetworkTool.h"

@interface RBIntelligenceVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *whiteView33;
@end

@implementation RBIntelligenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight - 184 - 44 - RBBottomSafeH - 32 - RBStatusBarH)];
    [self.view addSubview:self.scrollView];
    for (int i = 0; i < 2; i++) {
        UIView *hostColor = [[UIView alloc]init];
        hostColor.layer.masksToBounds = YES;
        hostColor.layer.cornerRadius = 5;
        [self.scrollView addSubview:hostColor];
        UILabel *hostLabel = [[UILabel alloc]init];

        hostLabel.textAlignment = NSTextAlignmentLeft;
        hostLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
        hostLabel.font = [UIFont boldSystemFontOfSize:14];
        [hostLabel sizeToFit];
        [self.scrollView addSubview:hostLabel];
        if (i == 0) {
            hostColor.backgroundColor = [UIColor colorWithSexadeString:@"#213A4B"];
            if (![self.biSaiModel.hostTeamName isKindOfClass:[NSNull class]]) {
                hostLabel.text = self.biSaiModel.hostTeamName;
            }
        } else {
            hostColor.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
            if (![self.biSaiModel.visitingTeamName isKindOfClass:[NSNull class]]) {
                hostLabel.text = self.biSaiModel.visitingTeamName;
            }
        }
        if (i == 0) {
            hostColor.frame = CGRectMake(16, 17, 10, 10);
            hostLabel.frame = CGRectMake(CGRectGetMaxX(hostColor.frame) + 4, 12, RBScreenWidth * 0.5 - 30, 20);
        } else {
            hostColor.frame = CGRectMake(RBScreenWidth * 0.5 + 16, 17, 10, 10);
            hostLabel.frame = CGRectMake(RBScreenWidth * 0.5 + 30, 12, RBScreenWidth * 0.5 - 30, 20);
        }
    }

    if (self.biSaiModel.hasIntelligence != NO) {
        NSString *str = [NSString stringWithFormat:@"api/sports/football/match/intelligence?id=%d", self.biSaiModel.namiId];
        NSDictionary *dict = @{ @"data": str };
        [RBNetworkTool PostDataWithUrlStr:@"try/go/gameproxy"  andParam:dict Success:^(NSDictionary *_Nonnull backData) {
            NSDictionary *info = backData[@"info"];
            NSDictionary *bad = info[@"bad"];
            NSDictionary *good = info[@"good"];
            NSArray *neutral = info[@"neutral"];
            NSArray *awayBad = bad[@"away"];
            NSArray *homeBad = bad[@"home"];
            NSArray *awayGood = good[@"away"];
            NSArray *homeGood = good[@"home"];

            NSString *hostGoodStr = @"";
            NSString *hostBadStr = @"";
            NSString *visitGoodStr = @"";
            NSString *visitBadStr = @"";
            NSString *neutralStr = @"";
            NSArray *titles = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五"];

            for (int i = 0; i < neutral.count; i++) {
                NSString *str = neutral[i][1];
                str = [str stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                NSString *str2 = [NSString stringWithFormat:@"情报%@:\n%@", titles[i], str];
                neutralStr = [NSString stringWithFormat:@"%@%@\n\n", neutralStr, str2];
            }
            for (int i = 0; i < homeGood.count; i++) {
                NSString *str = homeGood[i][1];
                str = [str stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                NSString *str2 = [NSString stringWithFormat:@"情报%@:\n%@", titles[i], str];
                hostGoodStr = [NSString stringWithFormat:@"%@%@\n\n", hostGoodStr, str2];
            }
            for (int i = 0; i < homeBad.count; i++) {
                NSString *str = homeBad[i][1];
                str = [str stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                NSString *str2 = [NSString stringWithFormat:@"情报%@:\n%@", titles[i], str];
                hostBadStr = [NSString stringWithFormat:@"%@%@\n\n", hostBadStr, str2];
            }

            for (int i = 0; i < awayGood.count; i++) {
                NSString *str = awayGood[i][1];
                str = [str stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                NSString *str2 = [NSString stringWithFormat:@"情报%@:\n%@", titles[i], str];
                visitGoodStr = [NSString stringWithFormat:@"%@%@\n\n", visitGoodStr, str2];
            }
            for (int i = 0; i < awayBad.count; i++) {
                NSString *str = awayBad[i][1];
                str = [str stringByReplacingOccurrencesOfString:@"" withString:@"\n"];
                NSString *str2 = [NSString stringWithFormat:@"情报%@:\n%@", titles[i], str];
                visitBadStr = [NSString stringWithFormat:@"%@%@\n\n", visitBadStr, str2];
            }
            hostGoodStr = [hostGoodStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            hostBadStr = [hostBadStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            visitGoodStr = [visitGoodStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            visitBadStr = [visitBadStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            neutralStr = [neutralStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            NSArray *strs = @[hostGoodStr, hostBadStr, visitGoodStr, visitBadStr, neutralStr];
            [self showIntelligenceWithArray:strs];
        } Fail:^(NSError *_Nonnull error) {
            [self showNoIntelligence];
        }];
    } else {
        [self showNoIntelligence];
    }
}

- (void)showIntelligenceWithArray:(NSArray *)arr {
    // 右情报
    CGFloat width = (RBScreenWidth - 39) * 0.5;
    CGFloat btnH = 40;
    self.scrollView.contentSize = CGSizeMake(RBScreenWidth, 240 + 32 + 40);
    int count = 0;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            NSString *title = @"有利情报";
            if (i == 1) {
                title = @"无利情报";
            }
            UIButton *btn = [self createBtnWithTitle:title andTag:(i + 1) * 10 + j];
            CGFloat x = j == 0 ? 16 : (16 + width + 7);
            btn.frame = CGRectMake(x, 40, width, btnH);
            [self.scrollView addSubview:btn];
            UIView *whiteView = [self createWhiteWithTitle:arr[count] andX:x andY:80];
            whiteView.tag = btn.tag + 100;
            whiteView.hidden = (i != 0);
            if (i == 0) {
                [self clickBtn:btn];
            }
            [self.scrollView addSubview:whiteView];
            count++;
        }
    }

    UIButton *btn = [self createBtnWithTitle:@"中立情报" andTag:31];
    btn.frame = CGRectMake(16, 192, RBScreenWidth - 32, btnH);
    [self.scrollView addSubview:btn];
    self.whiteView33 = [self createWhiteWithTitle:arr[4] andX:16 andY:192 + 40];
    self.whiteView33.tag = 131;
    self.whiteView33.hidden = YES;
    [self.scrollView addSubview:self.whiteView33];
    [self changeSize];
}

- (void)showNoIntelligence {
    // 没有情报
    CGFloat width = (RBScreenWidth - 39) * 0.5;
    CGFloat btnH = 40;
    self.scrollView.contentSize = CGSizeMake(RBScreenWidth, 240 + 32 + 40);
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            NSString *title = @"有利情报";
            if (i == 1) {
                title = @"无利情报";
            }
            UIButton *btn = [self createBtnWithTitle:title andTag:(i + 1) * 10 + j];
            CGFloat x = j == 0 ? 16 : (16 + width + 7);
            CGFloat y = 0;
            if (i == 0) {
                y = 40;
            } else if (i == 1) {
                y = 120 + 16;
            }
            btn.frame = CGRectMake(x, y, width, btnH);
            [self.scrollView addSubview:btn];
            UIView *whiteView = [self createWhiteWithTitle:@"暂无情报" andX:x andY:y + 40];
            whiteView.tag = btn.tag + 100;
            whiteView.hidden = (i != 0);
            if (i == 0) {
                [self clickBtn:btn];
            }
            [self.scrollView addSubview:whiteView];
        }
    }

    UIButton *btn = [self createBtnWithTitle:@"中立情报" andTag:31];
    btn.frame = CGRectMake(16, 192, RBScreenWidth - 32, btnH);
    [self.scrollView addSubview:btn];
    self.whiteView33 = [self createWhiteWithTitle:@"暂无情报" andX:16 andY:192 + 40];
    self.whiteView33.tag = 131;
    self.whiteView33.hidden = YES;
    [self.scrollView addSubview:self.whiteView33];
}

- (UIView *)createWhiteWithTitle:(NSString *)title andX:(CGFloat)x andY:(CGFloat)Y {
    CGFloat width = (RBScreenWidth - 39) * 0.5;
    CGFloat btnH = 40;
    UIView *whiteView1 = [[UIView alloc]init];
    whiteView1.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithSexadeString:@"#333333"];
    label.text = title;
    label.numberOfLines = 0;
    if ([title isEqualToString:@"暂无情报"]) {
        whiteView1.frame = CGRectMake(x, Y, width, btnH);
        label.frame = CGRectMake(9, 0, width - 9, btnH);
    } else {
        
        CGSize labelSize = [title getSizeWithFontSize:14 andMaxWidth:width - 14];
        whiteView1.frame = CGRectMake(x, Y, width, labelSize.height + 24);
        label.frame = CGRectMake(9, 8, width - 14, labelSize.height);
    }
    [whiteView1 addSubview:label];
    return whiteView1;
}

- (UIButton *)createBtnWithTitle:(NSString *)title andTag:(NSInteger)tag {
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = tag;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#FF4F72" AndAlpha:0.1]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithSexadeString:@"#EAEAEA"]] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#FF4F72"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithSexadeString:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.frame = CGRectMake(9, 0, 70, 40);
    [btn addSubview:titleLabel];

    UIImageView *icon = [[UIImageView alloc]init];
    if (tag == 31) {
        icon.frame = CGRectMake(RBScreenWidth - 64, 4, 32, 32);
    } else {
        icon.frame = CGRectMake((RBScreenWidth - 39) * 0.5 - 32, 4, 32, 32);
    }
    [icon setImage:[UIImage imageNamed:@"arrow"]];
    [btn addSubview:icon];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clickBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    UIView *whiteView = [self.view viewWithTag:btn.tag + 100];
    whiteView.hidden = !btn.selected;
    [self changeSize];
    if (btn.selected) {
        for (UIView *child in btn.subviews) {
            if ([child isKindOfClass:[UIImageView class]]) {
                UIImageView *icon = (UIImageView *)child;
                icon.image = [UIImage imageNamed:@"down blue"];
            }
            if ([child isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)child;
                label.textColor = [UIColor colorWithSexadeString:@"#FF4F72"];
            }
        }
    } else {
        for (UIView *child in btn.subviews) {
            if ([child isKindOfClass:[UIImageView class]]) {
                UIImageView *icon = (UIImageView *)child;
                icon.image = [UIImage imageNamed:@"arrow"];
            }
            if ([child isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)child;
                label.textColor = [UIColor colorWithSexadeString:@"#333333"];
            }
        }
    }
}

- (void)changeSize {
    UIView *btn10 = [self.view viewWithTag:10];
    UIView *white110 = [self.view viewWithTag:110];
    UIView *btn20 = [self.view viewWithTag:20];
    UIView *white120 = [self.view viewWithTag:120];

    UIButton *btn11 = [self.view viewWithTag:11];
    UIView *white111 = [self.view viewWithTag:111];
    UIButton *btn21 = [self.view viewWithTag:21];
    UIView *white121 = [self.view viewWithTag:121];

    // 左边
    if (white110.hidden) {
        btn20.y = CGRectGetMaxY(btn10.frame) + 16;
        white120.y = CGRectGetMaxY(btn20.frame);
    } else {
        btn20.y = CGRectGetMaxY(white110.frame) + 16;
        white120.y = CGRectGetMaxY(btn20.frame);
    }
    // 右边
    if (white111.hidden) {
        btn21.y = CGRectGetMaxY(btn11.frame) + 16;
        white121.y = CGRectGetMaxY(btn21.frame);
    } else {
        btn21.y = CGRectGetMaxY(white111.frame) + 16;
        white121.y = CGRectGetMaxY(btn21.frame);
    }

    UIView *btn = [self.view viewWithTag:31];
    if (white120.hidden && white121.hidden == NO) {
        btn.y = MAX(CGRectGetMaxY(btn20.frame), CGRectGetMaxY(white121.frame)) + 16;
    } else if (white120.hidden == NO && white121.hidden) {
        btn.y = MAX(CGRectGetMaxY(white120.frame), CGRectGetMaxY(btn21.frame)) + 16;
    } else if (white120.hidden && white121.hidden) {
        btn.y = MAX(CGRectGetMaxY(btn20.frame), CGRectGetMaxY(btn21.frame)) + 16;
    } else {
        btn.y = MAX(CGRectGetMaxY(white120.frame), CGRectGetMaxY(white121.frame)) + 16;
    }
    self.whiteView33.y = CGRectGetMaxY(btn.frame);

    UILabel *label3 = self.whiteView33.subviews[0];
   
    CGSize size = [label3.text  getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32];
    label3.frame = CGRectMake(9, 8, RBScreenWidth - 32, size.height);
    self.whiteView33.frame = CGRectMake(16, CGRectGetMaxY(btn.frame), RBScreenWidth - 32, size.height + 24);

    if (self.whiteView33.hidden) {
        self.scrollView.contentSize = CGSizeMake(RBScreenWidth, CGRectGetMaxY(btn.frame));
    } else {
        self.scrollView.contentSize = CGSizeMake(RBScreenWidth, CGRectGetMaxY(self.whiteView33.frame));
    }
}



@end
