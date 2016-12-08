//
//  resultsVC.h
//  Drive
//
//  Created by Jon Howell on 04/09/2014.
//  Copyright (c) 2016 Manchester Metropolitan University - ESS - essmobile. All rights reserved.
//
//  from Tachist 

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface resultsVC : UIViewController <MFMailComposeViewControllerDelegate>
{
    
IBOutlet UITextView    * resultsTxtView;
//text views for text displays ie results or help screens

// for file manager
    NSFileManager   * fileMgr;
    NSString        * homeDir;
    NSString        * filename;
    NSString        * filepath;

// for calculations and functions
    NSDate          * startDate;
    NSDate          * testDate;
    UILabel         * datelbl;
    UILabel         * timelbl;
    UIButton        * emailBTN;
    UILabel         * subjectlbl;
}

//file ops stuff
@property(nonatomic,retain) NSFileManager * fileMgr;
@property(nonatomic,retain) NSString      * homeDir;
@property(nonatomic,retain) NSString      * filename;
@property(nonatomic,retain) NSString      * filepath;

//dates
@property (nonatomic, copy) NSDate        * startDate;
@property (nonatomic, copy) NSDate        * testDate;


@property (nonatomic, strong) IBOutlet UIButton    * emailBTN;
@property (nonatomic, strong) UITextView           * resultsTxtView;
@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic) IBOutlet UILabel     * heading;

//array for table - test only
@property (nonatomic,strong) NSMutableArray *arrItems;

-(IBAction)showEmail:(id)sender;

-(NSString *) GetDocumentDirectory;
-(NSString *) setFilename;
-(void) WriteToStringFile:(NSMutableString *)textToWrite;

@end
