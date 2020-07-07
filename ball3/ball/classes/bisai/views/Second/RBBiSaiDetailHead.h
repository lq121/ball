#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiDetailHead : UIView
@property(nonatomic,strong) RBBiSaiModel*biSaiModel;
@property(nonatomic,strong)UIView *bigView;
@property(nonatomic,strong)UIView *smallView;
@property (nonatomic, weak) WKWebView *wkView; // 防止wkwebView不会被移除用若引用
@property (nonatomic, strong) NSTimer *timer;

- (instancetype)initWithFrame:(CGRect)frame andIndex:(int)index andClickBtn:(void (^)(int index))clickIndex andChangeHeight:(void(^)(int height))changeHeight;
-(void)clickIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
