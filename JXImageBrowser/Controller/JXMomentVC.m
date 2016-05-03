//
//  JXMomentVC.m
//  JXImageBrowser
//
//  Created by CoderSun on 5/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXMomentVC.h"
#import "JXMomentCell.h"

@interface JXMomentVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet    UITableView                         *tableView;
@property (nonatomic, strong)           NSMutableArray <JXMomentModel *>    *arrDatas;

@end

@implementation JXMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"JXImageBrowser";
    
    //
    _arrDatas = [[NSMutableArray alloc] init];
    UINib *nibMomentCell = [UINib nibWithNibName:NSStringFromClass([JXMomentCell class]) bundle:nil];
    [self.tableView registerNib:nibMomentCell forCellReuseIdentifier:@"momentCell"];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //
    NSArray *arrJSON = @[
                         @{
                             @"user_name":@"CoderSun",
                             @"imgs":@[
                                     @{@"imgUrlSub":@"101749"},
                                     @{@"imgUrlSub":@"107107"},
                                     @{@"imgUrlSub":@"107500"},
                                     @{@"imgUrlSub":@"938902"},
                                     @{@"imgUrlSub":@"931282"},
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
                                     @{@"imgUrlSub":@"361080"},
                                     @{@"imgUrlSub":@"361764"},
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
        [self.arrDatas addObject:[[JXMomentModel alloc] initWithDic:dicEnum]];
    }
    
    [self.tableView reloadData];
    
    
    
    // newBranch
    
    // 有的没有的
    
    
    
    
}

#pragma mark
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









