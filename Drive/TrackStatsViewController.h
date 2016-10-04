//
//  TrackStatsViewController.h
//  Drive
//
//  Created by Jonathan Howell on 13/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TrackStatsViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel     * statusMessageLab;
    
    // for file manager
    NSFileManager * fileMgr;
    NSString      * homeDir;
    NSString      * filename;
    NSString      * filepath;
    
    // for calculations and functions
    NSDate        * startDate;
    NSDate        * testDate;
}

//file ops stuff
@property(nonatomic,retain) NSFileManager * fileMgr;
@property(nonatomic,retain) NSString      * homeDir;
@property(nonatomic,retain) NSString      * filename;
@property(nonatomic,retain) NSString      * filepath;

//dates
@property (nonatomic, copy) NSDate        * testDate;
@property (nonatomic, copy) NSDate        * testTime;

//var label outlets

@property (nonatomic, strong) IBOutlet UILabel * email;
@property (nonatomic, strong) IBOutlet UILabel * testDates;
@property (nonatomic, strong) IBOutlet UILabel * testTimes;
@property (nonatomic, strong) IBOutlet UILabel * subjectName;
@property (nonatomic, strong) IBOutlet UILabel * versionNumber;
@property (nonatomic, strong) IBOutlet UILabel * laps;
@property (nonatomic, strong) IBOutlet UILabel * carNo;
@property (nonatomic, strong) IBOutlet UILabel * trackNo;
@property (nonatomic, strong) IBOutlet UILabel * musicTrack;
@property (nonatomic, strong) IBOutlet UILabel * fastestLap;
@property (nonatomic, strong) IBOutlet UILabel * slowestLapNo;
@property (nonatomic, strong) IBOutlet UILabel * fastestLapNo;
@property (nonatomic, strong) IBOutlet UILabel * slowestLap;
@property (nonatomic, strong) IBOutlet UILabel * averageLap;
@property (nonatomic, strong) IBOutlet UILabel * totalTime;
@property (nonatomic, strong) IBOutlet UILabel * hazCrashes;
@property (nonatomic, strong) IBOutlet UILabel * wallCrashes;
@property (nonatomic, strong) IBOutlet UILabel * totalCrashes;
@property (nonatomic, strong) IBOutlet UILabel * hornsPlayed;
@property (nonatomic, strong) IBOutlet UILabel * fastestHorn;
@property (nonatomic, strong) IBOutlet UILabel * slowestHorn;
@property (nonatomic, strong) IBOutlet UILabel * averageHorn;
@property (nonatomic, strong) IBOutlet UILabel * totalHorn;
@property (nonatomic, strong) IBOutlet UILabel * distractionOn;
@property (nonatomic, strong) IBOutlet UILabel * masterScore;
@property (weak, nonatomic) IBOutlet UILabel *racehms;
@property (weak, nonatomic) IBOutlet UILabel *hornhms;
@property (weak, nonatomic) IBOutlet UILabel *scorehms;
//for horns line of data
@property (weak, nonatomic) IBOutlet UILabel *h1;
@property (weak, nonatomic) IBOutlet UILabel *h2;
@property (weak, nonatomic) IBOutlet UILabel *h3;
@property (weak, nonatomic) IBOutlet UILabel *h4;
@property (weak, nonatomic) IBOutlet UILabel *h5;
@property (weak, nonatomic) IBOutlet UILabel *h6;
@property (weak, nonatomic) IBOutlet UILabel *h7;
@property (weak, nonatomic) IBOutlet UILabel *h8;

@property (nonatomic, strong) IBOutlet UIButton * emailbtn;

- (IBAction)finishAction:(id)sender;

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error;
- (NSString *) GetDocumentDirectory;
- (NSString *) setFilename;
- (void) WriteToStringFile:(NSMutableString *)textToWrite;
- (void) calculateStats;
- (void)setDateNow;
- (void)setTimeNow;

@end
