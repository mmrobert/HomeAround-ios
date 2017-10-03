//
//  NamePostPhoneViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-28.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "NamePostPhoneViewController.h"
#import "AppConstants.h"

@interface NamePostPhoneViewController ()

@end

@implementation NamePostPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.situationCode == 0) {
        self.navigationItem.title = @"Set Name";
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
        if (userName) {
            self.textEnter.text = userName;
        } else {
            self.textEnter.placeholder = @"Enter name";
        }
    } else if (self.situationCode == 1) {
        self.navigationItem.title = @"Set Postal Code";
        NSString *userPost = [[NSUserDefaults standardUserDefaults] objectForKey:myPostalCode];
        if (userPost) {
            self.textEnter.text = userPost;
        } else {
            self.textEnter.placeholder = @"Enter postal code";
        }
    } else {
        self.navigationItem.title = @"Set Phone No";
        NSString *userPhone = [[NSUserDefaults standardUserDefaults] objectForKey:myPhone];
        if (userPhone) {
            self.textEnter.text = userPhone;
        } else {
            self.textEnter.placeholder = @"Enter phone no";
        }
    }
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];

    self.textEnter.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textEnter) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)dismissKeyboard {
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

- (IBAction)saveAct:(id)sender {
    [self.view endEditing:YES];
    
    if (self.situationCode == 0) {
     //   NSLog(@"987654321 -- 12345 -- pp -- %@", self.textEnter.text);
        NSString *key = @"keyStr";
        NSString *newValue = self.textEnter.text;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSetName" object:nil userInfo:dictionary];
    } else if (self.situationCode == 1) {
        NSString *key = @"keyStr";
        NSString *newValue = [self.textEnter.text uppercaseString];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSetPost" object:nil userInfo:dictionary];
    } else {
        NSString *key = @"keyStr";
        NSString *newValue = self.textEnter.text;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:newValue forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSetPhone" object:nil userInfo:dictionary];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAct:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
