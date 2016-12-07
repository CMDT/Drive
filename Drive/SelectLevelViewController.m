//
//  SelectLevelViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "SelectLevelViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"

@interface SelectLevelViewController ()

@end

@implementation SelectLevelViewController

#pragma mark - Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    //clear the graphics for track level selected to start with
    /*_car1.hidden=YES;
    _car2.hidden=YES;
    _car3.hidden=YES;*/
    _speedo1.hidden=YES;
    _speedo2.hidden=YES;
    _speedo3.hidden=YES;
    
}
- (void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //check the car power/speed and bring the graphics back according to level selected
    //NSLog(@"car  %@", singleton.carNo);
    if([singleton.carNo isEqual:@"1"]){
        /*_car1.hidden=NO;
        _car2.hidden=YES;
        _car3.hidden=YES;*/
        _speedo1.hidden=NO;/*
        _speedo2.hidden=YES;
        _speedo3.hidden=YES;*/
        _car1.alpha=1;
        _car2.alpha=.15;
        _car3.alpha=.15;
        _speedo1.hidden=NO;
        _speedo2.hidden=YES;
        _speedo3.hidden=YES;
        
    }
    if([singleton.carNo isEqual:@"2"]){
        _car1.alpha=.15;
        _car2.alpha=1;
        _car3.alpha=.15;
        _speedo1.hidden=YES;
        _speedo2.hidden=NO;
        _speedo3.hidden=YES;
    }
    if([singleton.carNo isEqual:@"3"]){
        _car1.alpha=.15;
        _car2.alpha=.15;
        _car3.alpha=1;
        _speedo1.hidden=YES;
        _speedo2.hidden=YES;
        _speedo3.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Select a Track
- (IBAction)infoButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
}

- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelButtonDidTouchUpInside:(UIButton *)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    [self btnPressSound];

    //SelectDriverViewController *gameVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:NSStringFromClass([SelectDriverViewController class])];
    //gameVC.carType = self.carType;
    //gameVC.levelType = sender.tag;
    
    singleton.trackNo=[NSString stringWithFormat:@"%ld", (long)sender.tag];

    //[self.navigationController pushViewController:gameVC animated:YES];
}

- (void)btnPressSound{
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    int   fxVolumeSetLevel;
    float fxTemp;
    
    //find the sound level to play and play it
    fxTemp = singleton.ambientVolume * 100;
    fxVolumeSetLevel = (int)fxTemp;
    
    //report for dev only
    //NSLog(@"fxVolumeSetLevel= %f: %f :%d", singleton.ambientVolume, fxTemp, fxVolumeSetLevel);
    
    switch (fxVolumeSetLevel) {
        case 0 ... 10:
            //no sound
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press00.wav"];
            break;
        case 11 ... 25:
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press25.wav"];
            break;
        case 26 ... 50:
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press50.wav"];
            break;
        case 51 ... 75:
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press75.wav"];
            break;
        case 76 ... 100:
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press100.wav"];
            break;
        default:
            //no sound
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press00.wav"];
            break;
    }
}

@end
