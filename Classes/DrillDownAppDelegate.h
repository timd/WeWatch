//
//  DrillDownAppDelegate.h
//  DrillDown
//
//  Created by Aral Balkan on 21/07/2010.
//  Copyright Naklab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrillDownAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

@end

