//
//  ViewController.m
//  JYSTipCalculator
//
//  Created by John YS on 3/9/15.
//  Copyright (c) 2015 JohnYS. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *billFieldTopConstraint;
@property (strong, nonatomic) NSArray *tipPercentages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *tipPercentages = [defaults objectForKey:@"tipPercentages"];
    
    if (tipPercentages == nil) {
        tipPercentages = @[@"18", @"20", @"22"];
        [defaults setObject:tipPercentages forKey:@"tipPercentages"];
        [defaults synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTipPercentageOptions];
    [self resetViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTipPercentageOptions
{
    self.tipPercentages = [[NSUserDefaults standardUserDefaults] objectForKey:@"tipPercentages"];
    
    [self.tipControl setTitle:[NSString stringWithFormat:@"%%%@", self.tipPercentages[0]]  forSegmentAtIndex:0];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%%%@", self.tipPercentages[1]] forSegmentAtIndex:1];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%%%@", self.tipPercentages[2]] forSegmentAtIndex:2];
}

- (void)resetViews
{
    self.tipLabel.text = [self formattedStringWithDouble:0.f];
    self.totalLabel.text = [self formattedStringWithDouble:0.f];
    self.billField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedBillAmount"];
    
    self.billFieldTopConstraint.constant = 200.f;
    self.detailsView.alpha = 0.f;
    
    [self.billField becomeFirstResponder];
}

- (IBAction)didChangeEditing:(id)sender {

    [self animateDetailsViewIfNeeded];
    
    double tipPercentage = [self.tipPercentages[self.tipControl.selectedSegmentIndex] doubleValue];
    
    double bill = [self.billField.text doubleValue];
    double tip = bill * tipPercentage/100;
    double total = bill + tip;
    
    self.tipLabel.text = [self formattedStringWithDouble:tip];
    self.totalLabel.text = [self formattedStringWithDouble:total];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).lastBillAmount = self.billField.text;
}

- (void)animateDetailsViewIfNeeded {
    if ([self.billField.text length] > 0) {
        if (self.billFieldTopConstraint.constant == 200.f) {
            [self animationViewToConstant:74.f alpha:1.f];
        }
    } else {
        if (self.billFieldTopConstraint.constant == 74.f) {
            [self animationViewToConstant:200.f alpha:0.f];
        }
    }
}

- (void)animationViewToConstant:(CGFloat)constant alpha:(CGFloat)alpha
{
    self.billFieldTopConstraint.constant = constant;
    
    [UIView animateWithDuration:1.0
                          delay:0.f
         usingSpringWithDamping:0.8
          initialSpringVelocity:6.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.detailsView.alpha = alpha;
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

- (IBAction)didTapOnView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (NSString *)formattedStringWithDouble:(double)amount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setDecimalSeparator:@"."];
    [formatter setMaximumFractionDigits:2];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *formattedString = [formatter stringFromNumber:@(amount)];
    
    return formattedString;
}

@end
