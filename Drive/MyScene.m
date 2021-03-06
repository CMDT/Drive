//
//  MyScene.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  first commit 9/12/15
//  big update 12/12/15

#import "MyScene.h"
#import "AnalogControl.h"
#import "SKTUtils.h"
#import "AchievementsHelper.h"
#import "GameKitHelper.h"
//#import "SKTAudio.h"
#import "mySingleton.h"

//mySingleton *singleton = [mySingleton sharedSingleton];

typedef NS_OPTIONS(NSUInteger, CRPhysicsCategory) {
    CRBodyCar = 1 << 0,  // 0000001 = 1
    CRBodyBox = 1 << 1,  // 0000010 = 2
    CRBodyCrate = 1 << 1,
    CRBodyTyre = 1 << 1,
    CRBodyBale = 1 << 1,
    CRBodyPause = 1 << 1,
};

@interface MyScene () <SKPhysicsContactDelegate>
{
    Float32 reactionTime[100];
    Float32 noOfSeconds;
    int     xcounter;
    
    Float32 fastestLap;
    Float32 slowestLap;
    Float32 averageLap;
    Float32 fastestHorn;
    Float32 slowestHorn;
    Float32 averageHorn;
    Float32 raceTime;
    Float32 hornTime;
    Float32 masterScore;
    Float32 temp;
    long    totalCrashes;
    
    int     lap;
    int     fastLap;
    int     slowLap;
    int     horns;
    long    tt; // time for playning a horn every n seconds
    long    horn_tt;
    
    BOOL hornShowing;
    BOOL hornsPressed;//for horns pressed
    Float32 hornReactionTime[100];
    Float32 temp1;
    Float32 temp2;
    
    long xx,yy;
}

@property (nonatomic, assign) CRCarType carType;
@property (nonatomic, assign) CRLevelType levelType;
@property (nonatomic, assign) NSTimeInterval timeInSeconds;
@property (nonatomic, assign) NSInteger numOfLaps;
@property (nonatomic, strong) SKSpriteNode  * car;
@property (nonatomic, strong) SKLabelNode   * laps,
    * time,
    * colls,
    * walls;
@property (nonatomic, assign) NSInteger maxSpeed;
@property (nonatomic, assign) CGPoint trackCenter;
@property (nonatomic, assign) NSTimeInterval previousTimeInterval;
@property (nonatomic, assign) NSUInteger numOfCollisionsWithBoxes;
@property (nonatomic, assign) NSUInteger numOfCollisionsWithWalls;

// Sound effects
@property (nonatomic, strong) SKAction * boxSoundAction;
@property (nonatomic, strong) SKAction * hornSoundAction;
@property (nonatomic, strong) SKAction * lapSoundAction;
@property (nonatomic, strong) SKAction * nitroSoundAction;
@property (nonatomic, strong) SKAction * wallSoundAction;

@end

@implementation MyScene

@synthesize startDate, startDateHorn;

#pragma mark - Initialise Game

//in storyboard, note button for game centre is turned to 1px x 1px. set to 301 x 55 in settings measure properties.

- (instancetype)initWithSize:(CGSize)size carType:(CRCarType)carType level:(CRLevelType)levelType {
    self = [super initWithSize:size];
    mySingleton *singleton = [mySingleton sharedSingleton];
    if (self) {
        _carType = [singleton.carNo integerValue];//carType;
        _levelType = [singleton.trackNo integerValue];//levelType;
        _numOfCollisionsWithBoxes = 0; //start off with clean sheet
        
        horns = 0;
        singleton.hornsPlayed=@"0";
        
        fastestHorn = +999999;
        slowestHorn = -999999;
        averageHorn = -999999;
        [self p_initializeGame];
        
        //set the start timer for the horns, and put the result in the zero element of the array
        self.startDateHorn=[NSDate date];
        
        hornReactionTime[0]=(Float32)[self.startDateHorn timeIntervalSinceNow]* -1000;
        horns=1;
        hornReactionTime[1]=(Float32)[self.startDateHorn timeIntervalSinceNow]* -1000;
        //horns=2;
        singleton.hornsPlayed=[NSString stringWithFormat:@"0"];
        hornsPressed=NO;
        horn_tt=0;
    }
    return self;
}

//game proper, this is the run loop on this update
- (void)update:(NSTimeInterval)currentTime {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    if (self.previousTimeInterval == 0) {
        self.previousTimeInterval = currentTime;
    }
    //****************************************************************
    if (self.isPaused) {
        
        // find a way to halt the timer, then restart it for laps
        // *****
        // *****
        // *****
        
        //scrap that lap
        self.previousTimeInterval = currentTime;
        xcounter -=1;//drop back one lap
        self.numOfLaps -= 1;
        
        return;
    }
    //****************************************************************
    if (currentTime - self.previousTimeInterval > 1) {
        self.timeInSeconds += (currentTime - self.previousTimeInterval);//was -= to count down, now count up
        self.previousTimeInterval = currentTime;
        //self.time.text = [NSString stringWithFormat:@"Time: %.lf", self.timeInSeconds];
        
        //do some conversion for race
        long hours3,  minutes3, left3;
        long seconds3;
        left3=(long)_timeInSeconds;
        seconds3 = (left3 % 60);
        minutes3 = (left3 % 3600) / 60;
        hours3 = (left3 % 86400) / 3600;
        
        NSString *temp3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hours3,minutes3,seconds3];
        
        self.time.text = [NSString stringWithFormat:@"Time: %@", temp3];
        
    }
    
    //where is the car on the track?, is it going the correct way round to reduce the laps
    
    static CGFloat nextProgressAngle = M_PI; // was M_PI, pi rads == 180 deg
    
    // draw an imaginary line from centre of track to car
    CGPoint vector = CGPointSubtract(self.car.position, self.trackCenter);
    
    // turn the position to an angle
    CGFloat progressAngle = CGPointToAngle(vector) * M_PI; //was + not * error, no counts
    
    //NSLog(@"Vector = %d : %d, progress = %f : %f",(int)_car.position.x,(int)_car.position.y, progressAngle, nextProgressAngle);
    
    if (progressAngle > nextProgressAngle) {
        //NSLog(@"prog>nextProg");}else{NSLog(@"prog NOT > nextProg");
    }
    if (progressAngle - nextProgressAngle < M_PI_4) { // pi/4 rads == 90 deg
        //NSLog(@"prog-nextProg<pi/4");}else{NSLog(@"prog-nextProg NOT < pi/4");
    }
    
    if (progressAngle > nextProgressAngle && (progressAngle - nextProgressAngle) < M_PI_4) { // M_PI_4 = pi/4
        nextProgressAngle += M_PI_2; // M_PI_2 = pi/2 rads == 45 deg
        
        //self.numOfLaps -= 1;
        //NSLog(@"Lap=%li",(long)self.numOfLaps);
        
        if (nextProgressAngle > 2 * M_PI) { //was 2, 2*pi rads == 360
            nextProgressAngle = 0;
        }
        
        if (fabs(nextProgressAngle - M_PI) < FLT_EPSILON) { //the difference between 1.0 and the smallest float bigger than 1.0.
            self.numOfLaps -= 1;
            
            //read the timer
            
            reactionTime[xcounter] = (Float32)[self.startDate timeIntervalSinceNow]* -1000.0f;
            xcounter += 1;
            
            self.laps.text = [NSString stringWithFormat:@"Laps: %li", (long)self.numOfLaps];
            //NSLog(@"Lap time = %f",reactionTime[xcounter-1]);
            [self runAction:self.lapSoundAction];
        }
    }
    
    //only do this if the distraction flag is ON
    
    if ([singleton.distractionOn isEqual:@"ON"]) {
        
        tt = self.timeInSeconds;
        //NSLog(@"ttmod7=%i",((tt % 7) == 6));
        
        if (((tt % 7) == 6)) {
            //beep the horn every 7 seconds
            horn_tt++;
            //start the horn timer
            
            //hornReactionTime[horns]=(Float32)[self.startDateHorn timeIntervalSinceNow]* -1000;
            
            //set the flag, the horn sound was played
            [self runAction:self.hornSoundAction];
            
            if (horn_tt == 1) {
                //tell the timer that the horn is not pressed yet
                singleton.hornsShowing = NO;
                horns++;
                singleton.hornsPlayed = [NSString stringWithFormat:@"%i", horns];
            }
        }
        //look for the horn button being pressed
        if (singleton.hornsShowing == YES) {
            //stop the horn timer and record it
            hornReactionTime[horns]=(Float32)[self.startDateHorn timeIntervalSinceNow]* -1000;
            
            //reset the flag
            singleton.hornsShowing = NO;
            horn_tt = 0;
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
    
    SKSpriteNode *track = ({
        NSString *imageName = [NSString stringWithFormat:@"track_%li", _levelType];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sprite;
    });
    [self addChild:track];
    
    //[self p_addCarAtPosition:CGPointMake(CGRectGetMidX(track.frame), 50.0f)];//used to be 50, ==middle of track at centre bottom
    [self p_addCarAtPosition:CGPointMake(400.0f, 180.0f)];
    // Turn off the world's gravity
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);// 0,0 = g off .... 1,1 = pulls to right top corner
    self.physicsBody = ({
        CGRect frame = CGRectInset(track.frame, 40.0f, 0.0f);// 40.0f,0.0f= old
        SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
        body;
    });
    
    [self p_addObjectsForTrack:track];
    [self p_addGameUIForTrack: track];
    
    _maxSpeed = 150 * (1 + _carType);//was125
    
    _trackCenter = track.position;
    
    _boxSoundAction   = [SKAction playSoundFileNamed: @"box.wav"   waitForCompletion:NO];
    _hornSoundAction  = [SKAction playSoundFileNamed: @"horn.wav"  waitForCompletion:NO];
    _lapSoundAction   = [SKAction playSoundFileNamed: @"lap.wav"   waitForCompletion:NO];
    _nitroSoundAction = [SKAction playSoundFileNamed: @"nitro.wav" waitForCompletion:NO];
    _wallSoundAction  = [SKAction playSoundFileNamed: @"box.wav"   waitForCompletion:NO];//change to new sound some time = wall.wav
    
    //turn on the contact dlegate to test contacts between bodies
    self.physicsWorld.contactDelegate = self;
    xcounter=1;//start the array for timings of laps
    
    //add the first drive clock time tio the array
    self.startDate=[NSDate date];
    reactionTime[0] = [self.startDate timeIntervalSinceNow]* -1000;
    xcounter = 1;
    
    //set the horn 'off'
    singleton.hornsShowing = NO;
    
    xx=track.position.x;
    yy=track.position.y;
}

//now using singleton for laps
- (void)p_loadLevel {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LevelDetails" ofType:@"plist"];
    //NSArray *level = [NSArray arrayWithContentsOfFile:filePath];
    
    //NSNumber *timeInSeconds = level[_levelType - 1][@"time"];
    _timeInSeconds = 0;//[timeInSeconds doubleValue];
    
    //now using singleton
    //NSNumber *laps = level[_levelType - 1][@"laps"];
    //_numOfLaps = [laps integerValue];
    _numOfLaps = [singleton.laps  integerValue];
    
}

- (void)p_addCarAtPosition:(CGPoint)startPosition {
    _car = ({
        NSString *imageName = [NSString stringWithFormat:@"car_%li", _carType];
        //NSLog(@"Car=%li, Track=%li",_carType,_levelType);
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = startPosition;
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
        reactionTime[x]=0.0f;
    }
    slowestLap=-999999.0f;
    fastestLap=999999.0f;
    averageLap=999999.0f;
    
    slowestHorn=-999999.0f;
    fastestHorn=999999.0f;
    averageHorn=999999.0f;
}

- (void)p_addBoxAt:(CGPoint)point {
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
    box.position = point;
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
    //to mask the top right corner from the cars, its an obsticle and stops the car from running under it
    SKSpriteNode *pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause2Gr"];
    //set a smaller size as original was scaled down
    pause.xScale = 0.6;
    pause.yScale = 0.6;
    pause.position = point;
    pause.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pause.size];
    pause.physicsBody.categoryBitMask = CRBodyPause;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    pause.physicsBody.linearDamping = 1.0f;//1
    pause.physicsBody.angularDamping = 1.0f;//1
    //crate.physicsBody.mass=1000; //added but not needed
    //crate.physicsBody.friction = 1000; //added but not needed
    pause.physicsBody.dynamic=NO; //no=does not move or slide
    
    [self addChild:pause];
}

- (void)p_addBaleAt:(CGPoint)point {
    SKSpriteNode *bale = [SKSpriteNode spriteNodeWithImageNamed:@"bale"];
    bale.position = point;
    bale.xScale = 0.6;
    bale.yScale = 0.6;
    bale.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bale.size];
    bale.physicsBody.categoryBitMask = CRBodyBale;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    bale.physicsBody.linearDamping = 1.0f;//1
    bale.physicsBody.angularDamping = 1.0f;//1
    //bale.physicsBody.mass=1000; //added but not needed
    //bale.physicsBody.friction = 1000; //added but not needed
    bale.physicsBody.dynamic=NO;
    
    [self addChild:bale];
}

- (void)p_addTyreAt:(CGPoint)point {
    SKSpriteNode *tyre = [SKSpriteNode spriteNodeWithImageNamed:@"tyre"];
    tyre.position = point;
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
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    SKNode *innerBoundary = [SKNode node];
    innerBoundary.position = track.position;
    [self addChild:innerBoundary];
    
    innerBoundary.physicsBody = [SKPhysicsBody
                                 bodyWithRectangleOfSize:CGSizeMake(180.0f, 120.0f)];
    innerBoundary.physicsBody.dynamic = NO;
    
    // put two boxes, crates, tyres, bale, one pause (under pause top rt) on the track
    //check which track, as track 1=none, 2=some, 3=lots
    long trk;
    trk = [singleton.trackNo integerValue];
    switch (trk) {
        case 1:
            //track 1, no hazards, just walls and the pause buttun under the real pause button to avoid hiding the car
            [self p_addPauseAt:CGPointMake(track.position.x + 230, track.position.y + 145 )];
            [self p_addBoxAt:  CGPointMake(track.position.x -225, track.position.y + 150   )];
            break;
        case 2:
            //track 2, some hazards and walls
            //track x, y = 240:160 for ipad
            [self p_addBoxAt:  CGPointMake(track.position.x + 227, track.position.y  - 147 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 230, track.position.y  - 23 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 220, track.position.y  + 5 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 217, track.position.y  + 31 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 223, track.position.y  + 61 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 217, track.position.y  + 110 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 47, track.position.y   + 145 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 18, track.position.y   + 140 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 19, track.position.y   + 144 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 56, track.position.y   + 145 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 84, track.position.y   + 147 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 157, track.position.y  + 145 )];
            [self p_addBaleAt: CGPointMake(track.position.x - 222, track.position.y  + 143 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 228, track.position.y  + 48 )];
            [self p_addBaleAt: CGPointMake(track.position.x - 222, track.position.y  + 24 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 220, track.position.y  - 3 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 217, track.position.y  - 21 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 231, track.position.y  - 56 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 57, track.position.y   - 146 )];
            //[self p_addBaleAt: CGPointMake(track.position.x - 66, track.position.y   - 140 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 29, track.position.y   - 140 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 0, track.position.y    - 143 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 35, track.position.y   - 143 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 67, track.position.y   - 146 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 234, track.position.y  - 56 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 102, track.position.y  - 5 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 7, track.position.y    + 71 )];
            
            [self p_addPauseAt:CGPointMake(track.position.x + 230.0f, track.position.y + 145 )];
            break;
        case 3:
            //track 3, lots hazards and walls
            
            //needs reformatting
            // *******
            // *******
            // *******
            // *******
            
            [self p_addBoxAt:  CGPointMake(track.position.x - 225, track.position.y  + 151 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 42, track.position.y   + 148 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 11, track.position.y   + 148 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 40, track.position.y   + 148 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 4, track.position.y    + 129 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 28, track.position.y   + 131 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 84, track.position.y   + 84 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 224, track.position.y  - 58 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 230, track.position.y  + 18 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 195, track.position.y  + 14 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 190, track.position.y  - 8 )];
            [self p_addBaleAt: CGPointMake(track.position.x - 207, track.position.y  - 32 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 02, track.position.y   - 41 )];
            [self p_addBaleAt: CGPointMake(track.position.x - 94, track.position.y   - 64 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 54, track.position.y   - 76 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 76, track.position.y   - 86 )];
            [self p_addBoxAt:  CGPointMake(track.position.x - 102, track.position.y  - 87 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 115, track.position.y  - 92 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 134, track.position.y  - 84 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 122, track.position.y  - 63 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 222, track.position.y  - 148 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 56, track.position.y   - 154 )];
            [self p_addTyreAt: CGPointMake(track.position.x - 31, track.position.y   - 140 )];
            [self p_addCrateAt:CGPointMake(track.position.x - 1, track.position.y    - 135 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 36, track.position.y   - 137 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 55, track.position.y   - 153 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 65, track.position.y   - 73 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 85, track.position.y   - 77 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 110, track.position.y  - 91 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 111, track.position.y  - 64 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 115, track.position.y  - 31 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 136, track.position.y  - 8 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 109, track.position.y  + 4 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 123, track.position.y  + 30 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 101, track.position.y  + 50 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 126, track.position.y  + 55 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 116, track.position.y  + 76 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 231, track.position.y  + 142 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 212, track.position.y  + 87 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 235, track.position.y  + 94 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 223, track.position.y  + 72 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 230, track.position.y  - 8 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 234, track.position.y  - 30 )];
            [self p_addTyreAt: CGPointMake(track.position.x + 213, track.position.y  - 30 )];
            [self p_addBoxAt:  CGPointMake(track.position.x + 222, track.position.y  - 102 )];
            [self p_addCrateAt:CGPointMake(track.position.x + 166, track.position.y  - 141 )];
            [self p_addBaleAt: CGPointMake(track.position.x + 135, track.position.y  - 157 )];
            
            [self p_addPauseAt:CGPointMake(track.position.x + 230.0f, track.position.y + 145 )];
            break;
        default:
            //not used
            break;
    }
}

//******************************************************************
//***                                                            ***
//only to position some hazards at a good spot, rem out later    ***
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{   //                                                           ***
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView:touch.view];
    //NSLog(@"X:Y = %.0f:%.0f",location.x-240,(location.y-160)*-1);
//}   //                                                           ***
//******************************************************************

- (void)p_addGameUIForTrack:(SKSpriteNode *)track {
    // Displays the laps to go as set from LevelDetails.plist
    _laps = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _laps.text = [NSString stringWithFormat:@"Laps: %li", (long)_numOfLaps];
    _laps.fontSize = 20.0f;
    _laps.fontColor = [UIColor whiteColor];
    _laps.position = CGPointMake(track.position.x, track.position.y + 20.0f);
    [self addChild:_laps];
    
    // Shows the time left to finish the laps remaining
    
    //do some conversion for race
    long hours,  minutes, left;
    long seconds;
    left=(long)_timeInSeconds;
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours = (left % 86400) / 3600;
    
    NSString *temp4 = [NSString stringWithFormat:@"%li:%li:%li",hours,minutes,seconds];
    
    _time = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _time.text = [NSString stringWithFormat:@"Time: %@", temp4];
    _time.fontSize = 20.0f;
    _time.fontColor = [UIColor whiteColor];
    _time.position = CGPointMake(track.position.x, track.position.y - 10.0f);
    [self addChild:_time];
    
    // box collisions
    _colls = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _colls.text = [NSString stringWithFormat:@"Hazard Crashes: %li", (long)_numOfCollisionsWithBoxes];
    _colls.fontSize = 15.0f;
    _colls.fontColor = [UIColor whiteColor];
    _colls.position = CGPointMake(track.position.x, track.position.y - 30.0f);
    [self addChild:_colls];
    
    // box collisions
    _walls = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _walls.text = [NSString stringWithFormat:@"Wall Crashes: %li", (long)_numOfCollisionsWithBoxes];
    _walls.fontSize = 15.0f;
    _walls.fontColor = [UIColor whiteColor];
    _walls.position = CGPointMake(track.position.x, track.position.y - 45.0f);
    [self addChild:_walls];
}

- (void)p_analogControlUpdated:(AnalogControl *)analogControl {
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
        });
    }
}

- (void)p_reportAchievementsForGameState:(BOOL)hasWon {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSMutableArray *achievements = [@[] mutableCopy];
    
    // also ADD crashes with walls
    [achievements addObject:[AchievementsHelper collisionAchievement:self.numOfCollisionsWithBoxes]];
    
    if (hasWon) {
        [achievements addObject:[AchievementsHelper achievementForLevel:self.levelType]];
        
        //stop the clock in mS
        reactionTime[xcounter]=(Float32)[self.startDate timeIntervalSinceNow]* -1000;
        
        
        //update data as now finished
        
        //crashes
        singleton.wallCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithWalls];
        singleton.hazCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithBoxes];
        
        // NSLog(@"laps %d: ",xcounter-1);
        
        for (int x=2; x<xcounter+1; x+=1) {
            reactionTime[x]=(reactionTime[x]-reactionTime[x-1]);
            //NSLog(@"lap time %d: %f", x, reactionTime[x]);
        }
        for (int x=2; x<xcounter+1; x+=1) {
            reactionTime[x]=(reactionTime[x]/1000);
            //NSLog(@"lap time %d: %f", x, reactionTime[x]);
        }
        
        for (int x=2; x<xcounter+1; x+=1) {
            
            temp = reactionTime[x];
            
            // NSLog(@"lap time %d: %f",x, temp);
            
            if ( slowestLap < temp) {
                slowestLap = temp;
                //NSLog(@"slow lap time %d: %f", x, temp);
                slowLap = x-1;
            }
            if (fastestLap > temp) {
                fastestLap = temp;
                //NSLog(@"fast lap time %d: %f", x, temp);
                fastLap = x-1;
            }
            raceTime = raceTime + temp;
        }
        //make the time in seconds
        
        totalCrashes = (unsigned long)self.numOfCollisionsWithWalls + (unsigned long)self.numOfCollisionsWithBoxes;
        
        singleton.totalCrashes=[NSString stringWithFormat:@"%li",totalCrashes];
        
        averageLap = raceTime / (xcounter-1);
        
        //you finished the race, give the stats
        //horns = [singleton.hornsPlayed intValue];
        
        for (int x=0; x<horns+1; x+=1) {
            NSLog(@"Start Horn %i : Reaction %f",x,hornReactionTime[x]);
        }
        
        //find the time by difference
        //for (int x=4; x<horns+1; x+=1) {
        //    hornReactionTime[x]=(hornReactionTime[x]-hornReactionTime[x-1]);
        //    //NSLog(@"lap time %d: %f", x, hornReactionTime[x]);
        //}
        for (int x=2; x<horns+1; x+=1) {
            hornReactionTime[x]=(hornReactionTime[x]/1000);
            //NSLog(@"horn time %d: %f", x, hornReactionTime[x]);
        }    
        for (int x=2; x<horns+1; x+=1) {
            hornReactionTime[x]= ((x-1)*7)-hornReactionTime[x];
        //    //NSLog(@"lap time %d: %f", x, hornReactionTime[x]);
        }
        

        
        for (int x=3; x<horns; x+=1) {
            
            temp1 = hornReactionTime[x];
            
            // NSLog(@"lap time %d: %f",x, temp);
            
            if ( slowestHorn < temp1) {
                slowestHorn = temp1;
                //NSLog(@"slow lap time %d: %f", x, temp);
            }
            if (fastestHorn > temp1) {
                fastestHorn = temp1;
                //NSLog(@"fast lap time %d: %f", x, temp);
            }
            hornTime = hornTime + temp1;
        }
        averageHorn = hornTime / (horns-3);
        
        
        singleton.hornsPlayed = [NSString stringWithFormat:@"%i",horns-3];
        singleton.totalHorn   = [NSString stringWithFormat:@"%0.2f",hornTime];
        singleton.fastestHorn = [NSString stringWithFormat:@"%0.2f",fastestHorn];
        singleton.slowestHorn = [NSString stringWithFormat:@"%0.2f",slowestHorn];
        singleton.averageHorn = [NSString stringWithFormat:@"%0.2f",averageHorn];
        
        //************
        for (int x=0; x<horns+1; x+=1) {
            NSLog(@"final Horn %i : Reaction %f",x,hornReactionTime[x]);
        }
        
        singleton.slowestLap   = [NSString stringWithFormat:@"%0.2f",slowestLap];
        singleton.fastestLap   = [NSString stringWithFormat:@"%0.2f",fastestLap];
        singleton.averageLap   = [NSString stringWithFormat:@"%0.2f",averageLap];
        singleton.totalTime    = [NSString stringWithFormat:@"%0.2f",raceTime];
        singleton.slowestLapNo =[NSString stringWithFormat:@"%i",slowLap];
        singleton.fastestLapNo =[NSString stringWithFormat:@"%i",fastLap];
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

#pragma mark - Contact Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    //test for all the hazard objetcs collisions
    if ((contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyBox)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyCrate)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyTyre)||(contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyBale)) {
        self.numOfCollisionsWithBoxes += 1;
        // set for colls
        self.colls.text = [NSString stringWithFormat:@"Hazard Crashes: %li", (long)self.numOfCollisionsWithBoxes];
        
        [self runAction:self.boxSoundAction];
        
    }else{
        //if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == CRBodyCar + CRBodyTrack) {
        self.numOfCollisionsWithWalls += 1;
        // set for walls
        self.walls.text = [NSString stringWithFormat:@"Wall Crashes: %li", (long)self.numOfCollisionsWithWalls];
        
        [self runAction:self.wallSoundAction];
    }
}

@end
