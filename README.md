cmb-spinoff
===========

my code spun off from cmb

This is a custom AlertView that replaces all of Apple's UIAlertView in Coffee Meets Bagel ios app. For sake of consistency, styling is the same throughout the app, but there's a lot of freedom in implementing the closeAlert bahavior, as well as freedom in defining your own style that would be different from Apple's UIAlertView.

To use this, all you need to do is

CMBAlertView *alert = [CMBAlertView alertViewWithTitle:@"Some Title" 
                                               message:@"Some Message" 
                                              delegate:self 
                                     cancelButtonTitle:@"OK" 
                                     otherButtonTitles:@"Cancel"];
[alert show];

delegate can be set to self, or any other controller, or even to nil. Usually set to nil if you do not need to define any action that should execute upon pressing any of the buttons.

If delegate is set, then whatever controller is set as a delegate should implement this method:

- (void)customAlertView:(CMBAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
