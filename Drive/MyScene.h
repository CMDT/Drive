//
//  MyScene.h
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2016. Jonathan Howell, MMU. All rights reserved.
//

@import SpriteKit;
@import AVFoundation;

@interface MyScene : SKScene  <UITextFieldDelegate>
{
}
@property (nonatomic, copy) void (^gameOverBlock)(BOOL didWin);
@property (nonatomic, copy) NSDate * startDate;
@property (nonatomic, copy) NSDate * startDateHorn;

- (instancetype)initWithSize:(CGSize)size carType:(CRCarType)carType level:(CRLevelType)levelType;

@end
