//
//  UserProfileViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "UserProfileViewController.h"
#import "User.h"
#import "DataSource.h"
#import <ParseUI/ParseUI.h>

#import "CameraViewController.h"

@interface  UserProfileViewController()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, CameraViewControllerDelegate>

@property BOOL *loggedIn;
@property (nonatomic, strong) IBOutlet PFImageView *userProfileImageView;
@property (nonatomic, strong) UILabel *userProfileDescriptionLabel;
///@property (weak, nonatomic) IBOutlet UILabel *userProfileDescription;

@property UIButton *editProfileImageButton;
@property UIButton *editProfileDescriptionButton;

@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic,strong) UIPopoverController *cameraPopover;

@end


@implementation UserProfileViewController


-(void) viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userProfileImageView = [[PFImageView alloc] init];
    self.userProfileImageView.image = [UIImage imageNamed:@"11.png"];
    self.userProfileImageView.file = (PFFile *) self.user.profileImage;
    [self.userProfileImageView loadInBackground];
    
    self.userProfileDescriptionLabel = [[UILabel alloc] init];
    self.userProfileDescriptionLabel.text = self.user.userProfileDescription;
    
    /*self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutTapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];*/
    
    for (UIView *view in @[self.userProfileImageView, self.userProfileDescriptionLabel]) {
        [self.view addSubview:view];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOccurred) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOccurred) name:@"Logout" object:nil];
    
    if (self.loggedIn) {
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.logoutButton addTarget:self action:@selector(logoutTapPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.editProfileImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editProfileImageButton setTitle:@"Edit Picture" forState:UIControlStateNormal];
        [self.editProfileImageButton addTarget:self action:@selector(editProfileImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.editProfileDescriptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editProfileDescriptionButton setTitle:@"Edit Description" forState:UIControlStateNormal];
        [self.editProfileDescriptionButton addTarget:self action:@selector(editProfileDescriptionButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        for (UIView *view in @[self.logoutButton, self.editProfileImageButton, self.editProfileDescriptionButton]) {
            [self.view addSubview:view];
        }
    }
    

}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(id) initWithUser:(User *)user{
    
    self = [super init];
    if (self) {
        self.user = user;
        if ([User currentUser] == user ) {
            self.loggedIn = YES;
        }
    }
    
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    self.userProfileImageView.frame = CGRectMake(0, 40, 200, 200);
    self.userProfileDescriptionLabel.frame = CGRectMake(0, 540, 400, 20);
    if (self.loggedIn) {
        //self.logoutButton.frame = CGRectMake(0, 530, 320, 50);
        self.editProfileImageButton.frame = CGRectMake(0, 250, 100, 20);
        self.editProfileDescriptionButton.frame = CGRectMake(0, 300, 400, 20);
        self.logoutButton.frame = CGRectMake(0, 560, 320, 50);
    }
    
    
}


-(void) logoutTapPressed: (id) sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:self];
}

#pragma mark - Button tap events

-(void) editProfileImageButtonTap:(id) sender{
    NSLog(@"Editing profile picture");
    
    UIViewController *imageVC;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        CameraViewController *cameraVC = [[CameraViewController alloc] init];
        cameraVC.delegate = self;
        imageVC = cameraVC;
    }
    
    if (imageVC) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self presentViewController:nav animated:YES completion:nil];
        
        }else{
            self.cameraPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
            self.cameraPopover.popoverContentSize = CGSizeMake(320, 560);
            [self.cameraPopover presentPopoverFromRect:CGRectMake(0, 0, 100, 20) inView:self.editProfileImageButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(void) handleImage:(UIImage *) image withNavigationController:(UINavigationController *)nav{
    if (image) {
        NSLog(@"image: %@", image);
        NSLog(@"This is where we upload an image to Parse");
        
    }else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [nav dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.cameraPopover dismissPopoverAnimated:YES];
            self.cameraPopover = nil;
        }
    }
}

-(void) cameraViewController:(CameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image{
    [self handleImage:image withNavigationController:cameraViewController.navigationController];
}

#pragma mark - Popover Handling

-(void) imageDidFinish:(NSNotification *) notification{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else{
        [self.cameraPopover dismissPopoverAnimated:YES];
        self.cameraPopover = nil;
    }
}



-(void) editProfileDescriptionButtonTap:(id) sender{
    NSLog(@"Editing profile description");
}


#pragma mark - Login notification methods

-(void) loginOccurred{
    
}

-(void) logoutOccurred{
    
}


@end
