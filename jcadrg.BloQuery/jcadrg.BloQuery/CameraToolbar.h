//
//  CameraToolbar.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/9/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraToolbar;

@protocol CameraToolbarDelegate <NSObject>


-(void) leftButtonPressedOnToolbar:(CameraToolbar *) toolbar;
-(void) cameraButtonPressedOnToolbar:(CameraToolbar *) toolbar;
-(void) rightButtonPressedOnToolbar:(CameraToolbar *) toolbar;

@end

@interface CameraToolbar : UIView

-(instancetype) initWithImageNames:(NSArray *)imageNames;

@property (nonatomic, weak) NSObject <CameraToolbarDelegate> *delegate;

@end
