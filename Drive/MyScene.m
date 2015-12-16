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
#import "mySingleton.h"
//mySingleton *singleton = [mySingleton sharedSingleton];

typedef NS_OPTIONS(NSUInteger, CRPhysicsCategory) {
    CRBodyCar = 1 << 0,  // 0000001 = 1
    CRBodyBox = 1 << 1,  // 0000010 = 2
    CRBodyCrate = 1 << 1,
    CRBodyTyre = 1 << 1,
    CRBodyBale = 1 << 1,
};

@interface MyScene () <SKPhysicsContactDelegate>
{
    Float32 reactionTime[100];
    Float32 noOfSeconds;
    int xcounter;
}
@property (nonatomic, assign) CRCarType carType;
@property (nonatomic, assign) CRLevelType levelType;
@property (nonatomic, assign) NSTimeInterval timeInSeconds;
@property (nonatomic, assign) NSInteger numOfLaps;
@property (nonatomic, strong) SKSpriteNode *car;
@property (nonatomic, strong) SKLabelNode *laps, *time, *colls, *walls;
@property (nonatomic, assign) NSInteger maxSpeed;
@property (nonatomic, assign) CGPoint trackCenter;
@property (nonatomic, assign) NSTimeInterval previousTimeInterval;
@property (nonatomic, assign) NSUInteger numOfCollisionsWithBoxes;
@property (nonatomic, assign) NSUInteger numOfCollisionsWithWalls;

// Sound effects
@property (nonatomic, strong) SKAction *boxSoundAction;
@property (nonatomic, strong) SKAction *hornSoundAction;
@property (nonatomic, strong) SKAction *lapSoundAction;
@property (nonatomic, strong) SKAction *nitroSoundAction;
@property (nonatomic, strong) SKAction *wallSoundAction;

@end

@implementation MyScene

@synthesize startDate;

#pragma mark - Lifecycle

//in storyboard, note button for game centre is turned to 1px x 1px. set to 301 x 55 in settings measure properties.

- (instancetype)initWithSize:(CGSize)size carType:(CRCarType)carType level:(CRLevelType)levelType {
    self = [super initWithSize:size];

    if (self) {
        _carType = carType;
        _levelType = levelType;
        _numOfCollisionsWithBoxes = 0; //start off with clean sheet
        [self p_initializeGame];
    }
    return self;
}


//game proper, thjis is the run loop on this update
- (void)update:(NSTimeInterval)currentTime {
    if (self.previousTimeInterval == 0) {
        self.previousTimeInterval = currentTime;
    }
//****************************************************************
    if (self.isPaused) {
        
        // find a way to halt the timer, then restart it for laps
        
        self.previousTimeInterval = currentTime;
        return;
    }
//****************************************************************
    if (currentTime - self.previousTimeInterval > 1) {
        self.timeInSeconds += (currentTime - self.previousTimeInterval);//was -= to count down, now count up
        self.previousTimeInterval = currentTime;
        //self.time.text = [NSString stringWithFormat:@"Time: %.lf", self.timeInSeconds];
        self.time.text = [NSString stringWithFormat:@"Time: %.lf", self.timeInSeconds];
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
            NSLog(@"Lap time = %f",reactionTime[xcounter-1]);
            [self runAction:self.lapSoundAction];
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
    [self p_addGameUIForTrack:track];

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
    
    self.startDate=[NSDate date];
    reactionTime[0] = [self.startDate timeIntervalSinceNow]* -1000.0f;
    xcounter = 1;
}


- (void)p_loadLevel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LevelDetails" ofType:@"plist"];
    NSArray *level = [NSArray arrayWithContentsOfFile:filePath];

    //NSNumber *timeInSeconds = level[_levelType - 1][@"time"];
    _timeInSeconds = 0;//[timeInSeconds doubleValue];

    NSNumber *laps = level[_levelType - 1][@"laps"];
    _numOfLaps = [laps integerValue];
}

- (void)p_addCarAtPosition:(CGPoint)startPosition {
    _car = ({
        NSString *imageName = [NSString stringWithFormat:@"car_%li", _carType];
        //NSLog(@"Car=%li, Track=%li",_carType,_levelType);
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        sprite.position = startPosition;
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
    //and just run the action
    [_car runAction: rotation];
    
    //start the clock in mS
    for (int x=0; x<101; x+=1) {
        NSLog(@"lap times %d: %f",x, reactionTime[x]=0.0f);
    }
    
    
    reactionTime[0]=(Float32)[self.startDate timeIntervalSinceNow]* -1000.0f;
    xcounter=1;
    
}

- (void)p_addBoxAt:(CGPoint)point {
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithImageNamed:@"box"];
    box.position = point;
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    box.physicsBody.categoryBitMask = CRBodyBox;

    // Simulate friction and prevent the boxes from continuously sliding around
    box.physicsBody.linearDamping = 1.0f;//1
    box.physicsBody.angularDamping = 1.0f;//1
    //box.physicsBody.mass=1000; //added but not needed
    //box.physicsBody.friction = 1000; //added but not needed
    box.physicsBody.dynamic=YES;

    [self addChild:box];
}

- (void)p_addCrateAt:(CGPoint)point {
    SKSpriteNode *crate = [SKSpriteNode spriteNodeWithImageNamed:@"crate"];
    crate.position = point;
    crate.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:crate.size];
    crate.physicsBody.categoryBitMask = CRBodyCrate;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    crate.physicsBody.linearDamping = 1.0f;//1
    crate.physicsBody.angularDamping = 1.0f;//1
    //crate.physicsBody.mass=1000; //added but not needed
    //crate.physicsBody.friction = 1000; //added but not needed
    crate.physicsBody.dynamic=YES;
    
    [self addChild:crate];
}

- (void)p_addBaleAt:(CGPoint)point {
    SKSpriteNode *bale = [SKSpriteNode spriteNodeWithImageNamed:@"bale"];
    bale.position = point;
    bale.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bale.size];
    bale.physicsBody.categoryBitMask = CRBodyBale;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    bale.physicsBody.linearDamping = 1.0f;//1
    bale.physicsBody.angularDamping = 1.0f;//1
    //bale.physicsBody.mass=1000; //added but not needed
    //bale.physicsBody.friction = 1000; //added but not needed
    bale.physicsBody.dynamic=YES;
    
    [self addChild:bale];
}

- (void)p_addTyreAt:(CGPoint)point {
    SKSpriteNode *tyre = [SKSpriteNode spriteNodeWithImageNamed:@"tyre"];
    tyre.position = point;
    tyre.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tyre.size];
    tyre.physicsBody.categoryBitMask = CRBodyBox;
    
    // Simulate friction and prevent the boxes from continuously sliding around
    tyre.physicsBody.linearDamping = 1.0f;//1
    tyre.physicsBody.angularDamping = 1.0f;//1
    //tyre.physicsBody.mass=1000; //added but not needed
    //tyre.physicsBody.friction = 1000; //added but not needed
    tyre.physicsBody.dynamic=YES;
    
    [self addChild:tyre];
}

- (void)p_addObjectsForTrack:(SKSpriteNode *)track {
    SKNode *innerBoundary = [SKNode node];
    innerBoundary.position = track.position;
    [self addChild:innerBoundary];

    innerBoundary.physicsBody = [SKPhysicsBody
        bodyWithRectangleOfSize:CGSizeMake(180.0f, 120.0f)];
    innerBoundary.physicsBody.dynamic = NO;
    
// put two boxes on the track
    [self p_addBoxAt:CGPointMake(track.position.x + 130.0f, track.position.y)];
    [self p_addBaleAt:CGPointMake(track.position.x + 100.0f, track.position.y+120)];
    [self p_addTyreAt:CGPointMake(track.position.x - 200.0f, track.position.y+50)];
    [self p_addCrateAt:CGPointMake(track.position.x - 130.0f, track.position.y+80)];
}

//only to position some hazards at a good spot, rem out later
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //UITouch *touch = [[event allTouches] anyObject];
    //CGPoint location = [touch locationInView:touch.view];
    //NSLog(@"X:Y Touch = %f:%f",location.x,location.y);
}

- (void)p_addGameUIForTrack:(SKSpriteNode *)track {
    // Displays the laps to go as set from LevelDetails.plist
    _laps = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _laps.text = [NSString stringWithFormat:@"Laps: %li", (long)_numOfLaps];
    _laps.fontSize = 20.0f;
    _laps.fontColor = [UIColor whiteColor];
    _laps.position = CGPointMake(track.position.x, track.position.y + 20.0f);
    [self addChild:_laps];

    // Shows the time left to finish the laps remaining
    _time = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _time.text = [NSString stringWithFormat:@"Time: %li", (long)_timeInSeconds];
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

-(int)random22
//for random numbers
{
    int num1 = 1;
    num1 = arc4random_uniform(22); //1-21
    if (num1<1) {
        num1=1;
    }
    if (num1>21) {
        num1=21;
    }
    return num1;
}

- (void)p_reportAchievementsForGameState:(BOOL)hasWon {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSMutableArray *achievements = [@[] mutableCopy];
    
// also ADD crashes with walls
    [achievements addObject:[AchievementsHelper collisionAchievement:self.numOfCollisionsWithBoxes]];

    if (hasWon) {
        [achievements addObject:[AchievementsHelper achievementForLevel:self.levelType]];
        
        //stop the clock in mS
        reactionTime[xcounter]=(Float32)[self.startDate timeIntervalSinceNow]* -1000.0f;
        xcounter+=1;
    
    //NSLog(@"walls=%lu, haz=%lu",(unsigned long)self.numOfCollisionsWithWalls,(unsigned long)self.numOfCollisionsWithBoxes);
    
    //update data as now finished
    singleton.wallCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithWalls];
    singleton.hazCrashes = [NSString stringWithFormat:@"%lu",(unsigned long)self.numOfCollisionsWithBoxes];
    singleton.totalTime = [NSString stringWithFormat:@"%0.4f", reactionTime[0]-reactionTime[xcounter] ];// time now - time start.
}
    for (int x=0; x<xcounter; x+=1) {
        NSLog(@"lap times %d: %f",x, reactionTime[x]);
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
