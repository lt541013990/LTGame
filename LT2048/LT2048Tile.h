//
//  LT2048Tile.h
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class LT2048Cell;

@interface LT2048Tile : SKShapeNode

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, weak) LT2048Cell *cell;

+ (LT2048Tile *)insertNewTileToCell:(LT2048Cell *)cell;

- (void)commitPendingActions;

- (BOOL)canMergeWithTile:(LT2048Tile *)tile;

- (NSInteger)mergeToTile:(LT2048Tile *)tile;

- (NSInteger)merge3ToTile:(LT2048Tile *)tile andTile:(LT2048Tile *)furtherTile;

- (void)moveToCell:(LT2048Cell *)cell;

- (void)removeAnimated:(BOOL)animated;

@end
