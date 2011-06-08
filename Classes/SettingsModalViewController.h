//
//  SettingsModalViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 06/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import <RestKit/RestKit.h>
#import "Reachable.h"

// Define Twitter OAuth settings
#define kOAuthConsumerKey @"eQ0gA08Yl4uSrrhny0vew"
#define kOAuthConsumerSecret @"sL2E2nX1RWvHLaCOmLYXkoqgiHl7CxanhCLq2PGDtk"

@interface SettingsModalViewController : UIViewController <SA_OAuthTwitterControllerDelegate> {
    
    IBOutlet UIButton *twitterLoginButton;
    IBOutlet UIImageView *twitterLogo;
    IBOutlet UISwitch *enableTestNotifications;
    IBOutlet UISwitch *enableDebugMode;
    
    // ivar to hold reference to Twitter OAuth engine
    SA_OAuthTwitterEngine *twitterEngine;
    
}

@property (nonatomic, retain) SA_OAuthTwitterEngine *twitterEngine;

-(BOOL)checkTwitterLoginStatus;
-(IBAction)changeTwitterLoginStatus;
-(IBAction)dismissView;

// Set up notification handlers
extern NSString * const didChangeTwitterLoginStatusNotification;

@end
