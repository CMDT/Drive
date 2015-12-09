//
//  AchievementsHelper.h
//  
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

@import Foundation;
@import GameKit;

@interface AchievementsHelper : NSObject

+ (GKAchievement *)collisionAchievement:(NSUInteger)numOfCollisions;
+ (GKAchievement *)achievementForLevel:(CRLevelType)levelType;

@end
