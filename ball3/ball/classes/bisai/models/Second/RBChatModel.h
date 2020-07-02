#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBChatModel : NSObject
@property (nonatomic, assign) int c;
@property (nonatomic, assign) int giftId;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) int vipLevel;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) int isVip;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) int isStar;
@property (nonatomic, assign) int giftNum;
@property (nonatomic, assign) BOOL UsePack;
@property (nonatomic, copy) NSString *game;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, assign) int vip;
@property(nonatomic,copy)NSString *name;
@end

NS_ASSUME_NONNULL_END
