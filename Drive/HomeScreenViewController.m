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
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"2";
}

- (IBAction)lap5set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"5";
}

- (IBAction)lap10set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"10";
}

- (IBAction)lap20set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"20";
}

- (IBAction)lap50set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"50";
}

- (IBAction)lap100set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"100";
}

- (IBAction)musicNoneSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"None";
}

- (IBAction)musicLightSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Light";
}

- (IBAction)musicBluesSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Blues";
}

- (IBAction)musicBeatSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Beat";
}

- (IBAction)distractionON:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.distractionOn=@"NO";
}
@end
