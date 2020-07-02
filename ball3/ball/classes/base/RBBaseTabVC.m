#import "RBBaseTabVC.h"

@interface RBBaseTabVC ()

@end

@implementation RBBaseTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
}

@end
