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

@property (nonatomic) float leftMargin;
@property (nonatomic) float rightMargin;
@property (nonatomic) float topMargin;
@property (nonatomic) float bottomMargin;

@property (nonatomic) float rowSpace;
@property (nonatomic) float columnSpace;

@end
