#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RBPlayer;

typedef void (^ShiPingPlayingOverBlock) (RBPlayer *player);

@interface RBPlayer : UIView
@property (nonatomic, copy) ShiPingPlayingOverBlock playingOverBlock;
@property (nonatomic, strong) NSString *shipingUrl;

- (void)playPause;
- (void)pause;
- (void)destroyPlayer;
- (void)playerBindTableView:(UITableView *)bindTableView currentIndexPath:(NSIndexPath *)currentIndexPath;
- (void)playerScrollIsSupportSmallWindowPlay:(BOOL)support;
- (void)setShiPingUrl:(NSString *)shipingUrl andType:(int)type;
@end

NS_ASSUME_NONNULL_END
