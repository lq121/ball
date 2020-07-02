#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (RBExtension)
- (void)showDataCount:(NSInteger)count andimage:(NSString *)image andTitle:(NSString *)title andImageSize:(CGSize)size;
- (void)showDataCount:(NSInteger)count andTitle:(NSString *)title;
- (void)showDataCount:(NSInteger)count andimage:(NSString *)image andTitle:(NSString *)title andImageSize:(CGSize)size andType:(int)type;
- (void)showDataCount:(NSInteger)count andTitle:(NSString *)title andTitFrame:(CGRect)titleFrame;
@end

NS_ASSUME_NONNULL_END
