//
//  BSKeyboardControls.h
//  BSKeyboardControls
//
//  Created by Simon Støvring on 09/01/12.
//  Copyright (c) 2012 Simon B. Støvring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSKeyboardControlsDelegate;

/* Directions */
typedef enum
{
    KeyboardControlsDirectionPrevious,
    KeyboardControlsDirectionNext,
    KeyboardControlsDirectionSelected
} KeyboardControlsDirection;

@interface BSKeyboardControls : UIView

/*
 * Delegate
 */
@property (nonatomic, weak) id <BSKeyboardControlsDelegate> delegate;

/*
 * Text fields the controls should work on
 * The order of this, will be the order used when the next and the previous button is pressed
 */
@property (nonatomic, strong) NSArray *textFields;

/*
 * Currently active text field
 */
@property (nonatomic, strong) id activeTextField;

/*
 * Style of the bar
 */
@property (nonatomic, assign) UIBarStyle barStyle;

/*
 * Tint color of the previous and next buttons
 */
@property (nonatomic, strong) UIColor *previousNextTintColor;

/*
 * Title of the previous button
 */
@property (nonatomic, strong) NSString *previousTitle;

/*
 * Title of the next button
 */
@property (nonatomic, strong) NSString *nextTitle;

/*
 * Title of the done button
 */
@property (nonatomic, strong) NSString *doneTitle;

/*
 *  Tint color of the done button
 */
@property (nonatomic, strong) UIColor *doneTintColor;

/*
 * Reload text fields
 */
- (void)reloadTextFields;

/*
 * Allow hiding of previous / next buttons
 */
- (void)hidePrevNextButtons: (BOOL)isHidden;

@end

/* Delegation methods */
@protocol BSKeyboardControlsDelegate <NSObject>
@optional
/*
 * Previous or next button was pressed
 */
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(UITextField *)textField;

/*
 * Done button was pressed
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls;
@end
