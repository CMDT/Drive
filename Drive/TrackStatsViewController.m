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

- (void)action {
  
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
