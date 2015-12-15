//
//  HomeScreenViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "GameKitHelper.h"
#import "SelectCarViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Actions

- (IBAction)playButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    SelectCarViewController *selectCarVC = [self.storyboard
        instantiateViewControllerWithIdentifier:@"SelectCarViewController"];

    [self.navigationController pushViewController:selectCarVC animated:YES];
}

- (IBAction)gameCenterButtonDidTouchUpInside:(id)sender {
    
    //do nothing, not enabling yet - jah
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    //[[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self];
}

- (IBAction)lap2set:(id)sender {
}

- (IBAction)lap5set:(id)sender {
}

- (IBAction)lap10set:(id)sender {
}

- (IBAction)lap20set:(id)sender {
}

- (IBAction)lap50set:(id)sender {
}

- (IBAction)lap100set:(id)sender {
}

- (IBAction)musicNoneSet:(id)sender {
}

- (IBAction)musicLightSet:(id)sender {
}

- (IBAction)musicBluesSet:(id)sender {
}

- (IBAction)musicBeatSet:(id)sender {
}

- (IBAction)distractionON:(id)sender {
}
@end
