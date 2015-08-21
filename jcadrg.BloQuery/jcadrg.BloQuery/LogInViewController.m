//
//  LogInViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/20/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"BloQuery";
    
    [self.logInView setLogo:self.titleLabel];
}

-(void) viewDidLayoutSubviews{
    self.titleLabel.frame = CGRectMake(((self.view.frame.size.width - (self.view.frame.size.width - 70)) / 2),
                                       CGRectGetMinY(self.logInView.usernameField.frame) - 70,
                                       self.view.frame.size.width - 70, 50);
    
    self.logInView.logInButton.frame = CGRectMake(((self.view.frame.size.width - (self.view.frame.size.width - 70)) / 2),
                                                  CGRectGetMaxY(self.logInView.passwordField.frame) + 20,
                                                  self.view.frame.size.width - 70, 50);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
