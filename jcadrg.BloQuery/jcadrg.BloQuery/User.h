//
//  User.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser <PFSubclassing>

//@property (nonatomic, strong) NSString *test;
@property (nonatomic,strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *description;


@end
