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

- (float)numberOfItemsInCollection:(UVCollection *)collection;

@end

/**
 *  UVCollection委托
 */
@protocol UVCollectionDelegate<NSObject>
@optional

- (void)collection:(UVCollection *)collection configureModel:(UVSquare *) model atIndexPath:(UVIndexPath *)indexPath;
- (void)collection:(UVCollection *)collection configureModelViewMatrixForModel:(UVSquare *) model atIndexPath:(UVIndexPath *)indexPath;

- (float)horizontalMargin:(UVCollection *)collection;
- (float)verticalMargin:(UVCollection *)collection;
- (float)rowSpace:(UVCollection *)collection;
- (float)columnSpace:(UVCollection *)collection;

@end

/**
 *  UVCollection
 */
@interface UVCollection : UVSquare

@property (nonatomic, weak) id <UVCollectionDataSource> dataSource;
@property (nonatomic, weak) id <UVCollectionDelegate> delegate;

@end