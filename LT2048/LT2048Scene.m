//
//  LT2048Scene.m
//  LT2048
//
//  Created by lt on 2017/7/24.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048Scene.h"
#import "LT2048GridView.h"
#import "LT2048GameManager.h"

#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@implementation LT2048Scene {
    LT2048GameManager *_manager;
    
    BOOL _hasPendingSwipe;
    
    SKSpriteNode *_board;
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _manager = [[LT2048GameManager alloc] init];
    }
    return self;
}

- (void)loadBoardWithGrid:(LT2048Grid *)grid
{
    if (_board) {
        [_board removeFromParent];
    }
    UIImage *image = [LT2048GridView gridImageWithGrid:grid];
    SKTexture *backgroundTextTure = [SKTexture textureWithCGImage:image.CGImage];
    _board = [SKSpriteNode spriteNodeWithTexture:backgroundTextTure];
    [_board setScale:1/[UIScreen mainScreen].scale];
    _board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_board];
}

- (void)startNewGame
{
    [_manager startNewSessionWithScene:self];
}

# pragma mark - Swipe handling

- (void)didMoveToView:(SKView *)view
{
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    } else {
        for (UIPanGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    } else if (swipe.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation
{
    if (!_hasPendingSwipe) {
        return;
    }
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) {
        return;
    }
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.x < 0 ? [_manager moveToDirection:LT2048DirectionLeft] :
        [_manager moveToDirection:LT2048DirectionRight];
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.y < 0 ? [_manager moveToDirection:LT2048DirectionUp] :
        [_manager moveToDirection:LT2048DirectionDown];
    }
    
    _hasPendingSwipe = NO;
}

@end
