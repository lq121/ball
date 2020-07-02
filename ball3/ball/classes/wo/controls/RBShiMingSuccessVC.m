#import "RBShiMingSuccessVC.h"

@interface RBShiMingSuccessVC ()

@end

@implementation RBShiMingSuccessVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(28, 44 + RBNavBarAndStatusBarH, RBScreenWidth - 56, 285)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = true;
    whiteView.layer.cornerRadius = 10;
    [self.view addSubview:whiteView];

    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(107, 22, 109, 78)];
    image1.image = [UIImage imageNamed:@"ID card"];
    [whiteView addSubview:image1];

    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(84, 115, 16, 16)];
    image2.image = [UIImage imageNamed:@"tick"];
    [whiteView addSubview:image2];

    UILabel *success = [[UILabel alloc]init];
    success.frame = CGRectMake(CGRectGetMaxX(image2.frame) + 3, CGRectGetMaxY(image1.frame) + 12, 140, 22);
    success.text = @"您已完成实名验证";
    [whiteView addSubview:success];
    success.textAlignment = NSTextAlignmentLeft;
    success.textColor = [UIColor colorWithSexadeString:@"009904"];
    success.font = [UIFont systemFontOfSize:16];

    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(18, 176, RBScreenWidth - 56 - 36, 1)];
    line.image = [UIImage imageNamed:@"dotted_line"];
    [whiteView addSubview:line];

    UILabel *nameTip = [[UILabel alloc]init];
    nameTip.frame = CGRectMake(20, CGRectGetMaxY(line.frame) + 31, 140, 20);
    nameTip.text = @"姓名";
    nameTip.textAlignment = NSTextAlignmentLeft;
    nameTip.textColor = [UIColor colorWithSexadeString:@"#333333"];
    nameTip.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:nameTip];

    UILabel *name = [[UILabel alloc]init];
    name.frame = CGRectMake(RBScreenWidth - 300 - 56 - 20, CGRectGetMaxY(line.frame) + 32, 300, 22);
    name.text = self.data[@"userName"];
    name.textAlignment = NSTextAlignmentRight;
    name.textColor = [UIColor colorWithSexadeString:@"#333333"];
    name.font = [UIFont boldSystemFontOfSize:16];
    [whiteView addSubview:name];

    UILabel *codeTip = [[UILabel alloc]init];
    codeTip.frame = CGRectMake(20, CGRectGetMaxY(nameTip.frame) + 18, 100, 20);
    codeTip.text = @"身份证号";
    codeTip.textAlignment = NSTextAlignmentLeft;
    codeTip.textColor = [UIColor colorWithSexadeString:@"#333333"];
    codeTip.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:codeTip];

    UILabel *code = [[UILabel alloc]init];
    code.frame = CGRectMake(RBScreenWidth - 300 - 56 - 20, CGRectGetMaxY(name.frame) + 16, 300, 22);
    NSString *codeStr = self.data[@"userCode"];
    if (codeStr.length >= 15) {
        [codeStr stringByReplacingCharactersInRange:NSMakeRange(7, 5) withString:@"******"];
    }
    code.text = codeStr;
    code.textAlignment = NSTextAlignmentRight;
    code.textColor = [UIColor colorWithSexadeString:@"#333333"];
    code.font = [UIFont boldSystemFontOfSize:16];
    [whiteView addSubview:code];

    UIButton *backbtn = [[UIButton alloc]initWithFrame:CGRectMake(16, RBScreenHeight - 48 - 116, RBScreenWidth - 32, 48)];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"btn keep"] forState:UIControlStateNormal];
    [backbtn setTitle:@"返回" forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [backbtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}

- (void)clickBackBtn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
