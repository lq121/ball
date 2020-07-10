#import "RBResultBiSaiVC.h"
#import "RBBiSaiTipHeadView.h"
#import "RBBiSaiTabVC.h"
#import "RBBiSaiModel.h"

@interface RBResultBiSaiVC ()
@property (nonatomic, strong) RBBiSaiTabVC *biSaiTabVC;
@property (nonatomic, assign) int currentDate;
@end

@implementation RBResultBiSaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day] - 1)];
    NSDate *yesterday = [gregorian dateFromComponents:components];
    [components setDay:([components day] - 1)];
    NSDate *beforeYesterday = [gregorian dateFromComponents:components];
    [components setDay:([components day] - 1)];
    NSDate *threeDaysAgo = [gregorian dateFromComponents:components];
    NSArray *timeArr = @[threeDaysAgo, beforeYesterday, yesterday, date];

    int yesterdayTime = [yesterday timeIntervalSince1970];
    int beforeYesterdayTime = [beforeYesterday timeIntervalSince1970];
    int threeDaysAgoTime = [threeDaysAgo timeIntervalSince1970];
    NSString *yesterdayWeek = [NSString weekdayStringFromDate:yesterdayTime];
    NSString *beforeYesterdayWeek = [NSString weekdayStringFromDate:beforeYesterdayTime];
    NSString *threeDaysAgoTimeWeek = [NSString weekdayStringFromDate:threeDaysAgoTime];

    NSString *tomorrowHM = [NSString getStrWithDate:yesterday andFormat:@"MM月dd日"];
    NSString *afterTomorrowHM = [NSString getStrWithDate:beforeYesterday andFormat:@"MM月dd日"];
    NSString *threeDaysFromNowHM = [NSString getStrWithDate:threeDaysAgo andFormat:@"MM月dd日"];
    NSArray *days = @[[NSString stringWithFormat:@"%@\n%@", threeDaysAgoTimeWeek, threeDaysFromNowHM], [NSString stringWithFormat:@"%@\n%@", beforeYesterdayWeek, afterTomorrowHM], [NSString stringWithFormat:@"%@\n%@", yesterdayWeek, tomorrowHM], jintian];

    RBBiSaiTabVC *biSaiTabVC = [[RBBiSaiTabVC alloc]init];
    self.biSaiTabVC = biSaiTabVC;
    biSaiTabVC.biSaiType = 3;
    self.currentDate = [timeArr[3] timeIntervalSince1970];
    biSaiTabVC.date = self.currentDate;
    [self addChildViewController:biSaiTabVC];
    UITableView *tableView = biSaiTabVC.tableView;
    tableView.frame =  CGRectMake(0, 40, RBScreenWidth, self.view.height - 40);
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf = self;
    RBBiSaiTipHeadView *headView =  [[RBBiSaiTipHeadView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 40)  andDates:days andType:2 andClickItem:^(NSInteger index) {
        weakSelf.currentDate = [timeArr[index] timeIntervalSince1970];
        biSaiTabVC.date = weakSelf.currentDate;
        biSaiTabVC.hasSelect = NO;
        [biSaiTabVC getLocalBiSaiData];
    }];
    [self.view addSubview:headView];
}

- (void)getBiSaiData {
    self.biSaiTabVC.date = self.currentDate;
    self.biSaiTabVC.hasSelect = self.hasSelect;
    [self.biSaiTabVC getLocalBiSaiData];
}

@end
