#import "RBSelectCell.h"

@implementation RBSelectCell

+ (instancetype)createCellByTableView:(UITableView *)tableView {
    static NSString *ID = @"selectCell";
    RBSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithSexadeString:@"#F8F8F8"];
    return cell;
}

- (void)setDataArr:(NSArray *)dataArr {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _dataArr = dataArr;
    CGFloat margin = 6;
    CGFloat width = (RBScreenWidth - 32 - 2 * margin) / 3;
    CGFloat height = 26;
    for (int i = 0; i < dataArr.count; i++) {
        RBSelectModel *model = dataArr[i];
        UIButton *btn = [[UIButton alloc]init];
        CGFloat x = i % 3 * (margin + width) + 16;
        CGFloat y = i / 3 * (margin + height)+8;
        btn.frame = CGRectMake(x, y, width, height);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"little choose bg"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"choose circle"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"choose circle_selected"] forState:UIControlStateSelected];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithSexadeString:@"#333333"] forState:UIControlStateNormal];
        btn.selected = model.selected;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:btn];
    }
}

- (void)clickBtn:(UIButton *)btn
{
    int index = (int)btn.tag;
    RBSelectModel *model = self.dataArr[index];
    btn.selected = !btn.selected;
    model.selected = btn.selected;
    self.clickBtn(model);
}


@end
