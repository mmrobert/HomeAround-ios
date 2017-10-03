//
//  CreatePostalViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CreatePostalViewController.h"
#import "AppConstants.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CountryListTableViewController.h"

@interface CreatePostalViewController ()

@property CGFloat originalTopDistance;

@end

@implementation CreatePostalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   CGFloat tempW = self.laterOutlet.frame.size.width;
 //   self.laterOutlet.layer.cornerRadius = tempW / 2;
    
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.containerView2.layer.borderWidth = 1;
    self.containerView2.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.postalCodeTxt.delegate = self;
    
    NSString *roleStr = [[NSUserDefaults standardUserDefaults] objectForKey:myRole];
    if ([roleStr isEqualToString:@"customer"]) {
        self.descriptionL1.text = @"We use your postal code to match the best services nearby.";
    } else {
        self.descriptionL1.text = @"We use your postal code to match the jobs nearby.";
    }
    
    self.originalTopDistance = self.topDistance.constant;
    
    UITapGestureRecognizer *chooseCy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseIt:)];
    [self.containerView2 addGestureRecognizer:chooseCy];
    self.containerView2.userInteractionEnabled = YES;
}

- (void)chooseIt:(UITapGestureRecognizer *)tapGestureRecognizer {
    //  NSLog(@"12345TT- 99 --");
    CountryListTableViewController *controller = (CountryListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CountryListSB"];
    /*
     NSString *tagStr = [NSString stringWithFormat:@"%ld", (long)tapGestureRecognizer.view.tag];
     //    NSLog(@"uuuuuuuuTTT---%@", tagStr);
     controller.viewTag = tagStr;
     */
    controller.chosedCountry = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
    if ([self respondsToSelector:@selector(showViewController:sender:)]) {
        [self showViewController:controller sender:self];
    } else {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *tempCountry = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
    if (tempCountry == nil || [tempCountry isStringEmpty]) {
        UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
        self.countryL.textColor = aa;
        self.countryL.text = @"Choose your country";
    } else {
        self.countryL.textColor = [UIColor blackColor];
        self.countryL.text = tempCountry;
    }
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.postalCodeTxt) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // workaround for jumping text bug
    [textField resignFirstResponder];
    [textField layoutIfNeeded];
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
    
    // [self.tableView layoutIfNeeded];
    self.topDistance.constant = 10;
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
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
    self.topDistance.constant = self.originalTopDistance;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [self.view endEditing:YES];
}

- (IBAction)saveAct:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.postalCodeTxt.text isStringEmpty] || self.postalCodeTxt.text == nil) {
        NSString *alertMsg = @"Enter your postal code to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else if ([self.countryL.text isStringEmpty] || self.countryL.text == nil) {
        NSString *alertMsg = @"Choose your country to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        if ([self.countryL.text isEqualToString:@"Canada"]) {
            NSString *tempPost = self.postalCodeTxt.text;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            if (trimmed.length > 3 && trimmed.length < 7) {
                NSString *s1 = [trimmed substringToIndex:3];
                NSString *s2 = [trimmed substringFromIndex:3];
                self.postalCodeTxt.text = [NSString stringWithFormat:@"%@ %@", s1, s2];
      //          NSLog(@"999fffiii--here--999 %@", self.postalCodeTxt.text);
            } else {
                self.postalCodeTxt.text = trimmed;
            }
            
            NSString *postRegex = @"^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postalCodeTxt.text];
            if (!testResult) {
                NSString *alertMsg = @"Not right postal code format.";
                NSString *okTitle = @"OK";
                [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
            } else {
             //  NSLog(@"965--here--569, OK Canada");
                [self connectingServer];
            }
        } else if ([self.countryL.text isEqualToString:@"United States"]) {
            NSString *tempPost = self.postalCodeTxt.text;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            self.postalCodeTxt.text = trimmed;
            
            NSString *postRegex = @"^[0-9]{5}(-[0-9]{4})?$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postalCodeTxt.text];
            if (!testResult) {
                NSString *alertMsg = @"Not right postal code format.";
                NSString *okTitle = @"OK";
                [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
            } else {
             //   NSLog(@"965--here--569, OK states");
                [self connectingServer];
            }
        }
        //  NSLog(@"999--test here--999");
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Saving postal code...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"setpostcode"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:[self.postalCodeTxt.text uppercaseString], @"postcode", self.countryL.text, @"country", uToken, @"token", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSString *postcodeStr = [self.postalCodeTxt.text uppercaseString];
                    [[NSUserDefaults standardUserDefaults] setObject:postcodeStr forKey:myPostalCode];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"PostCodeToNext" sender:self];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *alertMsg = msg;
                    NSString *okTitle = @"OK";
                    [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                }
                
            }
        }
    }];
}

#pragma alert presentation

- (void)presentaAlert:(NSString *)aTitle withMsg:(NSString *)aMsg withConfirmTitle:(NSString *)aConfirmTitle {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:aTitle
                                message:aMsg
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:aConfirmTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
