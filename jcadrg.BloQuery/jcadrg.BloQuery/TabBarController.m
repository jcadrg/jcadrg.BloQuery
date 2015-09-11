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

@interface TabBarController()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>



@end

@implementation TabBarController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutOccurred) name:@"Logout" object:nil];
}



-(void) viewDidAppear:(BOOL)animated{
    
    if (![User currentUser]) {
        
        PFLogInViewController *loginVC = [[PFLogInViewController alloc] init];
        [loginVC setDelegate:self];
        
        PFSignUpViewController *signupVC = [[PFSignUpViewController alloc] init];
        [signupVC setDelegate:self];
        
        [loginVC setSignUpController:signupVC];
        [self presentViewController:loginVC animated:YES completion:nil];
        
        
    }else{
        
        [[DataSource sharedInstance] retrieveParseConfig];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:self];
        
        QueryTableViewController *queryTableVC = [[QueryTableViewController alloc] init];
        UINavigationController *feedNavigationController = [[UINavigationController alloc] init];
        [feedNavigationController setViewControllers:@[queryTableVC] animated:YES];
        
        UserProfileViewController *profileViewController = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
        //[profileViewController setTitle:@"Profile"];
        UINavigationController *profileNavigationController = [[UINavigationController alloc] init];
        [profileNavigationController setViewControllers:@[profileViewController] animated:YES];
        
        self.viewControllers = [NSArray arrayWithObjects:feedNavigationController, profileViewController ,nil];
        
        [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Image Feed", @"Image Feed")];
        [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"User Profile", @"User Profile")];
        
        
    }
}

-(void) didReceiveMemoryWarning{
    [self didReceiveMemoryWarning];
}

#pragma mark  - PFSignUpViewController delegate

-(BOOL) signUpViewController:(PFSignUpViewController * __nonnull)signUpController shouldBeginSignUp:(NSDictionary * __nonnull)info{
    
    BOOL fieldsFilled = YES;
    
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            fieldsFilled = NO;
            break;
        }
    }
    
    if (!fieldsFilled) {
        [[[UIAlertView alloc] initWithTitle:@"Field Missing" message:@"Make sure to fill all required fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return fieldsFilled;
    
}

-(void) signUpViewController:(PFSignUpViewController * __nonnull)signUpController didSignUpUser:(PFUser * __nonnull)user{
    [self setSelectedIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) signUpViewController:(PFSignUpViewController * __nonnull)signUpController didFailToSignUpWithError:(nullable NSError *)error{
    NSLog(@"Signup failed: %@", error);
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController * __nonnull)signUpController{
    NSLog(@"Signup dismissed");
}

#pragma mark - PFLoginViewController delegate

-(BOOL) logInViewController:(PFLogInViewController * __nonnull)logInController shouldBeginLogInWithUsername:(NSString * __nonnull)username password:(NSString * __nonnull)password{
    if (username && password && username.length !=0 && password.length !=0) {
        return YES;
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Field missing" message:@"Make sure to fill all required fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        return NO;
    }
    
}

-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
    [self setSelectedIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didFailToLogInWithError:(nullable NSError *)error{
    [[[UIAlertView alloc]initWithTitle:@"Login failed" message:@"User and password don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Logout event

-(void) logOutOccurred{
    [User logOutInBackgroundWithBlock:^(NSError *error){
        [self viewDidAppear:YES];
    }];
}

@end
