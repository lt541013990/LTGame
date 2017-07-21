//
//  LT2048Cell.h
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LT2048Tile;

@interface LT2048Cell : NSObject

@property (nonatomic, assign) LT2048Position position;

@property (nonatomic, strong) LT2048Tile *tile;

- (instancetype)initWithPosition:(LT2048Position)position;

@end
