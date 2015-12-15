//
//  HomeScreenViewController.h
//  Drive
//
//  Created by Jonathan Howell 15/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

@import UIKit;

@interface HomeScreenViewController : UIViewController
- (IBAction)lap2set:(id)sender;
- (IBAction)lap5set:(id)sender;
- (IBAction)lap10set:(id)sender;
- (IBAction)lap20set:(id)sender;
- (IBAction)lap50set:(id)sender;
- (IBAction)lap100set:(id)sender;

- (IBAction)musicNoneSet:(id)sender;
- (IBAction)musicLightSet:(id)sender;
- (IBAction)musicBluesSet:(id)sender;
- (IBAction)musicBeatSet:(id)sender;

- (IBAction)distractionON:(id)sender;

@end
