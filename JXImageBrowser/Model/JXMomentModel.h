//
//  JXMomentModel.h
//  JXImageBrowser
//
//  Created by shiba_iosJX on 5/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXImageBrowser.h"

#define H_IMG_CELL              50.f
#define W_IMG_CELL              50.f
#define S_FOR_CELL          5.f
#define S_FOR_LINE          5.f

@interface JXMomentModel : NSObject

@property (nonatomic, copy)     NSString                    *strUserName;
@property (nonatomic, strong)   NSMutableArray <NSURL *>    *arrMinUrls;
@property (nonatomic, strong)   NSMutableArray <JXImage *>  *arrJXImages;

@property (nonatomic, assign)   CGFloat                     hCollView;          // collectionView高
@property (nonatomic, assign)   CGFloat                     wCollView;          // collectionView宽
@property (nonatomic, assign)   CGFloat                     hCell;              // cell高

- (JXMomentModel *)initWithDic:(NSDictionary *)dic;

@end
