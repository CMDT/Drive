//
//  ViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "ViewController.h" 
#import "TrackStatsViewController.h"
#import "MyScene.h"
#import "AnalogControl.h"

@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) SKView        * skView;
@property (nonatomic, strong) AnalogControl * analogControl;
@property (nonatomic, strong) MyScene       * scene;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view sendSubviewToBack:self.skView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.skView) {
        self.skView = [[SKView alloc] initWithFrame:self.view.bounds];
        MyScene *scene = [[MyScene alloc]
            initWithSize:self.skView.bounds.size carType:self.carType level:self.levelType];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.skView presentScene:scene];

        [self.view addSubview:self.skView];

        const CGFloat padSide    = 128.0f;
        const CGFloat padPadding = 10.0f;

        self.analogControl = ({
            CGRect frame = CGRectMake(
                padPadding,
                CGRectGetHeight(self.skView.frame) - padPadding - padSide,
                padSide,
                padSide
            );
            AnalogControl *analogControl = [[AnalogControl alloc] initWithFrame:frame];
            analogControl;
        });
        [self.view addSubview:self.analogControl];

        [self.analogControl addObserver:scene forKeyPath:@"relativePosition"
                                options:NSKeyValueObservingOptionNew context:nil];
        self.scene = scene;

        __weak typeof(self) weakSelf = self;
        self.scene.gameOverBlock = ^(BOOL didWin) {
            [weakSelf p_gameOverWithWin:didWin];
        };
    }

    //only show fps when in debug mode
#ifdef DEBUG
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
#endif
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [self.analogControl removeObserver:self.scene forKeyPath:@"relativePosition"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Pause Action

- (IBAction)pauseButtonDidTouchUpInside:(id)sender {
    [self p_showInGameMenu];
}

#pragma mark - Game Over

- (void)p_gameOverWithWin:(BOOL)didWin {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:didWin ? @"You Completed the Laps Required!" : @"You Did Not Finish the Race"
                               message:@"... This Race is now Over., \n\n... Moving On ..."
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:nil];
    [alert show];
    if (didWin) {
        //you finished the race, give the stats
        [self performSelector:@selector(p_goBackStats:) withObject:alert afterDelay:2.0];
    }else{
        //you did not finish or cancelled, just start again... consider part stats, ie no email
        [self performSelector:@selector(p_goBack:) withObject:alert afterDelay:2.0];
    }
}

- (void)p_goBackStats:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    //re-route this to the results stats VC TrackStatsVC
    //[self.navigationController popToRootViewControllerAnimated:YES];
    TrackStatsViewController *TrackStatsVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TrackStatsViewController class])];
    
    [self.navigationController pushViewController:TrackStatsVC animated:YES];
}
- (void)p_goBack:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)p_showInGameMenu {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"MMU ESS Drive Menu"
                               message:@"You have Paused the Race.... \n\nWhat would you like to do?"
                              delegate:self
                     cancelButtonTitle:@"Resume Race"
                     otherButtonTitles:@"Start A New Race", nil];
    [alert show];

    self.scene.paused = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.scene.paused = NO;

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self p_gameOverWithWin:NO];
    }
}

@end
