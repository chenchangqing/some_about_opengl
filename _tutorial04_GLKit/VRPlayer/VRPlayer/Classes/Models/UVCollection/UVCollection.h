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

- (void)collection:(UVCollection *)collection modelViewMatrixAtIndexPath:(UVIndexPath *)indexPath;

@end

/**
 *  UVCollection
 */
@interface UVCollection : UVSquare

@property (nonatomic, assign) float rowCount;
@property (nonatomic, assign) float columnCount;

@property (nonatomic) float horizontalMargin;
@property (nonatomic) float verticalMargin;

@property (nonatomic) float rowSpace;
@property (nonatomic) float columnSpace;

@property (nonatomic, weak) id <UVCollectionDataSource> dataSource;
@property (nonatomic, weak) id <UVCollectionDelegate> delegate;

@end