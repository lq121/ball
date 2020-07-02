#import "FirstVC.h"

@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lastOne"]];
    imageView.frame = CGRectMake(0, 0, RBScreenWidth, RBScreenHeight);
    [self.view addSubview:imageView];

    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lanchicon"]];
    icon.frame = CGRectMake((RBScreenWidth - 120) * 0.5,300 + RBStatusBarH, 120, 38.4);
    [self.view addSubview:icon];

    UILabel *detailLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame), RBScreenWidth, 20)];
    detailLab2.text = @"— 小应体育 —";
    detailLab2.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.3];
    detailLab2.textAlignment = NSTextAlignmentCenter;
    detailLab2.font = [UIFont systemFontOfSize:17];

    [self.view addSubview:detailLab2];
}


@end
