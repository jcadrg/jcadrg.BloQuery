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




@interface  UserProfileViewController()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    
    //[self setTitle:NSLocalizedString(@"Profile", nil)];
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
    self.userProfileImageView.frame = CGRectMake(0, 40, 375, 375);
    self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.userProfileDescriptionLabel.frame = CGRectMake(0, 540, 400, 20);
    if (self.loggedIn) {
        //self.logoutButton.frame = CGRectMake(0, 530, 320, 50);
        self.editProfileImageButton.frame = CGRectMake(200, 80, 100, 20);
        self.editProfileDescriptionButton.frame = CGRectMake(0, 550, 400, 20);
        self.logoutButton.frame = CGRectMake(0, 570, 320, 50);
    }
    
    
}


/*-(void) logoutTapPressed: (id) sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:self];
}*/

#pragma mark - Button tap events

-(void) editProfileImageButtonTap:(id) sender{
    NSLog(@"Editing profile picture");
    
    //UIViewController *imageVC;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *profileImageEditAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take Photo", @"Take Photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self takePhoto];
        }];
        
        UIAlertAction *chooseExistingPhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose existing photo", @"Choose existing photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self chooseExistingPhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSLog(@"Cancel pressed");
        }];
        
        [profileImageEditAlertController addAction:takePhotoAction];
        [profileImageEditAlertController addAction:chooseExistingPhotoAction];
        [profileImageEditAlertController addAction:cancelAction];
        
        [self presentViewController:profileImageEditAlertController animated:YES completion:nil];
        /*CameraViewController *cameraVC = [[CameraViewController alloc] init];
        cameraVC.delegate = self;
        imageVC = cameraVC;
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        ImageLibraryViewController *imageLibraryVC = [[ImageLibraryViewController alloc] init];
        imageLibraryVC.delegate = self;
        imageVC = imageLibraryVC;
    }
    
    if (imageVC) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self presentViewController:nav animated:YES completion:nil];
        
        }else{
            self.cameraPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
            self.cameraPopover.popoverContentSize = CGSizeMake(320, 560);
            //[self.cameraPopover presentPopoverFromRect:CGRectMake(0, 0, 100, 20) inView:self.editProfileImageButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [self.cameraPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}*/

/*-(void) handleImage:(UIImage *) image withNavigationController:(UINavigationController *)nav{
    if (image) {
        NSLog(@"image: %@", image);
        NSLog(@"This is where we upload an image to Parse");
        
        [[DataSource sharedInstance] uploadImage:image ForUser:[User currentUser] WithCompletionHandler:^(NSError *error){
            NSLog(@"Image finished uploading");
            [self.userProfileImageView loadInBackground];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [nav dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.cameraPopover dismissPopoverAnimated:YES];
                self.cameraPopover = nil;
            }
        }];
        
    }else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [nav dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.cameraPopover dismissPopoverAnimated:YES];
            self.cameraPopover = nil;
        }
    }
}*/
    }
}


/*-(void) cameraViewController:(CameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image{
    [self handleImage:image withNavigationController:cameraViewController.navigationController];
}*/

/*-(void) imageLibraryViewController:(ImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image{
    [self handleImage:image withNavigationController:imageLibraryViewController];
}*/

-(void) takePhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(void) chooseExistingPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Popover Handling

/*-(void) imageDidFinish:(NSNotification *) notification{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }else{
        [self.cameraPopover dismissPopoverAnimated:YES];
        self.cameraPopover = nil;
    }
}*/

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    if (selectedImage) {
        [[DataSource sharedInstance] uploadImage:selectedImage ForUser:[User currentUser] WithCompletionHandler:^(NSError *error){
            NSLog(@"Image uploaded, time to refresh view");
            [self.userProfileImageView loadInBackground];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - profile editing methods

-(void) editProfileDescriptionButtonTap:(id) sender{
    NSLog(@"Editing profile description");
}


#pragma mark - Login notification methods

-(void) logoutTapPressed:(id) sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:self];
}

-(void) loginOccurred{
    
}

-(void) logoutOccurred{
    
}


@end
