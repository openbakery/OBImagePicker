//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ALAssetsGroupStub : ALAssetsGroup

@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *propertyType;
@property (nonatomic, strong) NSString *propertyPersistentID;
@property (nonatomic, strong) NSString *propertyURL;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;


@end