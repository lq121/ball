#import "RBAnalyThirdCell.h"
#import "RBAnalyzeTitleView.h"

@interface RBAnalyThirdCell ()
@property (nonatomic, strong) UILabel *name1;
@property (nonatomic, strong) UILabel *name2;
@property (nonatomic, strong) UILabel *count1;
@property (nonatomic, strong) UILabel *count2;
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation RBAnalyThirdCell

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.name1.text = self.currentHostName;
    self.name2.text = self.currentVisitingName;
    NSDictionary *home = dict[@"goal_distribution"][@"home"][@"all"];
    NSDictionary *away = dict[@"goal_distribution"][@"away"][@"all"];
    int allcount1 = 0,allcount2 = 0;
    NSArray *homeScored = home[@"scored"];
    NSArray *awayScored = away[@"scored"];
    for (int i = 0; i < homeScored.count; i++) {
        UILabel *label = (UILabel *)[self.whiteView viewWithTag:100 + i];
        label.text = [NSString stringWithFormat:@"%d", [homeScored[i][0] intValue] ];
        if ([homeScored[i][0] intValue] <= 2) {
            label.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
        } else {
            label.backgroundColor = [UIColor colorWithSexadeString:@"#FF8100"];
        }
        allcount1 += [homeScored[i][0] intValue];
    }

    for (int i = 0; i < awayScored.count; i++) {
        UILabel *label = (UILabel *)[self.whiteView viewWithTag:200 + i];
        label.text = [NSString stringWithFormat:@"%d", [awayScored[i][0] intValue] ];
        if ([awayScored[i][0] intValue] <= 2) {
            label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
        } else {
            label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.3];
        }
        allcount2 += [awayScored[i][0] intValue];
    }

    self.count1.text = [NSString stringWithFormat:@"%d", allcount1];
    [self.count1 sizeToFit];
    self.count2.text = [NSString stringWithFormat:@"%d", allcount2];
    [self.count2 sizeToFit];
}


+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *indentifier = @"RBAnalyThirdCell";
    RBAnalyThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        RBAnalyzeTitleView *titleView = [[RBAnalyzeTitleView alloc]initWithTitle:@"进球分布" andFrame:CGRectMake(0, 0, RBScreenWidth, 46)  andSecondTitle:@""   andDetail:@"" andFirstBtn:@"" andSecondBtn:@"" andClickFirstBtn:^(BOOL selected) {
        } andClickSecondBtn:^(BOOL selected) {
        }];
        [self addSubview:titleView];

        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, RBScreenWidth, 92)];
        self.whiteView = whiteView;
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];

        NSArray *arr = @[@"00'", @"15'", @"30'", @"45'", @"60'", @"75'", @"90'"];
        CGFloat width = 29;
        CGFloat height = 24;
        for (int i = 0; i < arr.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.text = arr[i];
            label.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.4];
            label.frame = CGRectMake(RBScreenWidth - (arr.count - i) * width - 16, 5, width, height);
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:10];

            [whiteView addSubview:label];
        }

        for (int i = 0; i < 2; i++) {
            UILabel *name1 = [[UILabel alloc]init];
            name1.textAlignment = NSTextAlignmentLeft;
            name1.font = [UIFont boldSystemFontOfSize:14];
            name1.textColor = [UIColor colorWithSexadeString:@"#333333"];
            [whiteView addSubview:name1];
            if (i == 0) {
                name1.frame = CGRectMake(16, 30, 120, 20);
                self.name1 = name1;
            } else {
                name1.frame = CGRectMake(16, 58, 120, 20);
                self.name2 = name1;
            }
        }

        for (int i = 0; i < 2; i++) {
            UILabel *name2 = [[UILabel alloc]init];
            name2.textAlignment = NSTextAlignmentRight;
            name2.font = [UIFont boldSystemFontOfSize:14];

            [whiteView addSubview:name2];
            if (i == 0) {
                self.count1 = name2;

                name2.textColor =   [UIColor colorWithSexadeString:@"#FFA500"];
                name2.frame = CGRectMake(RBScreenWidth - 6 * width - 20 - 18 - 10, 32, 10, 22);
            } else {
                self.count2 = name2;
                name2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.5];
                name2.frame = CGRectMake(RBScreenWidth - 6 * width - 20 - 18 - 10, 60, 10, 22);
            }
        }

        for (int i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.tag = 100 + i;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithSexadeString:@"#FFA500"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            if (i > 2) {
                label.frame = CGRectMake(RBScreenWidth - (6 - i) * width - 16, 28, width, height);
            } else {
                label.frame = CGRectMake(RBScreenWidth - (6 - i) * width - 20, 28, width, height);
            }

            [whiteView addSubview:label];
        }

        for (int i = 0; i < 6; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.textColor = [UIColor whiteColor];
            label.tag =  200 + i;
            if (i > 2) {
                label.frame = CGRectMake(RBScreenWidth - (6 - i) * width - 16, 56, width, height);
            } else {
                label.frame = CGRectMake(RBScreenWidth - (6 - i) * width - 20, 56, width, height);
            }

            label.backgroundColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.3];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];

            [whiteView addSubview:label];
        }
    }
    return self;
}

@end
