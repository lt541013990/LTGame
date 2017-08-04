//
//  LT2048ViewController.m
//  LT2048
//
//  Created by lt on 2017/7/19.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "LT2048ViewController.h"
#import "LT2048Scene.h"
#import "LTScoreView.h"
#import "LT2048GameManager.h"
#import "LT2048Overlay.h"
#import "LT2048GridView.h"


@interface LT2048ViewController ()

@end

@implementation LT2048ViewController {
    IBOutlet UIButton *_restartButton;
    IBOutlet UIButton *_settingButton;
    IBOutlet UILabel *_targetScore;
    IBOutlet UILabel *_subtitle;
    IBOutlet LTScoreView *_scoreView;
    IBOutlet LTScoreView *_bestView;
    
    LT2048Scene *_scene;
    
    IBOutlet LT2048Overlay *_overlay;
    IBOutlet UIImageView *_overlayBackground;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateState];
    
    _bestView.score.text = [NSString stringWithFormat:@"%ld",(long)[Settings integerForKey:@"Best Score"]];
    _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
    _restartButton.layer.masksToBounds = YES;
    
    _settingButton.layer.cornerRadius = [GSTATE cornerRadius];
    _settingButton.layer.masksToBounds = YES;
    
    _overlay.hidden = YES;
    _overlayBackground.hidden = YES;
    
    SKView * skView = (SKView *)self.view;
    
    LT2048Scene *scene = [LT2048Scene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:scene];
    [self updateScore:0];
    [scene startNewGame];
    
    _scene = scene;
    _scene.controller = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateState
{
    [_scoreView updateAppearance];
    [_bestView updateAppearance];
    
    _restartButton.backgroundColor = [GSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _settingButton.backgroundColor = [GSTATE buttonColor];
    _settingButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
    
    _targetScore.textColor = [GSTATE buttonColor];
    
    long target = [GSTATE valueForLevel:GSTATE.winninglevel];
    
    if (target > 100000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
    } else if (target < 10000) {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
    } else {
        _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
    }
    
    _targetScore.text = [NSString stringWithFormat:@"%ld",target];
    
    _subtitle.textColor = [GSTATE buttonColor];
    _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
    _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!",target];
    
    _overlay.message.font = [UIFont fontWithName: [GSTATE boldFontName] size:36];
    _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
    
    _overlay.message.textColor = [GSTATE buttonColor];
    [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
    [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
}

- (void)updateScore:(NSInteger)score
{
    _scoreView.score.text = [NSString stringWithFormat:@"%ld",(long)score];
    if ([Settings integerForKey:@"Best Score"] < score) {
        [Settings setInteger:score forKey:@"Best Score"];
        _bestView.score.text = [NSString stringWithFormat:@"%ld",(long)score];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((SKView *)self.view).paused = YES;
}

- (IBAction)restart:(id)sender
{
    [self hideOverlay];
    [self updateScore:0];
    [_scene startNewGame];
}

- (IBAction)keepPlaying:(id)sender
{
    [self hideOverlay];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    ((SKView *)self.view).paused = NO;
    if (GSTATE.needRefresh) {
        [GSTATE loadGlobalState];
        [self updateState];
        [self updateScore:0];
        [_scene startNewGame];
    }
}

- (void)endGame:(BOOL)won
{
    _overlay.hidden = NO;
    _overlay.alpha = 0;
    _overlayBackground.hidden = NO;
    _overlayBackground.alpha = 0;
    
    if (!won) {
        _overlay.keepPlaying.hidden = YES;
        _overlay.message.text = @"Game Over";
    } else {
        _overlay.keepPlaying.hidden = NO;
        _overlay.message.text = @"You Win";
    }
    
    _overlayBackground.image = [LT2048GridView gridImageWithOverlay];
    
    CGFloat verticalOffset = SCREEN_HEIGHT - GSTATE.verticalOffset;
    NSInteger side = GSTATE.dimension * (GSTATE.titleSize +GSTATE.borderWidth) + GSTATE.borderWidth;
    _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);

    [UIView animateWithDuration:.5f delay:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _overlay.alpha = 1;
        _overlayBackground.alpha = 1;
    }completion:^(BOOL finished) {
        ((SKView *)self.view).paused = YES;
    }];
}

- (void)hideOverlay
{
    ((SKView *)self.view).paused = NO;
    if (!_overlay.hidden) {
        [UIView animateWithDuration:.5f animations:^{
            _overlay.alpha = 0;
            _overlayBackground.alpha = 0;
        } completion:^(BOOL finished){
            _overlay.hidden = YES;
            _overlayBackground.hidden = YES;
        }];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
