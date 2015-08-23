//
//  ViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"
#import <ParseUI/ParseUI.h>
#import "User.h"
#import <Parse/Parse.h>


@interface ViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![User currentUser]) {
        
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc] init];
        [loginViewController setDelegate:self];
        
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self];
        
        [loginViewController setSignUpController:signUpViewController];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didFailToLogInWithError:(nullable NSError *)error{
    [[[UIAlertView alloc]initWithTitle:@"Login failed" message:@"User and password don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
