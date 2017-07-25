//
//  LT2048GameManager.m
//  LT2048
//
//  Created by lt on 2017/7/24.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048GameManager.h"
#import "LT2048Grid.h"
#import "LT2048Scene.h"
#import "LT2048ViewController.h"
#import "LT2048Tile.h"

BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower){
    return countUp ? value < upper : value > lower;
}

@implementation LT2048GameManager{
    BOOL _over;
    
    BOOL _won;
    
    BOOL _keepPlaying;
    
    NSInteger _score;
    
    NSInteger _pendingScore;
    
    LT2048Grid *_grid;
    
    CADisplayLink *_addTileDisplayLink;
}

# pragma mark - Setup

- (void)startNewSessionWithScene:(LT2048Scene *)scene
{
    if (_grid) {
        [_grid removeAllTilesAnimated:NO];
    }
    if (!_grid || _grid.dimension != GSTATE.dimension) {
        _grid = [[LT2048Grid alloc] initWithDimension:GSTATE.dimension];;
        _grid.scene = scene;
    }
    
    [scene loadBoardWithGrid:(_grid)];
    
    _score = 0; _over = NO; _won = NO; _keepPlaying = NO;
    
    _addTileDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addTwoRandomTiles)];
    [_addTileDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)addTwoRandomTiles
{
    if (_grid.scene.children.count <= 1) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_addTileDisplayLink invalidate];
    }
}

- (void)moveToDirection:(LT2048Direction)direction
{
    __block LT2048Tile *tile = nil;
    
    BOOL reverse = direction == LT2048DirectionUp || direction == LT2048DirectionRight;
    NSInteger unit = reverse ? 1 : -1;
    
    if (direction == LT2048DirectionUp || direction == LT2048DirectionDown) {
        [_grid forEach:^(LT2048Position position) {
            if ((tile = [_grid tileAtPosition:position])) {
            
                NSInteger target = position.x;
                for (NSInteger i = position.x + unit; iterate(i, reverse, _grid.dimension, -1); i += unit)
                {
                    LT2048Tile *t = [_grid tileAtPosition:LT2048PositionMake(i, position.y)];
                    
                    if (!t) {
                        target = i;
                    } else {
                        NSInteger level = 0;
                        
                        if (GSTATE.gameType == LTGameTypePowerOf3) {
                            LT2048Position further = LT2048PositionMake(i + unit, position.y);
                            LT2048Tile *ft = [_grid tileAtPosition:further];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.x;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        
                        break;
                    }
                }
                
                if (target != position.x) {
                    [tile moveToCell:[_grid cellAtPosition:LT2048PositionMake(target, position.y)]];
                    _pendingScore++;
                }
            }
        }reverseOrder:reverse];
            
    } else {
        [_grid forEach:^(LT2048Position position){
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.y;
                for (NSInteger i = position.y + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    LT2048Tile *t = [_grid tileAtPosition:LT2048PositionMake(position.x, i)];
                    
                    if (!t) {
                        target = i;
                    } else {
                        NSInteger level = 0;
                        
                        if (GSTATE.gameType == LTGameTypePowerOf3) {
                            LT2048Position further = LT2048PositionMake(position.x, i + unit);
                            LT2048Tile *ft = [_grid tileAtPosition:further];
                            if (ft) {
                                level = [tile mergeToTile:t];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.y;
                            _pendingScore = [GSTATE valueForLevel:level];
                        }
                        
                        break;
                    }
                }
                
                if (target != position.y) {
                    [tile moveToCell:[_grid cellAtPosition:LT2048PositionMake(position.x, target)]];
                    _pendingScore++;
                }
            }
        }reverseOrder:reverse];
        
    }
    
    if (!_pendingScore) {
        return;
    }
    
    [_grid forEach:^(LT2048Position position) {
        LT2048Tile *tile = [_grid tileAtPosition:position];
        if (tile) {
            [tile commitPendingActions];
            if (tile.level >= GSTATE.winninglevel) {
                _won = YES;
            }
        }
    }reverseOrder:reverse];
    
    [self materializePendingScore];
    
    if (!_keepPlaying && _won) {
        _keepPlaying = YES;
        [_grid.scene.controller endGame:YES];
    }
    
    [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    if (GSTATE.dimension == 5 && GSTATE.gameType == LTGameTypePowerOf2) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    }
    
    if (![self moveAvailable]) {
        [_grid.scene.controller endGame:NO];
    }

}

# pragma mark - Score

- (void)materializePendingScore
{
    _score += _pendingScore;
    _pendingScore = 0;
    [_grid.scene.controller updateScore:_score];
}

# pragma mark - State checkers

- (BOOL)moveAvailable
{
    return [_grid hasAvailableCells] || [self adjacentMatchesAvailable];
}

- (BOOL)adjacentMatchesAvailable
{
    for (NSInteger i = 0; i < _grid.dimension; i++) {
        for (NSInteger j = 0; j < _grid.dimension; j++) {
            LT2048Tile *tile = [_grid tileAtPosition:LT2048PositionMake(i, j)];
            
            if (!tile) {
                continue;
            }
            
            if (GSTATE.gameType == LTGameTypePowerOf3) {
                if (([tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i + 1, j)]] &&
                    [tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i + 2, j)]]) ||
                    ([tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i, j + 1)]] &&
                    [tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i, j + 2)]])) {
                    return YES;
                }
            } else {
                if ([tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i + 1, j)]] ||
                    [tile canMergeWithTile:[_grid tileAtPosition:LT2048PositionMake(i, j + 1)]]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end
