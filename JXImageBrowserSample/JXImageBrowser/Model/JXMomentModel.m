//
//  JXModel.m
//  JXImageBrowser
//
//  Created by CoderSun on 4/3/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXMomentModel.h"

#define URL_BASE                @"https://raw.githubusercontent.com/augsun/Resources/master/JXImageBrowser/"
#define STR_CAT(str1, str2)     [NSString stringWithFormat:@"%@%@", str1, str2]

@implementation JXMomentModel

- (JXMomentModel *)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        //
        _strUserName = [dic objectForKey:@"user_name"];
        _arrMinUrls = [[NSMutableArray alloc] init];
        _arrJXImages = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dicEnum in [dic objectForKey:@"imgs"]) {
            [_arrMinUrls addObject:[NSURL URLWithString:STR_CAT(URL_BASE, STR_CAT(STR_CAT(dicEnum[@"imgUrlSub"], @".min"), @".jpg"))]];
            JXImage *jxImage = [[JXImage alloc] init];
            jxImage.urlImg = [NSURL URLWithString:STR_CAT(URL_BASE, STR_CAT(dicEnum[@"imgUrlSub"], @".jpg"))];
            [_arrJXImages addObject:jxImage];
        }
        
        //
        NSInteger           numTotal        = self.arrMinUrls.count;
        const CGFloat       W_screen        = [UIScreen mainScreen].bounds.size.width;
        const NSInteger     N_per_Line      =  W_screen == 320.f ? 4 : W_screen == 375.f ? 5 : 6;

        CGFloat h_collView;
        CGFloat w_collView;
        
        if (numTotal == 0) {
            h_collView = 0;
            w_collView = 0;
        }
        else {
            NSInteger lineNum = (numTotal / N_per_Line + (numTotal % N_per_Line == 0 ? 0 : 1));
            if (lineNum == 1) {
                h_collView = WH_COLL_CELL;
                w_collView = (WH_COLL_CELL + S_COLL_INTERITEM) * numTotal - S_COLL_INTERITEM;
            }
            else {
                h_collView = (WH_COLL_CELL + S_COLL_LINE) * lineNum - S_COLL_LINE;
                w_collView = (WH_COLL_CELL + S_COLL_INTERITEM) * N_per_Line - S_COLL_INTERITEM;
            }
        }
        
        _hCollView  = ceil(h_collView);
        _wCollView  = ceil(w_collView);
        _hCell      = ceil(S_COLL_TO_TOP + _hCollView + S_COLL_TO_BOTTOM);
    }
    return self;
}

@end









