//
//  ExampleTableViewController.m
//  Example
//
//  Created by Simon Støvring on 16/01/12.
//  Copyright (c) 2012 Simon Støvring. All rights reserved.
//

#import "ExampleTableViewController.h"

#define SCROLL_VIEW_ANIMATION_DURATION 0.25

@interface ExampleTableViewController ()
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

/**
 *  Scroll view to text field.
 *  @param textField Text field to scroll to.
 */
- (void)scrollViewToTextField:(id)textField;
@end

@implementation ExampleTableViewController

@synthesize textUsername = _textUsername,
            textPassword = _textPassword,
            textPasswordRepeated = _textPasswordRepeated,
            textFood = _textFood,
            textTVShow = _textTVShow,
            textMovie = _textMovie,
            textBook = _textBook,
            textColor = _textColor,
            textBiography = _textBiography,
            keyboardControls = _keyboardControls;

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UITableViewCell *cell = (UITableViewCell *) ((UIView *) textField).superview.superview;
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/* 
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}

/* Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}

#pragma mark -
#pragma mark Text Field Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

/* Editing began */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:self.textUsername,
                                                                 self.textPassword,
                                                                 self.textPasswordRepeated,
                                                                 self.textFood,
                                                                 self.textTVShow,
                                                                 self.textMovie,
                                                                 self.textBook,
                                                                 self.textColor,
                                                                 self.textBiography, nil];
    
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    [self.keyboardControls reloadTextFields];
}

- (void)viewDidUnload
{
    [self setTextUsername:nil];
    [self setTextPassword:nil];
    [self setTextPasswordRepeated:nil];
    [self setTextFood:nil];
    [self setTextTVShow:nil];
    [self setTextMovie:nil];
    [self setTextBook:nil];
    [self setTextColor:nil];
    [self setTextBiography:nil];
    
    [super viewDidUnload];
}

@end
