//
//  JXMomentVC.m
//  JXImageBrowser
//
//  Created by shiba_iosJX on 5/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXMomentVC.h"
#import "JXMomentCell.h"

@interface JXMomentVC ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet    UITableView                         *tableView;
@property (nonatomic, strong)           NSMutableArray <JXMomentModel *>    *arrDatas;


@end

@implementation JXMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrDatas = [[NSMutableArray alloc] init];
    UINib *nibMomentCell = [UINib nibWithNibName:NSStringFromClass([JXMomentCell class]) bundle:nil];
    [self.tableView registerNib:nibMomentCell forCellReuseIdentifier:@"momentCell"];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
#if 0
    https://raw.githubusercontent.com/augsun/Resources/master/JXImageBrowser/101749.jpg
    101749.jpg	355354.jpg	361764.jpg	622388.jpg	931282.jpg
    107107.jpg	355362.jpg	365425.jpg	622394.jpg	938902.jpg
    107500.jpg	356022.jpg	393569.jpg	622506.jpg	950919.jpg
    108389.jpg	356770.jpg	393593.jpg	623818.jpg	969118.jpg
    111258.jpg	360108.jpg	409690.jpg	739017.jpg	970400.jpg
    112793.jpg	361080.jpg	573433.jpg	849617.jpg	986765.jpg
#endif
    
    NSArray *arrJSON = @[
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"101749"},
                                     @{@"imgUrlSub":@"107107"},
                                     @{@"imgUrlSub":@"107500"},
                                     @{@"imgUrlSub":@"938902"},
                                     @{@"imgUrlSub":@"931282"},
                                     @{@"imgUrlSub":@"361764"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"355362"},
                                     @{@"imgUrlSub":@"356770"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"970400"},
                                     @{@"imgUrlSub":@"950919"},
                                     @{@"imgUrlSub":@"986765"},
                                     @{@"imgUrlSub":@"739017"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"622388"},
                                     @{@"imgUrlSub":@"849617"},
                                     @{@"imgUrlSub":@"573433"},
                                     @{@"imgUrlSub":@"622506"},
                                     @{@"imgUrlSub":@"623818"},
                                     @{@"imgUrlSub":@"365425"},
                                     @{@"imgUrlSub":@"393569"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"393593"},
                                     @{@"imgUrlSub":@"409690"},
                                     @{@"imgUrlSub":@"108389"},
                                     @{@"imgUrlSub":@"356022"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"112793"},
                                     @{@"imgUrlSub":@"360108"},
                                     @{@"imgUrlSub":@"361080"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"355354"},
                                     ],
                             },
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"622394"},
                                     @{@"imgUrlSub":@"969118"},
                                     @{@"imgUrlSub":@"111258"},
                                     ],
                             },
                         ];
    
    for (NSDictionary *dicEnum in arrJSON) {
        JXMomentModel *jxModel = [[JXMomentModel alloc] initWithDic:dicEnum];
        [self.arrDatas addObject:jxModel];
    }
    
    [self.tableView reloadData];
    
    
    
    
    
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JXMomentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCell" forIndexPath:indexPath];
    cell.model = self.arrDatas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.arrDatas[indexPath.row].hCell;
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end









