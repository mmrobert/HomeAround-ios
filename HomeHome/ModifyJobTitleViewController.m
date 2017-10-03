//
//  ModifyJobTitleViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-08-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ModifyJobTitleViewController.h"
#import "NSString+EmptyCheck.h"

@interface ModifyJobTitleViewController ()

@property CGFloat originalBottomDistance;

@end

@implementation ModifyJobTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textEnter.text = self.titleStr;
    
    self.originalBottomDistance = self.bottomDistance.constant;
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)note {
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
    
    self.bottomDistance.constant = keyboardBounds.size.height + 15;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.bottomDistance.constant = self.originalBottomDistance;
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

- (IBAction)saveAct:(id)sender {
    if (self.situationCode == 0) {
        NSString *key = @"keyStr";
        NSString *newValue = self.textEnter.text;
        if ([newValue isStringEmpty] || newValue == nil) {
            newValue = @"";
        }
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTitleC" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.situationCode == 1) {
        NSString *key = @"keyStr";
        NSString *newValue = self.textEnter.text;
        if (newValue == nil || [newValue isStringEmpty]) {
            newValue = @"";
        }
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationTitleModify" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
