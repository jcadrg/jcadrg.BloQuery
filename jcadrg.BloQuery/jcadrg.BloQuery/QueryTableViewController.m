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




@interface QueryTableViewController () <QueryTableViewCellDelegate, QueryAlertControllerDelegate>

@end

@implementation QueryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"News Feed", nil)];
    
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.tableView registerClass:[QueryTableViewCell class] forCellReuseIdentifier:@"queryCell"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"+", nil) style:UIBarButtonItemStylePlain target:self action:@selector(newQuestionButtonPressed)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOccurred) name:@"Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutOccurred) name:@"Logout" object:nil];
    
    
    
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
    
    NSLog(@"Requesting queries!");
    [[DataSource sharedInstance] retrieveQueryWithCompletionHandler:^(NSError *error){
        [self.tableView reloadData];
    }];
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    QueryTableViewCell *queryCell = [tableView dequeueReusableCellWithIdentifier:@"queryCell" forIndexPath:indexPath];
    
    if (queryCell) {
        queryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([queryCell respondsToSelector:@selector(layoutMargins)]) {
            queryCell.layoutMargins = UIEdgeInsetsZero;
        }
        queryCell.delegate =self;
        queryCell.query =[DataSource sharedInstance].queryElements[indexPath.row];
    }
    
    return queryCell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleQueryViewController *singleQueryVC = [[SingleQueryViewController alloc] initWithQuery:[DataSource sharedInstance].queryElements[indexPath.row]];
    [self.navigationController pushViewController:singleQueryVC animated:YES];
 
}


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



#pragma mark - Cell tap events

-(void) didTapAnswerUserLabel:(QueryTableViewCell *)queryCell{
    UserProfileViewController *profileVC = [[UserProfileViewController alloc] initWithUser:queryCell.query.user];
    [self.navigationController pushViewController:profileVC animated:YES];
}

-(void) didTapQueryLabel:(QueryTableViewCell *)queryCell{
    
    SingleQueryViewController *singleQueryVC = [[SingleQueryViewController alloc] initWithQuery:queryCell.query];
    [self.navigationController pushViewController:singleQueryVC animated:YES];
    
    /*[[DataSource sharedInstance] retrieveAnswersForQueries:queryCell.query withCompletionHandler:^(NSError *error){
        QueryAnswersTableViewController *queryAnswersTableVC = [[QueryAnswersTableViewController alloc] initWithQuery:queryCell.query];
        [self.navigationController pushViewController:queryAnswersTableVC animated:YES];
    }];*/
    

}

#pragma mark - logout/login events

-(void) logoutOccurred{
    
    [DataSource sharedInstance].queryElements = nil;
}

-(void) loginOccurred{
    
    
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
