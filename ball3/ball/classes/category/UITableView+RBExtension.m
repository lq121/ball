#import "UITableView+RBExtension.h"

@implementation UITableView (RBExtension)
- (void)showDataCount:(NSInteger)count andimage:(NSString *)image andTitle:(NSString *)title andImageSize:(CGSize)size {
    [self showDataCount:count andimage:image andTitle:title andImageSize:size andType:1];
}

- (void)showDataCount:(NSInteger)count andimage:(NSString *)image andTitle:(NSString *)title andImageSize:(CGSize)size andType:(int)type {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if (count > 0) {
        self.backgroundView = nil;
        return;
    }

    UIImageView *cloudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    cloudImage.frame = CGRectMake((self.width - size.width) * 0.5 + 10, (self.height - size.height) * 0.5 - 45, size.width, size.height);
    [backgroundView addSubview:cloudImage];

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, CGRectGetMinY(cloudImage.frame) + size.height + 16, self.width, 20);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithSexadeString:@"#868686"];
    [backgroundView addSubview:label];
    if (type == 2) {
        CGSize size1 = [@"点击比赛详情页的'" getLineSizeWithFontSize:12];
        CGSize size2 = [@"'可关注比赛哟" getLineSizeWithFontSize:12];
        UILabel *leftLab = [[UILabel alloc]init];
        leftLab.font = [UIFont systemFontOfSize:12];
        leftLab.frame = CGRectMake( (RBScreenWidth - size1.width - size2.width - 17) * 0.5, CGRectGetMaxY(label.frame) + 4, size1.width, size1.height);
        leftLab.text = @"点击比赛详情页的'";
        leftLab.textAlignment = NSTextAlignmentRight;
        leftLab.textColor = [UIColor colorWithSexadeString:@"#868686"];
        [backgroundView addSubview:leftLab];

        UIImageView *cloudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star2"]];
        cloudImage.frame = CGRectMake(CGRectGetMaxX(leftLab.frame), CGRectGetMaxY(label.frame) + 4, 17, 16);
        [backgroundView addSubview:cloudImage];

        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.font = [UIFont systemFontOfSize:12];
        rightLab.frame = CGRectMake(CGRectGetMaxX(cloudImage.frame), CGRectGetMaxY(label.frame) + 4, size2.width, size2.height);
        rightLab.text = @"'可关注比赛哟";
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = [UIColor colorWithSexadeString:@"#868686"];
        [backgroundView addSubview:rightLab];
    }
    self.backgroundView = backgroundView;
}

- (void)showDataCount:(NSInteger)count andTitle:(NSString *)title andTitFrame:(CGRect)titleFrame {
    if (count > 0) {
        self.backgroundView = nil;
        return;
    }
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    UILabel *label = [[UILabel alloc]init];
    label.frame = titleFrame;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
    label.font = [UIFont systemFontOfSize:14];
    [backgroundView addSubview:label];
    self.backgroundView = backgroundView;
}

- (void)showDataCount:(NSInteger)count andTitle:(NSString *)title {
    [self showDataCount:count andTitle:title andTitFrame:CGRectMake(0, 58, self.width, 36)];
}
@end
