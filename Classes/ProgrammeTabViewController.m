//
//  ProgrammeTabViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 30/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeTabViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "Programme.h"

#import "ProgrammeDetailViewController.h"
#import "ProgrammeCommentViewController.h"

@implementation ProgrammeTabViewController

@synthesize displayProgramme = _displayProgramme;
@synthesize twitterEngine = _twitterEngine;

#define kDetailsButton 1010
#define kCommentsButton 1020

#pragma mark -
#pragma mark Custom methods

-(IBAction)swapViews:(id)sender {
    
    if ( [sender tag] == kDetailsButton ) {
        NSLog(@"Firing swapViews for Details button");
        
        // Check if the view controller already exists
        if (!_programmeDetailVC) {
            // Create it if not...
            _programmeDetailVC = [[ProgrammeDetailViewController alloc] init];
        }
        
        // Add the subview so it's visible
        [bodyView addSubview:_programmeDetailVC.view];
        
        // Swap the tab bar image around
        tabBarImage.image = [UIImage imageNamed:@"tabBar-details"];

    } else if ( [sender tag] == kCommentsButton ) {
        NSLog(@"Firing swapViews for Comments button");

        // check if the tab view controller already exists
        if (!_programmeCommentVC) {
            // Create it if it doesn't
            _programmeCommentVC = [[ProgrammeCommentViewController alloc] initWithNibName:@"ProgrammeCommentViewController" bundle:nil];
        }
        
        // Add the subview so it's visible
        [bodyView addSubview:_programmeCommentVC.view];
        
        // Swap the tab bar image around
        tabBarImage.image = [UIImage imageNamed:@"tabBar-comments"];
    
    }
    
}

#pragma mark -
#pragma mark Object methods

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

#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Check if the detail view controller already exists
    if (!_programmeDetailVC) {
        // Create it if not...
        _programmeDetailVC = [[ProgrammeDetailViewController alloc] init];
    }
    
    // Add the subview so it's visible
    [bodyView addSubview:_programmeDetailVC.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [watchButton release];
    watchButton = nil;
    
    [detailButton release];
    detailButton = nil;
    
    [commentButton release];
    commentButton = nil;
    
    [watchButtonLabel release];
    watchButtonLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
