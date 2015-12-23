//
//  SelectCarViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "SelectCarViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h"
//mySingleton *singleton = [mySingleton sharedSingleton];

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
    
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];

    //SelectLevelViewController *levelVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:NSStringFromClass([SelectLevelViewController class])];
    //levelVC.carType = sender.tag;
    
    //singleton.carNo=[NSString stringWithFormat:@"%ld", levelVC.carType];
    singleton.carNo=[NSString stringWithFormat:@"%ld", (long)sender.tag];

    //[self.navigationController pushViewController:levelVC animated:YES];
}
- (IBAction)infoButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
}
- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
