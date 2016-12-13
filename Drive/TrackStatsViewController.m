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
    h7,h8,
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
    singleton.email      = [defaults objectForKey:kEmail];
    singleton.subjectName= [defaults objectForKey:kSubject];
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
    
    int horns;
    horns = [singleton.hornsPlayed intValue];
    
    if (horns < 0) {
        horns = 0;
    }
    hornsPlayed.text=[NSString stringWithFormat:@"%i",horns];;
    
    if ([hornsPlayed.text integerValue] <= 0) {
        h1.hidden=YES;
        h2.hidden=YES;
        h3.hidden=YES;
        h4.hidden=YES;
        h5.hidden=YES;
        h6.hidden=YES;
        h7.hidden=YES;
        h8.hidden=YES;
    }else{
        h1.hidden=NO;
        h2.hidden=NO;
        h3.hidden=NO;
        h4.hidden=NO;
        h5.hidden=NO;
        h6.hidden=NO;
        h7.hidden=NO;
        h8.hidden=NO;
    }
    
    fastestHorn.text   = singleton.fastestHorn;
    slowestHorn.text   = singleton.slowestHorn;
    averageHorn.text   = singleton.averageHorn;
    totalHorn.text     = singleton.totalHorn;
    distractionOn.text = singleton.distractionOn;
    masterScore.text   = singleton.masterScore;
    
    masterScore.text = [NSString stringWithFormat:@"%0.2f",
                        ([singleton.totalTime floatValue])
                        +([singleton.wallCrashes floatValue] * singleton.wallCrashMult)
                        +([singleton.hazCrashes floatValue]  * singleton.hazCrashMult)
                        ];
    singleton.masterScore=masterScore.text;
    
    //do some conversion for race
    long hours,  minutes, seconds, left;
    NSString * hsec;
    
    hsec = [totalTime.text substringWithRange:NSMakeRange(totalTime.text.length-2, 2)];
    
    left = (long)[totalTime.text intValue];

    // whole number result % modulus
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    NSString *tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    
    self.racehms.text = [NSString stringWithFormat:@"%@", tem3];

    hsec= [totalHorn.text substringWithRange:NSMakeRange(totalHorn.text.length-2, 2)];
    
    left =(long)[totalHorn.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    
    self.hornhms.text = [NSString stringWithFormat:@"%@", tem3];

    hsec = [masterScore.text substringWithRange:NSMakeRange(masterScore.text.length-2, 2)];
    
    left = (long)[masterScore.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours   = (left % 86400) / 3600;
    
    tem3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    self.scorehms.text = [NSString stringWithFormat:@"%@", tem3];
    
    //set counter to cards for singleton global var
    singleton.counter = 1;
    
    // clear any old rsults from  results array
    [singleton.cardReactionTimeResult removeAllObjects];

    [singleton.cardReactionTimeResult addObject:@"MMU Cheshire, Exercise and Sport Science, DRIVE App Results<br/>"];
    singleton.counter = singleton.counter+1;
    //mmu copyright message 2014 JAH
    [singleton.cardReactionTimeResult addObject:@"(c) 2016 MMU written by Jonathan A. Howell for ESS DRIVE App<br/>"];
    singleton.counter = singleton.counter+1;
    //mmu version no
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"%@",singleton.versionNumber]];
    //[singleton.cardReactionTimeResult addObject:singleton.versionNumber];
    singleton.counter = singleton.counter+1;
    //blank line
    [singleton.cardReactionTimeResult addObject:@"<br/><br/> "];
    singleton.counter = singleton.counter+1;
    
    //title line - results one row per data entry
    [singleton.cardReactionTimeResult addObject:@"DRIVE Race Results <br/>"];
    
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:@"Subject Name, Test Date, Test Time"];
    
    singleton.counter = singleton.counter+1;
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" <br/>" ];
    singleton.counter = singleton.counter+1;
    // +++++++++++++++++++++++++++
    //loop if rows of results
    //results, one per line upto number of cards
    //for (int y=1; y<singleton.counter+1; y++) {
    //uncomment when formatted
 
        //myNumbStr = [NSString stringWithFormat:@"%@,%@,%@" ,
                     //singleton.subjectName,
                     //testDate,
                     //testTime
                     //];
    
    //[singleton.cardReactionTimeResult addObject: myNumbStr];
    //singleton.counter = singleton.counter+1;
    //}
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"%@, %@, %@ <br/>", singleton.subjectName, singleton.testDate, singleton.testTime ]];
    singleton.counter = singleton.counter+1;
    
    // +++++++++++++++++++++++++++
    //blank line
    [singleton.cardReactionTimeResult addObject:@" <br/>" ];
    singleton.counter = singleton.counter+1;
    
    // put all the data for the results here:
    // summary as per screen
    // lapTimes,

    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Email: %@ <br/>",singleton.email]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Car: %@, Track: %@ <br/>",singleton.carNo, singleton.trackNo]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Drive Music: %@ <br/>",singleton.musicTrack]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Distraction Set: %@ <br/>",singleton.distractionOn]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Laps Raced: %@ <br/>",singleton.laps]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horns Played: %@ <br/>",singleton.hornsPlayed]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wall Crashes: %@, Hazard Crashes: %@, Total Crashes: %@ <br/>",singleton.wallCrashes,singleton.hazCrashes, singleton.totalCrashes]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Lap: %@: %@, Slowest Lap: %@: %@, Average Lap: %@ <br/>",singleton.fastestLapNo, singleton.fastestLap,singleton.slowestLapNo,singleton.slowestLap, singleton.averageLap]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Race Time: %@<br/>",singleton.totalTime]];
    singleton.counter = singleton.counter+1;
    
    if (horns > 0) {
        //blank line
        [singleton.cardReactionTimeResult addObject:@" <br/>" ];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Horn: %@, Slowest Horn: %@, Average Horn: %@ <br/>",singleton.fastestHorn,singleton.slowestHorn, singleton.averageHorn]];
        singleton.counter = singleton.counter+1;
        
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Total Horn Time: %@ <br/>",singleton.totalHorn]];
        singleton.counter = singleton.counter+1;
    }

    //blank line
    [singleton.cardReactionTimeResult addObject:@" <br/>" ];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject: @"LapNo, Times, Wall Crashes, Hazard Crashes <br/>"];
    singleton.counter = singleton.counter+1;
    
    //***********************
    //look here for formatted result inc lap no. etc
    
    // all the laps, one per line
    for (int x=0; x<[laps.text intValue]; x+=1) {
        [singleton.cardReactionTimeResult addObject:singleton.lapTimes[x] ];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:@" <br/>" ];
        singleton.counter = singleton.counter+1;
    }

    // all the horns, one per line if present
    if (horns > 0) {
                //blank line
    [singleton.cardReactionTimeResult addObject:@" <br/>" ];
    singleton.counter = singleton.counter+1;
        
        [singleton.cardReactionTimeResult addObject:@"Horn No, Horn Reaction Time<br/>"];
        singleton.counter = singleton.counter+1;
        // list the horns and the timings
        for (int x=0; x<horns; x+=1) {
            [singleton.cardReactionTimeResult addObject:singleton.hornTimes[x] ];
            singleton.counter = singleton.counter+1;
            [singleton.cardReactionTimeResult addObject:@" <br/>" ];
            singleton.counter = singleton.counter+1;
        }
    }
    // ***************************
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" <br/>" ];
    singleton.counter = singleton.counter+1;
    [singleton.cardReactionTimeResult addObject:@"... " ];
    //end of data message
    [singleton.cardReactionTimeResult addObject:@"End of results table." ];
    singleton.counter = singleton.counter+1;
    
    //make a text file from the array of results
    NSMutableString * element     = [[NSMutableString alloc] init];
    NSMutableString * printString = [NSMutableString stringWithString:@"\n"];
    //
    //array of rows put into one string for text output
    //add back if multi output
    
    [printString appendString:@"\n"];
    for(int i=0; i< (singleton.counter); i++)
        {
        element = [singleton.cardReactionTimeResult objectAtIndex: i];
        [printString appendString:[NSString stringWithFormat:@"\n%@", element]];
        }
    [printString appendString:@"\n"];
    
    singleton.resultStrings = printString;
    
    [self WriteToStringFile:[printString mutableCopy]];
    
    //statusMessageLab.text=@"Waiting\nfor\nNext\nInstruction.";
}

-(NSString *) setFilename{
    mySingleton * singleton = [mySingleton sharedSingleton];
    NSString    * extn = @"csv";
    filename = [NSString stringWithFormat:@"%@.%@", singleton.subjectName, extn];
    return filename;
}

//find the home directory for Document
-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    NSString * docsDir;
    NSArray  * dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
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
    
    // not needed as all file names have date added to end of name
    //check if file exists
    
    //BOOL fileExists = TRUE;
    //if([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
    //exists, error, add +1 to filename and repeat
    //BOOL fileExists = TRUE;
    
    
    //singleton.subjectName = [singleton.oldSubjectName stringByAppendingString: [NSString stringWithFormat:@"_%@_%i",[self getCurrentDateTimeAsNSString], trynumber]];
    //[self WriteToStringFile:textToWrite];
    //    }
    //else
    //    {
    //not exists, write
    //BOOL fileExists = FALSE;
    
    singleton.subjectName = [singleton.subjectName stringByAppendingString: [NSString stringWithFormat:@"_%@",[self getCurrentDateTimeAsNSString]]];
    
    //}
    //
    
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
        [mailComposer setToRecipients:[NSArray arrayWithObjects:singleton.email ,Nil]];
        
        //[mailComposer setSubject:@"iPad Restults from DRIVE App"];
        [mailComposer setSubject:
         [NSString stringWithFormat:@"%@ - DRIVE, %@, %@.", [NSString stringWithFormat:@"%@", singleton.subjectName], singleton.testDate, singleton.testTime]];
        
        //[mailComposer setMessageBody:@"Dear Drive User: " isHTML:YES];
        
        [mailComposer setMessageBody: singleton.resultStrings isHTML:YES];
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:mailComposer animated:YES completion:^{/*email*/}];
    }else{
        
    } //end of if else to check if mail is able to be sent, send message if not
    statusMessageLab.text=@"Select\nNext\nTask";
} // end of mail function

//set out mail controller warnings screen
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error {
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
    statusMessageLab.text=@"Select\nNext\nTask";
}

- (void)saveText
{
    //save text results to file for attachment
    statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSFileManager *filemgr;
    NSData *databuffer;
    NSString *dataFile;
    NSString *docsDir;
    NSArray *dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    NSString *fileNameS = [NSString stringWithFormat:@"%@.csv", singleton.subjectName];
    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];
    
    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}

//END - test email client and components from Tachist
//*****************
//mail from button press - not used client?????? use ShowEmail
-(IBAction)sendEmail:(id)sender {
    statusMessageLab.hidden = NO;
    statusMessageLab.text=@"E-Mail\nResults\nLoading...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail]){
        [mailComposer setToRecipients:[NSArray arrayWithObjects:singleton.email ,Nil]];
        [mailComposer setSubject:@"Results from DRIVE App"];
        //[mailComposer setMessageBody:@"Dear Drive App User: " isHTML:YES];
        
        [mailComposer setMessageBody: singleton.resultStrings isHTML:NO];
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        [self presentViewController:mailComposer animated:YES completion:^{/*email*/}];
        
    }else{
        
    } //end of if else to check if mail is able to be sent, send message if not
    //statusMessageLab.text=@"Select\nNext\nTask";
} // end of mail function

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
