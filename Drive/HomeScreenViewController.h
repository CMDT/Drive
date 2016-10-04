//
//  HomeScreenViewController.h
//  Drive
//
//  Created by Jonathan Howell 15/12/15.
//  Copyright (c) 2016. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

@import UIKit;

@interface HomeScreenViewController : UIViewController <UITextFieldDelegate>

// definitions follow
- (BOOL)prefersStatusBarHidden;

- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)checkMusicAndPlay;
- (void)btnPressSound;
- (void)blankLapTicks;
- (void)blankMusicTicks;
- (void)blankFXTicks;

- (IBAction)distractionOSW:(id)sender;
- (IBAction)carButtonDidTouchUpInside:(id)sender;
- (IBAction)gameCenterButtonDidTouchUpInside:(id)sender;

- (IBAction)lap2set:(id)sender;
- (IBAction)lap5set:(id)sender;
- (IBAction)lap10set:(id)sender;
- (IBAction)lap20set:(id)sender;
- (IBAction)lap50set:(id)sender;
- (IBAction)lap100set:(id)sender;

- (IBAction)musicNoneSet:(id)sender;
- (IBAction)musicLightSet:(id)sender;
- (IBAction)musicBluesSet:(id)sender;
- (IBAction)musicBeatSet:(id)sender;

- (IBAction)fxNoneSet:(id)sender;
- (IBAction)fxLowSet:(id)sender;
- (IBAction)fxMidSet:(id)sender;
- (IBAction)fxNorSet:(id)sender;
- (IBAction)fxHiSet:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch    *distractionSW;

@property (weak, nonatomic) IBOutlet UIImageView *tick2;
@property (weak, nonatomic) IBOutlet UIImageView *tick5;
@property (weak, nonatomic) IBOutlet UIImageView *tick10;
@property (weak, nonatomic) IBOutlet UIImageView *tick20;
@property (weak, nonatomic) IBOutlet UIImageView *tick50;
@property (weak, nonatomic) IBOutlet UIImageView *tick100;
@property (weak, nonatomic) IBOutlet UIImageView *tickNone;
@property (weak, nonatomic) IBOutlet UIImageView *tickLight;
@property (weak, nonatomic) IBOutlet UIImageView *tickBlues;
@property (weak, nonatomic) IBOutlet UIImageView *tickBeat;
@property (weak, nonatomic) IBOutlet UIImageView *tickoff;
@property (weak, nonatomic) IBOutlet UIImageView *ticklow;
@property (weak, nonatomic) IBOutlet UIImageView *tickmed;
@property (weak, nonatomic) IBOutlet UIImageView *ticknor;
@property (weak, nonatomic) IBOutlet UIImageView *tickhigh;
@property (weak, nonatomic) IBOutlet UIImageView *tickdistraction;

@property (weak, nonatomic) IBOutlet UIButton *lap2btn;
@property (weak, nonatomic) IBOutlet UIButton *lap5btn;
@property (weak, nonatomic) IBOutlet UIButton *lap10btn;
@property (weak, nonatomic) IBOutlet UIButton *lap20btn;
@property (weak, nonatomic) IBOutlet UIButton *lap50btn;
@property (weak, nonatomic) IBOutlet UIButton *lap100btn;

@property (weak, nonatomic) IBOutlet UIButton *nonebtn;
@property (weak, nonatomic) IBOutlet UIButton *lightbtn;
@property (weak, nonatomic) IBOutlet UIButton *bluesbtn;
@property (weak, nonatomic) IBOutlet UIButton *beatbtn;

@property (weak, nonatomic) IBOutlet UIButton *fxnonebtn; //0%
@property (weak, nonatomic) IBOutlet UIButton *fxlowbtn;  //25%
@property (weak, nonatomic) IBOutlet UIButton *fxmedbtn;  //50%
@property (weak, nonatomic) IBOutlet UIButton *fxnorbtn;  //75%
@property (weak, nonatomic) IBOutlet UIButton *fxhighbtn; //100%

@end
