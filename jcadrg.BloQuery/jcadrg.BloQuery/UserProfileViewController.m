//
//  UserProfileViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 9/3/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "UserProfileViewController.h"
#import "User.h"

@interface  UserProfileViewController()

@property BOOL *loggedIn;
@property (nonatomic, strong) PFImageView *userProfileImageView;
@property (nonatomic, strong) UILabel *userProfileDescription;

@end


@implementation UserProfileViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userProfileImageView = [[PFImageView alloc] init];
    self.userProfileImageView.image =[UIImage imageNamed:@"11.png"];
    self.userProfileImageView.file = (PFFile *)self.user.profileImage;
    [self.userProfileImageView loadInBackground];
    
    self.userProfileDescription = [[UILabel alloc] init];
    self.userProfileDescription.text = self.user.userProfileDescription;
    
    
    for (UIView *view in @[self.userProfileImageView, self.userProfileDescription]) {
        [self.view addSubview:view];
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
    self.userProfileImageView.frame = CGRectMake(0, 40, 400, 500);
    self.userProfileDescription.frame = CGRectMake(0, 540, 400, 20);
    
    
}



@end
