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
#import <QuartzCore/QuartzCore.h>
#import "NavigationController.h"
#import "HexColors.h"
#import "QueryTableViewController.h"

@interface TabBarController()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>



@end

static UIFont *tabBarFont;
static UIColor *tabBarColor;
static UIColor *tabBarSelectedColor;
static UIColor *tabBarBackgroundColor;

@implementation TabBarController

+(void)load{
    tabBarFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
    tabBarColor = [UIColor colorWithHexString:@"#B0C4DE" alpha:1.0];
    tabBarSelectedColor = [UIColor colorWithHexString:@"#B0C4DE" alpha:1.0];
    tabBarBackgroundColor = [UIColor colorWithHexString: @"#EDEDED" alpha: 1.0];
}

-(id) init{
    self = [super init];
    if (self) {
        [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName: tabBarFont, NSForegroundColorAttributeName:tabBarColor,} forState:UIControlStateNormal];
        [UITabBarItem.appearance setTitleTextAttributes:@{NSFontAttributeName: tabBarFont, NSForegroundColorAttributeName: tabBarSelectedColor,} forState:UIControlStateNormal];
        
        [[UITabBar appearance] setTintColor:tabBarSelectedColor];
        [[UITabBar appearance] setBarTintColor:tabBarBackgroundColor];
    }
    
    return self;
}

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
        
        /*QueryTableViewController *queryTableVC = [[QueryTableViewController alloc] init];
        UINavigationController *feedNavigationController = [[UINavigationController alloc] init];
        [feedNavigationController setViewControllers:@[queryTableVC] animated:YES];
        
        UserProfileViewController *profileViewController = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
        //[profileViewController setTitle:@"Profile"];
        UINavigationController *profileNavigationController = [[UINavigationController alloc] init];
        [profileNavigationController setViewControllers:@[profileViewController] animated:YES];
        
        self.viewControllers = [NSArray arrayWithObjects:feedNavigationController, profileViewController ,nil];
        
        [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Image Feed", @"Image Feed")];
        [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"User Profile", @"User Profile")];*/
        if (self.viewControllers.count == 0) {
            QueryTableViewController *queryTableVC = [[QueryTableViewController alloc] init];
            
            //UIImage *feedImage = [UIImage imageNamed:@"overview_pages_3"];
            
            UIImage *selectedFeedImage = [UIImage imageNamed:@"overview_pages_3-1"];
            
            [queryTableVC.tabBarItem setImage:[selectedFeedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [queryTableVC.tabBarItem setSelectedImage:selectedFeedImage];
            NavigationController *feedNavigationController = [[NavigationController alloc]init];
            [feedNavigationController setViewControllers:@[queryTableVC] animated:YES];
            
            UserProfileViewController *profileVC = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
            //UIImage *userProfileImage = [UIImage imageNamed:@"approve"];
            
            UIImage *selectedUserProfileImage =[UIImage imageNamed:@"approve-1"];
            
            [profileVC.tabBarItem setImage:[selectedUserProfileImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [profileVC.tabBarItem setSelectedImage:selectedUserProfileImage];
            NavigationController *userProfileNavigationController = [[NavigationController alloc] init];
            [userProfileNavigationController setViewControllers:@[profileVC] animated:YES];
            
            self.viewControllers = [NSArray arrayWithObjects:feedNavigationController, userProfileNavigationController, nil];
            [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"News Feed", @"News Feed")];
            [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Profile", @"Profile")];
        }
        
        
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
