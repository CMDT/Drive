//
//  AchievementsHelper.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "AchievementsHelper.h"

static NSString * const kDestructionHeroAchievementId = @"uk.ac.mmu.ess.www.jah.destructiondriver";
static NSString * const kAmateurAchievementId         = @"uk.ac.mmu.ess.www.jah.amateurdriver";
static NSString * const kIntermediateAchievementId    = @"uk.ac.mmu.ess.www.jah.intermediatedriver";
static NSString * const kProfessionalAchievementId    = @"uk.ac.mmu.ess.www.jah.professionaldriver";

//static const NSInteger kMaxCollisions = 20;//orig
static const NSInteger kMaxCollisions = 200;//jah

@implementation AchievementsHelper

+ (GKAchievement *)collisionAchievement:(NSUInteger)numOfCollisions {
    CGFloat percent = (numOfCollisions / kMaxCollisions) / 100;

    GKAchievement *collisionAchievement = [[GKAchievement alloc] initWithIdentifier:kDestructionHeroAchievementId];
    collisionAchievement.percentComplete = percent;
    collisionAchievement.showsCompletionBanner = YES;

    return collisionAchievement;
}

+ (GKAchievement *)achievementForLevel:(CRLevelType)levelType {
    NSString *achievementId = kAmateurAchievementId;

    if (levelType == CRLevelMedium) {
        achievementId = kIntermediateAchievementId;
    }
    else if (levelType == CRLevelHard) {
        achievementId = kProfessionalAchievementId;
    }

    GKAchievement *levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementId];
    levelAchievement.percentComplete = 100;
    levelAchievement.showsCompletionBanner = YES;

    return levelAchievement;
}

@end
