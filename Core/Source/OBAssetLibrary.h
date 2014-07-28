//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBCollection;

typedef void (^OBAssetLibraryCompletionBlock)(NSArray *result, NSError *error);


@protocol OBAssetLibrary <NSObject>

-	(void)fetchCollections:(OBAssetLibraryCompletionBlock)completion;
- (void)fetchAssetsForCollection:(OBCollection *)collection completion:(OBAssetLibraryCompletionBlock)completion;
@end