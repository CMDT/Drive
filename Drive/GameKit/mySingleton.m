//
//  mySingleton.m
//  DRIVE
//
//  Created by Jon Howell on 14/12/2015.
//  Copyright (c) 2015 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
}
@synthesize
//strings
            hornsShowing,
            testDate,
            testTime,
            subjectName,
            email,
            resultStrings,
            cardReactionTimeResult,
            counter,
            versionNumber,
            laps,
            carNo,
            trackNo,
            musicTrack,
            fastestLap,
            slowestLap,
            fastestLapNo,
            slowestLapNo,
            averageLap,
            totalTime,
            hazCrashes,
            wallCrashes,
            totalCrashes,
            hornsPlayed,
            fastestHorn,
            slowestHorn,
            averageHorn,
            totalHorn,
            distractionOn,
            masterScore,
//float64
            wallCrashMult,
            hazCrashMult,
            hornsMulti
;

#pragma mark -
#pragma mark Singleton Methods

+ (mySingleton *) sharedSingleton {
    if(sharedSingleton==nil) {
        sharedSingleton = [[super allocWithZone:NULL]init];
    }
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *) zone {
    return [self sharedSingleton];
}

- (id)copyWithZone:(NSZone *) zone {
    return self;
}

- (id) init {
    if(self = [super init]) {
        hornsShowing        = NO;
        email               = @"";
        testDate            = @"15/12/2015";
        testTime            = @"12:00";
        resultStrings       = @"";
        subjectName         = @"Sub";
        resultStrings       = @"";
        versionNumber       = @"1.2.3 - 14.12.15";
        cardReactionTimeResult = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        counter             = 0;
        laps                = @"0";
        carNo               = @"0";
        trackNo             = @"0";
        musicTrack          = @"None";
        fastestLap          = @"999999";
        slowestLap          = @"999999";
        fastestLapNo        = @"0";
        slowestLapNo        = @"0";
        averageLap          = @"999999";
        totalTime           = @"999999";
        hazCrashes          = @"0";
        wallCrashes         = @"0";
        totalCrashes        = @"0";
        hornsPlayed         = @"0";
        fastestHorn         = @"999999";
        slowestHorn         = @"999999";
        averageHorn         = @"999999";
        totalHorn           = @"999999";
        distractionOn       = @"OFF";
        masterScore         = @"0";
        wallCrashMult       = 1.0;
        hazCrashMult        = 1.0;
        hornsMulti          = 1.0;
    }
    return self;
}
@end