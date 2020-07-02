#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBSelectModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *preTitle;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) int section;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int Id;
@end

NS_ASSUME_NONNULL_END
