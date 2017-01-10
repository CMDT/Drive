//
//  SelectDriverViewController.m
//  Drive
//
//  Created by Jon Howell on 17/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//
//  Updating for ios 10.0.2 and new sound features implementation.
//

#import "SelectDriverViewController.h"
#import "SKTAudio.h"
#import "mySingleton.h" // gets it from viewcontroller

#define kEmail      @"emailAddress"
#define kSubject    @"subjectName"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface SelectDriverViewController () 
{
    float keyboardAnimSpeed;
    float keyboardAnimDelay;
    NSString *track;
}
@end

@implementation SelectDriverViewController

@synthesize carView, driverName, email;

- (void)viewDidLoad {
    
    keyboardAnimDelay=0.5;
    keyboardAnimSpeed=0.3;
    
    [super viewDidLoad];
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    //tester name
    driverName.text = [defaults objectForKey:kSubject];
    //email name
    email.text      = [defaults objectForKey:kEmail];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:1];
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    keyboardAnimDelay=0.5;
    keyboardAnimSpeed=0.3;
    
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [defaults synchronize];
    //tester name
    driverName.text = [defaults objectForKey:kSubject];
    //email name
    email.text      = [defaults objectForKey:kEmail];
    
    email.delegate       = self;
    driverName.delegate  = self;
    
    //clear the graphics for track level selected to start with
    _tyre1.hidden=YES;
    _tyre2.hidden=YES;
    _bale.hidden=YES;
    _crate.hidden=YES;
    carView.alpha=1;
    
    carView.layer.anchorPoint = CGPointMake(.5,.5);
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
     
                     animations:^{
                         
                         CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1, 1);
                         
                         CGAffineTransform rotateTrans1 = CGAffineTransformMakeRotation(270* M_PI / 180);
                         carView.transform = CGAffineTransformConcat(scaleTrans, rotateTrans1);
                     }completion:nil];
    carView.alpha=0.5;

    
    //check the level and bring the graphics back according to level selected
    //NSLog(@"level  %@", singleton.trackNo);
    if([singleton.trackNo isEqual:@"1"]){
        //nothing
    }
    if([singleton.trackNo isEqual:@"2"]){
        _tyre1.hidden=NO;
        _bale.hidden=NO;
    }
    if([singleton.trackNo isEqual:@"3"]){
        _tyre1.hidden=NO;
        _bale.hidden=NO;
        _tyre2.hidden=NO;
        _crate.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
}

- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [self btnPressSound];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startButtonDidTouchUpInside:(UIButton *)sender {
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    singleton.subjectName=driverName.text;
    singleton.email=email.text;
    
    // pass to plist setting bundle the email and driver
    NSString        * pathStr               = [[NSBundle mainBundle] bundlePath];
    NSString        * settingsBundlePath    = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString        * defaultPrefsFile      = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary    * defaultPrefs          = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    NSUserDefaults  * defaults              = [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [defaults setObject:[NSString stringWithFormat:@"%@", singleton.subjectName] forKey:kSubject];
    [defaults setObject:[NSString stringWithFormat:@"%@", singleton.email] forKey:kEmail];
    [defaults synchronize];
    
    [self btnPressSound];
    
    //ViewController *gameVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
 
    //[self.navigationController pushViewController:gameVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
// no effect as this App is being ported to iPhone only, even though displaying on an iPad, compromise value
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
    
int yy;
    
if ( IDIOM == IPAD ) {
    /* do something specifically for iPad. */
    yy=100;
} else {
    /* do something specifically for iPhone or iPod touch. */
    yy=100;
}
    
if((textField == self->driverName)||(textField == self->email)){
    driverName.backgroundColor = [UIColor greenColor];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
    int oft=textField.frame.origin.y-yy;
    [self keyBoardAppeared:oft];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //used to clear keyboard if screen touched
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Show Keyboard and move frame

- (void) keyBoardAppeared :(int)oft
{
    //move screen up or down as needed to avoid text field entry
    CGRect frame = self.view.frame;
    
    //move frame without anim if toggle in settings indicates yes
    
        
        //oft= the y of the text field?  make some code to find it
        [UIView animateWithDuration:keyboardAnimSpeed
                              delay:keyboardAnimDelay
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    //oft= the y of the text field?  make some code to find it
    [UIView animateWithDuration:keyboardAnimSpeed
                          delay:keyboardAnimDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, -oft, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

#pragma mark - Done entry driver

- (void)textFieldDidEndEditing:(UITextField *) textField {
    
    //move the screen back to the original place
    [self keyBoardDisappeared:0];
    
    driverName.backgroundColor   = [UIColor whiteColor];
    email.backgroundColor        = [UIColor whiteColor];
    //
    driverName.textColor         = [UIColor blackColor];
    email.textColor              = [UIColor blackColor];
}

#pragma mark - Hide Keyboard when done

- (void) keyBoardDisappeared :(int)oft
{
    //move the screen back to original position
    CGRect frame = self.view.frame;

    //oft= the y of the text field?  make some code to find it
        [UIView animateWithDuration:keyboardAnimSpeed
                              delay:keyboardAnimDelay
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    [UIView animateWithDuration:keyboardAnimSpeed
                          delay:keyboardAnimDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(frame.origin.x, oft, frame.size.width, frame.size.height);
                         }
                     completion:^(BOOL finished){
                     }];

driverName.backgroundColor = [UIColor whiteColor];
email.backgroundColor      = [UIColor whiteColor];
}

#pragma mark - Set Sound Effect Level

- (void)btnPressSound{
    mySingleton *singleton = [mySingleton sharedSingleton];
    
    int   fxVolumeSetLevel;
    float fxTemp;
    
    //find the sound level to play and play it
    fxTemp = singleton.ambientVolume * 100;
    fxVolumeSetLevel = (int)fxTemp;
    
    //report for dev only
    //NSLog(@"fxVolumeSetLevel= %f: %f :%d", singleton.ambientVolume, fxTemp, fxVolumeSetLevel);
    
    switch (fxVolumeSetLevel) {
        case 0 ... 10:
            //no sound
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press00.wav"];
            break;
        case 11 ... 25:
            //25%
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press25.wav"];
            break;
        case 26 ... 50:
            //50%
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press50.wav"];
            break;
        case 51 ... 75:
            //75%
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press75.wav"];
            break;
        case 76 ... 100:
            //100%
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press100.wav"];
            break;
        default:
            //no sound
            [[SKTAudio sharedInstance] playSoundEffect:@"button_press00.wav"];
            break;
    }
}

@end
