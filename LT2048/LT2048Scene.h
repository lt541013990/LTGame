//
//  LT2048Scene.h
//  LT2048
//
//  Created by lt on 2017/7/24.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class LT2048Grid;
@class LT2048ViewController;

@interface LT2048Scene : SKScene

- (void)startNewGame;

- (void)loadBoardWithGrid:(LT2048Grid *)grid;

@end
