//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBAsset;


@interface OBAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) OBAsset *asset;


@property (nonatomic, strong) UIImageView *imageView;
@end