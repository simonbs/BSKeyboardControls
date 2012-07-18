//
//  BSKeyboardControls.m
//  BSKeyboardControls
//
//  Created by Simon Støvring on 09/01/12.
//  Copyright (c) 2012 Simon B. Støvring. All rights reserved.
//

#import "BSKeyboardControls.h"

enum {
    KeyboardControlsIndexPrevious,
    KeyboardControlsIndexNext
};

@interface BSKeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segmentedPreviousNext;
@property (nonatomic, strong) UIBarButtonItem *buttonDone;
- (IBAction)segmentedControlPreviousNextChangedValue:(id)sender;
- (IBAction)buttonDonePressed:(id)sender;
- (void)previous;
- (void)next;
- (void)done;
- (void)enableDisableButtonsForActiveTextField:(id)textField;
@end

@implementation BSKeyboardControls


@synthesize delegate = _delegate,
            textFields = _textFields,
            activeTextField = _activeTextField,
            toolbar = _toolbar,
            segmentedPreviousNext = _segmentedPreviousNext,
            buttonDone = _buttonDone,
            barStyle = _barStyle,
            previousNextTintColor = _previousNextTintColor,
            previousTitle = _previousTitle,
            nextTitle = _nextTitle,
            doneTitle = _doneTitle,
            doneTintColor = _doneTintColor;

/* Initialize */
- (id)init
{
    if (self = [super init])
    {
        // Set frame
        CGRect frame = CGRectMake(0, 0, 320, 44);
        self.frame = frame;
        
        // Default colors
        self.barStyle = UIBarStyleBlackTranslucent;
        self.previousNextTintColor = [UIColor blackColor];
        
        // Default labels
        self.previousTitle = NSLocalizedStringFromTable(@"Previous", @"BSKeyboardControls", nil);
        self.nextTitle = NSLocalizedStringFromTable(@"Next", @"BSKeyboardControls", nil);
        
        // Create toolbar
        self.toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
        self.toolbar.barStyle = self.barStyle;
        self.toolbar.backgroundColor = [UIColor clearColor];
        
        // Setup segmented controls
        self.segmentedPreviousNext = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:self.previousTitle, self.nextTitle, nil]];
        self.segmentedPreviousNext.tintColor = self.previousNextTintColor;
        self.segmentedPreviousNext.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segmentedPreviousNext.momentary = YES;
        [self.segmentedPreviousNext addTarget:self action:@selector(segmentedControlPreviousNextChangedValue:) forControlEvents:UIControlEventValueChanged];
        
        // Make segmented controls a bar button
        UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedPreviousNext];
        
        // Create spacing
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        // Create done button
        self.buttonDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"BSKeyboardControls", nil)
                                                           style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(buttonDonePressed:)];
        
        // Add items to bar
        NSArray *items = [NSArray arrayWithObjects:barSegment, flex, self.buttonDone, nil];
        self.toolbar.items = items;
        
        // Set autoresizing (when phone rotates)
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Add toolbar to self
        [self addSubview:self.toolbar];
    }
    
    return self;
}

/* Previous */
- (void)previous
{
    int index = [self.textFields indexOfObject:self.activeTextField];
    
    if (index > 0)
    {
        int previous = index - 1;
        self.activeTextField = [self.textFields objectAtIndex:previous];
        
        [self enableDisableButtonsForActiveTextField:self.activeTextField];
        
        [self keyboardControlsPreviousNextPressed:self withDirection:KeyboardControlsDirectionPrevious andActiveTextField:self.activeTextField];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControlsPreviousNextPressed:withDirection:andActiveTextField:)])
            [self.delegate keyboardControlsPreviousNextPressed:self withDirection:KeyboardControlsDirectionPrevious andActiveTextField:self.activeTextField];
    }
}

/* Next */
- (void)next
{
    int index = [self.textFields indexOfObject:self.activeTextField];

    if (index < self.textFields.count - 1)
    {
        int next = index + 1;
        self.activeTextField = [self.textFields objectAtIndex:next];
        
        [self enableDisableButtonsForActiveTextField:self.activeTextField];
        
        [self keyboardControlsPreviousNextPressed:self withDirection:KeyboardControlsDirectionNext andActiveTextField:self.activeTextField];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControlsPreviousNextPressed:withDirection:andActiveTextField:)])
            [self.delegate keyboardControlsPreviousNextPressed:self withDirection:KeyboardControlsDirectionNext andActiveTextField:self.activeTextField];
    }
}

/* Done */
- (void)done
{
    [self keyboardControlsDonePressed:self];
    
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
        [self.delegate keyboardControlsDonePressed:self];
}

/* Enable and disable buttons */
- (void)enableDisableButtonsForActiveTextField:(id)textField
{
    int index = [self.textFields indexOfObject:textField];
    
    // Check if "Previous" button should be enabled
    if (index > 0)
        [self.segmentedPreviousNext setEnabled:YES forSegmentAtIndex:0];
    else
        [self.segmentedPreviousNext setEnabled:NO forSegmentAtIndex:0];
    
    // Check if "Next" button should be enabled
    if (index < self.textFields.count - 1)
        [self.segmentedPreviousNext setEnabled:YES forSegmentAtIndex:1];
    else
        [self.segmentedPreviousNext setEnabled:NO forSegmentAtIndex:1];
}

/* Reload text fields */
- (void)reloadTextFields
{
    // Add the keyboard control as accessory view for all of the text fields
	// Also set the delegate of all the text fields to self
	for (id textField in self.textFields)
	{
	    if ([textField isKindOfClass:[UITextField class]])
	        ((UITextField *) textField).inputAccessoryView = self;
	    else if ([textField isKindOfClass:[UITextView class]])
	        ((UITextView *) textField).inputAccessoryView = self;
	}
}

#pragma mark -
#pragma mark Getters and Setters

/* Setter for self.activeTextField */
- (void)setActiveTextField:(id)activeTextField
{
    _activeTextField = activeTextField;
    [self enableDisableButtonsForActiveTextField:self.activeTextField];
}

#pragma mark -
#pragma mark Delegation

/* Done was pressed */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}

/* Previous or next was pressed */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
}

#pragma mark -
#pragma mark Interface Actions

/* Previous / Next segmented control changed value */
- (IBAction)segmentedControlPreviousNextChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case KeyboardControlsIndexPrevious:
            [self previous];
            break;
        case KeyboardControlsIndexNext:
            [self next];
            break;
        default:
            break;
    }
}

/* Done button was pressed */
- (void)buttonDonePressed:(id)sender
{
    [self done];
}

#pragma mark -
#pragma mark Settings

/* Set bar style */
- (void)setBarStyle:(UIBarStyle)barStyle
{
    _barStyle = barStyle;
    self.toolbar.barStyle = self.barStyle;
}

/* Set tint color of previous and next buttons */
- (void)setPreviousNextTintColor:(UIColor *)previousNextTintColor
{
    _previousNextTintColor = previousNextTintColor;
    self.segmentedPreviousNext.tintColor = previousNextTintColor;
}

/* Set previous title */
- (void)setPreviousTitle:(NSString *)previousTitle
{
    _previousTitle = previousTitle;
    [self.segmentedPreviousNext setTitle:previousTitle forSegmentAtIndex:KeyboardControlsIndexPrevious];
}

/* Set next title */
- (void)setNextTitle:(NSString *)nextTitle
{
    _nextTitle = nextTitle;
    [self.segmentedPreviousNext setTitle:nextTitle forSegmentAtIndex:KeyboardControlsIndexNext];
}

/* Set done title */
- (void)setDoneTitle:(NSString *)doneTitle
{
    _doneTitle = doneTitle;
    self.buttonDone.title = doneTitle;
}

/* Set done button tint color */
- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    _doneTintColor = doneTintColor;
    self.buttonDone.tintColor = doneTintColor;
}

@end
