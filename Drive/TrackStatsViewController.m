//
//  TrackStatsViewController.m
//  Drive
//
//  Created by Jonathan Howell on 13/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//

// back button is Start Again

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
    emailbtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    statusMessageLab.hidden = YES;
    
    //set up the plist params
    NSString *pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    singleton.email=[defaults objectForKey:kEmail];
    singleton.subjectName= [defaults objectForKey:kSubject];
}

- (void)viewDidAppear:(BOOL)animated{
    mySingleton *singleton = [mySingleton sharedSingleton];
    statusMessageLab.hidden=YES;
    //set up the plist params
    NSString *pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *defaultPrefs      = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults *defaults        = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    [defaults synchronize];
    singleton.email=[defaults objectForKey:kEmail];
    singleton.subjectName= [defaults objectForKey:kSubject];
    
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
    
    // build the stats
    laps.text=singleton.laps;
    testDates.text=singleton.testDate;
    testTimes.text=singleton.testTime;
    email.text=singleton.email;
    subjectName.text=singleton.subjectName;
    versionNumber.text=singleton.versionNumber;
    carNo.text=singleton.carNo;
    trackNo.text=singleton.trackNo;
    musicTrack.text=singleton.musicTrack;
    fastestLap.text=singleton.fastestLap;
    slowestLap.text=singleton.slowestLap;
    fastestLapNo.text=singleton.fastestLapNo;
    slowestLapNo.text=singleton.slowestLapNo;
    averageLap.text=singleton.averageLap;
    totalTime.text=singleton.totalTime;
    hazCrashes.text=singleton.hazCrashes;
    wallCrashes.text=singleton.wallCrashes;
    totalCrashes.text=singleton.totalCrashes;
    
    int horns;
    horns=[singleton.hornsPlayed intValue];
    
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
    
    
    fastestHorn.text=singleton.fastestHorn;
    slowestHorn.text=singleton.slowestHorn;
    averageHorn.text=singleton.averageHorn;
    totalHorn.text=singleton.totalHorn;
    distractionOn.text=singleton.distractionOn;
    masterScore.text=singleton.masterScore;
    
    masterScore.text = [NSString stringWithFormat:@"%0.2f",
                        ([singleton.totalTime floatValue])
                        +([singleton.wallCrashes floatValue] * singleton.wallCrashMult)
                        +([singleton.hazCrashes floatValue]  * singleton.hazCrashMult)
                        ];
    singleton.masterScore=masterScore.text;
    
    //do some conversion for race
    long hours,  minutes, seconds, left;
    NSString * hsec;
    
    hsec= [totalTime.text substringWithRange:NSMakeRange(totalTime.text.length-2, 2)];
    
    left =(long)[totalTime.text intValue];

    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours = (left % 86400) / 3600;
    
    NSString *temp3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    
    self.racehms.text = [NSString stringWithFormat:@"%@", temp3];

    hsec= [totalHorn.text substringWithRange:NSMakeRange(totalHorn.text.length-2, 2)];
    
    left =(long)[totalHorn.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours = (left % 86400) / 3600;
    
    temp3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    
    self.hornhms.text = [NSString stringWithFormat:@"%@", temp3];

    hsec= [masterScore.text substringWithRange:NSMakeRange(masterScore.text.length-2, 2)];
    
    left =(long)[masterScore.text intValue];
    
    seconds = (left % 60);
    minutes = (left % 3600) / 60;
    hours = (left % 86400) / 3600;
    
    temp3 = [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%@",hours,minutes,seconds,hsec];
    self.scorehms.text = [NSString stringWithFormat:@"%@", temp3];
    
    //set counter to cards for singleton global var
    singleton.counter = 1;
    
    // clear any old rsults from  results array
    [singleton.cardReactionTimeResult removeAllObjects];

    [singleton.cardReactionTimeResult addObject:@"MMU Cheshire, Exercise and Sport Science, DRIVE App Results"];
    singleton.counter = singleton.counter+1;
    //mmu copyright message 2014 JAH
    [singleton.cardReactionTimeResult addObject:@"(c) 2015 MMU written by Jonathan A. Howell for ESS DRIVE App"];
    singleton.counter = singleton.counter+1;
    //mmu version no
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"%@",singleton.versionNumber]];
    //[singleton.cardReactionTimeResult addObject:singleton.versionNumber];
    singleton.counter = singleton.counter+1;
    //blank line
    [singleton.cardReactionTimeResult addObject:@" "];
    singleton.counter = singleton.counter+1;
    
    //title line - results one row per data entry
    [singleton.cardReactionTimeResult addObject:@"DRIVE Race Results Results"];
    
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:@"Subject Name, Test Date, Test Time"];
    
    singleton.counter = singleton.counter+1;
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
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
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Date: %@, Time: %@, Subject Name: %@",singleton.testDate, singleton.testTime, singleton.subjectName]];
    singleton.counter = singleton.counter+1;
    
    // +++++++++++++++++++++++++++
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    // put all the data for the results here:
    // summary as per screen
    // lapTimes,

    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Email: %@",singleton.email]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Car: %@, Track: %@",singleton.carNo, singleton.trackNo]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Drive Music: %@",singleton.musicTrack]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Distraction Set: %@",singleton.distractionOn]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Laps Raced: %@",singleton.laps]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horns Played: %@",singleton.hornsPlayed]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Wall Crashes: %@, Hazard Crashes: %@, Total Crashes: %@",singleton.wallCrashes,singleton.hazCrashes, singleton.totalCrashes]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Lap: %@: %@, Slowest Lap: %@: %@, Average Lap: %@",singleton.fastestLapNo, singleton.fastestLap,singleton.slowestLapNo,singleton.slowestLap, singleton.averageLap]];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Race Time: %@",singleton.totalTime]];
    singleton.counter = singleton.counter+1;
    
    if (horns > 0) {
        //blank line
        [singleton.cardReactionTimeResult addObject:@" " ];
        singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Fastest Horn: %@, Slowest Horn: %@, Average Horn: %@",singleton.fastestHorn,singleton.slowestHorn, singleton.averageHorn]];
        singleton.counter = singleton.counter+1;
        
        [singleton.cardReactionTimeResult addObject:[NSString stringWithFormat:@"Horn Time: %@",singleton.totalHorn]];
        singleton.counter = singleton.counter+1;
    }

    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    [singleton.cardReactionTimeResult addObject: @"Laps: Times"];
    singleton.counter = singleton.counter+1;
    
    //***********************
    //look here for formatted result inc lap no. etc
    
    // all the laps, one per line
    for (int x=0; x<[laps.text intValue]; x+=1) {
        [singleton.cardReactionTimeResult addObject:singleton.lapTimes[x] ];
        singleton.counter = singleton.counter+1;
    }

    
    // all the horns, one per line if present
    if (horns > 0) {
                //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
        [singleton.cardReactionTimeResult addObject:@"Horn No: Reaction Time"];
        singleton.counter = singleton.counter+1;
        // list the horns and the timings
        for (int x=1; x<horns; x+=1) {
            [singleton.cardReactionTimeResult addObject:singleton.hornTimes ];
            singleton.counter = singleton.counter+1;
        }
    }
    // ***************************
    
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    
    //end of data message
    [singleton.cardReactionTimeResult addObject:@"End of results table. " ];
    singleton.counter = singleton.counter+1;
    //blank line
    [singleton.cardReactionTimeResult addObject:@" " ];
    singleton.counter = singleton.counter+1;
    //mmu copyright message
    [singleton.cardReactionTimeResult addObject:@"MMU (c) 2015 DRIVE App Jonathan A. Howell SAS Technical Services. " ];
    singleton.counter = singleton.counter+1;
    //version number
    [singleton.cardReactionTimeResult addObject: singleton.versionNumber ];
    singleton.counter = singleton.counter+1;
    //blank line
    [singleton.cardReactionTimeResult addObject:@"."];
    [singleton.cardReactionTimeResult addObject:@".."];
    [singleton.cardReactionTimeResult addObject:@"..."];
    singleton.counter = singleton.counter+1;
    
    //make a text file from the array of results
    NSMutableString *element = [[NSMutableString alloc] init];
    NSMutableString *printString = [NSMutableString stringWithString:@"\n"];
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
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *extn = @"csv";
    filename = [NSString stringWithFormat:@"%@.%@", singleton.subjectName, extn];
    return filename;
}

//find the home directory for Document
-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    NSString *docsDir;
    NSArray *dirPaths;
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
        //NSLog(@"Error writing file at %@\n%@", filepath, [err localizedFailureReason]);
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

- (void)saveText
{
    //statusMessageLab.text=@"Saving\nData\nFile.";
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSFileManager   * filemgr;
    NSData          * databuffer;
    NSString        * dataFile;
    NSString        * docsDir;
    NSArray         * dirPaths;
    
    filemgr = [NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    NSString * fileNameS = [NSString stringWithFormat:@"%@.csv", subjectName.text];
    dataFile = [docsDir stringByAppendingPathComponent:fileNameS];
    
    databuffer = [singleton.resultStrings dataUsingEncoding: NSASCIIStringEncoding];
    [filemgr createFileAtPath: dataFile
                     contents: databuffer attributes:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    statusMessageLab.hidden = YES;
}

//mail from button press
-(IBAction)sendEmail:(id)sender {
    statusMessageLab.hidden = NO;
    statusMessageLab.text=@"E-Mail\nResults\nLoading...";
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    if ([MFMailComposeViewController canSendMail]){
        [mailComposer setToRecipients:[NSArray arrayWithObjects:singleton.email ,Nil]];
        [mailComposer setSubject:@"Results from DRIVE App"];
        //[mailComposer setMessageBody:@"Dear VO2 App User: " isHTML:YES];
        
        [mailComposer setMessageBody: singleton.resultStrings isHTML:NO];
        [mailComposer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        [self presentViewController:mailComposer animated:YES completion:^{/*email*/}];
        
    }else{
        
    } //end of if else to check if mail is able to be sent, send message if not
    //statusMessageLab.text=@"Select\nNext\nTask";
} // end of mail function

//set out mail controller warnings screen
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *) error {
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

//if file name is passed, use...
//- (IBAction)showEmail:(NSString*)file {

- (IBAction)showEmail:(id)sender {
             [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    statusMessageLab.hidden = NO;
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    NSString *emailTitle = [NSString stringWithFormat:@"DRIVE App Data for: %@",singleton.subjectName];
    NSString *messageBody = [NSString stringWithFormat:@"The test data for the subject:%@ taken at the date: %@ and time: %@, is attached as a text/csv file.  \n\nThe file is comma separated variable, .csv extension.  \n\nThe data can be read by MS-Excel, then analysed by your own functions. \n\nSent by DRIVE App.",singleton.subjectName,singleton.testDate,singleton.testTime];
    //old for testing// NSArray  *toRecipents = [NSArray arrayWithObject:@"j.a.howell@mmu.ac.uk"];
    
    NSArray  *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", singleton.email,Nil]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    filepath = [[NSString alloc] init];
    
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:self.setFilename];
    
    // Get the resource path and read the file using NSData
    
    NSData *fileData = [NSData dataWithContentsOfFile:filepath];
    
    // Determine the MIME type
    NSString *mimeType;
    mimeType = @"text/csv";//only one type needed
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
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
         mySingleton *singleton = [mySingleton sharedSingleton];
         [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
     
     for (int x=0; x<(singleton.counter+1); x+=1) {
         NSLog(@"%@",singleton.cardReactionTimeResult[x]);
     }
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
