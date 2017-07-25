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
    
    [grid forEach:^(LT2048Position position) {
        CALayer *layer = [CALayer layer];
        CGPoint point = [GSTATE locationOfPosition:position];
        
        CGRect frame = layer.frame;
        frame.size = CGSizeMake(GSTATE.titleSize, GSTATE.titleSize);
        frame.origin = CGPointMake(point.x, SCREEN_HEIGHT - point.y - GSTATE.titleSize);
        layer.frame = frame;
        
        layer.backgroundColor = [GSTATE boardColor].CGColor;
        layer.cornerRadius = GSTATE.cornerRadius;
        layer.masksToBounds = YES;
        [backgroundView.layer addSublayer:layer];
    }reverseOrder:NO];
    
    return [LT2048GridView snapshotWithView:backgroundView];
}

+ (UIImage *)gridImageWithOverlay
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.opaque = NO;
    
    LT2048GridView *view = [[LT2048GridView alloc] init];
    view.backgroundColor = [[GSTATE backgroundColor] colorWithAlphaComponent:0.8];
    [backgroundView addSubview:view];
    
    return [LT2048GridView snapshotWithView:backgroundView];
}

+ (UIImage *)snapshotWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
