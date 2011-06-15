//
//  DrillDownAppDelegate.m
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright Charismatic Megafauna Ltd 2011. All rights reserved.
//

#import "WeWatchAppDelegate.h"
#import "RootViewController.h"

@implementation WeWatchAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize operationQueue;

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize pStoreCoordinator;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // Create RestKit client singleton with the WeWatch URL preloaded
    // client = [RKClient clientWithBaseURL:@"http://wewatch.co.uk"];
    
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	// Create the operation queue
	self.operationQueue = [[NSOperationQueue alloc] init];
    
    // Set up notification handling
    application.applicationIconBadgeNumber = 0;
    
    // Handle launching from a notification
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Received Notification %@",localNotif);
    }
    
    // Set up Core Data stuff
    
    return YES;
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    NSLog(@"Recieved Notification %@",notif);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    NSLog(@"applicationDidEnterBackground fired");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // Clear any notification badges that might have been set
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"applicationDidBecomeActive fired");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    
    NSError *error;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // handle error
        }
    }
}

#pragma mark -
#pragma mark Core Data utility methods
-(NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ( [paths count] > 0 ? [paths objectAtIndex:0] : nil );
    return basePath;
    
}

-(void)setupPersistentStore {
    NSString *docDir = [self applicationDocumentsDirectory];
    NSString *pathToDB = [docDir stringByAppendingPathComponent:@"WeWatch.sqlite"];
    NSURL *urlForPath = [NSURL fileURLWithPath:pathToDB];
    
    NSError *error;
    
    pStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![pStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                         configuration:nil 
                                                   URL:urlForPath 
                                               options:nil 
                                                 error:&error]) {
        //handle error
    }
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

