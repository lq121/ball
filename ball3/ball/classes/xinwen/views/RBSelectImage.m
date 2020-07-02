#import "RBSelectImage.h"

typedef void (^ClickCloseBtn)(UIImage *);
typedef void (^ClickBgImage)(UIImage *);
@interface RBSelectImage ()
@property (nonatomic, copy) ClickCloseBtn clickCloseBtn;
@property (nonatomic, copy) ClickBgImage clickBgImage;
@property (nonatomic, strong) UIImage *image;

@end
@implementation RBSelectImage
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andClickCloseBtn:(void (^)(UIImage *))clickCloseBtn andClickBgImage:(void (^)(UIImage *))clickBgImage {
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        self.clickCloseBtn = clickCloseBtn;
        self.clickBgImage = clickBgImage;
        UIButton *bgImage = [[UIButton alloc]init];
        [self addSubview:bgImage];
        bgImage.userInteractionEnabled = YES;
        [bgImage addTarget:self action:@selector(clickBGImage) forControlEvents:UIControlEventTouchUpInside];
        bgImage.frame = self.bounds;
        [bgImage setBackgroundImage:image forState:UIControlStateNormal];
        [bgImage setBackgroundImage:image forState:UIControlStateHighlighted];
        bgImage.layer.masksToBounds = YES;
        bgImage.layer.cornerRadius = 4;

        UIButton *btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[UIImage imageNamed:@"red_close"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(48, 0, 20, 20);
        [btn addTarget:self  action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)clickBGImage {
    self.clickBgImage(self.image);
}

- (void)clickCloseBtn:(UIButton *)btn {
    self.clickCloseBtn(self.image);
}

@end
