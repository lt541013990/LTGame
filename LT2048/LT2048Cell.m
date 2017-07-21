//
//  LT2048Cell.m
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048Cell.h"
#import "LT2048Tile.h"

@implementation LT2048Cell

- (instancetype)initWithPosition:(LT2048Position)position
{
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}

- (void)setTile:(LT2048Tile *)tile
{
    _tile = tile;
    if (tile) {
        tile.cell = self;
    }
}

@end
