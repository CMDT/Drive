//
//  mySingleton.h
//  DRIVE
//
//  Created by Jon Howell on 15/07/2014.
//  Copyright (c) 2015 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface mySingleton : NSObject {

    int counter;

    NSMutableArray * cardReactionTimeResult;
    NSString       * resultsStrings;
    
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
    NSString * averageLap;
    NSString * totalTime;
    NSString * hazCrashes;
    NSString * wallCrashes;
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
}

@property (nonatomic) int  counter;
@property (nonatomic, retain) NSMutableArray * cardReactionTimeResult;
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
@property (nonatomic, retain) NSString * averageLap;
@property (nonatomic, retain) NSString * totalTime;
@property (nonatomic, retain) NSString * hazCrashes;
@property (nonatomic, retain) NSString * wallCrashes;
@property (nonatomic, retain) NSString * hornsPlayed;
@property (nonatomic, retain) NSString * fastestHorn;
@property (nonatomic, retain) NSString * slowestHorn;
@property (nonatomic, retain) NSString * averageHorn;
@property (nonatomic, retain) NSString * totalHorn;
@property (nonatomic, retain) NSString * distractionOn;
@property (nonatomic, retain) NSString * masterScore;
@property (nonatomic) Float64 wallCrashMult;
@property (nonatomic) Float64 hazCrashMult;
@property (nonatomic) Float64 hornsMulti;

//set up singleton shared

+(mySingleton *)sharedSingleton;

@end

