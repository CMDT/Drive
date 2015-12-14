//
//  SelectCarViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "SelectCarViewController.h"
#import "SelectLevelViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface SelectCarViewController ()

@end

@implementation SelectCarViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//check what sound if any and play
    [[SKTAudio sharedInstance] playBackgroundMusic:@"circuitracer.mp3"]; //change to Drive.mp3
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Actions

- (IBAction)carButtonDidTouchUpInside:(UIButton *)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    SelectLevelViewController *levelVC = [self.storyboard
        instantiateViewControllerWithIdentifier:NSStringFromClass([SelectLevelViewController class])];
    levelVC.carType = sender.tag;

    [self.navigationController pushViewController:levelVC animated:YES];
}

@end
