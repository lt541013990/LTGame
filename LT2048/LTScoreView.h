//
//  LTScoreView.h
//  LT2048
//
//  Created by lt on 2017/7/19.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTScoreView : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *score;

- (void)updateAppearance;

@end
