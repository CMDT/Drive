//
//  ViewController.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

@import UIKit;
@import SpriteKit;

@interface ViewController : UIViewController  <UITextFieldDelegate>

@property (nonatomic, assign) CRCarType carType;
@property (nonatomic, assign) CRLevelType levelType;
@property (nonatomic, copy)   NSDate * hornTimer;

@end
