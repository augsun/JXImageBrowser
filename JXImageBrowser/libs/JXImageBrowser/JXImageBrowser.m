//
//  JXImageViewer.m
//  JXImageBrowser
//
//  Created by CoderSun on 4/21/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXImageBrowser.h"
#import "UIImageView+WebCache.h"

//#define JX_IMAGE_BROWSER_DEALLOC_TEST   - (void)dealloc { NSLog(@"dealloc -> %@",NSStringFromClass([self class])); }

#define SPA_INTERITEM               15          //
#define PROG_BG_RADIUS              78.f        //
#define PROG_SHAP_W                 4.f         //
#define PROG_SHAP_RADIUS            15.f        //
#define PROG_SHAP_STROKE_END_DEF    .01f        //

#define ZOOM_SCALE_MAX              4.f
#define ZOOM_SCALE_DEF              1.f
#define ZOOM_SCALE_TAP              2.5f

#define ANIM_DURATION               .35f

#define JXIMAGE_VIEW_TAG            888

@interface JXImage ()

@property (nonatomic, assign)   NSInteger                       indexItem;
@property (nonatomic, assign)   BOOL                            isFirstGrace;
@property (nonatomic, assign)   CGFloat                         progressDownload;
@property (nonatomic, strong)   UIImage                         *imageMax;

@end

@implementation JXImage

- (instancetype)init {
    self = [super init];
    if (self) {
        _progressDownload = PROG_SHAP_STROKE_END_DEF;
    }
    return self;
}

//JX_IMAGE_BROWSER_DEALLOC_TEST

@end

@protocol JXImageViewDelegate <NSObject>
@required
- (void)jxImageViewSingleTap;
- (void)jxImageViewDidZoomOut;
- (void)jxImageViewLongPress;
@end

@interface JXImageView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak)     id<JXImageViewDelegate>         delegate;
@property (nonatomic, strong)   JXImage                         *jxImage;
- (void)reFrameImageView;

@end

@interface JXImageView ()

@property (nonatomic, strong)   UIScrollView                    *scrollView;
@property (nonatomic, strong)   UIImageView                     *imgView;
@property (nonatomic, assign)   CGFloat                         *progressDownload;
@property (nonatomic, strong)   CALayer                         *layerHUD;
@property (nonatomic, strong)   CAShapeLayer                    *layerCircle;
@property (nonatomic, assign)   BOOL                            isZoomingIn;

@property (nonatomic, assign)   CGFloat                         wSelf;
@property (nonatomic, assign)   CGFloat                         hSelf;

@end

@implementation JXImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //
        [self setClipsToBounds:YES];
        [self setWSelf:self.frame.size.width];
        [self setHSelf:self.frame.size.height];
        
        //
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setMaximumZoomScale:3.f];
        [_scrollView setMinimumZoomScale:1.f];
        
        //
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.scrollView addSubview:_imgView];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
        [_imgView setUserInteractionEnabled:YES];
        [_imgView setClipsToBounds:YES];
        
        //
        _layerHUD = [CALayer layer];
        [self.layer addSublayer:_layerHUD];
        [_layerHUD setCornerRadius:10.f];
        [_layerHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.8f].CGColor];
        [_layerHUD setFrame:CGRectMake((self.frame.size.width - PROG_BG_RADIUS)/2,
                                       (self.frame.size.height - PROG_BG_RADIUS)/2,
                                       PROG_BG_RADIUS,
                                       PROG_BG_RADIUS)];
        
        CGRect rectCircle = CGRectMake((PROG_BG_RADIUS - PROG_SHAP_RADIUS*2) / 2,
                                       (PROG_BG_RADIUS - PROG_SHAP_RADIUS*2) / 2,
                                       PROG_SHAP_RADIUS * 2,
                                       PROG_SHAP_RADIUS * 2);
        
        //
        CAShapeLayer *circleLayerBg = [CAShapeLayer layer];
        [self.layerHUD addSublayer:circleLayerBg];
        [circleLayerBg setPath:[UIBezierPath bezierPathWithRoundedRect:rectCircle cornerRadius:PROG_SHAP_RADIUS].CGPath];
        [circleLayerBg setStrokeColor:[[UIColor alloc] initWithWhite:1.f alpha:.1f].CGColor];
        [circleLayerBg setFillColor:nil];
        [circleLayerBg setLineWidth:PROG_SHAP_W];
        [circleLayerBg setStrokeEnd:1.f];
        
        //
        _layerCircle = [CAShapeLayer layer];
        [self.layerHUD addSublayer:_layerCircle];
        [_layerCircle setPath:[UIBezierPath bezierPathWithRoundedRect:rectCircle cornerRadius:PROG_SHAP_RADIUS].CGPath];
        [_layerCircle setStrokeColor:[[UIColor alloc] initWithWhite:1.f alpha:1.f].CGColor];
        [_layerCircle setFillColor:nil];
        [_layerCircle setLineWidth:PROG_SHAP_W];
        [_layerCircle setLineCap:kCALineCapRound];
        [_layerCircle setLineJoin:kCALineJoinRound];
        [_layerCircle setStrokeEnd:PROG_SHAP_STROKE_END_DEF];
        
        //
        UITapGestureRecognizer *gesSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesSingleTap:)];
        UITapGestureRecognizer *gesDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesDoubleTap:)];
        UILongPressGestureRecognizer *gesLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gesLongPress:)];
        [gesDoubleTap setNumberOfTapsRequired:2];
        [gesSingleTap requireGestureRecognizerToFail:gesDoubleTap];
        [self addGestureRecognizer:gesSingleTap];
        [self addGestureRecognizer:gesDoubleTap];
        [self addGestureRecognizer:gesLongPress];
        
        
        
    }
    return self;
}

- (void)setJxImage:(JXImage *)jxImage {
    _jxImage = jxImage;
    
    self.scrollView.zoomScale = ZOOM_SCALE_DEF;
    if (jxImage.imageMax) {
        self.layerHUD.hidden = YES;
        self.imgView.image = jxImage.imageMax;
        [self reFrameImageView];
    }
    else {
        self.layerHUD.hidden = NO;
        self.layerCircle.strokeEnd = self.jxImage.progressDownload;
        self.imgView.image = jxImage.imageViewFrom.image;
        [self reFrameImageView];
        [[SDWebImageManager sharedManager] downloadImageWithURL:self.jxImage.urlImg options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat percent = 1.f * receivedSize / expectedSize;
            if (self.jxImage.indexItem == jxImage.indexItem && self.jxImage.progressDownload < percent) {
                self.layerCircle.strokeEnd = percent;
            }
            else {
                if (jxImage.progressDownload < percent) {
                    jxImage.progressDownload = percent;
                }
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image && finished) {
                jxImage.imageMax = image;
                if (self.jxImage.indexItem == jxImage.indexItem) {
                    self.layerHUD.hidden = YES;
                    self.imgView.image = image;
                    if (!self.isZoomingIn) {
                        [self reFrameImageView];
                    }
                }
            }
        }];
    }
}

- (void)reFrameImageView {
    CGFloat wImage = self.imgView.image.size.width;
    CGFloat hImage = self.imgView.image.size.height;
    self.scrollView.zoomScale = 1.f;
    if (wImage > 0 && hImage > 0) {
        CGFloat rImage = wImage / hImage;
        CGFloat rSelf = _wSelf / _hSelf;
        
        CGRect imageViewFrame = CGRectZero;
        if (rImage < rSelf) {
            imageViewFrame = CGRectMake((_wSelf - _hSelf * rImage) / 2, 0, _hSelf * rImage, _hSelf);
        }
        else {
            imageViewFrame = CGRectMake(0, (_hSelf - _wSelf / rImage) / 2, _wSelf, _wSelf / rImage);
        }
        self.scrollView.contentSize = imageViewFrame.size;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.maximumZoomScale = self.jxImage.imageMax ? ZOOM_SCALE_MAX : 1.f;
        
        if (self.jxImage.isFirstGrace) {
            self.isZoomingIn = YES;
            self.layerHUD.hidden = YES;
            self.jxImage.isFirstGrace = NO;
            if (self.jxImage.imageViewFrom) {
                UIImage *imgTemp = self.jxImage.imageViewFrom.image;
                self.jxImage.imageViewFrom.image = nil;
                self.imgView.frame = [self.jxImage.imageViewFrom convertRect:self.jxImage.imageViewFrom.bounds toView:nil];
                
                [UIView animateWithDuration:ANIM_DURATION animations:^{
                    self.imgView.frame = imageViewFrame;
                } completion:^(BOOL finished) {
                    self.isZoomingIn = NO;
                    if (self.jxImage.imageMax) {
                        [self reFrameImageView];
                    }
                    else {
                        self.layerHUD.hidden = NO;
                    }
                    if (!self.jxImage.imageViewFrom.image) {
                        self.jxImage.imageViewFrom.image = imgTemp;
                    }
                }];
            }
            else {
                self.imgView.alpha = .0f;
                self.imgView.frame = imageViewFrame;
                [UIView animateWithDuration:ANIM_DURATION animations:^{
                    self.imgView.alpha = 1.f;
                } completion:^(BOOL finished) {
                    self.isZoomingIn = NO;
                    if (self.jxImage.imageMax) {
                        [self reFrameImageView];
                    }
                    else {
                        self.layerHUD.hidden = NO;
                    }
                }];
            }
        }
        else {
            self.imgView.frame = imageViewFrame;
        }
    }
    else {
        if (self.jxImage.imageViewFrom && self.jxImage.isFirstGrace) {
            self.jxImage.isFirstGrace = NO;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = self.imgView.frame;
    if (self.imgView.image.size.width / self.imgView.image.size.height < _wSelf / _hSelf) {
        imageViewFrame.origin.x = imageViewFrame.size.width > _wSelf ? .0f : (_wSelf - imageViewFrame.size.width) / 2.0;
    }
    else {
        imageViewFrame.origin.y = imageViewFrame.size.height > _hSelf ? .0f : (_hSelf - imageViewFrame.size.height) / 2.0;
    }
    self.imgView.frame = imageViewFrame;
}

- (void)gesSingleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(jxImageViewSingleTap)]) {
        self.layerHUD.hidden = YES;
        [self.delegate jxImageViewSingleTap];
        if (self.jxImage.imageViewFrom) {
            UIImage *imgTemp = self.jxImage.imageViewFrom.image;
            self.jxImage.imageViewFrom.image = nil;
            if (self.jxImage.imageMax) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.18f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.imgView.image = imgTemp;
                });
            }
            
            [UIView animateWithDuration:ANIM_DURATION animations:^{
                self.imgView.frame = [self.jxImage.imageViewFrom.superview convertRect:self.jxImage.imageViewFrom.frame toView:self.scrollView];
            } completion:^(BOOL finished) {
                if (!self.jxImage.imageViewFrom.image) {
                    self.jxImage.imageViewFrom.image = imgTemp;
                }
                if ([self.delegate respondsToSelector:@selector(jxImageViewDidZoomOut)]) {
                    [self.delegate jxImageViewDidZoomOut];
                }
            }];
        }
        else {
            [UIView animateWithDuration:ANIM_DURATION animations:^{
                self.imgView.alpha = .0f;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(jxImageViewDidZoomOut)]) {
                    [self.delegate jxImageViewDidZoomOut];
                }
            }];
        }
    }
}

- (void)gesDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.jxImage.imageMax) {
        CGPoint touchPoint = [tap locationInView:self.imgView];
        if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        } else {
            CGFloat wNewRect = self.wSelf / ZOOM_SCALE_TAP;
            CGFloat hNewRect = self.hSelf / ZOOM_SCALE_TAP;
            [self.scrollView setZoomScale:1.f];
            [self.scrollView zoomToRect:CGRectMake(touchPoint.x - wNewRect / 2.f,
                                                   touchPoint.y - hNewRect / 2.f,
                                                   wNewRect,
                                                   hNewRect)
                               animated:YES];
        }
    }
}

- (void)gesLongPress:(UILongPressGestureRecognizer *)logGesture {
    if (self.jxImage.imageMax &&
        logGesture.state == UIGestureRecognizerStateBegan &&
        [self.delegate respondsToSelector:@selector(jxImageViewLongPress)]) {
        [self.delegate jxImageViewLongPress];
    }
}

//JX_IMAGE_BROWSER_DEALLOC_TEST

@end

@interface JXImageBrowser ()

<
UIScrollViewDelegate,
JXImageViewDelegate
>

@property (nonatomic, strong)   NSArray <JXImage *>             *arrImages;

@property (nonatomic, assign)   NSUInteger                      currentIndex;
@property (nonatomic, assign)   NSInteger                       numberImages;

@property (nonatomic, strong)   UIScrollView                    *scrollView;
@property (nonatomic, strong)   UIPageControl                   *pageCtl;

@property (nonatomic, assign)   CGFloat                         wSelf;
@property (nonatomic, assign)   CGFloat                         hSelf;

@property (nonatomic, strong)   NSMutableArray <JXImageView *>  *arrImageViews;
@property (nonatomic, assign)   CGFloat                         xOffsetPre;

@end

@implementation JXImageBrowser

+ (void)browseImages:(NSArray <JXImage *> *)jxImages fromIndex:(NSInteger)fromIndex {
    if (fromIndex < 0 || fromIndex >= jxImages.count) {
        return;
    }
    
    for (NSInteger i = 0; i < jxImages.count; i ++) {
        jxImages[i].indexItem = i;
        jxImages[i].isFirstGrace = i == fromIndex;
        NSLog(@"%d", jxImages[i].isFirstGrace);
    }
    
    JXImageBrowser *imageBrowser = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageBrowser.arrImages = jxImages;
    imageBrowser.currentIndex = fromIndex;
    imageBrowser.numberImages = jxImages.count;
    
    imageBrowser.backgroundColor = [UIColor clearColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageBrowser];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:ANIM_DURATION animations:^{
        imageBrowser.backgroundColor = [UIColor blackColor];
    }];
    
    [imageBrowser createComponents];
}

- (void)createComponents {
    [self setWSelf:self.bounds.size.width];
    [self setHSelf:self.bounds.size.height];
    [self setArrImageViews:[[NSMutableArray alloc] init]];
    
    //
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _wSelf + SPA_INTERITEM, _hSelf)];
    [self addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(self.numberImages * (_wSelf + SPA_INTERITEM), _hSelf)];
    [_scrollView setContentOffset:CGPointMake(self.currentIndex * (_wSelf + SPA_INTERITEM), 0)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setAlwaysBounceHorizontal:YES];
    [_scrollView setAlwaysBounceVertical:NO];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setScrollsToTop:NO];
    [_scrollView setDelegate:self];
    [_scrollView setBounces:YES];
    
    NSInteger fromIndexRefresh = 0;
    NSInteger imageViewCount = (self.numberImages > 2 ? 3 : self.numberImages);
    
    if (self.currentIndex == 0) {
        fromIndexRefresh = 0;
    }
    else if (self.numberImages - self.currentIndex < imageViewCount) {
        fromIndexRefresh = self.numberImages - imageViewCount;
    }
    else {
        fromIndexRefresh = self.currentIndex - 1;
    }
    
    for (NSInteger i = 0; i < imageViewCount; i ++) {
        CGRect rectImageView = CGRectMake((fromIndexRefresh + i) * (_wSelf + SPA_INTERITEM), 0, _wSelf, _hSelf);
        JXImageView *jxImageView = [[JXImageView alloc] initWithFrame:rectImageView];
        [self.scrollView addSubview:jxImageView];
        [jxImageView setDelegate:self];
        [self.arrImageViews addObject:jxImageView];
        jxImageView.jxImage = self.arrImages[fromIndexRefresh + i];
    }
    
    //
    _pageCtl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _hSelf - 50, _wSelf, 50)];
    [self addSubview:_pageCtl];
    [_pageCtl setNumberOfPages:self.numberImages];
    [_pageCtl setCurrentPage:self.currentIndex];
    [_pageCtl setUserInteractionEnabled:NO];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    NSInteger pageNow = (scrollView.contentOffset.x + (self.wSelf + SPA_INTERITEM)*.5f) / (self.wSelf + SPA_INTERITEM);
    
    if (self.numberImages > 3 && self.currentIndex != pageNow && pageNow < self.numberImages - 1 && pageNow > 0) {
        if (pageNow > self.currentIndex && pageNow > 1 && pageNow < self.numberImages) {
            JXImageView *imgViewTemp = [self.arrImageViews firstObject];
            [self.arrImageViews removeObjectAtIndex:0];
            [self.arrImageViews addObject:imgViewTemp];
            
            CGRect rectTemp = imgViewTemp.frame;
            rectTemp.origin.x += 3 * (self.wSelf + SPA_INTERITEM);
            imgViewTemp.frame = rectTemp;
            
            self.arrImageViews[2].jxImage = self.arrImages[self.currentIndex + 2];
        }
        
        if (pageNow < self.currentIndex && pageNow > 0 && pageNow < self.numberImages-2) {
            JXImageView *imgViewTemp = [self.arrImageViews lastObject];
            [self.arrImageViews removeLastObject];
            [self.arrImageViews insertObject:imgViewTemp atIndex:0];
            
            CGRect rectTemp = imgViewTemp.frame;
            rectTemp.origin.x -= 3 * (self.wSelf + SPA_INTERITEM);
            imgViewTemp.frame = rectTemp;
            
            self.arrImageViews[0].jxImage = self.arrImages[self.currentIndex - 2];
        }
    }
    
    if (fabs(xOffset - self.xOffsetPre) >= (self.wSelf + SPA_INTERITEM)) {
        if (pageNow == 0 || (pageNow == self.numberImages - 1 && self.numberImages > 2)) {
            [self.arrImageViews[1] reFrameImageView];
        }
        else {
            [self.arrImageViews[xOffset - self.xOffsetPre > 0 ? 0 : 2] reFrameImageView];
        }
        self.xOffsetPre = pageNow * (self.wSelf + SPA_INTERITEM);
    }
    
    if (self.currentIndex != pageNow) {
        self.currentIndex = pageNow < self.numberImages ? (pageNow > 0 ? pageNow : 0) : self.numberImages - 1;
        self.pageCtl.currentPage = self.currentIndex;
    }
}

- (void)jxImageViewSingleTap {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:ANIM_DURATION animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.pageCtl.alpha = .0f;
    }];
}

- (void)jxImageViewDidZoomOut {
    [self removeFromSuperview];
}

- (void)jxImageViewLongPress {
    self.userInteractionEnabled = NO;
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionSave = [UIAlertAction actionWithTitle:@"保存到手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.arrImages[self.currentIndex].imageMax, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.userInteractionEnabled = YES;
    }];
    [alertCtl addAction:actionSave];
    [alertCtl addAction:actionCancel];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    [window setRootViewController:[[UIViewController alloc] init]];
    [window.rootViewController presentViewController:alertCtl animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    CGFloat sideHUD = 100.f;
    CGFloat hTick = 50.f;
    CGFloat hText = 30.f;
    UIView *viewHUD = [[UIView alloc] initWithFrame:CGRectMake((self.wSelf - sideHUD)/2, (self.hSelf - sideHUD)/2, sideHUD, sideHUD)];
    [viewHUD setAlpha:.0f];
    [self addSubview:viewHUD];
    [viewHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.8f]];
    [viewHUD setClipsToBounds:YES];
    [viewHUD.layer setCornerRadius:10.f];
    
    UILabel *lblTick = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, sideHUD, hTick)];
    [viewHUD addSubview:lblTick];
    [lblTick setTextAlignment:NSTextAlignmentCenter];
    [lblTick setTextColor:[UIColor whiteColor]];
    [lblTick setText:error ? @"✕" : @"✓"];
    [lblTick setFont:[UIFont systemFontOfSize:50]];
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(0, sideHUD - hText - 10, sideHUD, hText)];
    [viewHUD addSubview:lblText];
    [lblText setTextAlignment:NSTextAlignmentCenter];
    [lblText setTextColor:[UIColor whiteColor]];
    [lblText setText:error ? @"保存失败" : @"保存成功"];
    [lblText setFont:[UIFont boldSystemFontOfSize:16]];
    
    [UIView animateWithDuration:.25f animations:^{
        viewHUD.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3f delay:1.2f options:0 animations:^{
            viewHUD.alpha = .0f;
        } completion:^(BOOL finished) {
            [viewHUD removeFromSuperview];
            self.userInteractionEnabled = YES;
        }];
    }];
}

//JX_IMAGE_BROWSER_DEALLOC_TEST

@end









