//
//  UserProfileViewController.h
//  jcadrg.BloQuery
//
//  Created by Mac on 9/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <ParseUI/ParseUI.h>

@interface UserProfileViewController : UIViewController

@property User *user;

-(id)initWithUser:(User *)user;

@end
