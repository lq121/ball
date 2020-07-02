#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBXinWenModel : NSObject
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *detailPag;
@property (nonatomic, strong) NSArray *detailImg;
@property (nonatomic, assign) int createt;
@property (nonatomic, assign) int readnum;
@end

NS_ASSUME_NONNULL_END
