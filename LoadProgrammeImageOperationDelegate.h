//
//  LoadProgrammeImageOperationDelegate.h
//  WeWatch
//
//  Created by Tim Duckett on 09/05/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoadProgrammeImageOperationDelegate

@required

-(void)LoadProgrammeImageOperation:(NSOperation *)theProgrammeImageOperation didLoadProgrammeImage:(UIImage *)retrievedImage;

@end
