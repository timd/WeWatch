//
//  TweetDetailViewController.m
//  DrillDown
//
//  Created by Tim Duckett on 21/07/2010.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "LoadImagesOperation.h"
#import "DrillDownAppDelegate.h"

@interface TweetDetailViewController(Private)
-(UIImage *)loadImageForKeyPath:(NSString *)keyPath;
@end


@implementation TweetDetailViewController

@synthesize loadImagesOperation;
@synthesize tweet;

@synthesize nameLabel;
@synthesize backgroundImageView;
@synthesize descriptionView;
@synthesize followersCount;
@synthesize followingCount;
@synthesize latestTweet;
@synthesize profileImageView;
@synthesize screenName;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tweet:(NSDictionary *)theTweet {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.tweet = theTweet;
		
		NSLog(@"Detail view about to display tweet: %@", theTweet);
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.nameLabel.text = [self.tweet valueForKeyPath:@"user.name"];
	self.screenName.text = [self.tweet valueForKeyPath:@"user.screen_name"];
	self.followersCount.text = [[self.tweet valueForKeyPath:@"user.followers_count"] stringValue];
	self.followingCount.text = [[self.tweet valueForKeyPath:@"user.friends_count"] stringValue];
	
	NSString *description = [self.tweet valueForKeyPath:@"user.description"];
	if ((NSNull *)description == [NSNull null])
	{
		description = @"None.";
	}
	self.descriptionView.text = description;
	
	self.latestTweet.text = [self.tweet objectForKey:@"text"];

	//
	// Load images.
	//
	self.loadImagesOperation = [[LoadImagesOperation alloc] init];
	self.loadImagesOperation.tweet = self.tweet;
	self.loadImagesOperation.delegate = self;
	
	NSOperationQueue *operationQueue = [(DrillDownAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
	[operationQueue addOperation:self.loadImagesOperation];
	
	
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	// Cancel operations.
	[self.loadImagesOperation cancel];
	self.loadImagesOperation.delegate = nil;
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.nameLabel = nil;
    self.backgroundImageView = nil;
    self.descriptionView = nil;
    self.followersCount = nil;
    self.followingCount = nil;
    self.latestTweet = nil;
    self.profileImageView = nil;
    self.screenName = nil;	
}


- (void)dealloc {
	
	[self.loadImagesOperation release];
	
	[nameLabel release];
    nameLabel = nil;
    [backgroundImageView release];
    backgroundImageView = nil;
    [descriptionView release];
    descriptionView = nil;
    [followersCount release];
    followersCount = nil;
    [followingCount release];
    followingCount = nil;
    [latestTweet release];
    latestTweet = nil;
    [profileImageView release];
    profileImageView = nil;
    [screenName release];
    screenName = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark LoadImagesOperationDelegate methods

-(void)loadImagesOperation:(NSOperation *)theImagesOperation didLoadProfileImage:(UIImage *)profileImage andBackgroundImage:(UIImage *)backgroundImage
{
	self.profileImageView.image = profileImage;
	self.backgroundImageView.image = backgroundImage;
}






@end
