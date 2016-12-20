//
//  MyScene.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  first commit 9/12/15
//  big update 12/12/15
//  Updating for ios 10.0.2 and new sound features implementation.
//

// defs
#import "MyScene.h"
// control the virtual joystick for car driving
#import "AnalogControl.h"
// graphics and sprites for obsticals and graphics displays
#import "SKTUtils.h"
// end of game achievement certificates if set in game kit use.  Not used at present in main game
#import "AchievementsHelper.h"
// Apple Game Centre, not used yet
#import "GameKitHelper.h"
// global vars here
#import "mySingleton.h"
#include <sys/time.h>

// how to call the singleton, line below in functions top, then reference var name
// ... mySingleton *singleton = [mySingleton sharedSingleton];

typedef NS_OPTIONS(NSUInteger, CRPhysicsCategory) {
    CRBodyCar   = 1 << 0,  // 0000001 = 1
    CRBodyBox   = 1 << 1,  // 0000010 = 2
    CRBodyCrate = 1 << 1,
    CRBodyTyre  = 1 << 1,
    CRBodyBale  = 1 << 1,
    CRBodyPause = 1 << 1,
};

@interface MyScene () <SKPhysicsContactDelegate>
{
    // set out all vars and constants for game
    Float32 reactionTime[101];
    Float32 noOfSeconds;
    int     xcounter;
    int     lapTimez[101];
    int     hornTimes[101];
    Float32 hornTimesAll[101];
    
    Float32 fastestLap;
    Float32 slowestLap;
    Float32 averageLap;
    Float32 fastestHorn;
    Float32 slowestHorn;
    Float32 averageHorn;
    Float32 raceTime;
    //Float32 hornTime;
    Float32 masterScore;
    double  temp;
    //int     angAdd;
    int     angAdd1;
    int     angAdd2;
    int     angAdd3;
    Float32 sign;
    Float32 tempt;
    long    totalCrashes;
    
    int     lap;
    int     fastLap;
    int     slowLap;
    int     tempHaz;
    int     tempWall;
    int     horns;
    long    tt; // time for playning a horn every n seconds
    long    tt6;
    long    horn_tt;
    long    horn_tt2;
    long    horn_tt3;
    long    pre; //pressed horns
    
    BOOL    displayMinimum;//if yes, then cut the horns counter on screen
    BOOL    hornShowing;
    BOOL    hornsPressed;//for horns pressed
    BOOL    hornTriggered; // when yes, the car is in the right position
    BOOL    horn2Triggered;
    BOOL    horn3Triggered;
    BOOL    started; // has the start lamp sequence finished?
    Float32 hornReactionTime[101];
    double temp1;
    double temp2;
    double temp3;
    double temp4;
    double temp5;
    double prev2;
    double millis2;
    double millis3;
    
    long    xx,yy;
}

@property (nonatomic, assign) CRCarType       carType;
@property (nonatomic, assign) CRLevelType     levelType;
@property (nonatomic, assign) NSTimeInterval  timeInSeconds;
@property (nonatomic, assign) NSInteger       numOfLaps;
@property (nonatomic, assign) NSInteger       hors;
@property (nonatomic, strong) SKSpriteNode  * car;

@property (nonatomic, strong) SKLabelNode   * laps,
                                            * time,
                                            * colls,
                                            * hor,
                                            * walls;

@property (nonatomic, assign) NSInteger       maxSpeed;
@property (nonatomic, assign) CGPoint         trackCenter;
@property (nonatomic, assign) NSTimeInterval  previousTimeInterval;
@property (nonatomic, assign) NSUInteger      numOfCollisionsWithBoxes;
@property (nonatomic, assign) NSUInteger      numOfCollisionsWithWalls;

// Sound effects
@property (nonatomic, strong) SKAction * boxSoundAction;
@property (nonatomic, strong) SKAction * hornSoundAction;
@property (nonatomic, strong) SKAction * lapSoundAction;
@property (nonatomic, strong) SKAction * punctureSoundAction;
@property (nonatomic, strong) SKAction * wallSoundAction;

@end

@implementation MyScene

@synthesize startDate, startDateHorn;

- (void)viewDidLoad {
    //
}

#pragma mark - Initialise Game

//in storyboard, note button for game centre is turned to 1px x 1px. set to 301 x 55 in settings measure properties.

- (instancetype)initWithSize:(CGSize)size carType:(CRCarType)carType level:(CRLevelType)levelType {
    self = [super initWithSize:size];
    mySingleton *singleton = [mySingleton sharedSingleton];
    if (self) {
        _carType   = [singleton.carNo   integerValue]; // carType;
        _levelType = [singleton.trackNo integerValue]; // levelType;
        _numOfCollisionsWithBoxes = 0;                 // start off with clean sheet

        horns = 0;
        singleton.hornsPlayed = @"0";
        
        fastestHorn = +999999;
        slowestHorn = -999999;
        averageHorn = -999999;
        
        displayMinimum=YES;//show the horns display
        
        // set singletn arrays to zero to start, as will be NULL if not.

        for (NSInteger i = 0; i < 102; ++i)
            {
            singleton.lapTimes[i]  = @"0";
            singleton.hornTimes[i] = @"0";
            singleton.hornTimes2[i]= @"0";
            singleton.wallLaps[i]  = @"0";
            singleton.hazLaps[i]   = @"0";
            singleton.hornLaps[i]  = @"0";
            singleton.cardReactionTimeResult[i] = @"0";
            }
        [self p_initializeGame];
        
        //set the start timer for the horns, and put the result in the zero element of the array
        self.startDateHorn     = [NSDate date];
        singleton.hornsPlayed  = [NSString stringWithFormat:@"0"];
        hornsPressed = NO;
        singleton.hornsShowing = NO;
        horn_tt  = 0; //lap  zero
        horn_tt2 = 0;
        horn_tt3 = 0;
        tempHaz  = 0;
        tempWall = 0;
        xcounter = 1;
        horns    = 0;
        singleton.hornTimerCounter = 0;
        angAdd1  = 3.01; //flagg=3.01, any other not flag
        angAdd2  = 0.0;
        angAdd3  = -7.0;
        hornTriggered  = NO;
        horn2Triggered = NO;
        horn3Triggered = NO;
        
        //4 second delay whilst start lamps display
        started=NO;
    }
    return self;
}

// *******************************************************************
// *** game proper, this is the run loop on this update            ***
// *******************************************************************
// this runs for each tick of the clock
//
- (void)update:(NSTimeInterval)currentTime {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //halt the timer until 4 seconds are up to allow start lamps display to finish
    if (self.previousTimeInterval == 0 && !started) {
        self.previousTimeInterval =  currentTime+4;
    }
    //NSLog(@"started=%i,prev=%.2f, curr=%.2f, time=%.3f", started, self.previousTimeInterval, currentTime, self.previousTimeInterval-currentTime);
    //only let the car moove when the lamps are out
    if (self.previousTimeInterval-currentTime<0) {
        started=YES;
    }
    
    //****************************************************************
    if (self.isPaused) {
        // find a way to halt the timer, then restart it for laps
        // *****
        // ***** still an issue, tell users not to pause, it will scrap the game data!
        // *****
        // *****
        
        //scrap that lap
        self.previousTimeInterval = currentTime;
        
        //look again at pause?
        //xcounter -=1;//drop back one lap
        //self.numOfLaps -= 1;
        
        return;
    }
    //****************************************************************
    if (currentTime - self.previousTimeInterval > 1) {
        self.timeInSeconds += (currentTime - self.previousTimeInterval);//was -= to count down, now count up
        self.previousTimeInterval = currentTime;
        
        //do some conversion for race
        long hours3,  minutes3, left3;
        long seconds3;
        left3=(long)_timeInSeconds;
        seconds3 = (left3 % 60);
        minutes3 = (left3 % 3600) / 60;
        hours3   = (left3 % 86400) / 3600;
        
        NSString *tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours3,minutes3,seconds3];
        
        self.time.text = [NSString stringWithFormat:@"Time: %@", tem3];
    }
    
    //where is the car on the track?, is it going the correct way round to reduce the laps
    
    static CGFloat nextProgressAngle = M_PI; // was M_PI, pi rads == 180 deg
    
    // draw an imaginary line from centre of track to car
    CGPoint vector = CGPointSubtract(self.car.position, self.trackCenter);
    
    // turn the position to an angle
    CGFloat progressAngle = CGPointToAngle(vector) * M_PI;
    
    //NSLog(@"Vector = %d : %d, progress = %f : %f",(int)_car.position.x,(int)_car.position.y, progressAngle, nextProgressAngle);
    
    //if (progressAngle > nextProgressAngle) {
        //NSLog(@"prog>nextProg");}else{NSLog(@"prog NOT > nextProg");
    //}
    //if (progressAngle - nextProgressAngle < M_PI_4) { // pi/4 rads == 90 deg
        // NSLog(@"prog-nextProg<pi/4"); } //else{NSLog(@"prog-nextProg NOT < pi/4");
    //}
    
    //check to see when the horn needs triggering
    
        long dist = [singleton.distractionOn integerValue];
    
        switch (dist) {
            case 1:
                if (horn_tt==0) {
                    
                //1 distraction per lap
                if(angAdd1>0){
                    if (progressAngle < angAdd1+1 && progressAngle >= angAdd1) {//(progressAngle < 2 && progressAngle > 1) range 0 to 10, -1 to -10
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd1 && progressAngle > angAdd1-1) {//(progressAngle < 2 && progressAngle > 1) range 0 to 10, -1 to -10
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                }
            }
            break;
                
            case 2:
                if (horn_tt2==0){

                //2 distractions per lap
                if(angAdd1>0){
                    if (progressAngle < angAdd1+1 && progressAngle >= angAdd1) {
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd1 && progressAngle > angAdd1-1) {
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                }
                if(angAdd2>0){
                    if (progressAngle < angAdd2+1 && progressAngle >= angAdd2) {
                        horn2Triggered = YES;
                    } else {
                        horn2Triggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd2 && progressAngle > angAdd2-1) {
                        horn2Triggered = YES;
                    } else {
                        horn2Triggered = NO;
                    }
                }
            }
            break;
                
            case 3:
                if (horn_tt3==0){
                //3 distractions per lap
                if(angAdd1>0){
                    if (progressAngle < angAdd1+1 && progressAngle >= angAdd1) {//(progressAngle < 2 && progressAngle > 1) range 0 to 10, -1 to -10
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd1 && progressAngle > angAdd1-1) {//(progressAngle < 2 && progressAngle > 1) range 0 to 10, -1 to -10
                        hornTriggered = YES;
                    } else {
                        hornTriggered = NO;
                    }
                }
                if(angAdd2>0){
                    if (progressAngle < angAdd2+1 && progressAngle >= angAdd2) {
                        horn2Triggered = YES;
                    } else {
                        horn2Triggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd2 && progressAngle > angAdd2-1) {
                        horn2Triggered = YES;
                    } else {
                        horn2Triggered = NO;
                    }
                }
                if(angAdd3>0){
                    if (progressAngle < angAdd3+1 && progressAngle >= angAdd3) {
                        horn3Triggered = YES;
                    } else {
                        horn3Triggered = NO;
                    }
                } else {
                    if (progressAngle <= angAdd3 && progressAngle > angAdd3-1) {
                        horn3Triggered = YES;
                    } else {
                        horn3Triggered = NO;
                    }
                }
            }
            break;
                
            default:
            break;
        }
    //NSLog(@"horn trig = %f, a1=%d, a2=%d, a3=%d",reactionTime[xcounter],angAdd1,angAdd2,angAdd3);
    
    if (progressAngle > nextProgressAngle && (progressAngle - nextProgressAngle) < M_PI_4) { // M_PI_4 = pi/4
        nextProgressAngle += M_PI_2; // M_PI_2 = pi/2 rads == 45 deg
        
       if (nextProgressAngle > 2 * M_PI) { //was 2, 2*pi rads == 360
           //reset angle of car
        nextProgressAngle = 0;
        }
        
        if (fabs(nextProgressAngle - M_PI) < FLT_EPSILON) { //the difference between 1.0 and the smallest float bigger than 1.0.
            //start of new lap here
            self.numOfLaps -= 1;
            self.hors=horns;
            horn_tt  = 0; //passed the finish line, reset all
            horn_tt2 = 0;
            horn_tt3 = 0;
            
            //read the timer
            reactionTime[xcounter] = (Float32)[self.startDate timeIntervalSinceNow]* -1000.0f;
            xcounter += 1;

            tempWall = 0;
            tempHaz  = 0;
            
            //test if last lap and message driver
            if ((long)self.numOfLaps>1) {
                self.laps.text = [NSString stringWithFormat:@"Laps to go: %li", (long)self.numOfLaps];
            } else {
                self.laps.text = @"Last Lap !";
            }
            //NSLog(@"Lap time = %f",reactionTime[xcounter]);
            
            //make a lapping sound OLD way
            //[self runAction:self.lapSoundAction];
            
            //make a lapping sound NEW way with volume level
            
            NSError * error1;
            NSURL   * soundURL1 = [[NSBundle mainBundle] URLForResource:@"lap" withExtension:@"wav"];
            AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL1 error:&error1];
            [player setVolume:singleton.ambientVolume];
            [player prepareToPlay];
            
            SKAction * playAction = [SKAction runBlock:^{
                [player play];
                }];
            SKAction * waitAction = [SKAction waitForDuration:player.duration+1];
            SKAction * sequence   = [SKAction sequence:@[playAction, waitAction]];
            
            [self runAction:sequence];

            //make a randon angle for horn trigger position as new lap started
            if (horn_tt<2) {
                
                long dist1 = [singleton.distractionOn integerValue];
                
                switch (dist1) {
                    case 1:
                        //1 distraction
                        if (angAdd1!=3.01) {
                            angAdd1 = 3+(((float)rand() /RAND_MAX)*6); //don't beep just past start line (start at 2), and avoid the very last part 9) so not to clash with lap sound
                            sign   = (((float)rand() /RAND_MAX)*2);   //make negative/positive at random
                            
                            if(sign > 1.0){
                                angAdd1 = -1 * angAdd1; //reverse sign
                            }
                            //NSLog(@"sign ang = %.3f %d", sign, angAdd);
                        } else {
                            angAdd1=6.0;
                        }
                    break;
                        
                    case 2:
                        //2 distractions
                            angAdd1 =  3+(((float)rand() /RAND_MAX)*6);
                            angAdd2 = -1 *(3+(((float)rand() /RAND_MAX)*6)); //reverse sign for second horn

                        //angAdd1 =  5.0;
                        //angAdd2 =  -5.0;
                        //angAdd3 =  -6.0;
                    break;
                        
                    case 3:
                        //3 distractions
                            angAdd1 = (3+(((float)rand() /RAND_MAX)*3));
                            angAdd2 = (0+(((float)rand() /RAND_MAX)*2));
                            angAdd3 = -1*(3+(((float)rand() /RAND_MAX)*3));

                        //angAdd1 =  4.0;
                        //angAdd2 =  9.0;
                        //angAdd3 =  -6.0;
                    break;
                        
                    default:
                        break;
                }
            }
        }
        //NSLog(@"reset angles");
    }
    
    //only do this if the distraction flag is ON
    
    if ([singleton.distractionOn isEqual:@"1"]||[singleton.distractionOn isEqual:@"2"]||[singleton.distractionOn isEqual:@"3"]) {

        if (hornTriggered||horn2Triggered||horn3Triggered){
            //reset the triggers if set
            if (hornTriggered) {
                hornTriggered = NO;
                horn_tt++;
            }
            if (horn2Triggered) {
                horn2Triggered = NO;
                horn_tt2++;
            }
            if (horn3Triggered) {
                horn3Triggered = NO;
                 horn_tt3++;
            }

            //start the horn timer
            //set the flag, the horn sound was played
            
            if (horn_tt == 1||horn_tt2 == 1||horn_tt3 == 1) {
                //tell the timer that the horn is not pressed yet
                singleton.hornsShowing = NO;
                //show the button
                self.hornBlock(YES);
                
                struct timeval time;
                gettimeofday(&time, NULL);
                millis2 = (time.tv_sec * 1000) + (time.tv_usec / 1000);
                hornReactionTime[horns]=millis2;
                
                //update horn counter on screen if flag on
                if(!displayMinimum){
                    self.hor.text = [NSString stringWithFormat:@"H: %li", (long)self.hors+1];
                }
                //beep the horn
                [self runAction:self.hornSoundAction];
                
                //update display for horn was beeped
                
                //trigger and time
                //NSLog(@"horn, start horn time=%i, %.f", horns, millis2); //only triggered on horn play
                horns++;
                if (hornTriggered  == YES) {
                    horn_tt++;
                }
                if (horn2Triggered == YES) {
                    horn_tt2++;
                }
                if (horn3Triggered == YES) {
                    horn_tt3++;
                }
                singleton.hornsPlayed = [NSString stringWithFormat:@"%i", horns];
            }
        } else {
            // do nothing, everywhere else n, s, e
                //NSLog(@"nothing to do");
            }
        
        // collect the current gap time

        struct timeval time;
        gettimeofday(&time, NULL);
        millis3 = (time.tv_sec * 1000) + (time.tv_usec / 1000);

        temp3 = (millis3-millis2)/1000;
        
        //look for the horn button being pressed
        if (singleton.hornsShowing == YES) {

            //stop the horn timer and record it
            hornReactionTime[horns-1] = temp3;
            //NSLog(@"Horn Reaction = , %.2f", temp3); //
            
            //reset the flag, so another horn can play
            singleton.hornsShowing = NO;
            /*if ([singleton.distractionOn isEqualToString: @"2"]) {
                horn_tt2 = 0;
            }
            
            if ([singleton.distractionOn isEqualToString: @"3"]) {
                horn_tt2 = 0;
                horn_tt3 = 0;
            }*/
        }
        //fix horn time at diff between start times if no recorded end
        if (millis2 > 1000) {
            hornReactionTime[horns] = 1000;//prev2;
        }
    }
    
    if (self.timeInSeconds < 0 || self.numOfLaps == 0) {
        self.paused = YES;
        
        BOOL hasWon = self.numOfLaps == 0;
        
        [self p_reportAchievementsForGameState:hasWon];
        
        self.gameOverBlock(hasWon);
    }
}

#pragma mark - Start the Game

- (void)p_initializeGame {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    [self p_loadLevel];
    
    SKSpriteNode     *track     = ({
        NSString     *imageName = [NSString stringWithFormat:@"track_%li", _levelType];
        SKSpriteNode *sprite    = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sprite;
    });
    [self addChild:track];
    
    //[self p_addCarAtPosition:CGPointMake(CGRectGetMidX(track.frame), 50.0f)];//used to be 50, == middle of track at centre bottom
    [self p_addCarAtPosition:CGPointMake(430.0f, 180.0f)];
    
    // Turn off the world's gravity
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);// 0,0 = g off .... 1,1 = pulls to right top corner
    
    self.physicsBody = ({
        CGRect frame = CGRectInset(track.frame, 40.0f, 0.0f);// 40.0f,0.0f= old
        SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
        body;
    });
    
    [self p_addObjectsForTrack:track];
    [self p_addGameUIForTrack: track];
    
    _maxSpeed = 150 * (1 + _carType); //was 125, but a bit too slow
    
    _trackCenter = track.position;
    
    _boxSoundAction      = [SKAction playSoundFileNamed: @"box.wav"      waitForCompletion:NO];
    _hornSoundAction     = [SKAction playSoundFileNamed: @"horn.wav"     waitForCompletion:NO];
    _lapSoundAction      = [SKAction playSoundFileNamed: @"lap.wav"      waitForCompletion:NO];
    _punctureSoundAction = [SKAction playSoundFileNamed: @"puncture.wav" waitForCompletion:NO];
    _wallSoundAction     = [SKAction playSoundFileNamed: @"box.wav"      waitForCompletion:NO]; //change to new sound some time = wall.wav
    
    //turn on the contact dlegate to test contacts between bodies, ie boxes and walls with car
    self.physicsWorld.contactDelegate = self;
    
    xcounter = 1;//start the array for timings of laps
    
    //add the first drive clock time to the array
    self.startDate=[NSDate date];
    reactionTime[0] = [self.startDate timeIntervalSinceNow]* -1000.000; // added .000, may not be needed for accuracy
    
    //set the horn display 'off' at start
    singleton.hornsShowing = NO;
    
    xx = track.position.x;
    yy = track.position.y;
    
//***************
    //GO NOW !
//***************
    //try countdown timers here...
}

//now using singleton for laps

- (void)p_loadLevel {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LevelDetails" ofType:@"plist"];
    //NSArray *level = [NSArray arrayWithContentsOfFile:filePath];
    
    //NSNumber *timeInSeconds = level[_levelType - 1][@"time"];
    _timeInSeconds = 0.0f; //[timeInSeconds doubleValue];
    
    //now using singleton
    //NSNumber *laps = level[_levelType - 1][@"laps"];
    //_numOfLaps = [laps integerValue];
    _numOfLaps = [singleton.laps integerValue];
    _hors=[singleton.hornsPlayed integerValue];
}

- (void)p_addCarAtPosition:(CGPoint)startPosition {
    _car = ({
        NSString *imageName = [NSString stringWithFormat:@"car_%li", _carType];
        //NSLog(@"Car=%li, Track=%li",_carType,_levelType);
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = startPosition;
        
        // make changes to scale car size
        sprite.xScale = 0.80;
        sprite.yScale = 0.80;
        
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.frame.size];
        sprite.physicsBody.categoryBitMask    = CRBodyCar;
        sprite.physicsBody.collisionBitMask   = CRBodyBox;
        sprite.physicsBody.contactTestBitMask = CRBodyBox;
        sprite.physicsBody.allowsRotation = NO;
        sprite;
    });
    
    //put a car on the track
    [self addChild:_car];
    
    //turn the car 90 degs ccw
    //M_PI/4.0 is 45 degrees, you can make duration different from 0 if you want to show the rotation, if it is 0 it will rotate instantly
    SKAction *rotation = [SKAction rotateByAngle: M_PI/2.0 duration:0];
    
    //and just run the action to turn it
    [_car runAction: rotation];
    
    //start the clock in mS
    //zero
    for (int x=0; x<101; x+=1) {
        reactionTime[x] = 0.0f;
    }
    slowestLap  = -999999.0f;
    fastestLap  =  999999.0f;
    averageLap  =  999999.0f;
    
    slowestHorn = -999999.0f;
    fastestHorn =  999999.0f;
    averageHorn =  999999.0f;
}

- (void)p_addBoxAt:(CGPoint)point {
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
    box.position = point;
    
    // scale the box here
    box.xScale = 0.65;
    box.yScale = 0.65;
    
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    box.physicsBody.categoryBitMask = CRBodyBox;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    box.physicsBody.linearDamping = 1.0f;//1
    box.physicsBody.angularDamping = 1.0f;//1
    //box.physicsBody.mass=1000; //added but not needed
    //box.physicsBody.friction = 1000; //added but not needed
    box.physicsBody.dynamic=NO;
    
    [self addChild:box];
}

- (void)p_addCrateAt:(CGPoint)point {
    SKSpriteNode *crate = [SKSpriteNode spriteNodeWithImageNamed:@"crate"];
    
    // scale the crate here
    crate.xScale = 0.6;
    crate.yScale = 0.6;
    
    crate.position = point;
    crate.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:crate.size];
    crate.physicsBody.categoryBitMask = CRBodyCrate;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    crate.physicsBody.linearDamping = 1.0f;//1
    crate.physicsBody.angularDamping = 1.0f;//1
    //crate.physicsBody.mass=1000; //added but not needed
    //crate.physicsBody.friction = 1000; //added but not needed
    crate.physicsBody.dynamic=NO;
    
    [self addChild:crate];
}
- (void)p_addPauseAt:(CGPoint)point {
    //cut for now.. need to link button to action.  in vc, its alreafdy displayed manually in storyboard.
    
    //to mask the top right corner from the cars, its an obsticle and stops the car from running under it
    /* SKSpriteNode *pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause2Gr"];
    
    // scale the pause here
    pause.xScale = 0.45;
    pause.yScale = 0.45;
    
    pause.position = point;
    pause.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pause.size];
    pause.physicsBody.categoryBitMask = CRBodyPause;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    pause.physicsBody.linearDamping  = 1.0f;//1
    pause.physicsBody.angularDamping = 1.0f;//1

    pause.physicsBody.dynamic=NO; //no=does not move or slide
    
    [self addChild:pause];
    */
}

- (void)p_addBaleAt:(CGPoint)point {
    SKSpriteNode *bale = [SKSpriteNode spriteNodeWithImageNamed:@"bale"];
    bale.position = point;
    
    // scale the bale here
    bale.xScale = 0.6;
    bale.yScale = 0.6;
    
    bale.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bale.size];
    bale.physicsBody.categoryBitMask = CRBodyBale;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    bale.physicsBody.linearDamping  = 1.0f;//1
    bale.physicsBody.angularDamping = 1.0f;//1
    //bale.physicsBody.mass=1000; //added but not needed
    //bale.physicsBody.friction = 1000; //added but not needed
    bale.physicsBody.dynamic=NO;
    
    [self addChild:bale];
}

- (void)p_addTyreAt:(CGPoint)point {
    SKSpriteNode *tyre = [SKSpriteNode spriteNodeWithImageNamed:@"tyre"];
    tyre.position = point;
    
    // scale the tyre here
    tyre.xScale = 0.6;
    tyre.yScale = 0.6;
    
    tyre.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tyre.size];
    tyre.physicsBody.categoryBitMask = CRBodyBox;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    tyre.physicsBody.linearDamping = 1.0f;//1
    tyre.physicsBody.angularDamping = 1.0f;//1
    //tyre.physicsBody.mass=1000; //added but not needed
    //tyre.physicsBody.friction = 1000; //added but not needed
    tyre.physicsBody.dynamic=NO;
    
    [self addChild:tyre];
}

- (void)p_addObjectsForTrack:(SKSpriteNode *)track {
    // sets the track up with objects such as boundaries and obsticles
    
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    SKNode *innerBoundary  = [SKNode node];
    innerBoundary.position = track.position;
    [self addChild:innerBoundary];
    
    innerBoundary.physicsBody = [SKPhysicsBody
                                 bodyWithRectangleOfSize:CGSizeMake(180.0f, 120.0f)];
    innerBoundary.physicsBody.dynamic = NO;
    
    // put two boxes, crates, tyres, bale, one pause (under pause top rt) on the track
    // check which track, as track 1=none, 2=some, 3=lots
    long trk;
    trk = [singleton.trackNo integerValue];
    switch (trk) {
        case 1:
            //track 1, no hazards, just walls and the pause button under the real pause button to avoid hiding the car
            
            [self p_addPauseAt:CGPointMake(track.position.x + 215, track.position.y + 145 )];//may need to alther to align with view
            
            [self p_addBoxAt:  CGPointMake(track.position.x - 225, track.position.y + 147 )];//top left corner
            
            break;
        case 2:
            //track 2, some hazards and walls
            //track x, y = 240:160 for ipad
            
            [self p_addPauseAt:CGPointMake(track.position.x + 215.0f, track.position.y + 145 )];//may need to alther to align with view
            
            [self p_addBoxAt:  CGPointMake(track.position.x + 227, track.position.y  - 147 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 230, track.position.y  - 23  )];
            [self p_addBaleAt: CGPointMake(track.position.x + 220, track.position.y  + 5   )];
            [self p_addBaleAt: CGPointMake(track.position.x + 217, track.position.y  + 31  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 223, track.position.y  + 61  )];
            [self p_addBaleAt: CGPointMake(track.position.x + 217, track.position.y  + 110 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 47, track.position.y   + 145 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 18, track.position.y   + 140 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 19, track.position.y   + 144 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 56, track.position.y   + 145 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 84, track.position.y   + 147 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 157, track.position.y  + 145 )];
            [self p_addBaleAt: CGPointMake(track.position.x - 222, track.position.y  + 143 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 228, track.position.y  + 48  )];
            [self p_addBaleAt: CGPointMake(track.position.x - 222, track.position.y  + 24  )];
            [self p_addCrateAt:CGPointMake(track.position.x - 220, track.position.y  - 3   )];
            [self p_addTyreAt: CGPointMake(track.position.x - 217, track.position.y  - 21  )];
            [self p_addCrateAt:CGPointMake(track.position.x - 231, track.position.y  - 56  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 57, track.position.y   - 146 )];
          //[self p_addBaleAt: CGPointMake(track.position.x - 66, track.position.y   - 140 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 29, track.position.y   - 140 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 0, track.position.y    - 143 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 35, track.position.y   - 143 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 67, track.position.y   - 146 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 234, track.position.y  - 56  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 102, track.position.y  - 5   )];
            [self p_addTyreAt: CGPointMake(track.position.x + 7, track.position.y    + 71  )];
            
            break;
        case 3:
            //track 3, lots hazards and walls
            
            //needs reformatting with better layout at some point
            // *******
            // *******
            // *******
            // *******
            [self p_addPauseAt:CGPointMake(track.position.x + 215.0f, track.position.y + 145 )];//may need to alther to align with view
            
            [self p_addBoxAt:  CGPointMake(track.position.x - 225, track.position.y  + 147 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 42,  track.position.y  + 148 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 11,  track.position.y  + 148 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 40,  track.position.y  + 148 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 4,   track.position.y  + 129 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 28,  track.position.y  + 131 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 84,  track.position.y  + 84  )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 224, track.position.y  - 58  )];
            [self p_addCrateAt:CGPointMake(track.position.x - 230, track.position.y  + 18  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 195, track.position.y  + 14  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 190, track.position.y  - 8   )];
            [self p_addBaleAt: CGPointMake(track.position.x - 207, track.position.y  - 32  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 02,  track.position.y  - 41  )];
            [self p_addBaleAt: CGPointMake(track.position.x - 94,  track.position.y  - 64  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 54,  track.position.y  - 76  )];
            [self p_addCrateAt:CGPointMake(track.position.x - 76,  track.position.y  - 86  )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 102, track.position.y  - 87  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 115, track.position.y  - 92  )];
            [self p_addCrateAt:CGPointMake(track.position.x - 134, track.position.y  - 84  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 122, track.position.y  - 63  )];
            [self p_addTyreAt: CGPointMake(track.position.x - 222, track.position.y  - 148 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 56,  track.position.y  - 154 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 31,  track.position.y  - 140 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 1,   track.position.y  - 135 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 36,  track.position.y  - 137 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 55,  track.position.y  - 153 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 65,  track.position.y  - 73  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 85,  track.position.y  - 77  )];
            [self p_addBaleAt: CGPointMake(track.position.x + 110, track.position.y  - 91  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 111, track.position.y  - 64  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 115, track.position.y  - 31  )];
            [self p_addCrateAt:CGPointMake(track.position.x + 136, track.position.y  - 8   )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 109, track.position.y  + 4   )];
            [self p_addTyreAt: CGPointMake(track.position.x + 123, track.position.y  + 30  )];
            [self p_addBaleAt: CGPointMake(track.position.x + 101, track.position.y  + 50  )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 126, track.position.y  + 55  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 116, track.position.y  + 76  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 231, track.position.y  + 142 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 212, track.position.y  + 87  )];
            [self p_addBaleAt: CGPointMake(track.position.x + 235, track.position.y  + 94  )];
            [self p_addCrateAt:CGPointMake(track.position.x + 223, track.position.y  + 72  )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 230, track.position.y  - 8   )];
            [self p_addTyreAt: CGPointMake(track.position.x + 234, track.position.y  - 30  )];
            [self p_addTyreAt: CGPointMake(track.position.x + 213, track.position.y  - 30  )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 222, track.position.y  - 102 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 166, track.position.y  - 141 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 135, track.position.y  - 157 )];
            
            break;
        default:
            //not used, no other tracks
            break;
    }
}

//********************************************************************
//***                                                              ***
//*** only to position some hazards at a good spot, rem out later  ***
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{   //                                                           ***
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView:touch.view];
    //NSLog(@"X:Y = %.0f:%.0f",location.x-240,(location.y-160)*-1);
//}   //                                                           ***
//********************************************************************

- (void)p_addGameUIForTrack:(SKSpriteNode *)track {
    // Displays the laps to go as set from LevelDetails.plist
    _laps = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _laps.text = [NSString stringWithFormat:@"Laps to go: %li", (long)_numOfLaps];
    _laps.fontSize = 19.0f; //was 20.0f
    _laps.fontColor = [UIColor whiteColor];
    _laps.position = CGPointMake(track.position.x, track.position.y + 19.0f); // was 20.0f
    [self addChild:_laps];
    
    // Shows the time left to finish the laps remaining
    
    // do some conversion for race
    long hours,  minutes, seconds, left;
    
    left    = (long)_timeInSeconds;
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    NSString *tem4 = [NSString stringWithFormat:@"%li:%li:%li",hours,minutes,seconds];
    
    _time           = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _time.text      = [NSString stringWithFormat:@"Time: %@", tem4];
    _time.fontSize  = 20.0f;
    _time.fontColor = [UIColor whiteColor];
    _time.position  = CGPointMake(track.position.x, track.position.y - 10.0f);
    [self addChild:_time];
    
    // box collisions
    _colls = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _colls.text      = [NSString stringWithFormat:@"Hazard Crashes: %li", (long)_numOfCollisionsWithBoxes];
    _colls.fontSize  = 15.0f;
    // _colls.fontColor = [UIColor whiteColor];
    _colls.fontColor = [UIColor yellowColor];
    _colls.position  = CGPointMake(track.position.x, track.position.y - 30.0f);
    [self addChild:_colls];
    
    // box collisions
    _walls           = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _walls.text      = [NSString stringWithFormat:@"Wall Crashes: %li", (long)_numOfCollisionsWithBoxes];
    _walls.fontSize  = 15.0f;
    // _walls.fontColor = [UIColor whiteColor];
    _walls.fontColor = [UIColor yellowColor];
    _walls.position  = CGPointMake(track.position.x, track.position.y - 45.0f);
    [self addChild:_walls];
    
   //horns counter for display
   //if display flag OFF, dont show horns counter
    if(!displayMinimum){
        //horns that are beeped counter
        _hor           = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _hor.text      = [NSString stringWithFormat:@"H: %li", (long)_hors];
        _hor.fontSize  = 15.0f;
        _hor.fontColor = [UIColor greenColor];
        _hor.position  = CGPointMake(track.position.x - 65.0f, track.position.y+40.0f);
        [self addChild:_hor];
    }
}

- (void)p_analogControlUpdated:(AnalogControl *)analogControl {
    //if race is at start lamp phase, return
    if (started==YES) {

        // Negate the y-axis to bridge a gap between SpriteKit and UIKit
        self.car.physicsBody.velocity = CGVectorMake(
                                                 analogControl.relativePosition.x * self.maxSpeed,
                                                 -analogControl.relativePosition.y * self.maxSpeed
                                                 );
    
        if (!CGPointEqualToPoint(analogControl.relativePosition, CGPointZero)) {
            self.car.zRotation = ({
            CGPoint point = CGPointMake(
                                        analogControl.relativePosition.x,
                                        -analogControl.relativePosition.y
                                        );
            
            CGFloat angle = CGPointToAngle(point);
            angle;
            }
            );
        }
    }
}

-(void)p_reportHorn:(BOOL)showHornNow{
 // ?? is this required
}

- (void)p_reportAchievementsForGameState:(BOOL)hasWon {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSMutableArray *achievements = [@[] mutableCopy];
    
    // also ADD crashes with walls
    [achievements addObject:[AchievementsHelper collisionAchievement:self.numOfCollisionsWithBoxes+self.numOfCollisionsWithWalls]];
    
    if (hasWon) {
        if (xcounter > 100) {
            xcounter = 100;
        }
        if (xcounter < 0) {
            xcounter = 0;
        }
        [achievements addObject:[AchievementsHelper achievementForLevel:self.levelType]];
        
        //stop the clock in mS
        reactionTime[xcounter]=(Float32)[self.startDate timeIntervalSinceNow]* -1000;
        
        //update data as now finished
        
        //crashes
        singleton.wallCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithWalls];
        singleton.hazCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithBoxes];
        
        if (xcounter > 100) {
            xcounter = 100;
        }
        if (xcounter < 0) {
            xcounter = 0;
        }
        
        for (int x=1; x<xcounter; x+=1) {
            temp1 = reactionTime[x];
            temp2 = reactionTime[x-1];
            reactionTime[x-1]=(temp1-temp2);
            //NSLog(@"a- lap time %d: %f", x, reactionTime[x-1]);
        }

        for (int x=0; x<xcounter-1; x+=1) {
            reactionTime[x]=(reactionTime[x]/1000);
            //NSLog(@"b- lap time %d: %f", x+1, reactionTime[x]);
        }
        
        //correct 1st lap time for lamps 4 seconds start
        reactionTime[0]=reactionTime[0]-4.0f;
        
        for (int x=0; x<xcounter-1; x+=1) {
            
            temp = reactionTime[x];
            singleton.lapTimes[x]=[NSString stringWithFormat:@"%0.2f", temp];
            
            //NSLog(@"c- lap time %d: %f",x+1, temp);
            
            if ( slowestLap < temp) {
                slowestLap = temp;
                //NSLog(@"s- lap time %d: %f", x+1, slowestLap);
                slowLap = x+1;
            }
            if (fastestLap > temp) {
                fastestLap = temp;
                //NSLog(@"f- lap time %d: %f", x+1, fastestLap);
                fastLap = x+1;
            }
            raceTime = raceTime + temp;
            //NSLog(@"g- race time %f",  raceTime);
        }
        //make the time in seconds
        
        totalCrashes = (unsigned long)self.numOfCollisionsWithWalls + (unsigned long)self.numOfCollisionsWithBoxes;
        
        singleton.totalCrashes = [NSString stringWithFormat:@"%li",totalCrashes];
        
        averageLap = raceTime / (xcounter-1);
        NSLog(@"average lap time %.2f",  raceTime/(xcounter-1));

        
        //you finished the race, give the stats
        
        horns = [singleton.hornsPlayed intValue];
        
        for (int x=0; x<horns; x+=1) {
            //hornReactionTime[x]=(hornReactionTime[x]);//  /1000;
            
            //correct the lag for horn time key presses
            hornReactionTime[x]=hornReactionTime[x]-0.3f;
            if (hornReactionTime[x]<0) {
                hornReactionTime[x]=0.01;
            }
            
            //cant be longer than the lap time
            if (hornReactionTime[x] > reactionTime[x]) {
                hornReactionTime[x] = raceTime;
            }
                //NSLog(@"horn time %d: %.3f S", x+1, hornReactionTime[x]);
        }
        
        //averages
        Float32 _hornTime = 0;
        for (int x=0; x<horns; x+=1) {
            
            temp1 = hornReactionTime[x];
                //NSLog(@"horn time %d: %.f mS",x+1, temp1);
            
            if (slowestHorn < temp1) {
                slowestHorn = temp1;
                //NSLog(@"slow horn time %d: %.f mS", x+1, temp1);
            }
            if (fastestHorn > temp1) {
                fastestHorn = temp1;
                //NSLog(@"fast horn time %d: %.f mS", x+1, temp1);
            }
            if (_numOfLaps == 1) {
                fastestHorn = slowestHorn;
            }
            _hornTime = _hornTime + temp1;
        }
        averageHorn = _hornTime / (horns);
        //NSLog(@"ave horn time %.3f S", averageHorn);
        
        singleton.totalHorn   = [NSString stringWithFormat:@"%.3f", _hornTime];
        singleton.fastestHorn = [NSString stringWithFormat:@"%.3f", fastestHorn];
        singleton.slowestHorn = [NSString stringWithFormat:@"%.3f", slowestHorn];
        singleton.averageHorn = [NSString stringWithFormat:@"%.3f", averageHorn];
        
        singleton.slowestLap   = [NSString stringWithFormat:@"%0.2f", slowestLap];
        singleton.fastestLap   = [NSString stringWithFormat:@"%0.2f", fastestLap];
        singleton.averageLap   = [NSString stringWithFormat:@"%0.2f", averageLap];
        singleton.totalTime    = [NSString stringWithFormat:@"%0.2f", raceTime];
        singleton.slowestLapNo = [NSString stringWithFormat:@"%i",    slowLap];
        singleton.fastestLapNo = [NSString stringWithFormat:@"%i",    fastLap];
        
        //bounds limits
        if (xcounter > 100) {
            xcounter = 100;
        }
        if (xcounter < 0) {
            xcounter = 0;
        }
        
        for (int x=0; x<xcounter-1; x+=1) { //was xcounter
            singleton.lapTimes[x] = [NSString stringWithFormat:@"%i, %.2f, %@, %@",
                                     x+1,
                                     reactionTime[x],
                                     singleton.wallLaps[x],
                                     singleton.hazLaps[x]
                                     ];
            
            NSLog(@"react lap: %@", singleton.lapTimes[x]);
        }
        for (int x=0; x<horns; x+=1) {
            singleton.hornTimes[x] = [NSString stringWithFormat:@"%i, %.3f",
                                     x+1,
                                     hornReactionTime[x]
                                     ];
            
            //NSLog(@"horn  lap: %@", singleton.hornTimes[x]);
        }
    }
    
    //not on game centre yet
    //[[GameKitHelper sharedGameKitHelper] reportAchievements:achievements];
}

#pragma mark - Key-Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"relativePosition"]) {
        [self p_analogControlUpdated:object];
    }
}

#pragma mark - Contact Delegate for collisions between car and objects

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (xcounter > 100) {
        xcounter = 100;
    }
    if (xcounter < 0) {
        xcounter = 0;
    }
    //NSLog(@"tempLap=%i",xcounter);
    mySingleton *singleton = [mySingleton sharedSingleton];
    //test for all the hazard objetcs collisions
    if ((contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyBox)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyCrate)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyTyre)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyBale)) {
        self.numOfCollisionsWithBoxes += 1;
        tempHaz++;
        singleton.hazLaps[xcounter-1]=[NSString stringWithFormat:@"%i",tempHaz];//was xcounter
        // set for colls
        self.colls.text = [NSString stringWithFormat:@"Hazard Crashes: %li", (long)self.numOfCollisionsWithBoxes];
        
        // OLD WAY FOR SOUND, BUT 'preset' LOUD VOLUME // [self runAction:self.boxSoundAction];
        //
        // to change volume level
        NSError * error;
        NSURL   * soundURL = [[NSBundle mainBundle] URLForResource:@"box" withExtension:@"wav"];
        AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        [player setVolume:singleton.ambientVolume];
        [player prepareToPlay];
        
        SKAction * playAction = [SKAction runBlock:^{
            [player play];
        }];
        SKAction * waitAction = [SKAction waitForDuration:player.duration+1];
        SKAction * sequence = [SKAction sequence:@[playAction, waitAction]];
        
        [self runAction:sequence];
    }else{
        //if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyTrack) {
        self.numOfCollisionsWithWalls += 1;
        tempWall++;
        singleton.wallLaps[xcounter-1]=[NSString stringWithFormat:@"%i",tempWall];//was xcounter
        // set for walls
        self.walls.text = [NSString stringWithFormat:@"Wall Crashes: %li", (long)self.numOfCollisionsWithWalls];
        
        // OLD WAY FOR SOUND, BUT FIXED LOUD VOLUME // [self runAction:self.wallSoundAction];
        //
        // to change volume level
        NSError * error;
        NSURL   * soundURL = [[NSBundle mainBundle] URLForResource:@"box" withExtension:@"wav"];
        AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        [player setVolume:singleton.ambientVolume];
        [player prepareToPlay];
        
        SKAction * playAction = [SKAction runBlock:^{
            [player play];
        }];
        SKAction * waitAction = [SKAction waitForDuration:player.duration+1];
        SKAction * sequence   = [SKAction sequence:@[playAction, waitAction]];
        
        [self runAction:sequence];
    }
    //NSLog(@"tempHaz=%i, tempWall=%i",tempHaz,tempWall);
}

@end
