//
//  TrackStatsViewController.m
//  Drive
//
//  Created by Jonathan Howell on 13/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//

// back button is Start Again

#import "TrackStatsViewController.h"
#import "ViewController.h"

@interface TrackStatsViewController ()

@end

@implementation TrackStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    //print up the results and then save the lot to the plist settings bundle for later review.
    
    //Save to email and send
}

 - (IBAction)finishAction:(id)sender {
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
