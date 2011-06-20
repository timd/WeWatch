//
//  LoadImageDelegate.h
//  WeWatch
//
//  Created by Tim Duckett on 20/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadImageDelegate : NSObject {
    
}

@end



@protocol LoadImageDelegate

@required

-(void)didLoadImage:(UIImage *)retrievedImage;

@end
