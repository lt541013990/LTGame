//
//  LT2048GridView.m
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048GridView.h"
#import "LT2048Grid.h"

@implementation LT2048GridView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [GSTATE scoreBoardColor];
        self.layer.cornerRadius = GSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init
{
    CGFloat side = GSTATE.dimension * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
    CGFloat verticalOffset = SCREEN_HEIGHT - GSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(GSTATE.horizontalOffset, verticalOffset - side, side, side)];
}

+ (UIImage *)gridImageWithGrid:(LT2048Grid *)grid
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    backgroundView.backgroundColor = [GSTATE backgroundColor];
    
    LT2048GridView *view = [[LT2048GridView alloc] init];
    [backgroundView addSubview:view];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
