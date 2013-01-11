//
//  BSKeyboardControls.m
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import "BSKeyboardControls.h"

@interface BSKeyboardControls ()
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) NSMutableArray *mutableFields;
@end

@implementation BSKeyboardControls

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    return [self initWithFields:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFields:nil];
}

- (id)initWithFields:(NSArray *)fields
{
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)])
    {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:self.frame]];
        [self.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [self.toolbar setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth)];
        [self addSubview:self.toolbar];
        
        [self setSegmentedControl:[[UISegmentedControl alloc] initWithItems:@[ NSLocalizedStringFromTable(@"Previous", @"BSKeyboardControls", @"Previous button title."),
                                                                               NSLocalizedStringFromTable(@"Next", @"BSKeyboardControls", @"Next button title.") ]]];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.segmentedControl setMomentary:YES];
        [self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
        [self.segmentedControl setEnabled:NO forSegmentAtIndex:BSKeyboardControlsDirectionNext];
        
        [self setDoneButton:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @"BSKeyboardControls", @"Done button title.")
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(doneButtonPressed:)]];
        
        [self.toolbar setItems:@[ [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl],
                                  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                  self.doneButton ]];
        
        [self setFields:fields];
    }
    
    return self;
}

- (void)dealloc
{
    [self setFields:nil];
    [self setMutableFields:nil];
    [self setSegmentedControlTintControl:nil];
    [self setPreviousTitle:nil];
    [self setBarTintColor:nil];
    [self setNextTitle:nil];
    [self setDoneTitle:nil];
    [self setDoneTintColor:nil];
    [self setActiveField:nil];
    [self setToolbar:nil];
    [self setSegmentedControl:nil];
    [self setDoneButton:nil];
}

#pragma mark -
#pragma mark Public Methods

- (void)setActiveField:(id)activeField
{
    if (activeField != _activeField)
    {
        if ([self.fields containsObject:activeField])
        {
            _activeField = activeField;
        
            if (![activeField isFirstResponder])
            {
                [activeField becomeFirstResponder];
            }
        
            [self updateSegmentedControlEnabledStates];
        }
    }
}

- (void)registerFieldsInView:(UIView *)view
{
    [self addFieldsFromView:view];
    
    NSArray *reversed = [[self.fields reverseObjectEnumerator] allObjects];
    [self setFields:[NSMutableArray arrayWithArray:reversed]];
}

- (void)setFields:(NSArray *)fields
{
    [self setMutableFields:[NSArray arrayWithArray:fields]];
    
    for (UIView *field in fields)
    {
        if ([field isKindOfClass:[UITextField class]])
        {
            [(UITextField *)field setInputAccessoryView:self];
        }
        else if ([field isKindOfClass:[UITextView class]])
        {
            [(UITextView *)field setInputAccessoryView:self];
        }
    }
}

- (NSArray *)fields
{
    return self.mutableFields;
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
    if (barStyle != _barStyle)
    {
        [self.toolbar setBarStyle:barStyle];
        
        _barStyle = barStyle;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (barTintColor != _barTintColor)
    {
        [self.toolbar setTintColor:barTintColor];
        
        _barTintColor = barTintColor;
    }
}

- (void)setSegmentedControlTintControl:(UIColor *)segmentedControlTintControl
{
    if (segmentedControlTintControl != _segmentedControlTintControl)
    {
        [self.segmentedControl setTintColor:segmentedControlTintControl];
        
        _segmentedControlTintControl = segmentedControlTintControl;
    }
}

- (void)setPreviousTitle:(NSString *)previousTitle
{
    if (![previousTitle isEqualToString:_previousTitle])
    {
        [self.segmentedControl setTitle:previousTitle forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
        
        _previousTitle = previousTitle;
    }
}

- (void)setNextTitle:(NSString *)nextTitle
{
    if (![nextTitle isEqualToString:_nextTitle])
    {
        [self.segmentedControl setTitle:nextTitle forSegmentAtIndex:BSKeyboardControlsDirectionNext];
        
        _nextTitle = nextTitle;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle
{
    if (![doneTitle isEqualToString:_doneTitle])
    {
        [self.doneButton setTitle:doneTitle];
        
        _doneTitle = doneTitle;
    }
}

- (void)setDoneTintColor:(UIColor *)doneTintColor
{
    if (doneTintColor != _doneTintColor)
    {
        [self.doneButton setTintColor:doneTintColor];
        
        _doneTintColor = doneTintColor;
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)segmentedControlValueChanged:(id)sender
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case BSKeyboardControlsDirectionPrevious:
            [self selectPreviousField];
            break;
        case BSKeyboardControlsDirectionNext:
            [self selectNextField];
            break;
        default:
            break;
    }
}

- (void)doneButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(keyboardControlsDonePressed:)])
    {
        [self.delegate keyboardControlsDonePressed:self];
    }
}

- (void)updateSegmentedControlEnabledStates
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index != NSNotFound)
    {
        [self.segmentedControl setEnabled:(index > 0) forSegmentAtIndex:BSKeyboardControlsDirectionPrevious];
        [self.segmentedControl setEnabled:(index < [self.fields count] - 1) forSegmentAtIndex:BSKeyboardControlsDirectionNext];
    }
}

- (void)selectPreviousField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index > 0)
    {
        index -= 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionPrevious];
        }
    }
}

- (void)selectNextField
{
    NSInteger index = [self.fields indexOfObject:self.activeField];
    if (index < [self.fields count] - 1)
    {
        index += 1;
        UIView *field = [self.fields objectAtIndex:index];
        [self setActiveField:field];
        
        if ([self.delegate respondsToSelector:@selector(keyboardControls:selectedField:inDirection:)])
        {
            [self.delegate keyboardControls:self selectedField:field inDirection:BSKeyboardControlsDirectionNext];
        }
    }
}

- (void)addFieldsFromView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]])
        {
            [self.mutableFields addObject:subview];
        }
        else
        {
            [self addFieldsFromView:subview];
        }
    }
}

@end
