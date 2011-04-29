//
//  LoadImagesOperationDelegate.h
//  WeWatch
//
//  Created by Tim Duckett on 28/04/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadImagesOperationDelegate
@required
-(void)loadImagesOperation:(NSOperation *)theImagesOperation didLoadProfileImage:(UIImage *)profileImage andBackgroundImage:(UIImage *)backgroundImage;

@end
