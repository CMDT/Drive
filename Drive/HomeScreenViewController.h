//
//  HomeScreenViewController.h
//  Drive
//
//  Created by Jonathan Howell 15/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

@import UIKit;

@interface HomeScreenViewController : UIViewController
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

@property (weak, nonatomic) IBOutlet UISwitch *distractionSW;

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

- (void)blankLapTicks;
- (void)blankMusicTicks;

@end
