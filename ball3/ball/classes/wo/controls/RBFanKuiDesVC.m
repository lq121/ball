#import "RBFanKuiDesVC.h"

@interface RBFanKuiDesVC ()

@end

@implementation RBFanKuiDesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录详情";
    self.view.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];

    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];

    UILabel *title = [[UILabel alloc]init];
    title.text = self.fanKuiModel.Title;
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = [UIColor colorWithSexadeString:@"#333333"];
    title.font = [UIFont systemFontOfSize:16];
    title.frame = CGRectMake(16, 19, RBScreenWidth - 32, [title.text getSizeWithFontSize:16 andMaxWidth:RBScreenWidth - 32].height);
    [whiteView addSubview:title];

    UILabel *desLab = [[UILabel alloc]init];
    if (self.fanKuiModel.Txt.length > 0) {
        desLab.text = self.fanKuiModel.Txt;
        desLab.numberOfLines = 0;
        desLab.textAlignment = NSTextAlignmentLeft;
        desLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        desLab.font = [UIFont systemFontOfSize:14];
        desLab.frame = CGRectMake(16, CGRectGetMaxY(title.frame) + 8, RBScreenWidth - 32, [desLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 32].height);
        [whiteView addSubview:desLab];
    }

    UIImageView *icon = [[UIImageView alloc]init];
    if (self.fanKuiModel.Img.length > 0) {
        [whiteView addSubview:icon];
        if (self.fanKuiModel.Txt.length > 0) {
            icon.frame = CGRectMake(16, CGRectGetMaxY(desLab.frame) + 16, RBScreenWidth - 32, 194);
        } else {
            icon.frame = CGRectMake(16, CGRectGetMaxY(title.frame) + 19, RBScreenWidth - 32, 194);
        }
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager.imageCache queryImageForKey:self.fanKuiModel.Img options:0 context:nil completion:^(UIImage *_Nullable image, NSData *_Nullable data, SDImageCacheType cacheType) {
            if (image != nil) {
                icon.image = [image cutImageWithSize:icon.size];
            } else {
                [icon sd_setImageWithURL:[NSURL URLWithString:self.fanKuiModel.Img] placeholderImage:[UIImage compositionImageWithBaseImageName:@"logo pic" andFrame:CGRectMake(0, 0, RBScreenWidth - 32, 194) andBGColor:[UIColor colorWithSexadeString:@"#EEEEEE"]]  completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                    if (image != nil) {
                        [manager.imageCache storeImage:image imageData:nil forKey:self.fanKuiModel.Img cacheType:SDImageCacheTypeDisk completion:nil];
                    }
                    icon.image = [image cutImageWithSize:icon.size];
                }];
            }
        }];
    }

    if (self.fanKuiModel.Reply.length > 0) {
        UIView *replyView = [[UIView alloc]init];
        replyView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        UILabel *replyLab = [[UILabel alloc]init];
        replyLab.numberOfLines = 0;
        replyLab.text = self.fanKuiModel.Reply;
        replyLab.textAlignment = NSTextAlignmentLeft;
        replyLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        replyLab.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        replyLab.font = [UIFont boldSystemFontOfSize:14];
        replyLab.frame = CGRectMake(16, 8, RBScreenWidth - 64, [replyLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64].height);
        if (self.fanKuiModel.Img.length > 0) {
            replyView.frame = CGRectMake(16, CGRectGetMaxY(icon.frame) + 16,  RBScreenWidth - 32, [replyLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64].height + 16);
        } else if (self.fanKuiModel.Txt.length > 0) {
            replyView.frame = CGRectMake(16, CGRectGetMaxY(desLab.frame) + 16, RBScreenWidth - 32, [replyLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64].height + 16);
        } else {
            replyView.frame = CGRectMake(16, CGRectGetMaxY(title.frame) + 16, RBScreenWidth - 32, [replyLab.text getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 64].height + 16);
        }
        [replyView addSubview:replyLab];
        [whiteView addSubview:replyView];
        whiteView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(replyView.frame) + 16);
    }
    if (self.fanKuiModel.Reply.length <= 0) {
        UILabel *noReplayLab = [[UILabel alloc]init];
        noReplayLab.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
        noReplayLab.text = @"正在处理中…";
        noReplayLab.textAlignment = NSTextAlignmentCenter;
        noReplayLab.textColor = [UIColor colorWithSexadeString:@"#333333" AndAlpha:0.8];
        noReplayLab.font = [UIFont systemFontOfSize:14];
        if (self.fanKuiModel.Img.length > 0) {
            noReplayLab.frame = CGRectMake(16, CGRectGetMaxY(icon.frame) + 16,  RBScreenWidth - 32, 80);
        } else if (self.fanKuiModel.Txt.length > 0) {
            noReplayLab.frame = CGRectMake(16, CGRectGetMaxY(desLab.frame) + 16, RBScreenWidth - 32, 80);
        } else {
            noReplayLab.frame = CGRectMake(16, CGRectGetMaxY(title.frame) + 16, RBScreenWidth - 32, 80);
        }
        [whiteView addSubview:noReplayLab];
        whiteView.frame = CGRectMake(0, 0, RBScreenWidth, CGRectGetMaxY(noReplayLab.frame) + 16);
    }
}

@end
