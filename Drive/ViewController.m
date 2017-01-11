//
//  ViewController.m
//  Drive
//
//  Created by Jonathan Howell 9/12/15.
//  Copyright (c) 2015. Jonathan Howell, MMU. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import  "ViewController.h"
#import  "mySingleton.h"
#import  "TrackStatsViewController.h"
#import  "MyScene.h"
#import  "AnalogControl.h"
#import  "SKTUtils.h"
#include "sys/time.h"

#define kEmail          @"emailAddress"
#define kSubject        @"subjectName"
#define khpx            @"hornPosX"
#define khpy            @"hornPosY"
#define kCarSize        @"carSize"
#define kVersion0       @"version0"
#define kVersion1       @"version1"
#define kVersion2       @"version2"
#define kVersion3       @"version3"
#define kGamePhysics    @"gamePhysics"
#define kHazScale       @"hazScale"
#define kDisplayMinimum @"displayMinimum"


@interface ViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
    Float32 temp5;
    UIImageView *st0;
    UIImageView *st1;
    UIImageView *st2;
    UIImageView *st3;
    UIImageView *fin0;
    UIImageView *fin1;
    BOOL didWin2;
    float ss; //scale factor start lamps
}

@property (nonatomic, strong) SKView              * skView;
@property (nonatomic, strong) AnalogControl       * analogControl;
@property (nonatomic, strong) MyScene             * scene;
@property (retain, nonatomic  ) IBOutlet UIButton * hornBtn;
@property (retain, nonatomic  ) IBOutlet UIButton * pauseBtn;

@end

@implementation ViewController

@synthesize hornBtn, pauseBtn, hornTimer, startLampImageView, startDate;

-(void)awakeFromNib{
    [super awakeFromNib];

    //load the start lamp images for display
    st0  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"st4.png"]];
    st1  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"st1.png"]];
    st2  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"st2.png"]];
    st3  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"st3.png"]];
    fin0 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"finish.png"]];
    fin1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notfinish.png"]];
}

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
    NSString * hpx; // horn graphic location on screen
    NSString * hpy;
    NSString * carSize;
    NSString * hazScale;
    NSString * displayMinimum;
    NSString * gamePhysics;
    
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
    
    version0 =  @"DRIVE Version 4.0.6 - 11.1.17";     // version   *** keep short
    version1 =  @"MMU (C) 2017";                // copyright *** limited line space
    version2 =  @"j.a.howell@mmu.ac.uk";        // author    *** to display on device
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
    if([subjectName isEqualToString: @ "" ] || subjectName == nil){
        subjectName =  @"Me";
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.subjectName] forKey:kSubject];
    }
    //email name
    email     = [defaults objectForKey:kEmail];
    if([email isEqualToString: @ "" ] || email == nil){
        email =  @"Me@mmu.ac.uk";
        [defaults setObject:[NSString stringWithFormat:@"%@", singleton.email] forKey:kEmail];
    }
    
    //position of horn
    hpx     = [defaults objectForKey:khpx];
    if([hpx isEqualToString: @ "" ] || khpx == nil){
        hpx =  @"305";
        [defaults setObject:[NSString stringWithFormat:@"%f", singleton.hornPosX] forKey:khpx];
    }
    hpy     = [defaults objectForKey:khpy];
    if([hpy isEqualToString: @ "" ] || khpy == nil){
        hpy =  @"85";
        [defaults setObject:[NSString stringWithFormat:@"%f", singleton.hornPosY] forKey:khpy];
    }
    
    //display info level 0=none, 1=some, 2=all
    displayMinimum     = [defaults objectForKey:kDisplayMinimum];
    if([displayMinimum isEqualToString: @ "" ] || kDisplayMinimum == nil){
        displayMinimum =  @"1";
        [defaults setObject:[NSString stringWithFormat:@"%d", singleton.displayMinimum] forKey:kDisplayMinimum];
    }
    
    //bounds check of display is in range 0 - 2
    if ([displayMinimum integerValue] <0) {
        displayMinimum=@"0";
        [defaults setObject:[NSString stringWithFormat:@"%d", 0] forKey:kDisplayMinimum];
    }
    if ([displayMinimum integerValue] >2) {
        displayMinimum=@"2";
        [defaults setObject:[NSString stringWithFormat:@"%d", 2] forKey:kDisplayMinimum];
    }
    
    //game physics level 0=none, 1=weak all, 2=med all, 3=high all, 4=mixed
    gamePhysics     = [defaults objectForKey:kGamePhysics];
    if([gamePhysics isEqualToString: @ "" ] || kGamePhysics == nil){
        gamePhysics = @"0";
        [defaults setObject:[NSString stringWithFormat:@"%d", singleton.gamePhysics] forKey:kGamePhysics];
    }
    
    //bounds check physics is in range 0 - 5
    if ([gamePhysics integerValue] <0) {
        gamePhysics = @"0";
        [defaults setObject:[NSString stringWithFormat:@"%d", 0] forKey:kGamePhysics];
    }
    if ([gamePhysics integerValue] >5) {
        gamePhysics = @"5";
        [defaults setObject:[NSString stringWithFormat:@"%d", 5] forKey:kGamePhysics];
    }
    
    // hazards scale size
    //
    hazScale    = [defaults objectForKey:kHazScale];
    if([hazScale isEqualToString: @ "" ] || kHazScale == nil){
        hazScale = @"0.00";
        [defaults setObject:[NSString stringWithFormat:@"%f", singleton.hazScale] forKey:kHazScale];
    }
    
    //bounds check physics is in range 0 - 5
    if ([hazScale floatValue] <0.25) {
        hazScale = @"0.25";
        [defaults setObject:[NSString stringWithFormat:@"%.2f", 0.25] forKey:kHazScale];
    }
    if ([hazScale floatValue] >1.0) {
        hazScale = @"1.00";
        [defaults setObject:[NSString stringWithFormat:@"%.2f", 1.0] forKey:kHazScale];
    }
    
    //car size
    carSize     = [defaults objectForKey:kCarSize];
    if([carSize isEqualToString: @ "" ] || kCarSize == nil){
        carSize = @"0.50";
        [defaults setObject:[NSString stringWithFormat:@"%f", singleton.carSize] forKey:kCarSize];
    }
    
    //bounds check x,y of horn button is in range
    if ([hpx integerValue] <0) {
        hpx=@"0";
        [defaults setObject:[NSString stringWithFormat:@"%d", 0] forKey:khpx];
    }
    if ([hpx integerValue] >500) {
        hpx=@"500";
        [defaults setObject:[NSString stringWithFormat:@"%d", 500] forKey:khpx];
    }
    if ([hpy integerValue] <0) {
        hpy=@"0";
        [defaults setObject:[NSString stringWithFormat:@"%d", 0] forKey:khpy];
    }
    if ([hpy integerValue] >300) {
        hpy=@"300";
        [defaults setObject:[NSString stringWithFormat:@"%d", 300] forKey:khpy];
    }
    if ([carSize floatValue] <0.25) {
        carSize=@"0.25";
        [defaults setObject:[NSString stringWithFormat:@"0.25"] forKey:kCarSize];
    }
    if ([carSize floatValue] >1.00) {
        carSize=@"1.00";
        [defaults setObject:[NSString stringWithFormat:@"1.00"] forKey:kCarSize];
    }
    
    singleton.subjectName       = subjectName;
    singleton.email             = email;
    singleton.hornPosX          = [hpx integerValue];
    singleton.hornPosY          = [hpy integerValue];
    singleton.carSize           = [carSize floatValue];         //default 0.50
    singleton.hazScale          = [hazScale floatValue];        //default 0.60
    singleton.displayMinimum    = [displayMinimum doubleValue]; //default 1
    singleton.gamePhysics       = [gamePhysics doubleValue];    //default 0
    
    [defaults synchronize];//make sure all are updated
    
    //versionNumberLab.text   = version0;
    singleton.versionNumber = version0;
    hornBtn.hidden = YES;
    hornBtn.alpha  = 0.4;
    pauseBtn.alpha = 0.5;
    hornBtn.frame  = CGRectMake([hpx integerValue], [hpy integerValue], 44, 44);
    
    if ([singleton.distractionOn isEqual:@"0"]) {
        hornBtn.hidden = YES;
    }else{
        hornBtn.hidden = NO;
    }
    ss = 1.00;
    startLampImageView.alpha=0.6;
    [startLampImageView setImage: st0.image];
    startLampImageView.hidden = NO;
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(0.2f) target:self selector:@selector(startLamp0) userInfo:nil repeats:NO];
}

-(void)startLamp0 {
    startLampImageView.alpha=0.6;
    [startLampImageView setImage: st0.image];
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(1.0f) target:self selector:@selector(startLamp1) userInfo:nil repeats:NO];
}

-(void)startLamp1 {
    startLampImageView.alpha=0.6;
    [startLampImageView setImage: st1.image];
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(1.0f) target:self selector:@selector(startLamp2) userInfo:nil repeats:NO];
}

-(void)startLamp2 {
    startLampImageView.alpha=0.8;
    [startLampImageView setImage: st2.image];
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(1.0f) target:self selector:@selector(startLamp3) userInfo:nil repeats:NO];
}
-(void)startLamp3 {
    startLampImageView.alpha=0.9;
    [startLampImageView setImage: st3.image];
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(1.0f) target:self selector:@selector(startLampGO) userInfo:nil repeats:NO];
}

-(void)startLampGO {
    startLampImageView.alpha=1.0;
    [startLampImageView setImage: st0.image];
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    //start the timer
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(1.0f) target:self selector:@selector(startGame) userInfo:nil repeats:NO];
}

-(void)finishLine0 {
    //display chequered flag finish line image
    [self.view sendSubviewToBack:self.analogControl];
    [_finishLampImageView setImage: fin0.image];
    _finishLampImageView.alpha=0.0;
    _finishLampImageView.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:(0.2f) target:self selector:@selector(animateMessageViewIN) userInfo:nil repeats:NO];
}

-(void)finishLine1 {
    //display black flag finish line image
    [self.view sendSubviewToBack:self.analogControl];
    [_finishLampImageView setImage: fin1.image];
    _finishLampImageView.alpha  = 0.0;
    _finishLampImageView.hidden = YES;
    //[NSTimer scheduledTimerWithTimeInterval:(3.0f) target:self selector:@selector(p_gameOverWithWin2) userInfo:nil repeats:NO]; //straight to end no image
    [NSTimer scheduledTimerWithTimeInterval:(0.2f) target:self selector:@selector(animateMessageViewIN) userInfo:nil repeats:NO]; // finish image appropriate to win or fail
}

-(void)animateMessageViewIN{
    //ease in image of finish flag
    _finishLampImageView.alpha  = 0.0;
    _finishLampImageView.hidden = NO;
    [[_finishLampImageView superview] bringSubviewToFront:_finishLampImageView];
    
    //[UIView animateKeyframesWithDuration:1 delay:1 options:1 animations:^(){_finishLampImageView.alpha = 1.0;} completion:nil];
    [UIView animateWithDuration:1.2
                          delay:0  /* do not add a delay because we will use performSelector. */
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         _finishLampImageView.alpha = 1.0; //fade in
                     }
                     completion:^(BOOL finished) {[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animateMessageViewOUT) userInfo:nil repeats:NO];
                     }];
}

-(void)animateMessageViewOUT{
    //ease out image of finish flag
    _finishLampImageView.hidden = NO;
    [[_finishLampImageView superview] bringSubviewToFront:_finishLampImageView];
    
    [UIView animateWithDuration:1.0
                          delay:1.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         /*if (isCalculating) { //do not fade out, keep display on
                          MessageView.alpha = 1.0;
                          }else{
                          MessageView.alpha = 0.0;
                          }*/
                         _finishLampImageView.alpha = 0.0; //fade out
                     }
                     completion:^(BOOL finished) {
                     }];
    //nothing else to do, the image was shown
        [NSTimer scheduledTimerWithTimeInterval:(0.0f) target:self selector:@selector(carryon) userInfo:nil repeats:NO];
}

-(void)carryon{
        [NSTimer scheduledTimerWithTimeInterval:(3.0f) target:self selector:@selector(p_gameOverWithWin2) userInfo:nil repeats:NO];
}

-(void)startGame {
    startLampImageView.hidden=YES;
}

- (void)setDateNow:(id)sender{
    // for date format
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    singleton.testDate=dateString;
}

- (void)setTimeNow:(id)sender{
    // for time format
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString = [dateFormatter stringFromDate: currentTime];
    singleton.testTime=timeString;
}

- (void)registerDefaultsFromSettingsBundle {
    // read the iPad/iPhone settings from file
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        //NSLog(@"Could not find Settings.bundle");
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
    mySingleton *singleton = [mySingleton sharedSingleton];
    if ([singleton.distractionOn isEqual:@"0"]) {
        hornBtn.hidden = YES;
    }else{
        hornBtn.hidden = NO;
    }
    ss = 1.00;
    startLampImageView.alpha=0.6;
    [startLampImageView setImage: st0.image];
    startLampImageView.hidden = NO;
    startLampImageView.frame = CGRectMake(127, 181, 240*ss, 125*ss);
    
    self.startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:(0.2f) target:self selector:@selector(startLamp0) userInfo:nil repeats:NO];
    [self.view sendSubviewToBack:self.skView];
}

#pragma mark - Lay out the screens 

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //stop App if cancelled
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    _carType = [singleton.carNo integerValue];       //carType;
    _levelType = [singleton.trackNo integerValue];   //levelType;
    
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
        //for horn button showing
        self.scene.hornBlock = ^(BOOL showHornNow) {
            [weakSelf showHorn: showHornNow];
        };
    }

    //only show fps when in debug mode
#ifdef DEBUG
    self.skView.showsFPS       = YES;
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
    //hornBtn.hidden=YES;
    hornBtn.alpha=0.4;
    [self p_showInGameMenu];
}

- (IBAction)hornButtonDidTouchUpInside:(id)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    //the horn button was pressed
    
    //get clock time now and save to singleton
    struct timeval time;
    gettimeofday(&time, NULL);
    Float32 millis = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    
    singleton.hornsShowing = YES;
    singleton.hornsMulti   = millis;
    //NSLog(@"STOP Horn horntouch =  %.f",  millis);
    hornBtn.alpha=0.3;
}

- (void)showHorn:(BOOL)showHornNow {
    //show the horn message was received from myScene viewController
    if (showHornNow) {
        //no fade, active
        hornBtn.alpha=1.0;
    }else{
        //faded as not active
        hornBtn.alpha=0.4;
    }
}

#pragma mark - Game Over

- (void)p_gameOverWithWin:(BOOL)didWin {
    _finishLampImageView.hidden=NO;
    didWin2=didWin;
    if (didWin2) {
        //stats and times, completed
        [NSTimer scheduledTimerWithTimeInterval:(0.0f) target:self selector:@selector(finishLine0) userInfo:nil repeats:NO];
    }else{
        //you did not finish or cancelled, just start again... consider part stats, ie no email
        [NSTimer scheduledTimerWithTimeInterval:(0.0f) target:self selector:@selector(finishLine1) userInfo:nil repeats:NO];
    }
}

- (void)p_gameOverWithWin2 {
    [self.view bringSubviewToFront:self.analogControl];
    startLampImageView.hidden   = YES;
    _finishLampImageView.hidden = YES;
    
    mySingleton *singleton = [mySingleton sharedSingleton];
    NSString *completedMessage  = [NSString stringWithFormat:@"You Have Completed %@ Laps.\n\nRace Results Will Follow...", singleton.laps];
    NSString *notFinishMessage  = @"You Did Not Finish !\n\nYou Will Have to Start Again.";
    NSString *bodyMessage       = @"... This Race is Now Over ...\n\n";
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:didWin2 ? completedMessage : notFinishMessage //selects the choice didwin BOOL
                               message:bodyMessage
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:nil]; //nil];
    [alert show]; // show the alert then...
    if (didWin2) {
        //stats and times, completed
        [self performSelector:@selector(p_goBackStats:) withObject:alert afterDelay:3.0];
            }else{
        //you did not finish or cancelled, just start again... consider part stats, ie no email
        [self performSelector:@selector(p_goBack:)      withObject:alert afterDelay:3.0];
    }
}

#pragma mark - Stats Display Screen

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

#pragma mark - Game Menu

- (void)p_showInGameMenu {
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"MMU ESS Drive App Menu"
                               message:@"You have Stopped the Race.... \n\nWhat would you like to do?"
                              delegate:self
                     cancelButtonTitle:@"Resume, but... Results will be invalid"
                     otherButtonTitles:@"Start A New Race or Quit", nil];
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
