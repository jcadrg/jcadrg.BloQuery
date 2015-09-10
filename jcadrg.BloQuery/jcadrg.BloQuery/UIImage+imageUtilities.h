//
//  UIImage+imageUtilities.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (imageUtilities)

- (UIImage *)imageWithFixedOrientation;
- (UIImage *)imageResizedToMatchAspectRatioOfSize:(CGSize)size;
- (UIImage *)imageCroppedToRect:(CGRect)cropRect;
- (UIImage *)imageByScalingToSize:(CGSize)size andCroppingWithRect:(CGRect)rect;

@end
