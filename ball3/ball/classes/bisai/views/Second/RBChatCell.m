#import "RBChatCell.h"
@interface RBChatCell ()
@property (nonatomic, strong) UILabel *lvLab;
@property (nonatomic, strong) UIButton *userNameBtn;
@property (nonatomic, strong) UILabel *rightLab;
@end

@implementation RBChatCell
+ (instancetype)createCellByTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"RBChatCell";
    RBChatCell *cell = (RBChatCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *lvLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 5.8, 32, 16)];
        self.lvLab = lvLab;
        lvLab.layer.cornerRadius = 4;
        lvLab.layer.masksToBounds = true;
        lvLab.textAlignment = NSTextAlignmentCenter;
        lvLab.textColor = [UIColor whiteColor];
        lvLab.font = [UIFont systemFontOfSize:10];
        [self addSubview:lvLab];

        UIButton *userNameBtn = [[UIButton alloc]init];
        userNameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [userNameBtn addTarget:self  action:@selector(clickUserNamBtn) forControlEvents:UIControlEventTouchUpInside];
        self.userNameBtn = userNameBtn;
        [self addSubview:userNameBtn];

        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.numberOfLines = 0;
        self.rightLab = rightLab;
        rightLab.textAlignment = NSTextAlignmentLeft;
        rightLab.textColor = [UIColor colorWithSexadeString:@"#333333"];
        rightLab.font =  [UIFont systemFontOfSize:14];
        [self addSubview:rightLab];
    }
    return self;
}

- (void)clickUserNamBtn {
}

- (CGFloat)getCellHeight {
    NSString *msgStr = self.chatModel.msg;
    CGSize msgSize = [msgStr getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 16 - CGRectGetMaxX(self.userNameBtn.frame)];
    return msgSize.height + 8;
}

- (void)setChatModel:(RBChatModel *)chatModel {
    _chatModel = chatModel;
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    if ([uid isEqualToString:chatModel.uid]) {
        chatModel.nickName = @"我";
    }
    if (chatModel.c == 2) {
        // 送礼物
        NSArray *arr = @[@"UFO", @"冲天火箭", @"超级跑车", @"双彩虹", @"82年雪碧", @"玫瑰花", @"棒棒糖", @"赞"];
        chatModel.msg = [NSString stringWithFormat:@"（送出%@×%d）", arr[chatModel.giftId - 1], chatModel.giftNum];
    }
    self.lvLab.text = [NSString stringWithFormat:@"Lv%d", chatModel.vipLevel];
    if (chatModel.vipLevel < 10) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#95C4FA"];
    } else if (chatModel.vipLevel < 20) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#8B8FFF"];
    } else if (chatModel.vipLevel < 30) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#98D1B2"];
    } else if (chatModel.vipLevel < 40) {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FFC57F"];
    } else {
        self.lvLab.backgroundColor = [UIColor colorWithSexadeString:@"#FF9D95"];
    }
    NSString *nickName = [NSString stringWithFormat:@"%@:", chatModel.nickName];
    
    CGSize nickSize = [nickName getLineSizeWithFontSize:14];
    [self.userNameBtn setTitle:nickName forState:UIControlStateNormal];
    if (chatModel.vip > 0) {
        self.userNameBtn.frame = CGRectMake(CGRectGetMaxX(self.lvLab.frame) + 2, 4, nickSize.width + 38, nickSize.height);
        self.userNameBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        [self.userNameBtn setImage:[UIImage imageNamed:@"vip kim"] forState:UIControlStateNormal];
        [self.userNameBtn setTitleColor:[UIColor colorWithSexadeString:@"#FA7268"] forState:UIControlStateNormal];
    } else {
        [self.userNameBtn setImage:nil forState:UIControlStateNormal];
        self.userNameBtn.imageEdgeInsets = UIEdgeInsetsZero;
        [self.userNameBtn setTitleColor:[UIColor colorWithSexadeString:@"#2B8AF7"] forState:UIControlStateNormal];
        self.userNameBtn.frame = CGRectMake(CGRectGetMaxX(self.lvLab.frame) + 2, 4, nickSize.width, nickSize.height);
    }
    NSString *msgStr = chatModel.msg;
    CGSize msgSize = [msgStr getSizeWithFontSize:14 andMaxWidth:RBScreenWidth - 16 - CGRectGetMaxX(self.userNameBtn.frame)];
    self.rightLab.text = msgStr;
    self.rightLab.frame = CGRectMake(CGRectGetMaxX(self.userNameBtn.frame) + 4, 4, msgSize.width, msgSize.height);
}


@end
