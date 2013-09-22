//
//  Math Stars Lite

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
@class MathStarsViewController;

@interface MathStarsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MathStarsViewController *viewController;
    AVAudioPlayer *player;
}
BOOL isGameCenterAPIAvailable();

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MathStarsViewController *viewController;
@property(nonatomic, retain) IBOutlet AVAudioPlayer *player;
-(void)preparePlayer;

@end
