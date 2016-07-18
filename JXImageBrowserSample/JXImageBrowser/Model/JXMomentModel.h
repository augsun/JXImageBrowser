//
//  JXMomentModel.h
//  JXImageBrowser
//
//  Created by CoderSun on 4/3/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXImageBrowser.h"

#define S_COLL_TO_TOP       78.f
#define S_COLL_TO_LEFT      66.f
#define S_COLL_TO_BOTTOM    12.f

#define WH_COLL_CELL        50.f
#define S_COLL_INTERITEM    5.f
#define S_COLL_LINE         5.f

@interface JXMomentModel : NSObject

@property (nonatomic, copy)     NSString                    *strUserName;
@property (nonatomic, strong)   NSMutableArray <NSURL *>    *arrMinUrls;
@property (nonatomic, strong)   NSMutableArray <JXImage *>  *arrJXImages;

@property (nonatomic, assign)   CGFloat                     hCollView;
@property (nonatomic, assign)   CGFloat                     wCollView;
@property (nonatomic, assign)   CGFloat                     hCell;

- (JXMomentModel *)initWithDic:(NSDictionary *)dic;

@end









