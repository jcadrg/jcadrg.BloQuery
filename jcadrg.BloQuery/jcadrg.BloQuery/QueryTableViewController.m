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

@interface QueryTableViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, QueryTableViewCellDelegate>

@end

@implementation QueryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QueryTableViewCell class] forCellReuseIdentifier:@"queryCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        [[DataSource sharedInstance] retrieveQueryWithCompletionHandler:^(NSError *error){
            NSLog(@"Obtaining queries from source");
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
        queryCell.delegate =self;
        queryCell.query =[DataSource sharedInstance].queryElements[indexPath.row];
    }
    
    
    
    // Configure the cell...
    
    return queryCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleQueryViewController *singleQueryVC = [[SingleQueryViewController alloc] init];
    singleQueryVC.singleQuery =[DataSource sharedInstance].queryElements[indexPath.row];
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
