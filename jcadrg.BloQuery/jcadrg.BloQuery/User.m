//
//  User.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

//@dynamic test;
@dynamic description;
@dynamic profileImageURL;


+(void) load{
    [User registerSubclass];
}


@end
