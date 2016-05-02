//
//  JXModel.m
//  JXImageBrowser
//
//  Created by shiba_iosJX on 5/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXMomentModel.h"

#define URL_BASE                @"https://raw.githubusercontent.com/augsun/Resources/master/JXImageBrowser/"
#define STR_CAT(str1, str2)     [NSString stringWithFormat:@"%@%@", str1, str2]

@implementation JXMomentModel

- (JXMomentModel *)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _strUserName = dic[@"user_name"];
        _arrMinUrls = [[NSMutableArray alloc] init];
        _arrJXImages = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dicEnum in dic[@"imgs"]) {
            [_arrMinUrls addObject:[NSURL URLWithString:STR_CAT(URL_BASE, STR_CAT(STR_CAT(dicEnum[@"imgUrlSub"], @".min"), @".jpg"))]];
            JXImage *jxImage = [[JXImage alloc] init];
            jxImage.urlImg = [NSURL URLWithString:STR_CAT(URL_BASE, STR_CAT(dicEnum[@"imgUrlSub"], @".jpg"))];
            [_arrJXImages addObject:jxImage];
        }
        
        
        // xib 下数值
        CGFloat     wScreen     = [UIScreen mainScreen].bounds.size.width;
        NSInteger   numTotal    = self.arrMinUrls.count;
        const NSInteger xibH_cell = 170;                              // cell 的高
        const NSInteger xibWH_cellImg = 50;                           // 图片 cell 的高宽
        const NSInteger xibS_for_cell = 5;                            // 图片 cell 的间距
        const NSInteger xibS_for_line = 5;                            // 图片 cell 的行距
        const NSInteger xibH_collView = 80;                           // collView 的高
        const NSInteger N_Per_Line =  wScreen == 320.f ? 4 : wScreen == 375.f ? 5 : 6; // 不同屏幕每行个数
        
        // 待计算数值
        CGFloat h_collView;                                     // collView 的高
        CGFloat w_collView;                                     // collView 宽
        
        // 如果评论没有图片
        if (numTotal == 0) {
            h_collView = 0; w_collView = 0;
        }
        else {
            NSInteger lineNum = (numTotal / N_Per_Line + (numTotal % N_Per_Line == 0 ? 0 : 1));
            // 一行
            if (lineNum == 1) {
                h_collView = xibWH_cellImg;
                w_collView = (xibWH_cellImg + xibS_for_cell) * numTotal - xibS_for_cell;
            }
            // 大于一行
            else {
                h_collView = (xibWH_cellImg + xibS_for_line) * lineNum - xibS_for_line;
                w_collView = (xibWH_cellImg + xibS_for_cell) * N_Per_Line - xibS_for_cell;
            }
        }
        
        _hCollView = (NSInteger)h_collView + 1;
        _wCollView = (NSInteger)w_collView + 1;
        _hCell = ceil(xibH_cell - xibH_collView + h_collView);

        
        
        
    }
    return self;
}

@end
