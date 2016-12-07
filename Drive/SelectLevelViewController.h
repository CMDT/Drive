//
//  SelectLevelViewController.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

@import UIKit;

@interface SelectLevelViewController : UIViewController <UITextFieldDelegate>

// definitions follow
- (void)     viewDidLoad;
- (void)     didReceiveMemoryWarning;
- (BOOL)     prefersStatusBarHidden;
- (IBAction) infoButtonDidTouchUpInside:(id)sender;
- (IBAction) backButtonDidTouchUpInside:(id)sender;
- (IBAction) levelButtonDidTouchUpInside:(UIButton *)sender;
- (void)     btnPressSound;

@property (nonatomic, assign) CRCarType carType;

@property (weak, nonatomic) IBOutlet UIImageView *car1;
@property (weak, nonatomic) IBOutlet UIImageView *car2;
@property (weak, nonatomic) IBOutlet UIImageView *car3;
@property (weak, nonatomic) IBOutlet UIImageView *speedo1;
@property (weak, nonatomic) IBOutlet UIImageView *speedo2;
@property (weak, nonatomic) IBOutlet UIImageView *speedo3;
@end
