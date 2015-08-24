//
//  Query.h
//  jcadrg.BloQuery
//
//  Created by Mac on 8/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Query : PFObject <PFSubclassing>

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSArray *answers;


@end
