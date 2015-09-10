//
//  CameraViewController.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>

- (void)cameraViewController:(CameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image;

@end


@interface CameraViewController : UIViewController

@property (nonatomic, weak) NSObject <CameraViewControllerDelegate> *delegate;

@end
