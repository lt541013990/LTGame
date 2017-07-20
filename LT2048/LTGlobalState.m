//
//  LTGlobalState.m
//  LT2048
//
//  Created by lt on 2017/7/19.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LTGlobalState.h"
#import "LT2048Theme.h"

#define GAMETYPE    @"Game Type"
#define THEME       @"Theme"
#define BOARDSIZE   @"Board Size"
#define BESTSCORE   @"Best Score"

@interface LTGlobalState ()

@property (nonatomic, assign, readwrite) NSInteger dimension;      /**< 维数 */
@property (nonatomic, assign, readwrite) NSInteger winninglevel;

@property (nonatomic, assign, readwrite) CGFloat titleSize;
@property (nonatomic, assign, readwrite) CGFloat borderWidth;
@property (nonatomic, assign, readwrite) CGFloat cornerRadius;
@property (nonatomic, assign, readwrite) CGFloat horizontalOffset;
@property (nonatomic, assign, readwrite) CGFloat verticalOffset;
@property (nonatomic, assign, readwrite) NSTimeInterval animationDuration;
@property (nonatomic, assign, readwrite) LTGameType gameType;
@property (nonatomic, assign)  LT2048ThemeType theme;

@end

@implementation LTGlobalState

+ (LTGlobalState *)sharedInstance
{
    static LTGlobalState *state = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        state = [[LTGlobalState alloc] init];
    });
    
    return state;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupDefaultState];
        [self loadGlobalState];
    }
    return self;
}

- (void)setupDefaultState
{
    NSDictionary *defaultValues = @{GAMETYPE: @0, THEME: @0, BOARDSIZE: @1, BESTSCORE: @0};
    [Settings registerDefaults:defaultValues];
}

- (void)loadGlobalState
{
    self.dimension = [Settings integerForKey:BOARDSIZE] + 3;
    self.borderWidth = 5;
    self.cornerRadius = 4;
    self.animationDuration = 0.1;
    self.gameType = [Settings integerForKey:GAMETYPE];
    self.horizontalOffset = [self horizontalOffset];
    self.verticalOffset = [self verticalOffset];
    self.theme = [Settings integerForKey:THEME];
    self.needRefresh = NO;
}

- (CGFloat)titleSize
{
    return self.dimension <= 4 ? 66 : 56;
}

- (CGFloat)horizontalOffset
{
    CGFloat width = self.dimension * (self.titleSize + self.borderWidth) + self.borderWidth;
    return (SCREEN_WIDTH - width) / 2;
}

- (CGFloat)verticalOffset
{
    CGFloat height = self.dimension * (self.titleSize + self.borderWidth) + self.borderWidth + 120;
    return (SCREEN_HEIGHT - height) / 2;
}

- (NSInteger)winninglevel
{
    if (GSTATE.gameType == LTGameTypePowerOf3) {
        switch (self.dimension) {
            case 3:
                return 4;
                break;
            
            case 4:
                return 5;
                break;
                
            case 5:
                return 6;
                break;
                
            default:
                return 5;
                break;
        }
    }
    
    NSInteger level = 11;
    if (self.dimension == 3)    return level - 1;
    if (self.dimension == 5)    return level + 2;
    return level;
}

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2
{
    if (self.gameType == LTGameTypeFibonacci) {
        return abs((int)level1 - (int)level2) == 1;
    }
    return level1 == level2;
}

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2
{
    if (![self isLevel:level1 mergeableWithLevel:level2]) {
        return 0;
    }
    
    if (self.gameType == LTGameTypeFibonacci) {
        return (level1 + 1 == level2) ? level2 + 1 : level1 + 1;
    }
    return level1 + 1;
}

- (NSInteger)valueForLevel:(NSInteger)level
{
    if (self.gameType == LTGameTypeFibonacci) {
        NSInteger a = 1, b = 1;
        for (NSInteger i = 0; i< level; i++) {
            NSInteger c = a + b;
            a = b;
            b = c;
        }
        return b;
    } else {
        NSInteger value = 1;
        NSInteger base = self.gameType == LTGameTypePowerOf2 ? 2 : 3;
        for (NSInteger i = 0; i < level; i++) {
            value *= base;
        }
        return value;
    }
}

# pragma mark - Appreance

- (UIColor *)colorForLevel:(NSInteger)level
{
    return [[LT2048Theme themeClassForType:self.theme] colorForLevel:level];
}

- (UIColor *)textColorForLevel:(NSInteger)level
{
    return [[LT2048Theme themeClassForType:self.theme] textColorForLevel:level];
}


- (CGFloat)textSizeForValue:(NSInteger)value
{
    CGFloat offset = self.dimension == 5 ? 2 : 0;
    CGFloat finalValue = 0;
    if (value < 100) {
        finalValue = 32 - offset;
    } else if (value < 1000) {
        finalValue = 28 - offset;
    } else if (value < 10000) {
        finalValue = 24 - offset;
    } else if (value < 100000) {
        finalValue = 20 - offset;
    } else if (value < 1000000) {
        finalValue = 16 - offset;
    } else {
        finalValue = 13 - offset;
    }
    
    return finalValue;
}

- (UIColor *)backgroundColor
{
    return [[LT2048Theme themeClassForType:self.theme] backgroundColor];
}

- (UIColor *)scoreBoardColor
{
    return [[LT2048Theme themeClassForType:self.theme] scoreBoardColor];
}

- (UIColor *)boardColor
{
    return [[LT2048Theme themeClassForType:self.theme] boardColor];
}

- (UIColor *)buttonColor
{
    return [[LT2048Theme themeClassForType:self.theme] buttonColor];
}

- (NSString *)boldFontName
{
    return [[LT2048Theme themeClassForType:self.theme] boldFontName];
}

- (NSString *)regularFontName
{
    return [[LT2048Theme themeClassForType:self.theme] regularFontName];
}

# pragma mark - Position to point conversion
- (CGPoint)locationOfPosition:(LT2048Position)position
{
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset, [self yLocationOfPosition:position] + self.verticalOffset);
}

- (CGFloat)xLocationOfPosition:(LT2048Position)position
{
    return position.y * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

- (CGFloat)yLocationOfPosition:(LT2048Position)position
{
    return position.x * (GSTATE.titleSize + GSTATE.borderWidth) + GSTATE.borderWidth;
}

@end
