//
//  SelectDriverViewController.m
//  Drive
//
//  Created by Jon Howell on 17/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//

#import "SelectDriverViewController.h"
#import "SKTAudio.h"
//#import "ViewController.m" //???????
#import "mySingleton.h" // gets it from viewcontroller

#define kEmail      @"emailAddress"
#define kSubject    @"subjectName"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface SelectDriverViewController ()
{
    float keyboardAnimSpeed;
    float keyboardAnimDelay;
}
@end

@implementation SelectDriverViewController

@synthesize driverName, email;

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

-(void)viewDidAppear:(BOOL)animated{
    
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonDidTouchUpInside:(id)sender {
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [[SKTAudio sharedInstance] playSoundEffect:@"button_press.wav"];
    
    //ViewController *gameVC = [self.storyboard
        //instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
 
    //[self.navigationController pushViewController:gameVC animated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//no effrect as this App is being ported to iPhone only, even though displaying on an iPad, compromise value
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
    
    yy=100;///////overide/////////
    
    
if(textField==self->driverName){
    driverName.backgroundColor = [UIColor greenColor];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
    int oft=textField.frame.origin.y-yy;
    [self keyBoardAppeared:oft];
}
if(textField==self->email){
    email.backgroundColor = [UIColor greenColor];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y), textField.frame.size.width, textField.frame.size.height);
    int oft=textField.frame.origin.y-yy;
    [self keyBoardAppeared:oft];
}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //used to clear keyboard if screen touched
    // NSLog(@"Touches began with this event");
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

-(void) keyBoardAppeared :(int)oft
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
}

-(void)textFieldDidEndEditing:(UITextField *) textField {
    
    //move the screen back to the original place
    [self keyBoardDisappeared:0];
    
    driverName.backgroundColor   = [UIColor whiteColor];
    email.backgroundColor        = [UIColor whiteColor];
    //
    driverName.textColor         = [UIColor blackColor];
    email.textColor              = [UIColor blackColor];
}

-(void) keyBoardDisappeared :(int)oft
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

driverName.backgroundColor = [UIColor whiteColor];
email.backgroundColor       = [UIColor whiteColor];


}@end
