//
//  LTGlobalState.h
//  LT2048
//
//  Created by lt on 2017/7/19.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LT2048Position.h"

#define GSTATE              [LTGlobalState sharedInstance]
#define Settings            [NSUserDefaults standardUserDefaults]
#define NotifCenter         [NSNotificationCenter defaultCenter]
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSInteger, LTGameType) {
    LTGameTypePowerOf2 = 0,
    LTGameTypePowerOf3 = 1,
    LTGameTypeFibonacci = 2
};

@interface LTGlobalState : NSObject

@property (nonatomic, assign, readonly) NSInteger dimension;      /**< 维数 */
@property (nonatomic, assign, readonly) NSInteger winninglevel;

@property (nonatomic, assign, readonly) CGFloat titleSize;
@property (nonatomic, assign, readonly) CGFloat borderWidth;
@property (nonatomic, assign, readonly) CGFloat cornerRadius;
@property (nonatomic, assign, readonly) CGFloat horizontalOffset;
@property (nonatomic, assign, readonly) CGFloat verticalOffset;
@property (nonatomic, assign, readonly) NSTimeInterval animationDuration;
@property (nonatomic, assign, readonly) LTGameType gameType;

@property (nonatomic, assign) BOOL needRefresh;

+ (LTGlobalState *)sharedInstance;

- (void)loadGlobalState;

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2;

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2;

- (NSInteger)valueForLevel:(NSInteger)level;

- (UIColor *)colorForLevel:(NSInteger)level;

- (UIColor *)textColorForLevel:(NSInteger)level;

- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regularFontName;

- (CGFloat)textSizeForValue:(NSInteger)value;

- (CGPoint)locationOfPosition:(LT2048Position)position;

- (CGFloat)xLocationOfPosition:(LT2048Position)position;

- (CGFloat)yLocationOfPosition:(LT2048Position)position;

@end
