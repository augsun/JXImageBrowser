//
//  SBAllCommentCell.m
//  JXImageBrowser
//
//  Created by CoderSun on 4/3/16.
//  Copyright © 2015 CoderSun. All rights reserved.
//

#import "JXMomentCell.h"
#import "JXMomentImageCell.h"
#import <UIImageView+WebCache.h>

@interface JXMomentCell () <UICollectionViewDelegate, UICollectionViewDataSource>

// P
@property (weak, nonatomic) IBOutlet UIImageView        *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel            *lblName;
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;

// A

// C
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space_collViewToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space_collViewToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_collView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width_collView;

//

@end

@implementation JXMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UINib *nibCollCell = [UINib nibWithNibName:NSStringFromClass([JXMomentImageCell class]) bundle:nil];
    [_collectionView registerNib:nibCollCell forCellWithReuseIdentifier:@"collCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _space_collViewToTop.constant = S_COLL_TO_TOP;
    _space_collViewToLeft.constant = S_COLL_TO_LEFT;
}

#pragma mark
- (void)setModel:(JXMomentModel *)model {
    _model = model;
    
    _height_collView.constant = self.model.hCollView;
    _width_collView.constant = self.model.wCollView;
    
    _imgViewPortrait.image = [UIImage imageNamed:@"portrait"];
    _lblName.text = _model.strUserName;
    [self.collectionView reloadData];
}

#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.arrMinUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXMomentImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collCell" forIndexPath:indexPath];
    
    JXImage *jxImage = self.model.arrJXImages[indexPath.item];
    [cell.imgView sd_setImageWithURL:self.model.arrMinUrls[indexPath.item]
                    placeholderImage:nil
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.imgView.image = image;
        jxImage.imageViewFrom = cell.imgView;       // OPTIONAL
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [JXImageBrowser browseImages:self.model.arrJXImages fromIndex:indexPath.item];
}

@end









