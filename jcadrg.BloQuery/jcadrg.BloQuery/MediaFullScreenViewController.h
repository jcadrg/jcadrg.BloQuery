//
//  MediaFullScreenViewController.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/10/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *imageForFullScreen;

- (instancetype)initWithImage:(UIImage *)sourceImage;

- (void)centerScrollView;

- (void)recalculateZoomScale;

@end
