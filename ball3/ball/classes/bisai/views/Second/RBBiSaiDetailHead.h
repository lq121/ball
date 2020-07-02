#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface RBBiSaiDetailHead : UIView
@property(nonatomic,strong) RBBiSaiModel*biSaiModel;
- (instancetype)initWithFrame:(CGRect)frame andIndex:(int)index andClickBtn:(void (^)(int index))clickIndex;
-(void)clickIndex:(int)index;
@property(nonatomic,strong)UIView *bigView;
@property(nonatomic,strong)UIView *smallView;



@end

NS_ASSUME_NONNULL_END
