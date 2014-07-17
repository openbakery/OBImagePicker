//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>


@interface OBCollection : NSObject



- (instancetype)initWithName:(NSString *)name image:(UIImage *)image numberOfAssets:(NSInteger)numberOfAssets;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSInteger numberOfAssets;

@end