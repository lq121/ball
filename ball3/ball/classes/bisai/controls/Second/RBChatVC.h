#import <UIKit/UIKit.h>
#import "RBBiSaiModel.h"
#import "RBBiSaiDetailHead.h"
NS_ASSUME_NONNULL_BEGIN

@interface RBChatVC : UIViewController
@property (nonatomic, strong) RBBiSaiModel *biSaiModel;
- (void)connectSocket;
@property (nonatomic, assign) BOOL hasSend;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *chatToolBar;
- (void)connct;
@end

NS_ASSUME_NONNULL_END
