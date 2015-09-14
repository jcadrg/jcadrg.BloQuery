//
//  NavigationController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/12/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "HexColors.h"

static UIFont *navBarFont;
static UIColor *navBarFontColor;
static UIColor *navBarColor;

@implementation NavigationController

+(void)load{
    navBarFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    navBarFontColor = [UIColor colorWithHexString:@"#DDDDDD" alpha:1.0];
    navBarColor = [UIColor colorWithHexString: @"#2D0A4A" alpha: 1.0];
    
}

-(id) init{
    self = [super init];
    if (self) {
        [UINavigationBar.appearance setTitleTextAttributes:@{NSFontAttributeName:navBarFont}];
        self.navigationBar.barTintColor = navBarColor;
        self.navigationBar.tintColor = navBarFontColor;
    }
    
    return self;
}

@end
