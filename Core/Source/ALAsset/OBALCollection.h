//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBCollection.h"

@class ALAssetsGroup;


@interface OBALCollection : OBCollection

- (instancetype)initWithALAssetsGroup:(ALAssetsGroup *)assetGroup;

- (ALAssetsGroup *)assetsGroups;
@end