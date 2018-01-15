//
//  JXImageViewer.h
//  JXImageBrowser
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface JXImage : NSObject

@property (nonatomic, strong) NSURL *urlImg; // 图片的 url
@property (nonatomic, strong) UIImageView *imageViewFrom; // 图片的来源 imageView.(可不传)

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface JXImageBrowser : UIView

// images 将要显示的图片数组, fromIndex 最先显示的索引
+ (void)browseImages:(NSArray <JXImage *> *)images fromIndex:(NSInteger)fromIndex;

NS_ASSUME_NONNULL_END

@end















