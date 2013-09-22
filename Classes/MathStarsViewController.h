//
//  MathStarsViewController.h
//  Math Board

#import <UIKit/UIKit.h>

@interface MathStarsViewController : UIViewController {

    IBOutlet UIButton *startButton;
    IBOutlet UISwitch *musicSwitch;
    IBOutlet UISwitch *soundSwitch;
    NSUserDefaults *defaults;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *InfoView;
    
}
@property (retain, nonatomic) IBOutlet UISwitch *addSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *subtractSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *multiplySwitch;
@property (retain, nonatomic) IBOutlet UISwitch *divideSwitch;

- (IBAction)startGame:(id)sender;

- (IBAction)musicOnOff:(id)sender;
- (IBAction)soundChanged:(id)sender;
- (IBAction)showInfo:(id)sender;
- (IBAction)dismissInfo:(id)sender;

@end

