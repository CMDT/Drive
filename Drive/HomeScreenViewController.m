//
//  HomeScreenViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "GameKitHelper.h"
//#import "SelectCarViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

@synthesize distractionSW;

#pragma mark - Run App

- (void)viewDidLoad {
    mySingleton *singleton = [mySingleton sharedSingleton];
    [super viewDidLoad];
    
    [self blankLapTicks];
    self.tick10.hidden=NO;
    self.lap10btn.alpha=1;
    
    
    [self blankMusicTicks];
    self.tickNone.hidden=NO;
    self.nonebtn.alpha=1;
    
    singleton.musicTrack=@"None";
    singleton.laps=@"10";
    [[SKTAudio sharedInstance] playBackgroundMusic:@"silence30.mp3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)checkMusicAndPlay{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //check what sound if any and play
    NSString *music;
    music=singleton.musicTrack;
    
    if ([music isEqual:@"Beat"]){
        [[SKTAudio sharedInstance] playBackgroundMusic:@"track16.mp3"]; //change to Drive.mp3
    }else{
        if ([music isEqual:@"Light"]) {
            [[SKTAudio sharedInstance] playBackgroundMusic:@"Funky_Good_Time.mp3"];
        }else{
            if([music isEqual:@"Blues"]){
                [[SKTAudio sharedInstance] playBackgroundMusic:@"Johnson-jass-Blues.mp3"];
            }else{
                //None
                [[SKTAudio sharedInstance] playBackgroundMusic:@"silence30.mp3"];
            }
        }
    }
}

#pragma mark - Start the Game

- (IBAction)carButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    //SelectCarViewController *selectCarVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:@"SelectCarViewController"];

    //[self.navigationController pushViewController:selectCarVC animated:YES];
}

- (IBAction)gameCenterButtonDidTouchUpInside:(id)sender {
    // a 1px x 1px button, hard to hit, but it is there....
    //do nothing, not enabling game ctr yet . weill need to turn back on in final vc m code- jah
    //[[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    //[[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self];
}

- (void)blankLapTicks{
    //opacity 50%
    self.lap2btn.alpha=0.5;
    self.lap5btn.alpha=0.5;
    self.lap10btn.alpha=0.5;
    self.lap20btn.alpha=0.5;
    self.lap50btn.alpha=0.5;
    self.lap100btn.alpha=0.5;
    //clear all the ticks for laps
    self.tick2.hidden=YES;
    self.tick5.hidden=YES;
    self.tick10.hidden=YES;
    self.tick20.hidden=YES;
    self.tick50.hidden=YES;
    self.tick100.hidden=YES;

}

- (void)blankMusicTicks{
    //opacity 50%
    self.nonebtn.alpha=0.5;
    self.lightbtn.alpha=0.5;
    self.bluesbtn.alpha=0.5;
    self.beatbtn.alpha=0.5;
    // clear all the music ticks
    self.tickNone.hidden=YES;
    self.tickLight.hidden=YES;
    self.tickBlues.hidden=YES;
    self.tickBeat.hidden=YES;

}

#pragma mark - Set the laps, music and distractions
- (IBAction)lap2set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"2";
    [self blankLapTicks];
    self.lap2btn.alpha=1;
    self.tick2.hidden=NO;
    
}

- (IBAction)lap5set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"5";
    [self blankLapTicks];
    self.lap5btn.alpha=1;
    self.tick5.hidden=NO;
}

- (IBAction)lap10set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"10";
    [self blankLapTicks];
    self.lap10btn.alpha=1;
    self.tick10.hidden=NO;
}

- (IBAction)lap20set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"20";
    [self blankLapTicks];
    self.lap20btn.alpha=1;
    self.tick20.hidden=NO;
}

- (IBAction)lap50set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"50";
    [self blankLapTicks];
    self.lap50btn.alpha=1;
    self.tick50.hidden=NO;
}

- (IBAction)lap100set:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.laps=@"100";
    [self blankLapTicks];
    self.lap100btn.alpha=1;
    self.tick100.hidden=NO;
}

- (IBAction)musicNoneSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"None";
    [self blankMusicTicks];
    self.nonebtn.alpha=1;
    self.tickNone.hidden=NO;
    [self checkMusicAndPlay];
}

- (IBAction)musicLightSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Light";
    [self blankMusicTicks];
    self.lightbtn.alpha=1;
    self.tickLight.hidden=NO;
    [self checkMusicAndPlay];
}

- (IBAction)musicBluesSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Blues";
    [self blankMusicTicks];
    self.bluesbtn.alpha=1;
    self.tickBlues.hidden=NO;
    [self checkMusicAndPlay];
}

- (IBAction)musicBeatSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.musicTrack=@"Beat";
    [self blankMusicTicks];
    self.beatbtn.alpha=1;
    self.tickBeat.hidden=NO;
    [self checkMusicAndPlay];
}

- (IBAction)distractionOSW:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    if (distractionSW.isOn) {
        singleton.distractionOn=@"ON";
    }else{
        singleton.distractionOn=@"OFF";
    }
}

@end
