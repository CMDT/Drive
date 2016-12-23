//
//  SelectDriverViewController.h
//  Drive
//
//  Created by Jon Howell on 17/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import <UIKit/UIKit.h>

@interface SelectDriverViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *driverName;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UIImageView *tyre1;
@property (weak, nonatomic) IBOutlet UIImageView *tyre2;
@property (weak, nonatomic) IBOutlet UIImageView *bale;
@property (weak, nonatomic) IBOutlet UIImageView *crate;

@property (strong, nonatomic) IBOutlet UIImageView * carView;

// definitions for functions follow
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (IBAction)infoButtonDidTouchUpInside:(id)sender;
- (IBAction)backButtonDidTouchUpInside:(id)sender;
- (IBAction)startButtonDidTouchUpInside:(UIButton *)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) keyBoardAppeared :(int)oft;
- (void)textFieldDidEndEditing:(UITextField *) textField;
- (void) keyBoardDisappeared :(int)oft;
- (void)btnPressSound;

@end
