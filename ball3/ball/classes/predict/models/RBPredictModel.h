#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RBPredictModel : NSObject
/// 大小球
@property (nonatomic, strong) NSArray *daxiao;
/// 详情
@property (nonatomic, copy) NSString *detail;
/// 动画
@property (nonatomic, assign) int donghua;
/// 大小结果
@property (nonatomic, assign) int dxresult;
/// Id
@property (nonatomic, assign) int Id;
/// 阶段组
@property (nonatomic, assign) int jieduangroup;
/// 阶段id
@property (nonatomic, assign) int jieduanid;
/// 阶段轮
@property (nonatomic, assign) int jieduanlun;
/// 阶段模型
@property (nonatomic, assign) int jieduanmode;
/// 阶段名
@property (nonatomic, strong) NSArray *jieduanname;
/// 阶段
@property (nonatomic, assign) int jieduanround;
/// 阶段组
@property (nonatomic, assign) int jieduanzu;
/// 客队加时比分
@property (nonatomic, assign) int keaddfen;
/// 客队点球
@property (nonatomic, assign) int kedianfen;
/// 客队的分
@property (nonatomic, assign) int kefen;
/// 客队半球
@property (nonatomic, assign) int kehalffen;
/// 客队红牌
@property (nonatomic, assign) int kehong;
/// 客队黄
@property (nonatomic, assign) int kehuang;
/// 客队id
@property (nonatomic, assign) int keid;
/// 客队角球
@property (nonatomic, assign) int kejiao;
/// 客队logo
@property (nonatomic, copy) NSString *kelogo;
/// 客队名
@property (nonatomic, strong) NSArray *kename;
/// 客排名
@property (nonatomic, copy) NSString *kerank;
///  球队logo
@property (nonatomic, copy) NSString *logo;
/// 轮次
@property (nonatomic, assign) int lunci;
/// 赛事名
@property (nonatomic, strong) NSArray *name;
/// 纳米id
@property (nonatomic, assign) int namiid;
/// 情报
@property (nonatomic, assign) int qingbao;
/// 让球
@property (nonatomic, strong) NSArray *rangqiuArr;
/// 让球结果
@property (nonatomic, assign) int rqresult;
/// 赛季Id
@property (nonatomic, assign) int saijiid;
/// 赛季年
@property (nonatomic, assign) int saijiyear;
/// 胜平负
@property (nonatomic, strong) NSArray *shengps;
/// 胜平负结果
@property (nonatomic, assign) int spsresult;
/// 开球时间
@property (nonatomic, assign) int startballt;
/// 比赛时间
@property (nonatomic, assign) int startt;
/// 比赛状态
@property (nonatomic, assign) int state;
/// 阵容
@property (nonatomic, assign) int zhenrong;
/// 中立
@property (nonatomic, assign) int zhongli;
/// 主队加时分
@property (nonatomic, assign) int zhuaddfen;
/// 主队点球
@property (nonatomic, assign) int zhudianfen;
/// 主队比分
@property (nonatomic, assign) int zhufen;
/// 主队半球
@property (nonatomic, assign) int zhuhalffen;
/// 主队红牌
@property (nonatomic, assign) int zhuhong;
/// 主队黄牌
@property (nonatomic, assign) int zhuhuang;
/// 主队id
@property (nonatomic, assign) int zhuid;
/// 主队角球
@property (nonatomic, assign) int zhujiao;
/// 主队logo
@property (nonatomic, copy) NSString *zhulogo;
/// 主队名
@property (nonatomic, strong) NSArray *zhuname;
/// 主队排名
@property (nonatomic, copy) NSString *zhurank;
/// 购买类型
@property (nonatomic, assign) int style;
/// 购买的时间
@property (nonatomic, assign) int createt;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) int Result;
@property (nonatomic, strong) NSArray *zhibo;
@end

NS_ASSUME_NONNULL_END
