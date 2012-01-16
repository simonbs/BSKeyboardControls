//
//  BSKeyboardControls.m
//  Simon Støvring
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

@synthesize delegate;
@synthesize textFields;
@synthesize activeTextField = activeTextField_;
@synthesize toolbar;
@synthesize segmentedPreviousNext;
@synthesize buttonDone;
@synthesize barStyle = barStyle_;
@synthesize previousNextTintColor = previousNextTintColor_;
@synthesize doneTintColor = doneTintColor_;
@synthesize previousTitle = previousTitle_;
@synthesize nextTitle = nextTitle_;

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
        self.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
        
        // Default labels
        self.previousTitle = @"Previous";
        self.nextTitle = @"Next";
        
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
        self.buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonDonePressed:)];
        self.buttonDone.tintColor = self.doneTintColor;
        
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
        
        if ([self.delegate respondsToSelector:@selector(keyboardControlsPreviousNextPressed:withDirection:andActiveTextField:)])
            [self.delegate keyboardControlsPreviousNextPressed:self withDirection:KeyboardControlsDirectionNext andActiveTextField:self.activeTextField];
    }
}

/* Done */
- (void)done
{
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

#pragma mark -
#pragma mark Getters and Setters

/* Setter for self.activeTextField */
- (void)setActiveTextField:(id)activeTextField
{
    activeTextField_ = activeTextField;
    [self enableDisableButtonsForActiveTextField:self.activeTextField];
}

#pragma mark -
#pragma mark IBActions

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
    barStyle_ = barStyle;
    self.toolbar.barStyle = self.barStyle;
}

/* Set tint color of previous and next buttons */
- (void)setPreviousNextTintColor:(UIColor *)previousNextTintColor
{
    previousNextTintColor_ = previousNextTintColor;
    self.segmentedPreviousNext.tintColor = self.previousNextTintColor;
}

/* Set tint color of done button */
- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    doneTintColor_ = doneTintColor;
    self.buttonDone.tintColor = self.doneTintColor;
}

/* Set previous title */
- (void)setPreviousTitle:(NSString *)previousTitle
{
    previousTitle_ = previousTitle;
    [self.segmentedPreviousNext setTitle:self.previousTitle forSegmentAtIndex:KeyboardControlsIndexPrevious];
}

/* Set next title */
- (void)setNextTitle:(NSString *)nextTitle
{
    nextTitle_ = nextTitle;
    [self.segmentedPreviousNext setTitle:self.nextTitle forSegmentAtIndex:KeyboardControlsIndexNext];
}

@end
