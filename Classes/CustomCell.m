//
//  CustomCell.m
//  WeWatch
//
//  Created by Tim Duckett on 05/07/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize userName;
@synthesize commentText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
		// we need a view to place our labels on.
		UIView *cellContentView = self.contentView;

		self.userName = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
		self.userName.textAlignment = UITextAlignmentLeft; // default
        self.userName.text = @"userName";
		[cellContentView addSubview:self.userName];
		[self.userName release];
        
        self.commentText = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor lightGrayColor] fontSize:10.0 bold:NO];
		self.commentText.textAlignment = UITextAlignmentLeft; // default
        self.commentText.text = @"commentText";
        [cellContentView addSubview:self.commentText];
        [self.commentText release];

	}
    
	return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
	// getting the cell size
    CGRect contentRect = self.contentView.bounds;
    
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
        
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        /*
		 Place the title label.
		 place the label whatever the current X is plus 10 pixels from the left
		 place the label 4 pixels from the top
		 make the label 200 pixels wide
		 make the label 20 pixels high
         */
		frame = CGRectMake(boundsX + 10, 4, 200, 20);
		self.userName.frame = frame;
        
		// place the url label
		frame = CGRectMake(boundsX + 10, 28, 200, 14);
		self.commentText.frame = frame;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
	 Create and configure a label.
	 */
    
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = NO;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
    
	return newLabel;
}


- (void)dealloc
{
    [userName release];
    userName = nil;
    
    [commentText release];
    commentText = nil;
    
    [super dealloc];
}

@end
