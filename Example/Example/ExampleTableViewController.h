//
//  ExampleTableViewController.h
//  Example
//
//  Created by Simon Støvring on 16/01/12.
//  Copyright (c) 2012 Simon Støvring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface ExampleTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textPasswordRepeated;
@property (weak, nonatomic) IBOutlet UITextField *textFood;
@property (weak, nonatomic) IBOutlet UITextField *textTVShow;
@property (weak, nonatomic) IBOutlet UITextField *textMovie;
@property (weak, nonatomic) IBOutlet UITextField *textBook;
@property (weak, nonatomic) IBOutlet UITextField *textColor;
@property (weak, nonatomic) IBOutlet UITextView *textBiography;

@end
