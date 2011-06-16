//
//  ProgrammeSiteViewController.h
//  WeWatch
//
//  Created by Tim Duckett on 16/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ProgrammeSiteViewController : UIViewController {
    
    IBOutlet UIWebView *programmeSite;
    NSString *programmeSiteURL;
    
}

@property (nonatomic, retain) NSString *programmeSiteURL;

@end
