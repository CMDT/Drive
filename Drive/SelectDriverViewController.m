//
//  SelectDriverViewController.m
//  Drive
//
//  Created by Jon Howell on 17/12/2015.
//  Copyright © 2015 MMU ESS JAH. All rights reserved.
//

#import "SelectDriverViewController.h"
#import "SKTAudio.h"
#import "SelectLevelViewController.h"
#import "ViewController.m"
#import "mySingleton.h"

//#define kEmail      @"emailAddress"
//#define kSubject    @"subjectName"
//mySingleton *singleton = [mySingleton sharedSingleton];

@interface SelectDriverViewController ()

@end

@implementation SelectDriverViewController

@synthesize driverName, email;

- (void)viewDidLoad {
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
    
    ViewController *gameVC = [self.storyboard
                              instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
 
    
    [self.navigationController pushViewController:gameVC animated:YES];
}
@end
