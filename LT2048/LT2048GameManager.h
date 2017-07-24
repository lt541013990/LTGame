//
//  LT2048GameManager.h
//  LT2048
//
//  Created by lt on 2017/7/24.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LT2048Scene;
@class LT2048Grid;

typedef NS_ENUM(NSInteger, LT2048Direction) {
    LT2048DirectionUp,
    LT2048DirectionLeft,
    LT2048DirectionDown,
    LT2048DirectionRight
};

@interface LT2048GameManager : NSObject

- (void)startNewSessionWithScene:(LT2048Scene *)scene;

- (void)moveToDirection:(LT2048Direction)direction;

@end
