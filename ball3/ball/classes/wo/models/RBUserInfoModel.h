#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBUserInfoModel : NSObject
@property (copy, nonatomic) NSString *tipName;
@property (copy, nonatomic) NSString *desName;
@property (assign, nonatomic, readwrite) BOOL showRow;
@property (assign, nonatomic, readwrite) BOOL isImage;
@property (assign, nonatomic, readwrite) BOOL showLine;
@property(nonatomic,assign)BOOL hasUsed;
@end

NS_ASSUME_NONNULL_END
