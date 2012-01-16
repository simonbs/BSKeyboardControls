//
//  IPKeyboardControls.h
//  Simon Støvring
//
//  Created by Simon Støvring on 09/01/12.
//  Copyright (c) 2012 Simon Støvring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BSKeyboardControlsDelegate;

typedef enum {
    KeyboardControlsDirectionPrevious,
    KeyboardControlsDirectionNext
} KeyboardControlsDirection;

@interface BSKeyboardControls : UIView

@property (nonatomic, strong) id <BSKeyboardControlsDelegate> delegate;
@property (nonatomic, strong) NSArray *textFields;
@property (nonatomic, strong) id activeTextField;
@property (nonatomic, assign) UIBarStyle barStyle;
@property (nonatomic, assign) UIColor *previousNextTintColor;
@property (nonatomic, assign) UIColor *doneTintColor;
@property (nonatomic, assign) NSString *previousTitle;
@property (nonatomic, assign) NSString *nextTitle;

@end

@protocol BSKeyboardControlsDelegate <NSObject>
@required
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField;
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls;
@end
