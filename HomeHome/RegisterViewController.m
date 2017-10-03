//
//  RegisterViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-21.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppConstants.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@property CGFloat originalTopDistance;
@property CGFloat originalTopRegisterBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [[UIColor grayColor] CGColor];
  //  self.registerOutlet.layer.cornerRadius = 10;
    
    self.emailImg.image = [self.emailImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    self.passwordImg.image = [self.passwordImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.passwordImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    self.pwConfirmImg.image = [self.pwConfirmImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pwConfirmImg setTintColor:[UIColor colorWithHue:0.7 saturation:0.9 brightness:0.7 alpha:1.0]];
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.emailTxt.delegate = self;
    self.passwordTxt.delegate = self;
    self.pwConfirmTxt.delegate = self;
    
    self.originalTopDistance = self.topDistance.constant;
    self.originalTopRegisterBtn = self.topRegisterBtn.constant;
 //   NSLog(@"Here 55555 -- %@", self.roleStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.emailTxt) || (textField == self.passwordTxt) || (textField == self.pwConfirmTxt)) {
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
    
    //  NSLog(@"key hide %f", [duration doubleValue]);
  //  CGFloat tempH = self.view.frame.size.height - 30 - self.logoImg.frame.size.height - 30 - self.containerView1.frame.size.height - 5 - self.registerOutlet.frame.size.height - 5 - self.containerView2.frame.size.height;
 //   CGFloat tempKH = keyboardBounds.size.height + 60;
    self.topRegisterBtn.constant = 5;
    if (!(self.topDistance.constant < 6)) {
        self.topDistance.constant -= 135;
    }
    // [self.tableView layoutIfNeeded];
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
    self.topRegisterBtn.constant = self.originalTopRegisterBtn;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"regReturnTologin"] || [[segue identifier] isEqualToString:@"toAgreeMent"]) {
        //   UINavigationController *nv = [segue destinationViewController];
        [self.view endEditing:YES];
    }
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.emailTxt.text isStringEmpty] || [self.passwordTxt.text isStringEmpty] || [self.pwConfirmTxt.text isStringEmpty]) {
        NSString *alertMsg = @"Please enter the required fields.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else if (![self.passwordTxt.text isEqualToString:self.pwConfirmTxt.text]) {
        NSString *alertMsg = @"Not right password confirmation.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL testResult = [emailTest evaluateWithObject:self.emailTxt.text];
        if (!testResult) {
            NSString *alertMsg = @"Not right email format.";
            NSString *okTitle = @"OK";
            [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
        } else {
            // net work
            [self connectingServer];
        }
    }
 //   NSLog(@"999--test here--999");
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Registering...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"register"]];
    
    BOOL allowRemote = [[NSUserDefaults standardUserDefaults] boolForKey:myRemoteNoteAllow];
    NSString *dToken;
    if (allowRemote) {
        dToken = [[NSUserDefaults standardUserDefaults] objectForKey:myDeviceToken];
    } else {
        dToken = @"0";
    }
    
    NSString *emailOriginal = self.emailTxt.text;
    NSString *emailLcase = [emailOriginal lowercaseString];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:emailLcase, @"email", self.passwordTxt.text, @"password", self.roleStr, @"role", @"ios", @"platform", dToken, @"devicetoken", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"7654321%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSString *token = [returnedDict objectForKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:myToken];
                    NSString *emailOriginal = self.emailTxt.text;
                    NSString *email = [emailOriginal lowercaseString];
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:myEmail];
                    NSString *password = self.passwordTxt.text;
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:myPassword];
                    [[NSUserDefaults standardUserDefaults] setObject:self.roleStr forKey:myRole];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
              //      [self dismissViewControllerAnimated:YES completion:nil];
                    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavCreateProfile"];
                    [self presentViewController:controller animated:YES completion:nil];
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

#pragma alert presention

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
