//
//  TrackStatsViewController.m
//  Drive
//
//  Created by Jonathan Howell on 13/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//
//  back button is Start Again
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "TrackStatsViewController.h"
#import "mySingleton.h"
#import "SKTAudio.h"

#define kEmail      @"emailAddress"
#define kSubject    @"subjectName"

@interface TrackStatsViewController ()

@end

@implementation TrackStatsViewController{
   //
}

@synthesize
    fileMgr,
    homeDir,
    filename,
    filepath,
    testDate,
    testTime,
    email,
    testDates,
    testTimes,
    subjectName,
    versionNumber,
    musicTrack,
    laps,
    carNo,
    trackNo,
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
    hornsMissed,
    fastestHorn,
    slowestHorn,
    averageHorn,
    totalHorn,
    distractionOn,
    masterScore,
    racehms,
    hornhms,
    scorehms,
    h1,h2,h3,
    h4,h5,h6,
    h7,h8,h9,h10,h11,h12,
// last one... ;
    emailbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    statusMessageLab.hidden = YES;
    
    //set up the plist params
    NSString * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary * defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults * defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    singleton.email       = [defaults objectForKey:kEmail];
    singleton.subjectName = [defaults objectForKey:kSubject];
}

- (void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
    statusMessageLab.hidden=YES;
    //set up the plist params
    NSString * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary * defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults * defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    [defaults synchronize];
    singleton.email       = [defaults objectForKey:kEmail];
    singleton.subjectName = [defaults objectForKey:kSubject];
    
    //stop the background audio
    [[SKTAudio sharedInstance] playBackgroundMusic:@"silence30.mp3"];
    
    //do the stats output
    [self calculateStats];
    
    //print up the results and then save the lot to the plist settings bundle for later review.
    
    //Save to email and send
}

-(void)calculateStats{
    statusMessageLab.hidden = YES;
    
    //statusMessageLab.text=@"Calculating\nStats\nPlease\nWait...";
    
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    // NSLog(@"Starting Stats");
    
    //NSString * myNumbStr = [[NSString alloc] init];
    
    // build the stats from data held in the singleton
    laps.text          = singleton.laps;
    testDates.text     = singleton.testDate;
    testTimes.text     = singleton.testTime;
    email.text         = singleton.email;
    subjectName.text   = singleton.subjectName;
    versionNumber.text = singleton.versionNumber;
    carNo.text         = singleton.carNo;
    trackNo.text       = singleton.trackNo;
    musicTrack.text    = singleton.musicTrack;
    fastestLap.text    = singleton.fastestLap;
    slowestLap.text    = singleton.slowestLap;
    fastestLapNo.text  = singleton.fastestLapNo;
    slowestLapNo.text  = singleton.slowestLapNo;
    averageLap.text    = singleton.averageLap;
    totalTime.text     = singleton.totalTime;
    hazCrashes.text    = singleton.hazCrashes;
    wallCrashes.text   = singleton.wallCrashes;
    totalCrashes.text  = singleton.totalCrashes;
    hornsMissed.text   = singleton.missed;
    
    int horns;
    horns = [singleton.hornsPlayed intValue];
    
    if (horns < 0) {
        horns = 0;
    }
    hornsPlayed.text=[NSString stringWithFormat:@"%i",horns];;
    
    if ([hornsPlayed.text integerValue] <= 0) {
        h1.hidden  = YES;
        h2.hidden  = YES;
        h3.hidden  = YES;
        h4.hidden  = YES;
        h5.hidden  = YES;
        h6.hidden  = YES;
        h7.hidden  = YES;
        h8.hidden  = YES;
        h9.hidden  = YES;
        h10.hidden = YES;
        h11.hidden = YES;
        h12.hidden = YES;
        hornsMissed.hidden = YES;
    } else {
        h1.hidden  = NO;
        h2.hidden  = NO;
        h3.hidden  = NO;
        h4.hidden  = NO;
        h5.hidden  = NO;
        h6.hidden  = NO;
        h7.hidden  = NO;
        h8.hidden  = NO;
        h9.hidden  = NO;
        h10.hidden = NO;
        h11.hidden = NO;
        h12.hidden = NO;
        hornsMissed.hidden = NO;
    }
    
    fastestHorn.text   = singleton.fastestHorn;
    slowestHorn.text   = singleton.slowestHorn;
    averageHorn.text   = singleton.averageHorn;
    totalHorn.text     = singleton.totalHorn;
    distractionOn.text = singleton.distractionOn;
    masterScore.text   = singleton.masterScore;
    
    if ([fastestHorn.text floatValue] > 999) {
        //no horns wer pressed, hide the data fields
        fastestHorn.text = @"Missed";
        h3.hidden=YES;
        h4.hidden=YES;
        h5.hidden=YES;
        h6.hidden=YES;
        h7.hidden=YES;
        h8.hidden=YES;
        h10.hidden=YES;
        h11.hidden=YES;
        h12.hidden=YES;
    } else {
        //show the horns data
        h3.hidden=NO;
        h4.hidden=NO;
        h5.hidden=NO;
        h6.hidden=NO;
        h7.hidden=NO;
        h8.hidden=NO;
        h10.hidden=NO;
        h11.hidden=NO;
        h12.hidden=NO;
    }
    
    masterScore.text = [NSString stringWithFormat:@"%0.3f",
                        ([singleton.totalTime floatValue])
                        + ([singleton.wallCrashes floatValue] * singleton.wallCrashMult)
                        + ([singleton.hazCrashes floatValue]  * singleton.hazCrashMult)
                        + (singleton.penalty)
                        + ([singleton.pressedTime floatValue])
                        ];
    singleton.masterScore = masterScore.text;
    
    //do some conversion for race
    long hours,  minutes, seconds, left;
    NSString * hsec;
    
    hsec = [totalTime.text substringWithRange:NSMakeRange(totalTime.text.length-2, 2)];
    
    left = (long)[totalTime.text intValue];

    // whole number result % modulus
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    NSString *tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@", hours, minutes, seconds, hsec];
    
    self.racehms.text = [NSString stringWithFormat:@"%@", tem3];

    hsec= [totalHorn.text substringWithRange:NSMakeRange(totalHorn.text.length-2, 2)];
    
    left =(long)[totalHorn.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@", hours, minutes, seconds, hsec];
    
    self.hornhms.text = [NSString stringWithFormat:@"%@", tem3];

    hsec = [masterScore.text substringWithRange:NSMakeRange(masterScore.text.length-2, 2)];
    
    left = (long)[masterScore.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@", hours, minutes, seconds, hsec];
    self.scorehms.text = [NSString stringWithFormat:@"%@", tem3];
    
    //set counter to cards for singleton global var
    singleton.counter = 0;
    
    // clear any old rsults from  results array
    [singleton.cardReactionTimeResult removeAllObjects];

    [singleton.cardReactionTimeResult addObject:@"MMU Cheshire, Exercise and Sport Science DRIVE App Results"];
    singleton.counter = singleton.counter+1;
    //mmu copyright message 2014 JAH
    [singleton.cardReactionTimeResult addObject:@"(c) 2016 MMU written by Jonathan A. Howell for ESS DRIVE App"];
    singleton.counter = singleton.counter+1;
    //mmu version no
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"%@",singleton.versionNumber]];
    //[singleton.cardReactionTimeResult addObject:singleton.versionNumber];
    singleton.counter = singleton.counter+1;
    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];
    singleton.counter = singleton.counter+1;
    
    //title line - results one row per data entry
    [singleton.cardReactionTimeResult addObject:@"DRIVE Race Results"];
    
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:@"Subject Name, Test Date, Test Time"];
    
    singleton.counter = singleton.counter+1;
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    // +++++++++++++++++++++++++++
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"%@, %@, %@", singleton.subjectName, singleton.testDate, singleton.testTime ]];
    singleton.counter = singleton.counter+1;
    
    // +++++++++++++++++++++++++++
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    // put all the data for the results here:
    // summary as per screen
    // lapTimes,

    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Email Sent To, %@", singleton.email]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Car No, %@", singleton.carNo]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Track No, %@", singleton.trackNo]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Drive Music, %@", singleton.musicTrack]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Distraction Set, %@", singleton.distractionOn]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Laps Raced, %@", singleton.laps]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horns Played, %@", singleton.hornsPlayed]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wall Crashes, %@", singleton.wallCrashes]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Hazard Crashes, %@", singleton.hazCrashes]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Crashes, %@", singleton.totalCrashes]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Lap, %@, %@", singleton.fastestLapNo, singleton.fastestLap]];
    singleton.counter = singleton.counter+1;
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Slowest Lap, %@, %@", singleton.slowestLapNo, singleton.slowestLap]];
    singleton.counter = singleton.counter+1;
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Lap,, %@", singleton.averageLap]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Race Time,, %@", singleton.totalTime]];
    singleton.counter = singleton.counter+1;
    
    if (horns > 0) {
        //only if horns are there at all
        //blank line
        [singleton.cardReactionTimeResult addObject:@" " ];
        singleton.counter = singleton.counter+1;
        
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horns Missed,     %@", singleton.missed]];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horns Reacted To, %@", singleton.reacted]];
        singleton.counter = singleton.counter+1;
        //[singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Missed Horn Time Total,  %@ <br/>",singleton.missedTime]];
        //singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Reacted Horn Time Total,, %@", singleton.pressedTime]];
        singleton.counter = singleton.counter+1;
        
        if ([singleton.reacted isEqualToString:@"0"]){
            singleton.fastestReaction = @"All Horns Missed";
        }
        
        if ([singleton.reacted isEqualToString:@"0"]){
            singleton.slowestReaction = @"All Horns Missed";
            //penalty printed in gap on display as all horns missed
            h3.hidden=NO;
            h3.text=[NSString stringWithFormat:@"TP %0.3f ", singleton.penalty];
        }
        
            [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@" Missed Horn Time Penalty,, %0.3f", singleton.penalty]];
            singleton.counter = singleton.counter+1;

        
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Reacted Horn Time Total,, %@", singleton.fastestReaction]];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Slowest Reacted Horn Time Total,, %@", singleton.slowestReaction]];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Average Reacted Only Horn Time,,  %@", singleton.averageReaction]];
        singleton.counter = singleton.counter+1;
    }
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Race Score,, %@", singleton.masterScore]];
    singleton.counter = singleton.counter+1;

    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject: @"LapNo, Time(S), Wall Crashes, Hazard Crashes"];
    singleton.counter = singleton.counter+1;
    
    //***********************
    //look here for formatted result inc lap no. etc
    
    // all the laps, one per line
    for (int x=0; x<[laps.text intValue]; x+=1) {
        [singleton.cardReactionTimeResult addObject:singleton.lapTimes[x] ];
        singleton.counter = singleton.counter+1;
        //[singleton.cardReactionTimeResult addObject:@" " ];
        //singleton.counter = singleton.counter+1;
    }

    // all the horns, one per line if present
    if (horns > 0) {
                //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
        
        [singleton.cardReactionTimeResult addObject:@"Horn No, Horn Reaction Time(S), Missed horn(T/F)"];
        singleton.counter = singleton.counter+1;
        // list the horns and the timings
        for (int x=0; x<horns; x+=1) {
            [singleton.cardReactionTimeResult addObject:singleton.hornTimes[x] ];
            singleton.counter = singleton.counter+1;
            //[singleton.cardReactionTimeResult addObject:@" " ];
            //singleton.counter = singleton.counter+1;
        }
    }
    // ***************************
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    [singleton.cardReactionTimeResult addObject:@"... " ];
    //end of data message
    [singleton.cardReactionTimeResult addObject:@"End of Drive Results table." ];
    singleton.counter = singleton.counter+1;
    
    //make a text file from the array of results
    NSMutableString * element     = [[NSMutableString alloc] init];
    //NSMutableString * printString = [NSMutableString stringWithString:@"\n"];
    NSMutableString * printString = [NSMutableString stringWithString:@""];
    //
    //array of rows put into one string for text output
    //add back if multi output
    
    //[printString appendString:@"\n"];
    
    for(int i=0; i< (singleton.counter+1); i++)
        {
        element = [singleton.cardReactionTimeResult objectAtIndex: i];
        [printString appendString:[NSString stringWithFormat:@"\n%@", element]];
        }
    // [printString appendString:@"\n"];
    
    singleton.resultStrings = printString;
    
    [self WriteToStringFile:[printString mutableCopy]];
    
    //statusMessageLab.text=@"Waiting\nfor\nNext\nInstruction.";
}

-(NSString *) setFilename{
    //mySingleton * singleton = [mySingleton sharedSingleton];
    NSString    * extn = @"csv";
    //filename  = [NSString stringWithFormat:@"%@.%@", singleton.subjectName, extn];
    filename    = [NSString stringWithFormat:@"%@.%@", @"DriveAppData", extn];
    return filename;
}

//find the home directory for Document
-(NSString *)GetDocumentDirectory{
    fileMgr  = [NSFileManager defaultManager];
    NSString * docsDir;
    NSArray  * dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir  = dirPaths[0];
    return docsDir;
}

/*Create a new file*/
-(void)WriteToStringFile:(NSMutableString *)textToWrite{
    mySingleton *singleton = [mySingleton sharedSingleton];
    //int trynumber = 0;
    filepath = [[NSString alloc] init];
    NSError *err;
    
    //get sub name and add date
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    
    singleton.subjectName = [singleton.subjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];

    BOOL ok;
    ok = [textToWrite writeToFile:filepath atomically:YES encoding:NSASCIIStringEncoding error:&err];
    if (!ok) {
        //(statusMessageLab.text=filepath, [err localizedFailureReason]);
        NSLog(@"Error writing file at %@\n%@", filepath, [err localizedFailureReason]);
    }
}

-(NSString*)getCurrentDateTimeAsNSString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyHHmmss"];
    NSDate *now = [NSDate date];
    NSString *retStr = [format stringFromDate:now];
    
    return retStr;
}

-(void)viewDidDisappear:(BOOL)animated{
    statusMessageLab.hidden = YES;
}
//*****************
//START - test email client and components from Tachist
//mail from button press
-(IBAction)showEmail:(id)sender {
    statusMessageLab.text=@"E-Mail\nResults\nLoading...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]){
        [mailComposer setToRecipients:[NSArray arrayWithObjects:singleton.email, Nil]];
        
        //[mailComposer setSubject:@"iPad Restults from DRIVE App"];
        [mailComposer setSubject:
         //[NSString stringWithFormat:@"%@ - DRIVE, %@, %@.", [NSString stringWithFormat:@"%@", singleton.subjectName], singleton.testDate, singleton.testTime]];
         [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", singleton.subjectName]]
         ];
        
        //[mailComposer setMessageBody:@"Dear Drive User: " isHTML:YES];
        filepath = [[NSString alloc] init];
        
        filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
        
        // Get the resource path and read the file using NSData
        
        NSData *fileData = [NSData dataWithContentsOfFile:filepath];
        filename=@"DriveAppData.csv";
        
        //formatted for csv Excel type file
        //[mailComposer setMessageBody: singleton.resultStrings isHTML:YES];
        
        //formatted in HTML
        NSString * display=@"";
        
        //replace \n with <br/> for display
        display = [singleton.resultStrings stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        //replace any double comma ,, with one comma
        display = [display stringByReplacingOccurrencesOfString:@",," withString:@","];
        
        //display the screen formatted email body now
        [mailComposer setMessageBody: display isHTML:YES];
        
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        //add the data as an attachment in csv Excel format
        [mailComposer addAttachmentData:fileData mimeType:@"text/csv" fileName:filename];
        
        //present the email client.
        [self presentViewController:mailComposer animated:YES completion:^{/*email*/}];
    }else{
        
    } //end of if else to check if mail is able to be sent, send message if not
    statusMessageLab.text=@"Select\nNext\nTask";
} // end of mail function

//set out mail controller warnings screen
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error {
    statusMessageLab.text = @"Mail\nController";
    if (error) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil,nil];
        [alertview show];
        //[alert release];
        [self dismissViewControllerAnimated:YES completion:^{/*error*/}];
        statusMessageLab.text = @"An mail\nError\nOccurred.";
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{/*ok*/}];
        statusMessageLab.text = @"E-Mail Sent\nOK.";
    }
    statusMessageLab.text = @"Select\nNext\nTask";
}

- (void)saveText
{
    //save text results to file for attachment
    statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton   * singleton = [mySingleton sharedSingleton];
    NSFileManager * filemgr;
    NSData        * databuffer;
    NSString      * dataFile;
    NSString      * docsDir;
    NSArray       * dirPaths;
    
    filemgr  = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir  = dirPaths[0];
    
    //NSString *fileNameS = [NSString stringWithFormat:@"%@.csv", singleton.subjectName];
    NSString * fileNameS = [NSString stringWithFormat:@"%@.csv", @"DriveAppData"];
    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];
    
    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}

//END - test email client and components from Tachist

//set out mail controller warnings screen
-(void)mailComposeController2:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error {
    statusMessageLab.hidden = NO;
    statusMessageLab.text=@"Mail\nController";
    if (error) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil,nil];
        [alertview show];
        //[alert release];
        [self dismissViewControllerAnimated:YES completion:^{/*error*/}];
        statusMessageLab.text=@"An mail\nError\nOccurred.";
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{/*ok*/}];
        statusMessageLab.text=@"E-Mail Sent\nOK.";
    }
    //statusMessageLab.text=@"Select\nNext\nTask";
}

-(void)setDateNow{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    testDates.text=dateString;
    singleton.testDate=testDates.text;
}

-(void)setTimeNow{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate: currentTime];
    testTimes.text=timeString;
    singleton.testDate=testTimes.text;
}

 - (IBAction)finishAction:(id)sender {
         [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
     
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
