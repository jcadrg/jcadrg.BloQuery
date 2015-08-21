//
//  ViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "LogInViewController.h"
#import "SignUpViewController.h"

@interface ViewController ()<PFSignUpViewControllerDelegate,PFLogInViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [PFUser logOut];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(![PFUser currentUser]){
        
        //Customize the login view controller
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        loginVC.delegate = self;
        loginVC.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton | PFSignUpFieldsSignUpButton;
        
        //Customize the sign up view controller
        
        SignUpViewController *signupVC = [[SignUpViewController alloc] init];
        signupVC.delegate = self;
        signupVC.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
        loginVC.signUpController = signupVC;
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - PFSignUpViewControllerDelegate

-(BOOL) signUpViewController:(PFSignUpViewController * __nonnull)signUpController shouldBeginSignUp:(NSDictionary * __nonnull)info{
    BOOL informationComplete = YES;
    
    //loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Field", nil) message:NSLocalizedString(@"Make sure to fill al required fields!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
    
}

//Send the delegate that PFUser is signed up!
-(void) signUpViewController:(PFSignUpViewController * __nonnull)signUpController didSignUpUser:(PFUser * __nonnull)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Sign up failed
-(void) signUpViewController:(PFSignUpViewController * __nonnull)signUpController didFailToSignUpWithError:(nullable NSError *)error{
    NSLog(@"Sign Up Failed : %@", error);
}

-(void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController * __nonnull)signUpController{
    NSLog(@"Sign Up Dismissed");
}

#pragma mark - PFLoginViewControllerDelegate

-(BOOL) logInViewController:(PFLogInViewController * __nonnull)logInController shouldBeginLogInWithUsername:(NSString * __nonnull)username password:(NSString * __nonnull)password{
    
    if (username && password && username.length && password.length) {
        return YES;
    
    }else{
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Field", nil) message:NSLocalizedString(@"Make sure to fill all required fields!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        return NO;
    }

}

-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) logInViewController:(PFLogInViewController * __nonnull)logInController didFailToLogInWithError:(nullable NSError *)error{
    NSLog(@"Login Failed: %@",error);
}

-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController * __nonnull)logInController{
    NSLog(@"Login Dismissed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
