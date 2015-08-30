//
//  QueryAlertController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/28/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "QueryAlertController.h"

#import "DataSource.h"

@interface QueryAlertController()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *queryText;

@end

@implementation QueryAlertController


-(id) init{
    self = [super init];
    if (self) {
        self.view.backgroundColor =[UIColor whiteColor];
    }
    
    return  self;
}

-(void) viewDidLoad{
    
    CGRect frame = CGRectMake(0, 0,320 , 100);
    self.textField = [[UITextField alloc] initWithFrame:frame];
    self.textField.userInteractionEnabled = YES;
    self.textField.placeholder = NSLocalizedString([DataSource sharedInstance].configNewQuestion, nil);
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleBezel;
    self.textField.autocorrectionType = UITextAutocorrectionTypeYes;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
    
    [self.contentView addSubview:self.textField];
    [self.contentView bringSubviewToFront:self.textField];
    
    
    SDCAlertAction *action = [SDCAlertAction actionWithTitle:NSLocalizedString(@"Post", nil) style:SDCAlertActionStyleDefault handler:^(SDCAlertAction *action){
        
        //[self sendQueryTextToDataSource];
        [self.delegate queryAlertController:self didSubmitQueryText:self.textField.text];
    
    }];
    
    [self addAction:action];
    [self addAction:[SDCAlertAction actionWithTitle:@"Cancel" style:SDCAlertActionStyleDefault handler:nil]];
    
    
    
}

-(void) viewDidLayoutSubviews{
    
}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}


-(BOOL) textFieldShouldBeginEditing:(UITextField *) textField{
    return YES;
}


-(BOOL) textFieldShoudEndEditing:(UITextField *) textField{
    return YES;
}


-(BOOL) textFieldDismiss:(UITextField *) textField{
    
    //[self sendQueryTextToDataSource];
    
    [self.delegate queryAlertController:self didSubmitQueryText:self.textField.text];
    
    
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}


/*-(void) sendQueryTextToDataSource{            NO LONGER NEEDED SINCE I'M USING THE DELEGATE METHOD TO SEND THE QUERIES/ANSWERS TO THE DATA SOURCE!
    self.queryText = self.textField.text;
    [[DataSource sharedInstance] submitQuery:self.queryText withCompletionHandler:^(NSError *error){
        [[DataSource sharedInstance] retrieveQueryWithCompletionHandler:^(NSError *error){
            [self.presentAlertToTableViewController.tableView reloadData];
        }];
    }];
    
}*/





@end
