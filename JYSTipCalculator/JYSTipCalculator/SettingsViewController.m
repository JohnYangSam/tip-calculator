//
//  SettingsViewController.m
//  JYSTipCalculator
//
//  Created by John YS on 3/9/15.
//  Copyright (c) 2015 JohnYS. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *minField;
@property (weak, nonatomic) IBOutlet UITextField *defaultField;
@property (weak, nonatomic) IBOutlet UITextField *maxField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *leadingConstraints;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tipPercentages = [defaults objectForKey:@"tipPercentages"];
    
    self.minField.text = tipPercentages[0];
    self.defaultField.text = tipPercentages[1];
    self.maxField.text = tipPercentages[2];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    for (NSLayoutConstraint *constraint in self.leadingConstraints) {
        constraint.constant = 0.f;
    }
    
    self.titleLabelTopConstraint.constant = 76.f;
    
    [UIView animateWithDuration:1.0
                          delay:0.f
         usingSpringWithDamping:0.8
          initialSpringVelocity:6.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    for (NSLayoutConstraint *constraint in self.leadingConstraints) {
        constraint.constant = 500.f;
    }
    
    self.titleLabelTopConstraint.constant = 0;
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender {
    NSArray *tipPercentages = @[[self.minField.text length] > 0? self.minField.text : @"0", [self.defaultField.text length] > 0? self.defaultField.text : @"0", [self.maxField.text length] >0? self.maxField.text : @"0"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tipPercentages forKey:@"tipPercentages"];
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didChangeText:(UITextField *)sender {
    if ([sender.text floatValue] > 100.f) {
        sender.text = @"100";
    }
}
- (IBAction)didTapOnView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
