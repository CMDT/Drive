//
//  SelectLevelViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "SelectLevelViewController.h"
#import "SKTAudio.h"
#import "SelectDriverViewController.h"
#import "mySingleton.h"
#import "ViewController.h"
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

- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelButtonDidTouchUpInside:(UIButton *)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    ViewController *gameVC = [self.storyboard
        instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    gameVC.carType = self.carType;
    gameVC.levelType = sender.tag;
    
    singleton.trackNo=[NSString stringWithFormat:@"%ld", gameVC.levelType];

    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
