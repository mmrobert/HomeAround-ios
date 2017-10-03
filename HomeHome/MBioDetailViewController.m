//
//  MBioDetailViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-30.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MBioDetailViewController.h"
#import "AppConstants.h"

@interface MBioDetailViewController ()

@property CGFloat originalBottomDistance;

@end

@implementation MBioDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
 //   self.textEnter.delegate = self;
    
    self.originalBottomDistance = self.bottomDistance.constant;
    
    NSString *temp3 = [[NSUserDefaults standardUserDefaults] objectForKey:myBio];
    if (temp3) {
        self.textEnter.text = temp3;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void) keyboardWillShow:(NSNotification *)note {
    //  NSLog(@"key show");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // needs to translate the bounds to account for rotation
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // animation settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    //  NSLog(@"key hide %f", [duration doubleValue]);
    // [self.tableView layoutIfNeeded];
    self.bottomDistance.constant = keyboardBounds.size.height + 10;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    // set table view scroll to bottom
    [UIView commitAnimations];
    
}

- (void) keyboardWillHide:(NSNotification *)note {
    //  NSLog(@"key hide");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set table view height
    // self.heightForTable.constant += keyboardBounds.size.height + 10;
    // [self.tableView layoutIfNeeded];
    self.bottomDistance.constant = self.originalBottomDistance;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAct:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneAct:(id)sender {
    [self.view endEditing:YES];
 //   NSLog(@"987654321 -- 12345 -- pp -- %@", self.textEnter.text);
    NSString *key = @"keyStr";
    NSString *newValue = self.textEnter.text;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSetBio" object:nil userInfo:dictionary];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
