//
//  GameViewController.h
//  Math Stars iPad
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@class FacebookManager;
@interface GameViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    int seconds;
    int difficultyMode;
    int currentLevel;
    int currentScoreIncrement;
    UIView *buttonsView;
    
    IBOutlet UILabel *secondsLabel;
    IBOutlet UILabel *digitsLabel;
    IBOutlet UIView *GameOverView;
    IBOutlet UIView *LevelView;
    IBOutlet UIView *levelSummaryView;
    
    int number1;
    int number2;
    int gameSize;
    float size;
    int resultToGuess;
    int progressTracker;
    int questionCount;
    NSTimer *timer;
    
    IBOutlet UILabel *gameLevel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *bigLevelLabel;
    IBOutlet UIImageView *starCombo3;
    IBOutlet UIImageView *singleStarView;
    IBOutlet UILabel *summaryBigLabel;
    
    //Tracking    
    int levelScore;
    int levelRight;
    int levelWrong;
    float levelaccuracy;
    int combo3;

    int64_t score;
    int totalRight;
    int totalWrong;
    float totalAccuracy;
    int totalcombo3;    
    NSUserDefaults *defaults;
    IBOutlet UIView *highScoreView;
    IBOutlet UIPickerView *pickerView;
    AVAudioPlayer *audioPlayer;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    FacebookManager *fbManager;
    int pickerIndexToShow;
}

@property(nonatomic,assign) int difficultyMode;
@property (nonatomic, assign) BOOL add;
@property (nonatomic, assign) BOOL subtract;
@property (nonatomic, assign) BOOL multiply;
@property (nonatomic, assign) BOOL divide;

-(IBAction) showStats;
-(IBAction) resetScore;
-(IBAction) quit;
-(IBAction) drawNumbers;
-(IBAction) startLevel:(id)sender;
-(IBAction) nextLevel:(id)sender;

-(IBAction) gameOver:(id)sender;

-(void) playNo;
-(void) playYes;
-(void) buildAnimations;
-(void) buildLevel:(int)level;
-(void) setButtons;
-(void) updateStats;

@end
