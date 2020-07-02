#import "RBFenXiangView.h"
#import "RBCommButton.h"

typedef void (^ClickItem)(NSInteger);
typedef void (^ClickSureBtn)(void);
@interface RBFenXiangView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, copy) ClickItem clickItem;
@property (nonatomic, copy) ClickSureBtn clickSureBtn;
@end

@implementation RBFenXiangView
- (instancetype)initWithCopy:(BOOL)nocopy andClickItem:(void (^)(NSInteger index))clickitem {
    if (self  = [super initWithFrame:CGRectMake(0, 0, RBScreenWidth, RBScreenHeight)]) {
        self.clickItem = clickitem;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, RBScreenHeight, RBScreenWidth, 134)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:durationTime animations:^{
            whiteView.y = RBScreenHeight - 134;
        }];

        [self addSubview:whiteView];

        UILabel *tip = [[UILabel alloc]init];
        tip.text = @"转发至";
        tip.frame = CGRectMake(0, 16, RBScreenWidth, 22);
        tip.textAlignment = NSTextAlignmentCenter;
        tip.textColor = [UIColor colorWithSexadeString:@"#333333"];
        tip.font = [UIFont boldSystemFontOfSize:16];
        [whiteView addSubview:tip];
        if (nocopy) {
            RBCommButton *WXBtn = [[RBCommButton alloc] initWithImage:@"wx" andHeighImage:@"wx" andFrame:CGRectMake(49, 54, 56, 72) andTitle:@"微信好友" andTarget:self andAction:@selector(clickWXBtn)];
            [whiteView addSubview:WXBtn];

            RBCommButton *wFriendsBtn = [[RBCommButton alloc] initWithImage:@"quan" andHeighImage:@"quan" andFrame:CGRectMake(RBScreenWidth - 56 - 49, 54, 56, 72) andTitle:@"朋友圈" andTarget:self andAction:@selector(clickwFriendsBtn)];
            [whiteView addSubview:wFriendsBtn];
        } else {
            RBCommButton *WXBtn = [[RBCommButton alloc] initWithImage:@"wx" andHeighImage:@"wx" andFrame:CGRectMake(49, 54, 56, 72) andTitle:@"微信好友" andTarget:self andAction:@selector(clickWXBtn)];
            [whiteView addSubview:WXBtn];

            RBCommButton *wFriendsBtn = [[RBCommButton alloc] initWithImage:@"quan" andHeighImage:@"quan" andFrame:CGRectMake((RBScreenWidth - 56) * 0.5, 54, 56, 72) andTitle:@"朋友圈" andTarget:self andAction:@selector(clickwFriendsBtn)];
            [whiteView addSubview:wFriendsBtn];

            RBCommButton *copyBtn = [[RBCommButton alloc] initWithImage:@"link" andHeighImage:@"link" andFrame:CGRectMake(RBScreenWidth - 56 - 49, 54, 56, 72) andTitle:@"复制链接" andTarget:self andAction:@selector(clickCopyBtn)];
            [whiteView addSubview:copyBtn];
        }
    }

    return self;
}



- (instancetype)initWithClickItem:(void (^)(NSInteger index))clickitem {
    return [self initWithCopy:NO andClickItem:clickitem];
}

- (void)clickWXBtn {
    self.clickItem(1);
    [self clickCancelBtn];
}

- (void)clickwFriendsBtn {
    self.clickItem(2);
    [self clickCancelBtn];
}

- (void)clickCopyBtn {
    self.clickItem(3);
    [self clickCancelBtn];
}

- (void)clickCancelBtn {
    [UIView animateWithDuration:durationTime animations:^{
        self.whiteView.y = RBScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}





@end
