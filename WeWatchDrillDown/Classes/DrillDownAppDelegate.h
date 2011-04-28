//
//  DrillDownAppDelegate.h
//  DrillDown
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright Charismatic Megafauna Ltd 2011. All rights reserved.
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

