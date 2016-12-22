//
//  mySingleton.h
//  DRIVE
//
//  Created by Jon Howell on 15/07/2014.
//  Copyright (c) 2015 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import <Foundation/Foundation.h>

@interface mySingleton : NSObject {
    BOOL hornsShowing;
    BOOL okGoNow; //flag that App can run
    int  counter;

    NSMutableArray * cardReactionTimeResult;
    NSString       * resultsStrings;
    // arrays for detailed timings for each lap in data
    NSMutableArray * lapTimes;
    NSMutableArray * hornTimes;
    NSMutableArray * hornTimes2;
    NSMutableArray * hornTimesAll;
    NSMutableArray * wallLaps;
    NSMutableArray * hazLaps;
    NSMutableArray * hornLaps;
    NSString       * tempEntry; // for above arrays
    
    NSString * email;
    NSString * testDate;
    NSString * testTime;
    NSString * resultStrings;
    NSString * subjectName;
    NSString * versionNumber;
    NSString * laps;
    NSString * carNo;
    NSString * trackNo;
    NSString * musicTrack;
    NSString * fastestLap;
    NSString * slowestLap;
    NSString * fastestLapNo;
    NSString * slowestLapNo;
    NSString * averageLap;
    NSString * totalTime;
    NSString * hazCrashes;
    NSString * wallCrashes;
    NSString * totalCrashes;
    NSString * hornsPlayed;
    NSString * fastestHorn;
    NSString * slowestHorn;
    NSString * averageHorn;
    NSString * totalHorn;
    NSString * distractionOn;
    NSString * masterScore;
    Float64    wallCrashMult;
    Float64    hazCrashMult;
    Float64    hornsMulti;
    float      ambientVolume;
    int        hornTimerCounter;
}
@property (nonatomic) BOOL    hornsShowing;
@property (nonatomic) BOOL    okGoNow;
@property (nonatomic) int     counter;
@property (nonatomic, retain) NSMutableArray * cardReactionTimeResult;

// arrays for detailed timings for each lap in data
@property (nonatomic, retain) NSMutableArray * lapTimes;
@property (nonatomic, retain) NSMutableArray * hornTimes;
@property (nonatomic, retain) NSMutableArray * hornTimes2;
@property (nonatomic, retain) NSMutableArray * hornTimesAll;
@property (nonatomic, retain) NSMutableArray * wallLaps;
@property (nonatomic, retain) NSMutableArray * hazLaps;
@property (nonatomic, retain) NSMutableArray * hornLaps;
@property (nonatomic, retain) NSString       * tempEntry; // for above arrays

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * resultStrings;
@property (nonatomic, retain) NSString * subjectName;
@property (nonatomic, retain) NSString * testDate;
@property (nonatomic, retain) NSString * testTime;
@property (nonatomic, retain) NSString * versionNumber;
@property (nonatomic, retain) NSString * laps;
@property (nonatomic, retain) NSString * carNo;
@property (nonatomic, retain) NSString * trackNo;
@property (nonatomic, retain) NSString * musicTrack;
@property (nonatomic, retain) NSString * fastestLap;
@property (nonatomic, retain) NSString * slowestLap;
@property (nonatomic, retain) NSString * fastestLapNo;
@property (nonatomic, retain) NSString * slowestLapNo;
@property (nonatomic, retain) NSString * averageLap;
@property (nonatomic, retain) NSString * totalTime;
@property (nonatomic, retain) NSString * hazCrashes;
@property (nonatomic, retain) NSString * wallCrashes;
@property (nonatomic, retain) NSString * totalCrashes;
@property (nonatomic, retain) NSString * hornsPlayed;
@property (nonatomic, retain) NSString * fastestHorn;
@property (nonatomic, retain) NSString * slowestHorn;
@property (nonatomic, retain) NSString * averageHorn;
@property (nonatomic, retain) NSString * totalHorn;
@property (nonatomic, retain) NSString * distractionOn;
@property (nonatomic, retain) NSString * masterScore;
@property (nonatomic)          Float64   wallCrashMult;
@property (nonatomic)          Float64   hazCrashMult;
@property (nonatomic)          Float64   hornsMulti;
@property (nonatomic)          float     ambientVolume;
@property (nonatomic)          int       hornTimerCounter;

//set up singleton shared

+(mySingleton *)sharedSingleton;

@end
