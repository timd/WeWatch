//
//  ProgrammeCommentViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeCommentViewController.h"
#import "Reachable.h"
#import "LoadCommentsOperation.h"
#import "WeWatchAppDelegate.h"

@implementation ProgrammeCommentViewController

@synthesize programmeTitle = _programmeTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up view content
    titleLabel.text = _programmeTitle;
    
    [self fireLoadCommentsJob];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [titleLabel release];
    titleLabel = nil;
    
    [textScroller release];
    textScroller = nil;
    
    [backgroundImage release];
    backgroundImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Comment retrieval delegate method


-(void)fireLoadCommentsJob {
    
    // Check if the network's available
    Reachable *reachable = [[Reachable alloc] init];
    
    if ( [reachable isReachable] ) {
        
        NSLog(@"ProgrammeCommentVC: fireLoadCommentsJob : network reachable");
        
        // There is a network, can fire off the queued comment retreival
        loadCommentsOperation = [[LoadCommentsOperation alloc] init];
        loadCommentsOperation.delegate = self;
        
        // Send the job off to the queue
        NSOperationQueue *commentsOperationQueue = [(WeWatchAppDelegate *)[[UIApplication sharedApplication] delegate] operationQueue];
        [commentsOperationQueue addOperation:loadCommentsOperation];
        
    } else {
        // There isn't a network, can't get the comments
        NSLog(@"ProgrammeCommentVC: fireLoadCommentsJob : network NOT reachable");
        
    }
    
    // Clean up
    [reachable release];
    
}

-(void)LoadCommentsOperation:(NSOperation *)theProgrammeCommentOperation didLoadComments:(NSArray *)retrievedComments{
    
    NSLog(@"ProgrammeCommentVC: fired didLoadComments method");
    NSLog(@"Array = %@", retrievedComments);
}


@end
