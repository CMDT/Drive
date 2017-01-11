//
//  MyScene.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2017. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//
// graphics
@import SpriteKit;

// Audio
@import AVFoundation;

@interface MyScene : SKScene  <UITextFieldDelegate>
{
}

// if the race is over, do the end sequence
@property (nonatomic, copy) void (^gameOverBlock)(BOOL didWin);
@property (nonatomic, copy) void (^hornBlock)(BOOL showHornNow);

// set date/time for race start point, reference back to this at the ned or when event like laps/horns occur
@property (nonatomic, copy) NSDate * startDate;
@property (nonatomic, copy) NSDate * startDateHorn;

// set out the displays depending upon what was selected for the car and track
- (instancetype)initWithSize:(CGSize)size carType:(CRCarType)carType level:(CRLevelType)levelType;

@end
