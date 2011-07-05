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
#import "CommentsTableViewController.h"

@implementation ProgrammeCommentViewController

@synthesize programmeTitle = _programmeTitle;
@synthesize programmeID = _programmeID;
@synthesize commentsArray = _commentsArray;

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
    NSLog(@"ProgrammeCommentVC:viewDidLoad");
    
    // Set up view content
    titleLabel.text = _programmeTitle;
    
    // Check if there's any comments to work with
    if ( [_commentsArray count] != 0 ) {
        
        // There are some comments, so    
        // load in the embedded table view controller
        commentsTableVC = [[CommentsTableViewController alloc] initWithNibName:@"CommentsTableViewController" bundle:nil];    
        
        // Hide the "no comments yet" label
        noCommentLabel.hidden = YES;
        
        
        // Pass over the array of comments
        [commentsTableVC setCommentsArray:_commentsArray];

        // Embed the table view into the view
        [embeddedTableView addSubview:commentsTableVC.view];
        embeddedTableView.backgroundColor = [UIColor clearColor];
        
    } else {
        
        // There aren't any comments, so remove the table view to expose
        // the label, and make the label visible
        
        [embeddedTableView removeFromSuperview];
        noCommentLabel.hidden = NO;
        
    }

    // Register to listen for the updateComments notification
    // Register this class so that it can listen out for didWatchProgramme and didUnwatchProgramme notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveUpdatedComments) 
                                                 name:@"didUpdateComments" 
                                               object:nil];

}

-(void)viewDidAppear:(BOOL)animated {
    //    NSLog(@"ProgrammeCommentVC:viewDidAppear");    
    
    //    NSLog(@"Comments array = %@", _commentsArray);
    
}

-(void)viewWillAppear:(BOOL)animated {
    //    NSLog(@"ProgrammeCommentVC:viewWillAppear");    
    
    //    NSLog(@"Comments array = %@", _commentsArray);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [titleLabel release];
    titleLabel = nil;
    
    [_commentsArray release];
    _commentsArray = nil;
    
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

/*
-(void)fireLoadCommentsJob {
    
    // Check if the network's available
    Reachable *reachable = [[Reachable alloc] init];
    
    if ( [reachable isReachable] ) {
        
        NSLog(@"ProgrammeCommentVC: fireLoadCommentsJob : network reachable");
        NSLog(@"ProgrammeCommentVC: fireLoadCommentsJob : programmeID = %d", _programmeID);
        
        // There is a network, can fire off the queued comment retreival
        loadCommentsOperation = [[LoadCommentsOperation alloc] init];
        [loadCommentsOperation setProgrammeID:_programmeID];
        [loadCommentsOperation setDelegate:self];
        
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
    
    NSLog(@"retrievedComments = %@", retrievedComments);
    
    // Update comment number display
    // get reference to parent controller
    NSLog(@"%@", [self.view superview]);
    
    NSLog(@"comment count = %d", [retrievedComments count]);
}
*/
 
-(void)didUpdateComments {
    NSLog(@"Firing ProgrammeCommentViewController::didUpdateComments");
    [self viewDidAppear:NO];
}

-(void)parseCommentsIntoText{
}

@end
