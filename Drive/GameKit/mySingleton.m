//
//  mySingleton.m
//  VO2
//
//  Created by Jon Howell on 15/07/2014.
//  Copyright (c) 2014 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//  7/12/15
//

#import "mySingleton.h"

static mySingleton * sharedSingleton = nil;

@implementation mySingleton {
    
}

//note, some of these vars unused from other apps, left for reference and future use
// eg for all in .h
// @synthesize counter;

//Counters
@synthesize
            testDate,
            testTime,
            testerName,
            subjectName,
            oldSubjectName,
            subWt,
            subHt,
            email,

            labTemp,
            labPressure_mmHg,
            labHumidity,
            labLocation,
            sampTime,
            feco2,
            feo2,
            labO2,
            labCO2,

            veatps,
            vestpd,
            vebtps,
            corrFactor,
            vo2,
            vco2,
            n2, //nitrogen
            vo2kg,
            rer,

            addedToResults,
            dataCompleted,
            isDegC,
            ismmHg,
            resultStrings,
            cardReactionTimeResult,
            counter,

            versionNumber,
            fata,
            fatb,
            cho291,
            cho412,
//energies
energyExpend,
chug,
chukj,
fatg,
fatkj,
pfat,
pcho;

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
        
        //initialise with values, eg
        //linewidth=1;
        //counter=0;
        //lineColour=[UIColor blueColor];
        //boxShow=YES;
        //subjectName=@"TempSubject";
        //picturePos=CGRectMake(10,50,1000,800);//approx, will be updated in a moment anyway
        //cardReactionTimeResult = [[NSMutableArray alloc]initWithObjects: nil];

        addedToResults     = NO;
        dataCompleted      = NO;
        isDegC             = YES;
        ismmHg             = YES;
        subWt              = @"75.0";
        subHt              = @"1.75";
        labTemp            = @"20.0";
        labPressure_mmHg   = @"760.0";
        labHumidity        = @"35.0";
        labLocation        = @"hpl";
        sampTime           = @"60";
        veatps             = @"0";
        vestpd             = @"0";
        feco2              = @"0";
        feo2               = @"0";
        veatps             = @"30";
        vebtps             = @"0";
        corrFactor         = @"1";
        vo2                = @"0";
        vco2               = @"0";
        n2                 = @"0";
        vo2kg              = @"0";
        labO2              = @"20.93";
        labCO2             = @"0.04";
        rer                = @"0";
        testerName         = @"";
        email              = @"";
        testDate           = @"";
        testTime           = @"";
        resultStrings      = @"";
        subjectName        = @"Sub";
        oldSubjectName     = @"Sub";
        resultStrings      = @"";
        versionNumber      = @"2.2.3 - 00.00.15";
        cardReactionTimeResult = [[NSMutableArray alloc]initWithObjects:@"", nil]; //empty array
        counter            = 0;
        cho291             = 2.91;
        cho412             = 4.12;
        fata               = 1.689;
        fatb               = 1.689;
        //energies
        energyExpend        = @"0";
        chug                = @"0";
        chukj               = @"0";
        fatg                = @"0";
        fatkj               = @"0";
        pfat                = @"0";
        pcho                = @"0";
    }
    return self;
}
@end