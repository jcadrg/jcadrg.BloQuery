//
//  QueryTableViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "QueryTableViewController.h"
#import <Parse/Parse.h>
#import <ParseUI.h>
#import "User.h"
#import "Query.h"
#import "DataSource.h"
#import "QueryTableViewCell.h"
#import "SingleQueryViewController.h"
#import "HexColors.h"
#import "SDCAlertController.h"
#import "QueryAlertController.h"
#import "UserProfileViewController.h"




@interface QueryTableViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, QueryTableViewCellDelegate, QueryAlertControllerDelegate>

@end

@implementation QueryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.tableView registerClass:[QueryTableViewCell class] forCellReuseIdentifier:@"queryCell"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"+", nil) style:UIBarButtonItemStylePlain target:self action:@selector(newQuestionButtonPressed)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillLayoutSubviews{
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    /*if ([self.tableView respondsToSelector:@selector(layoutMargins:)]) {
        self.tableView.layoutMargins =UIEdgeInsetsZero;
    }*/
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

    }else{
        [[DataSource sharedInstance] retrieveParseConfig];
        [[DataSource sharedInstance] retrieveQueryWithCompletionHandler:^(NSError *error){
            [self.tableView reloadData];
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    
    return [DataSource sharedInstance].queryElements.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    QueryTableViewCell *queryCell = [tableView dequeueReusableCellWithIdentifier:@"queryCell" forIndexPath:indexPath];
    
    /*if (cell) {
        UILabel *queryLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
        queryLabel.numberOfLines = 0;
        Query *newQuery = [DataSource sharedInstance].queryElements[indexPath.row];
        queryLabel.text = newQuery.query;
        [cell.contentView addSubview:queryLabel];
    }*/
    
    
    if (queryCell) {
        queryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([queryCell respondsToSelector:@selector(layoutMargins)]) {
            queryCell.layoutMargins = UIEdgeInsetsZero;
        }
        queryCell.delegate =self;
        queryCell.query =[DataSource sharedInstance].queryElements[indexPath.row];
    }
    
    
    
    // Configure the cell...
    
    return queryCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/*-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleQueryViewController *singleQueryVC = [[SingleQueryViewController alloc] initWithQuery:[DataSource sharedInstance].queryElements[indexPath.row]];
    [self.navigationController pushViewController:singleQueryVC animated:YES];
    
}*/


#pragma mark - New question button pressed

-(void) newQuestionButtonPressed{
    QueryAlertController *newQuestion = [QueryAlertController alertControllerWithTitle:NSLocalizedString(@"What is your question?", @"What is your question?") message:NSLocalizedString(@"Type a new question", @"Type a new question") preferredStyle:SDCAlertControllerStyleAlert];
    
    //newQuestion.presentAlertToTableViewController = self;
    
    newQuestion.delegate = self;
    [newQuestion presentWithCompletion:nil];
}

#pragma mark - QueryAlertController delegate

-(void) queryAlertController:(QueryAlertController *) queryAlertController didSubmitQueryText:(NSString *) queryText{
    
    [[DataSource sharedInstance] submitQuery:queryText withCompletionHandler:^(NSError *error){
        [[DataSource sharedInstance] retrieveQueryWithCompletionHandler:^(NSError *error){
            [self.tableView reloadData];
        }];
    }];
}




/*-(void) profileImage{
    if ([User currentUser]) {
        User *user = [User currentUser];
        
        UIImage *image = [UIImage imageNamed:@"11.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        user.profileImage = imageFile;
        
        NSString *profileDescription = @"Hi!! it's me!";
        user.userProfileDescription =profileDescription;
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                NSLog(@"Image creation succesful!");
            }else{
                NSLog(@"Image creation failed!");
            }
        }];
        
    }
}*/

#pragma mark - Cell tap events

-(void) didTapAnswerUserLabel:(QueryTableViewCell *)queryCell{
    UserProfileViewController *profileVC = [[UserProfileViewController alloc] initWithUser:queryCell.query.user];
    [self.navigationController pushViewController:profileVC animated:YES];
}

-(void) didTapQueryLabel:(QueryTableViewCell *)queryCell{
    SingleQueryViewController *singleQueryVC = [[SingleQueryViewController alloc] initWithQuery:queryCell.query];
    [self.navigationController pushViewController:singleQueryVC animated:YES];
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
