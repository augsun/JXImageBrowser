//
//  SBAllCommentCell.m
//  JXImageBrowser
//
//  Created by shiba_iosJX on 11/3/15.
//  Copyright © 2015 ShiBa. All rights reserved.
//

#import "JXMomentCell.h"
#import "JXMomentImageCell.h"

#import "JXImageBrowser.h"
#import <UIImageView+WebCache.h>

@interface JXMomentCell ()

<
UICollectionViewDelegate,
UICollectionViewDataSource
>

// 属性
@property (weak, nonatomic) IBOutlet UILabel            *lblName;               // 用户昵称
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;        // 图片

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_collectionView; // 图片collectionView的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width_collectionView;  // 图片collectionView的宽

//

@end

@implementation JXMomentCell

- (void)awakeFromNib {
    [self setLayoutMargins:UIEdgeInsetsZero];
    [self setSeparatorInset:UIEdgeInsetsZero];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JXMomentImageCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// ====================================================================================================
#pragma mark -


- (void)setModel:(JXMomentModel *)model {
    _model = model;
    
    _height_collectionView.constant = self.model.hCollView;
    _width_collectionView.constant = self.model.wCollView;
    
    [self.collectionView reloadData];

    // 昵称
    _lblName.text = _model.strUserName;
    
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.arrMinUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXMomentImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    JXImage *jxImage = self.model.arrJXImages[indexPath.item];
    [cell.imgView sd_setImageWithURL:self.model.arrMinUrls[indexPath.item]
                    placeholderImage:nil
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.imgView.image = image;
        jxImage.imageViewFrom = cell.imgView;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [JXImageBrowser browseImages:self.model.arrJXImages fromIndex:indexPath.item];
}

@end








