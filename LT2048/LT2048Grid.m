//
//  LT2048Grid.m
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048Grid.h"
#import "LT2048Tile.h"
#import "LT2048Scene.h"

@interface LT2048Grid ()

@property (nonatomic, assign, readwrite) NSInteger dimension;

@end


@implementation LT2048Grid {
    NSMutableArray *_gridArray;
}

- (instancetype)initWithDimension:(NSInteger)dimension
{
    if (self = [super init]) {
        _gridArray = [NSMutableArray arrayWithCapacity:dimension];
        
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[LT2048Cell alloc] initWithPosition:LT2048PositionMake(i, j)]];
            }
            [_gridArray addObject:array];
        }
        
        self.dimension = dimension;
    }
    
    return self;
}

# pragma mark - Iterator

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse
{
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++) {
            for (NSInteger j = 0; j < self.dimension; j++) {
                block(LT2048PositionMake(i, j));
            }
        }
    } else {
        for (NSInteger i = self.dimension - 1; i >= 0; i--) {
            for (NSInteger j = self.dimension - 1; j >= 0; j--) {
                block(LT2048PositionMake(i, j));
            }
        }
    }
}

# pragma mark - Position helpers

- (LT2048Cell *)cellAtPosition:(LT2048Position)position
{
    if (position.x >= self.dimension || position.y >= self.dimension || position.x < 0 || position.y < 0) {
        return nil;
    }
    return _gridArray[position.x][position.y];
}

- (LT2048Tile *)tileAtPosition:(LT2048Position)position
{
    LT2048Cell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

# pragma mark - Cell availability

- (BOOL)hasAvailableCells
{
    return [self availableCells].count != 0;
}

- (LT2048Cell *)randomAvailableCell
{
    NSArray *availableCells = [self availableCells];
    if (availableCells.count) {
        return availableCells[arc4random_uniform((int)availableCells.count)];
    }
    
    return nil;
}

- (NSArray *)availableCells
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.dimension * self.dimension];
    [self forEach:^(LT2048Position position){
        LT2048Cell *cell = [self cellAtPosition:position];
        if (!cell.tile) {
            [array addObject:cell];
        }
    }reverseOrder:NO];
    return array;
}

# pragma mark - Cell manipulation

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay
{
    LT2048Cell *cell = [self randomAvailableCell];
    if (cell) {
        LT2048Tile *tile = [LT2048Tile insertNewTileToCell:cell];
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:GSTATE.animationDuration * 3] : [SKAction waitForDuration:0];
        SKAction *move = [SKAction moveBy:CGVectorMake(- GSTATE.titleSize / 2, - GSTATE.titleSize / 2) duration:GSTATE.animationDuration];
        SKAction *scale = [SKAction scaleTo:1 duration:GSTATE.animationDuration];
        [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move,scale]]]]];
    }
}

- (void)removeAllTilesAnimated:(BOOL)animated
{
    [self forEach:^(LT2048Position position){
        LT2048Tile *tile = [self tileAtPosition:position];
        if (tile) {
            [tile removeAnimated:animated];
        }
    }reverseOrder:NO];
}

@end
