//
//  UVCollection.h
//  Pods
//
//  Created by green on 16/5/24.
//
//

#import <VRPlayer/VRPlayer.h>

@interface UVCollection : UVSquare

@property (nonatomic, assign) float rowCount;
@property (nonatomic, assign) float columnCount;

@property (nonatomic) float margin;
@property (nonatomic) float padding;

@property (nonatomic) float rowSpace;
@property (nonatomic) float columnSpace;

@end