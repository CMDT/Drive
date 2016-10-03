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

@end
