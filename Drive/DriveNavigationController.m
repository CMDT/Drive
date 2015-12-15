//
//  DriveNavigationController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "DriveNavigationController.h"
#import "GameKitHelper.h"

@interface DriveNavigationController ()

@end

@implementation DriveNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//prob for game centre, don't bother yet
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];

    //[[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Observer

- (void)p_showAuthenticationViewController {
    //GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];

    //[self.topViewController presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

@end
