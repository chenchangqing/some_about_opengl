//
//  JTHotspotView.h
//  Pods
//
//  Created by green on 16/5/17.
//
//

#import "HotspotItem.h"

@interface JTHotspotView : UIView

/**
 *  增加热点
 */
- (void)addHotspot: (HotspotItem *)item;

/**
 *  删除热点
 */
- (void)removeHotspot: (HotspotItem *)item;

/**
 *  清空热点
 */
- (void)clearHotspots;

@end
