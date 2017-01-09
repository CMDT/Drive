//
//  mySingleton.m
//  DRIVE
//
//  Created by Jon Howell on 14/12/2015.
//  Copyright (c) 2016 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
}

@synthesize
//strings
            lapTimes,
            hornTimes,
            hornTimes2,
            hornTimesAll,
            wallLaps,
            hazLaps,
            hornLaps,
            tempEntry,
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

            missedTime,
            pressedTime,
            fastestReaction,
            slowestReaction,
            averageReaction,
            missed,
            reacted,
            gamePhysics,

// float64
            wallCrashMult,
            hazCrashMult,
            hornsMulti,
// float;
            ambientVolume,
            hornPosX,
            hornPosY,
            carSize,
            hazScale,
// int
            hornTimerCounter,
//bool
    hornsShowing,
    okGoNow,
    displayMinimum;

#pragma mark Singleton Methods

+ (mySingleton *) sharedSingleton {
    if(sharedSingleton  == nil) {
        sharedSingleton =  [[super allocWithZone:NULL]init];
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
        lapTimes               = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        hornTimes              = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        hornTimes2             = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        hornTimesAll           = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        wallLaps               = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        hazLaps                = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        hornLaps               = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        cardReactionTimeResult = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array

        
        //populate arrays with zeros at start of race, 100 laps max, do them all
        for (NSInteger i = 0; i < 102; ++i)
        {
            [lapTimes   addObject:@"0"];
            [wallLaps   addObject:@"0"];
            [hazLaps    addObject:@"0"];
            [hornLaps   addObject:@"0"];
            [cardReactionTimeResult addObject:@"0"];
        }
        for (NSInteger i = 0; i < 310; ++i) //more distractions than laps
            {
            [hornTimes    addObject:@"0"];
            [hornTimes2   addObject:@"0"];
            [hornTimesAll addObject:@"0"];
            }
        
        tempEntry           = @"";
        hornsShowing        = NO;
        okGoNow             = NO; // App will not run unless set to YES
        displayMinimum      = 1; //set to '2' if want horns pressed displayed, 1=just times & laps, 0 nothing except laps
        email               = @"me@mmu.ac.uk";
        testDate            = @"9/1/2017";
        testTime            = @"10:00";
        resultStrings       = @"";
        subjectName         = @"Sub";
        resultStrings       = @"";
        versionNumber       = @"4.0.4 - 09.01.17";
        
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
        distractionOn       = @"0";
        masterScore         = @"0";
        gamePhysics         = 0;
        
        missedTime          = @"999999";
        pressedTime         = @"999999";
        fastestReaction     = @"999999";
        slowestReaction     = @"999999";
        averageReaction     = @"999999";
        missed              = @"0";
        reacted             = @"0";
        
        wallCrashMult       = 0.05;
        hazCrashMult        = 0.1;
        hornsMulti          = 1.0;
        ambientVolume       = 0.50;
        hornTimerCounter    = 0;
        hornPosY            = 305; // set to default pos
        hornPosY            = 85;
        carSize             = 0.50;
        hazScale            = 0.60;
    }
    return self;
}
@end
