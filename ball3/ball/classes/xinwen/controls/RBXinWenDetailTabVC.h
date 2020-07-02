#import "RBBaseTabVC.h"
#import "RBXinWenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenDetailTabVC : RBBaseTabVC
@property(nonatomic,strong)RBXinWenModel *xinWenModel;
@property(nonatomic,assign)BOOL canGoBack;
@end

NS_ASSUME_NONNULL_END
