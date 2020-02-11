//
//  ViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//

#import "ViewController.h" 
#import "mySingleton.h"
#import "TrackStatsViewController.h"
#import "MyScene.h"
#import "AnalogControl.h"
#import "SKTUtils.h"

#define kEmail      @"emailAddress"
#define kSubject    @"subjectName"
#define kVersion0   @"version0"
#define kVersion1   @"version1"
#define kVersion2   @"version2"
#define kVersion3   @"version3"

@interface ViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
}

@property (nonatomic, strong) SKView          * skView;
@property (nonatomic, strong) AnalogControl   * analogControl;
@property (nonatomic, strong) MyScene         * scene;
@property (weak, nonatomic) IBOutlet UIButton * hornBtn;

@end

@implementation ViewController

@synthesize hornBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    //for plist version group
    NSString * version0; //version number
    NSString * version1; //copyright info
    NSString * version2; //author info
    NSString * version3; //web site info
    NSString * subjectName; //web site info
    NSString * email; //web site info
    
    // for web page link
    //NSURL *url = [NSURL URLWithString:@"http://www.ess.mmu.ac.uk/"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[webview loadRequest:request];
    //read the user defaults from the iPhone/iPad bundle
    // if any are set to nil (no value on first run), put a temporary one in
    
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //*************************************************************
    //version, set anyway *****************************************
    //*************************************************************
    
    version0 =  @"DRIVE Version 2.4.0 - 11.02.2020";     // version   *** keep short
    version1 =  @"MMU (C) 2020";                // copyright *** limited line space
    version2 =  @"s.maudsley-barton@mmu.ac.uk";        // author    *** to display on device
    version3 =  @"http://www.ess.mmu.ac.uk";    // web site  *** settings screen
    //*************************************************************
    [defaults setObject:version0 forKey:kVersion0];   //***
    [defaults setObject:version1 forKey:kVersion1];   //***
    [defaults setObject:version2 forKey:kVersion2];   //***
    [defaults setObject:version3 forKey:kVersion3];   //***
    //*************************************************************
    //version set end *********************************************
    //*************************************************************
    
    //for plist
    //set up the plist params
    
    [defaults synchronize];
    //if any settings not already set, as in new installation, put the defaults in.
    
    [self registerDefaultsFromSettingsBundle];
    //set date and time

        [self setDateNow:self];
        [self setTimeNow:self];
    
    //tester name
    subjectName     = [defaults objectForKey:kSubject];
    if([subjectName isEqualToString: @ "" ]|| email == nil){
        subjectName =  @"Me";
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.subjectName] forKey:kSubject];
    }
    //email name
    email     = [defaults objectForKey:kEmail];
    if([email isEqualToString: @ "" ]|| email == nil){
        email =  @"Me@mmu.ac.uk";
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.email] forKey:kEmail];
    }
    singleton.subjectName = subjectName;
    singleton.email       = email;
    
    [defaults synchronize];//make sure all are updated
    
    //versionNumberLab.text   = version0;
    singleton.versionNumber = version0;
    
    if ([singleton.distractionOn isEqual:@"OFF"]) {
        hornBtn.hidden=YES;
    }else{
        hornBtn.hidden=NO;
    }
}

-(void)setDateNow:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    singleton.testDate=dateString;
}

-(void)setTimeNow:(id)sender{
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate: currentTime];
    singleton.testTime=timeString;
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    [self.view sendSubviewToBack:self.skView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
mySingleton *singleton = [mySingleton sharedSingleton];
    
    _carType = [singleton.carNo integerValue];//carType;
    _levelType = [singleton.trackNo integerValue];//levelType;
    
    if (!self.skView) {
        self.skView = [[SKView alloc] initWithFrame:self.view.bounds];
        MyScene *scene = [[MyScene alloc]
                          
        initWithSize:self.skView.bounds.size carType:self.carType level:self.levelType];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.skView presentScene:scene];

        [self.view addSubview:self.skView];

        const CGFloat padSide    = 128.0f;
        const CGFloat padPadding = 10.0f;

        self.analogControl = ({
            CGRect frame = CGRectMake(
                padPadding,
                CGRectGetHeight(self.skView.frame) - padPadding - padSide,
                padSide,
                padSide
            );
            AnalogControl *analogControl = [[AnalogControl alloc] initWithFrame:frame];
            analogControl;
        });
        [self.view addSubview:self.analogControl];

        [self.analogControl addObserver:scene forKeyPath:@"relativePosition"
                                options:NSKeyValueObservingOptionNew context:nil];
        self.scene = scene;

        __weak typeof(self) weakSelf = self;
        self.scene.gameOverBlock = ^(BOOL didWin) {
            [weakSelf p_gameOverWithWin: didWin];
        };
    }

    //only show fps when in debug mode
#ifdef DEBUG
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
#endif

}

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        } else {
            return UIInterfaceOrientationMaskAll;
        }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [self.analogControl removeObserver:self.scene forKeyPath:@"relativePosition"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Pause Action

- (IBAction)pauseButtonDidTouchUpInside:(id)sender {
    [self p_showInGameMenu];
}

- (IBAction)hornButtonDidTouchUpInside:(id)sender {
    //the horn button was pressed
    mySingleton *singleton = [mySingleton sharedSingleton];
    singleton.hornsShowing = YES;
}

#pragma mark - Game Over

- (void)p_gameOverWithWin:(BOOL)didWin {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:didWin ? @"You Completed the Laps Required!" : @"You Did Not Finish the Race"
                               message:@"... This Race is Now Over ..."
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:nil];
    [alert show];
    if (didWin) {
        [self performSelector:@selector(p_goBackStats:) withObject:alert afterDelay:2.0];
    }else{
        //you did not finish or cancelled, just start again... consider part stats, ie no email
        [self performSelector:@selector(p_goBack:) withObject:alert afterDelay:2.0];
    }
}

- (void)p_goBackStats:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated: YES];
    
    //re-route this to the results stats VC TrackStatsVC
    //[self.navigationController popToRootViewControllerAnimated:YES];
    TrackStatsViewController *TrackStatsVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TrackStatsViewController class])];
    
    [self.navigationController pushViewController:TrackStatsVC animated: YES];
}
- (void)p_goBack:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated: YES];
    
    //re-route this to the results stats VC TrackStatsVC
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)p_showInGameMenu {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"MMU ESS Drive Menu"
                               message:@"You have Paused the Race.... \n\nWhat would you like to do?"
                              delegate:self
                     cancelButtonTitle:@"Resume Race"
                     otherButtonTitles:@"Start A New Race", nil];
    [alert show];

    self.scene.paused = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.scene.paused = NO;

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self p_gameOverWithWin: NO];
    }
}

@end
