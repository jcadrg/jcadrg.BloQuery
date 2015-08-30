//
//  NewAnswerAlertController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/30/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "NewAnswerAlertController.h"
#import "DataSource.h"

@interface NewAnswerAlertController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextField *answerTextField;
@property (nonatomic, strong) NSString *answerText;

@end

@implementation NewAnswerAlertController




//Same alert looks as the query one
-(id) init{
    self = [super init];
    if (self) {
        self.view.backgroundColor =[UIColor whiteColor];
    }
    
    return  self;
}

-(void) viewDidLoad{
    
    CGRect frame = CGRectMake(0, 0,320 , 100);
    self.answerTextField = [[UITextField alloc] initWithFrame:frame];
    self.answerTextField.userInteractionEnabled = YES;
    self.answerTextField.placeholder = NSLocalizedString([DataSource sharedInstance].configNewAnswer, nil);
    self.answerTextField.backgroundColor = [UIColor whiteColor];
    self.answerTextField.borderStyle = UITextBorderStyleBezel;
    self.answerTextField.autocorrectionType = UITextAutocorrectionTypeYes;
    self.answerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.answerTextField.delegate = self;
    
    [self.contentView addSubview:self.answerTextField];
    [self.contentView bringSubviewToFront:self.answerTextField];
    
    SDCAlertAction *submitAnswerAction = [SDCAlertAction actionWithTitle:NSLocalizedString(@"Post", nil) style:SDCAlertActionStyleDefault handler:^(SDCAlertAction *action){
        
        [self.delegate newAnswerAlertController:self didSubmitAnswer:self.answerTextField.text];
    }];
    
    [self addAction:submitAnswerAction];
    [self addAction:[SDCAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:SDCAlertActionStyleDefault handler:nil]];
    
    
    
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

-(BOOL) textFieldDismiss:(UITextField *)textField{
    
    [self.delegate newAnswerAlertController:self didSubmitAnswer:self.answerTextField.text];
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
    
}




@end
