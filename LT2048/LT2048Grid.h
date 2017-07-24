//
//  LT2048Grid.h
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT2048Cell.h"

@class LT2048Scene;

typedef void (^IteratorBlock)(LT2048Position);


@interface LT2048Grid : NSObject

@property (nonatomic, assign, readonly) NSInteger dimension;

@property (nonatomic, weak) LT2048Scene *scene;


- (instancetype)initWithDimension:(NSInteger)dimension;

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse;

- (LT2048Cell *)cellAtPosition:(LT2048Position)position;

- (LT2048Tile *)tileAtPosition:(LT2048Position)position;

- (BOOL)hasAvailableCells;

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay;

- (void)removeAllTilesAnimated:(BOOL)animated;

@end
