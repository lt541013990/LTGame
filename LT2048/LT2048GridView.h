//
//  LT2048GridView.h
//  LT2048
//
//  Created by lt on 2017/7/21.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LT2048Grid;

@interface LT2048GridView : UIView

+ (UIImage *)gridImageWithGrid:(LT2048Grid *)grid;

+ (UIImage *)gridImageWithOverlay;

@end
