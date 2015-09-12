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




@interface  UserProfileViewController()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property BOOL *loggedIn;
@property (nonatomic, strong) IBOutlet PFImageView *userProfileImageView;
@property (nonatomic, strong) UILabel *userProfileDescriptionLabel;
@property (nonatomic, strong) UITextField *userProfileDescriptionTextField;
///@property (weak, nonatomic) IBOutlet UILabel *userProfileDescription;

@property UIButton *editProfileImageButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@property (nonatomic,strong) UIPopoverController *cameraPopover;

@end


@implementation UserProfileViewController


-(void) viewDidLoad{
    [super viewDidLoad];
    
    //[self setTitle:NSLocalizedString(@"Profile", nil)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userProfileImageView = [[PFImageView alloc] init];
    //self.userProfileImageView.image = [UIImage imageNamed:@"11.png"];
    if (self.userProfileImageView.image == nil) {
        self.userProfileImageView.image = [UIImage imageNamed:@"11.png"];
    }
    
    self.userProfileImageView.file = (PFFile *) self.user.profileImage;
    [self.userProfileImageView loadInBackground];
    
    /*self.userProfileDescriptionLabel = [[UILabel alloc] init];
    self.userProfileDescriptionLabel.text = self.user.userProfileDescription;
    
    
    for (UIView *view in @[self.userProfileImageView, self.userProfileDescriptionLabel]) {
        [self.view addSubview:view];
    }*/
    
    [self.view addSubview:self.userProfileImageView];
    
    
    
    if (self.loggedIn) {
        
        self.userProfileDescriptionTextField = [[UITextField alloc] init];
        self.userProfileDescriptionTextField.text = self.user.userProfileDescription;
        self.userProfileDescriptionTextField.placeholder = @"Enter profile description";
        self.userProfileDescriptionTextField.userInteractionEnabled = YES;
        self.userProfileDescriptionTextField.borderStyle = UITextBorderStyleLine;
        self.userProfileDescriptionTextField.backgroundColor = [UIColor whiteColor];
        self.userProfileDescriptionTextField.autocorrectionType = UITextAutocorrectionTypeYes;
        self.userProfileDescriptionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userProfileDescriptionTextField.delegate = self;
        
        self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.logoutButton addTarget:self action:@selector(logoutTapPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.editProfileImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editProfileImageButton setTitle:@"Edit Picture" forState:UIControlStateNormal];
        [self.editProfileImageButton addTarget:self action:@selector(editProfileImageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        /*self.editProfileDescriptionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editProfileDescriptionButton setTitle:@"Edit Description" forState:UIControlStateNormal];
        [self.editProfileDescriptionButton addTarget:self action:@selector(editProfileDescriptionButtonTap:) forControlEvents:UIControlEventTouchUpInside];*/
        
        for (UIView *view in @[self.userProfileDescriptionTextField, self.logoutButton, self.editProfileImageButton]) {
            [self.view addSubview:view];
        }
    }else{
        self.userProfileDescriptionLabel = [[UILabel alloc] init];
        self.userProfileDescriptionLabel.text = self.user.userProfileDescription;
        
        [self.view addSubview:self.userProfileDescriptionLabel];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOccurred) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOccurred) name:@"Logout" object:nil];
    

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
    self.userProfileImageView.frame = CGRectMake(50, 50, 275, 275);
    self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.loggedIn) {
        //self.logoutButton.frame = CGRectMake(0, 530, 320, 50);
        self.editProfileImageButton.frame = CGRectMake(150, 80, 75, 20);
        
        self.logoutButton.frame = CGRectMake(0, 500, 375, 50);
        self.userProfileDescriptionTextField.frame = CGRectMake(0, 360, 375, 40);
    }else{
        self.userProfileDescriptionLabel.frame = CGRectMake(0, 360, 375, 40);
    }
    
    
}


/*-(void) logoutTapPressed: (id) sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:self];
}*/

#pragma mark - Button tap events

-(void) editProfileImageButtonTap:(id) sender{
    NSLog(@"Editing profile picture");
    
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
        
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        
        UIAlertController *userProfileImageEditAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *chooseExistingPhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose existing photo", @"Choose existing photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self chooseExistingPhoto];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSLog(@"Cancel pressed");
        }];
        
        [userProfileImageEditAlertController addAction:chooseExistingPhotoAction];
        [userProfileImageEditAlertController addAction:cancelAction];
        
        [self presentViewController:userProfileImageEditAlertController animated:YES completion:nil];
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
        
        self.userProfileImageView.image = selectedImage;
        [[DataSource sharedInstance] uploadImage:selectedImage ForUser:[User currentUser] WithCompletionHandler:^(NSError *error){
            
            NSLog(@"Image uploaded, time to refresh view");
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - profile editing methods

/*-(void) editProfileDescriptionButtonTap:(id) sender{
    NSLog(@"Editing profile description");
}*/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.user.userProfileDescription = textField.text;
    [[DataSource sharedInstance] updateUser:[User currentUser] WithCompletionHandler:nil];
    [textField resignFirstResponder];
    return YES;
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
