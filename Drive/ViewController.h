//
//  ViewController.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

@import UIKit;
@import SpriteKit;

@interface ViewController : UIViewController

@property (nonatomic, assign) CRCarType carType;
@property (nonatomic, assign) CRLevelType levelType;
@property (nonatomic, copy) NSDate * startDateHorn;

-(void)hornShow;

@end
