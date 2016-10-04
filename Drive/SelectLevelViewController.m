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
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface SelectLevelViewController ()

@end

@implementation SelectLevelViewController

#pragma mark - Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
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
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press00.wav"];
            break;
    }
}
@end
