#import "RBScheduleBiSaiVC.h"
#import "RBBiSaiTipHeadView.h"
#import "RBBiSaiTabVC.h"

@interface RBScheduleBiSaiVC ()
@property (nonatomic, strong) RBBiSaiTabVC *biSaiTabVC;
@property (nonatomic, assign) int currentDate;
@end

@implementation RBScheduleBiSaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:([components day] + 1)];
    NSDate *tomorrow = [gregorian dateFromComponents:components];
    [components setDay:([components day] + 1)];
    NSDate *afterTomorrow = [gregorian dateFromComponents:components];
    [components setDay:([components day] + 1)];
    NSDate *threeDaysFromNow = [gregorian dateFromComponents:components];
    NSArray *timeArr = @[date, tomorrow, afterTomorrow, threeDaysFromNow];
    int tomorrowTime = [tomorrow timeIntervalSince1970];
    int afterTomorrowTime = [afterTomorrow timeIntervalSince1970];
    int threeDaysFromNowTime = [threeDaysFromNow timeIntervalSince1970];

    NSString *tomorrowWeek = [NSString weekdayStringFromDate:tomorrowTime];
    NSString *afterTomorrowWeek = [NSString weekdayStringFromDate:afterTomorrowTime];
    NSString *threeDaysFromNowWeek = [NSString weekdayStringFromDate:threeDaysFromNowTime];

    NSString *tomorrowHM = [NSString getStrWithDate:tomorrow andFormat:@"MM月dd日"];
    NSString *afterTomorrowHM = [NSString getStrWithDate:afterTomorrow andFormat:@"MM月dd日"];
    NSString *threeDaysFromNowHM = [NSString getStrWithDate:threeDaysFromNow andFormat:@"MM月dd日"];
    NSArray *days = @[jintian, [NSString stringWithFormat:@"%@\n%@", tomorrowWeek, tomorrowHM], [NSString stringWithFormat:@"%@\n%@", afterTomorrowWeek, afterTomorrowHM], [NSString stringWithFormat:@"%@\n%@", threeDaysFromNowWeek, threeDaysFromNowHM]];

    RBBiSaiTabVC *biSaiTabVC = [[RBBiSaiTabVC alloc]init];
    self.biSaiTabVC = biSaiTabVC;
    biSaiTabVC.biSaiType = 2;
    self.currentDate = [timeArr[0] timeIntervalSince1970];
    biSaiTabVC.date = self.currentDate;
    [self addChildViewController:biSaiTabVC];
    UITableView *tableView = biSaiTabVC.tableView;
    tableView.frame =  CGRectMake(0, 40, RBScreenWidth, self.view.height - 40);
    [self.view addSubview:tableView];
    __weak typeof(self) weakSelf = self;
    RBBiSaiTipHeadView *headView =  [[RBBiSaiTipHeadView alloc]initWithFrame:CGRectMake(0, 0, RBScreenWidth, 40) andDates:days andType:1 andClickItem:^(NSInteger index) {
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
