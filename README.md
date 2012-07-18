Installation
====================

The easiest way to use BSKeyboardControls is to copy the files in `BSKeyboardControls/` into your Xcode project.

1. In Finder, navigate to your `BSKeyboardControls` directory
2. Drag the complete directory into Xcode

Usage
====================

Wherever you want to use BSKeyboardControls import `BSKeyboardControls.h` like this:

`#import "BSKeyboardControls.h"`

Now you will have to set up BSKeyboardControls. This is done in five easy steps:

1. Initialize the keyboard controls
2. Set the delegate of the keyboard controls
3. Add all the text fields to the keyboard controls (Order is important)
4. Add the keyboard controls as the accessory view for all the text fields
5. Set the delegate of all the text fields

Below is an example on how to setup the keyboard controls.

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

	// Set the style of the bar. Default is UIBarStyleBlackTranslucent.
	self.keyboardControls.barStyle = UIBarStyleBlackTranslucent;

	// Set the tint color of the "Previous" and "Next" button. Default is black.
	self.keyboardControls.previousNextTintColor = [UIColor blackColor];

	// Set the tint color of the done button. Default is a color which looks a lot like the original blue color for a "Done" butotn
	self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];

	// Set title for the "Previous" button. Default is "Previous".
	self.keyboardControls.previousTitle = @"Previous";

	// Set title for the "Next button". Default is "Next".
	self.keyboardControls.nextTitle = @"Next";

	// Add the keyboard control as accessory view for all of the text fields
	// Also set the delegate of all the text fields to self
	for (id textField in self.keyboardControls.textFields)
	{
	    if ([textField isKindOfClass:[UITextField class]])
	    {
	        ((UITextField *) textField).inputAccessoryView = self.keyboardControls;
	        ((UITextField *) textField).delegate = self;
	    }
	    else if ([textField isKindOfClass:[UITextView class]])
	    {
	        ((UITextView *) textField).inputAccessoryView = self.keyboardControls;
	        ((UITextView *) textField).delegate = self;
	    }
	}
	
Next you will have to set up the delegation methods. BSKeyboardControls requires three delegates: `BSKeyboardControlsDelegate`, `UITextFieldDelegate` and `UITextViewDelegate`.

First you want to close the keyboard if the user presses the "Done button".

	- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
	{
	    [controls.activeTextField resignFirstResponder];
	}
	
Next you want to focus the previous or the next text field whenever the user presses either the "Previous" or the "Next" button.

	- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
	{
	    [textField becomeFirstResponder];
	}
	
This is all there is for the `BSKeyboardControlsDelegate`. Now you want to set up the `UITextFieldDelegate`. The only method required is `- (void)textFieldDidBeginEditing:`

	- (void)textFieldDidBeginEditing:(UITextField *)textField
	{
	    if ([self.keyboardControls.textFields containsObject:textField])
	        self.keyboardControls.activeTextField = textField;
	}
	
Next you set up the `- (void)textViewDidBeginEditing:` method of the `UITextViewDelegate`. This is entirely similar to the `UITextFieldDelegate`.

	- (void)textViewDidBeginEditing:(UITextView *)textView
	{
	    if ([self.keyboardControls.textFields containsObject:textView])
	        self.keyboardControls.activeTextField = textView;
	    [self scrollViewToTextField:textView];
	}
	
Now you are ready to use BSKeyboardControls. For more information on how to use BSKeyboardControls, please see `Example.xcodeproj`.