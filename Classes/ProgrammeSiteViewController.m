//
//  ProgrammeSiteViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 16/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ProgrammeSiteViewController.h"

@implementation ProgrammeSiteViewController

@synthesize programmeSiteURL;

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
    
    // Setup the web view to do scaling
    [programmeSite setScalesPageToFit:YES];
    
    // Create a URL and URLRequest from the url passed in
    NSURL *url = [NSURL URLWithString:programmeSiteURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    // Load the page
    [programmeSite loadRequest:urlRequest];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
