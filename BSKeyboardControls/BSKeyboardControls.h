//
//  IPKeyboardControls.h
//  Simon Støvring
//
//  Created by Simon Støvring on 09/01/12.
//  Copyright (c) 2012 Simon Støvring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSKeyboardControlsDelegate;

/* Used to tell whether the user pressed the "Previous" or the "Next" button */
typedef enum {
    KeyboardControlsDirectionPrevious,
    KeyboardControlsDirectionNext
} KeyboardControlsDirection;

@interface BSKeyboardControls : UIView

/* The delegate (BSKeyboardControlsDelegate, see below) */
@property (nonatomic, strong) id <BSKeyboardControlsDelegate> delegate;

/* The text fields the BSKeyboardControls will handle */
@property (nonatomic, strong) NSArray *textFields;

/* The currently active text field */
@property (nonatomic, strong) id activeTextField;

/* The style of the UIToolbar */
@property (nonatomic, assign) UIBarStyle barStyle;

/* The tint color of the "Previous" and the "Next" button */
@property (nonatomic, strong) UIColor *previousNextTintColor;

/* The tint color of the done button */
@property (nonatomic, strong) UIColor *doneTintColor;

/* The title of the "Previous" button */
@property (nonatomic, strong) NSString *previousTitle;

/* The title of the "Next" button */
@property (nonatomic, strong) NSString *nextTitle;

@end

@protocol BSKeyboardControlsDelegate <NSObject>
@required
/* Called when the user presses either the "Previous" or the "Next" button */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField;

/* Called when the user pressed the "Done" button */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls;
@end
