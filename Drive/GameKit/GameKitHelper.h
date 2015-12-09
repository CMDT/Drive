//
//  GameKitHelper.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

@import Foundation;
@import GameKit;

UIKIT_EXTERN NSString * const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic, strong, readonly) UIViewController *authenticationViewController;
@property (nonatomic, strong, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)reportAchievements:(NSArray *)achievements;
- (void)showGKGameCenterViewController:(UIViewController *)viewController;

@end
