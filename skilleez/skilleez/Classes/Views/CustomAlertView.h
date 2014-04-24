#import <UIKit/UIKit.h>

@protocol CustomIOS7AlertViewDelegate

@optional
- (void)dismissAlert:(id)alertView withButtonIndex:(NSInteger)buttonIndex;

@end

@interface CustomAlertView : UIView<CustomIOS7AlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property (nonatomic, retain) UIView *buttonView;    // Buttons on the bottom of the dialog

@property (nonatomic, assign) id<CustomIOS7AlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, retain) NSArray *buttons;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign) SEL methodName;

@property (copy) void (^onButtonClick)(CustomAlertView *alertView, int buttonIndex);

- (id)init;

/*!
 DEPRECATED: Use the [CustomIOS7AlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));
- (id)initDefaultOkWithText:(NSString *)text delegate:(id)delegateClass;
- (id)initDefaultYesCancelWithText:(NSString *)text delegate:(id)delegateClass;
- (id)initDefaultWithText:(NSString *)text delegate:(id)delegateClass buttons:(NSArray *)titles;

- (void)show;
- (void)close;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setDefaultContainerView:(NSString *)question;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;

@end
