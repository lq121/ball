#import "RBGuanYuPingTaiVC.h"

@interface RBGuanYuPingTaiVC ()

@end

@implementation RBGuanYuPingTaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        self.title = @"关于平台";

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guanyu icon"]];
        imageView.frame = CGRectMake((RBScreenWidth - 84) * 0.5, 136, 84, 84);
        [self.view addSubview:imageView];

        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 4, RBScreenWidth, 28);
        [self.view addSubview:label];
        NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:appName];
        [string1 addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"] } range:NSMakeRange(0, string1.string.length)];
        label.attributedText = string1;
        label.textAlignment = NSTextAlignmentCenter;

        UILabel *label2 = [[UILabel alloc] init];
        label2.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 28, RBScreenWidth, 25);
        [self.view addSubview:label2];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Version %@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
        [string3 addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor colorWithSexadeString:@"#333333"] } range:NSMakeRange(0, string3.string.length)];
        label2.attributedText = string3;
        label2.textAlignment = NSTextAlignmentCenter;
}


@end
