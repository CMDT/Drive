//
//  HomeScreenViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "HomeScreenViewController.h"
// not implemented game kit yet, maydo later, load anyway
#import "GameKitHelper.h"

//#import "SelectCarViewController.h" // for dev testing, not needed?

#import "SKTAudio.h"
#import "mySingleton.h"

//mySingleton *singleton = [mySingleton sharedSingleton];

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

@synthesize distractionSW;

#pragma mark - Run App once loaded in memory

- (void)viewDidLoad {
    mySingleton *singleton = [mySingleton sharedSingleton];
    [super viewDidLoad];
    
    self.tickdistraction.hidden=YES;
    
    [self blankLapTicks];
    self.tick10.hidden=NO;
    self.lap10btn.alpha=1;
    
    [self blankMusicTicks];
    self.tickNone.hidden=NO;
    self.nonebtn.alpha=1;
    
    [self blankFXTicks];
    self.tickmed.hidden=NO;
    self.fxmedbtn.alpha=1;
    
    singleton.musicTrack=@"None";
    singleton.laps=@"10";
    singleton.ambientVolume=0.66;
    
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
    //check what sound if any and play it in background
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

#pragma mark - Start the Race Game

- (IBAction)carButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    //SelectCarViewController *selectCarVC = [self.storyboard
    //instantiateViewControllerWithIdentifier:@"SelectCarViewController"];
    //[self.navigationController pushViewController:selectCarVC animated:YES];
}

- (IBAction)gameCenterButtonDidTouchUpInside:(id)sender {
    // this for the Apple Game Centre stats and sharing drive data only:
    // a 1px x 1px button, hard to hit, but it is there....
    //do nothing, not enabling game ctr yet. will need to turn back on in final vc m code- jah
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

- (void)blankFXTicks{
    //opacity 50%
    self.fxnonebtn.alpha=0.5;
    self.fxlowbtn.alpha=0.5;
    self.fxmedbtn.alpha=0.5;
    self.fxhighbtn.alpha=0.5;
    // clear all the music ticks
    self.tickoff.hidden=YES;
    self.ticklow.hidden=YES;
    self.tickmed.hidden=YES;
    self.tickhigh.hidden=YES;
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

- (IBAction)fxNoneSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.ambientVolume=0.0;
    [self blankFXTicks];
    self.fxnonebtn.alpha=1;
    self.tickoff.hidden=NO;
}

- (IBAction)fxLowSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.ambientVolume=0.33;
    [self blankFXTicks];
    self.fxlowbtn.alpha=1;
    self.ticklow.hidden=NO;
}

- (IBAction)fxMidSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.ambientVolume=0.66;
    [self blankFXTicks];
    self.fxmedbtn.alpha=1;
    self.tickmed.hidden=NO;
}

- (IBAction)fxHiSet:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.ambientVolume=1.0;
    [self blankFXTicks];
    self.fxhighbtn.alpha=1;
    self.tickhigh.hidden=NO;
}

- (IBAction)distractionOSW:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    if (distractionSW.isOn) {
        singleton.distractionOn=@"ON";
        self.tickdistraction.hidden=NO;
    }else{
        singleton.distractionOn=@"OFF";
        self.tickdistraction.hidden=YES;
    }
}

@end
