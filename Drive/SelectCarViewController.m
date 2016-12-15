//
//  SelectCarViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "SelectCarViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"

@interface SelectCarViewController ()

@end

@implementation SelectCarViewController

#pragma mark - Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Select a Car

- (IBAction)carButtonDidTouchUpInside:(UIButton *)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    [self btnPressSound];

    //SelectLevelViewController *levelVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:NSStringFromClass([SelectLevelViewController class])];
    //levelVC.carType = sender.tag;
    
    //singleton.carNo=[NSString stringWithFormat:@"%ld", levelVC.carType];
    singleton.carNo=[NSString stringWithFormat:@"%ld", (long)sender.tag];

    //[self.navigationController pushViewController:levelVC animated:YES];
}

- (IBAction)infoButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
}

- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
    //[self.navigationController popViewControllerAnimated:YES];
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
