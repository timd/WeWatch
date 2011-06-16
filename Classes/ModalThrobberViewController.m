//
//  ModalThrobberViewController.m
//  WeWatch
//
//  Created by Tim Duckett on 13/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//



#import "ModalThrobberViewController.h"
#import "SVProgressHUD.h"

@implementation ModalThrobberViewController

#pragma mark -
#pragma mark Throbber methods

- (IBAction)showThrobber {
    
}

- (IBAction)showThrobberWithStatus {
    // TODO: implement
}

- (IBAction)dismissThrobber {
        
}

- (IBAction)dismissThrobberWithSuccess{
    // TODO: implement    
}

- (IBAction)dismissThrobberWithError {
    // TODO: implement    
}


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
    
    // Create the subview and load the throbber
   	[SVProgressHUD showInView:self.view status:@"Loading..."];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [SVProgressHUD dismiss];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
