//
//  LT2048Position.h
//  LT2048
//
//  Created by lt on 2017/7/20.
//  Copyright © 2017年 tl. All rights reserved.
//

#ifndef LT2048Position_h
#define LT2048Position_h

typedef struct Position {
    NSInteger x;
    NSInteger y;
} LT2048Position;

CG_INLINE LT2048Position LT2048PositionMake(NSInteger x, NSInteger y) {
    LT2048Position position;
    position.x = x;
    position.y = y;
    return position;
}

#endif /* LT2048Position_h */
