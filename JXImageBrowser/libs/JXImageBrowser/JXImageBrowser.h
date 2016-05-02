//
//  JXImageViewer.h
//  ShiBa
//
//  Created by shiba_iosJX on 4/21/16.
//  Copyright © 2016 ShiBa. All rights reserved.
//

#import <UIKit/UIKit.h>

// ====================================================================================================
#pragma mark - JXImage
NS_CLASS_AVAILABLE_IOS(8_0) @interface JXImage : NSObject

@property (nonatomic, strong) NSURL         *urlImg;            // 大图 url
@property (nonatomic, strong) UIImageView   *imageViewFrom;     // 来源 imgView

@end

// ====================================================================================================
#pragma mark - JXImageBrowser
NS_CLASS_AVAILABLE_IOS(8_0) @interface JXImageBrowser : UIView

+ (void)browseImages:(NSArray <JXImage *> *)jxImages fromIndex:(NSInteger)fromIndex;

@end
