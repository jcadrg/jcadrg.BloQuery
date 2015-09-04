//
//  TabBarController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "TabBarController.h"
#import "UserProfileViewController.h"
#import "User.h"
#import "DataSource.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "HexColors.h"
#import "QueryTableViewController.h"

@implementation TabBarController

-(void) viewDidLoad{
    [super viewDidLoad];
}


-(void) viewDidAppear:(BOOL)animated{
    if ([User currentUser]) {
        [[DataSource sharedInstance] retrieveParseConfig];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:self];
        
        QueryTableViewController *queryTableVC = [[QueryTableViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] init];
        [navigationController setViewControllers:@[queryTableVC] animated:YES];
        
        UserProfileViewController *profileViewController = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
        
        self.viewControllers = [NSArray arrayWithObjects:navigationController, profileViewController ,nil];
    }
}

@end
