//
//  UVCollection.h
//  Pods
//
//  Created by green on 16/5/24.
//
//

#import <VRPlayer/VRPlayer.h>
#import "UVIndexPath.h"

@class UVCollection;

/**
 *  UVCollection数据源
 */
@protocol UVCollectionDataSource<NSObject>
@required

- (float)numberOfRowsInCollection:(UVCollection *)collection;

- (float)numberOfColumnsInCollection:(UVCollection *)collection;

- (UVSquare *)collection:(UVCollection *)collection modelForItemAtIndexPath:(UVIndexPath *)indexPath;

@end

/**
 *  UVCollection委托
 */
@protocol UVCollectionDelegate<NSObject>
@optional

- (void)collection:(UVCollection *)collection modelViewMatrix:(GLKMatrix4)modelViewMatrix atIndexPath:(UVIndexPath *)indexPath;

- (float)horizontalMargin;
- (float)verticalMargin;
- (float)rowSpace;
- (float)columnSpace;

@end

/**
 *  UVCollection
 */
@interface UVCollection : UVSquare

@property (nonatomic, weak) id <UVCollectionDataSource> dataSource;
@property (nonatomic, weak) id <UVCollectionDelegate> delegate;

@end