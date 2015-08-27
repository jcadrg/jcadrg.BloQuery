//
//  SingleQueryViewController.m
//  jcadrg.BloQuery
//
//  Created by Mac on 8/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "SingleQueryViewController.h"

@interface SingleQueryViewController ()

@property (nonatomic, strong) UILabel *queryLabel;
@property (nonatomic, strong) UILabel *askerLabel;
@property (nonatomic, strong) UILabel *answerCounter;


@end

@implementation SingleQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // There's no need of using reuse identifiers since i only want one cell here.
    
    if (self) {
        
        self.queryLabel = [[UILabel alloc] init];
        self.queryLabel.numberOfLines = 0;
        self.askerLabel = [[UILabel alloc] init];
        self.askerLabel.numberOfLines =0;
        self.answerCounter = [[UILabel alloc] init];
        self.answerCounter.numberOfLines =0;
        
        self.queryLabel.text = self.singleQuery.query;
        self.askerLabel.text =self.singleQuery.user.username;
        self.answerCounter.text = @"2 answers!";
        
        
        
        for (UIView *view in @[self.queryLabel, self.askerLabel, self.answerCounter]) {
            [self.view addSubview:view];
        }
        
        
        
    }

    
    
    
    
}

-(void) viewWillLayoutSubviews{
    
    CGFloat padding = 10;
    CGFloat queryLabelHeight = 50;
    CGFloat askerLabelHeight = 15;
    CGFloat answerCounterLabelHeight = 15;
    CGFloat navigation = 80;
    
    self.queryLabel.frame = CGRectMake(padding, navigation, CGRectGetWidth(self.view.bounds), queryLabelHeight);
    self.askerLabel.frame = CGRectMake(padding, CGRectGetMaxY(self.queryLabel.frame)+padding, CGRectGetWidth(self.view.bounds), askerLabelHeight);
    self.answerCounter.frame = CGRectMake(padding, CGRectGetMaxY(self.askerLabel.frame)+padding, CGRectGetWidth(self.view.bounds), answerCounterLabelHeight);
    
    self.queryLabel.backgroundColor = [UIColor whiteColor];
    self.askerLabel.backgroundColor = [UIColor whiteColor];
    self.answerCounter.backgroundColor = [UIColor whiteColor];
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
