//
//  GameViewController.m
//  Math Board

#import "GameViewController.h"
#import "FacebookManager.h"
#import "MathStarsAppDelegate.h"

#define BASE_SCORE_LEVEL1 1
#define BASE_SCORE_LEVEL2 2
#define BASE_SCORE_LEVEL3 3
#define BASE_SCORE_LEVEL4 4
#define BASE_SCORE_LEVEL5 5
#define BASE_SCORE_LEVEL6 6
#define BASE_SCORE_LEVEL7 7
#define BASE_SCORE_LEVEL8 8
#define BASE_SCORE_LEVEL9 9
#define BASE_SCORE_LEVEL10 10
#define GAMELEVELS 10

#define GAME_SIZE_LEVEL1 2
#define GAME_SIZE_LEVEL2 3
#define GAME_SIZE_LEVEL3 4
#define GAME_SIZE_LEVEL4 5
#define GAME_SIZE_LEVEL5 6
#define GAME_SIZE_LEVEL6 7
#define GAME_SIZE_LEVEL7 8
#define GAME_SIZE_LEVEL8 9
#define GAME_SIZE_LEVEL9 10
#define GAME_SIZE_LEVEL10 10

#define QUESTION_COUNT_LEVEL1 10
#define QUESTION_COUNT_LEVEL2 15
#define QUESTION_COUNT_LEVEL3 20
#define QUESTION_COUNT_LEVEL4 25
#define QUESTION_COUNT_LEVEL5 30
#define QUESTION_COUNT_LEVEL6 35
#define QUESTION_COUNT_LEVEL7 40
#define QUESTION_COUNT_LEVEL8 45
#define QUESTION_COUNT_LEVEL9 50
#define QUESTION_COUNT_LEVEL10 100000

#define BASE_TIME_BEG 30
#define BASE_TIME_INT 20
#define BASE_TIME_ADV 10

@implementation GameViewController
@synthesize difficultyMode;
@synthesize add;
@synthesize subtract;
@synthesize multiply;
@synthesize divide;

#pragma mark sounds
-(void)playBackgroundMusic {
    MathStarsAppDelegate *app= (MathStarsAppDelegate *)[[UIApplication sharedApplication] delegate];    
    audioPlayer=app.player;
    if([audioPlayer play]==NO){
        [audioPlayer play];
    }
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:YES];
}
  
-(void)playYes {
    if([[defaults objectForKey:@"Sounds"] isEqualToString:@"On"]){
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"RightAnswer" ofType:@"wav"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlaySystemSound (soundID);
    }
}

-(void)playNo {
    if([[defaults objectForKey:@"Sounds"] isEqualToString:@"On"]){
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"WrongAnswer" ofType:@"wav"];
        SystemSoundID soundID2;
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID2);
        AudioServicesPlaySystemSound (soundID2);
    }
}

#pragma mark show score
-(IBAction) showStats {	
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
     [highScoreView removeFromSuperview];
    [UIView commitAnimations];
}

-(IBAction) resetScore {
	[defaults removeObjectForKey:@"highScores"];
	[defaults removeObjectForKey:@"highScoresNames"];
	[defaults synchronize];
    [pickerView reloadAllComponents];
    //[self restartGame];
}

-(void) saveScore {
	NSMutableArray *highScoresArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableArray *highScoresNamesArray=[[NSMutableArray alloc]initWithCapacity:0];
	[highScoresArray addObjectsFromArray: [defaults arrayForKey:@"highScores"]];
	[highScoresNamesArray addObjectsFromArray: [defaults arrayForKey:@"highScoresNames"]];
	NSString *currentScore=[NSString stringWithFormat: @"Level: %.2d,   Score: %.4lld", currentLevel, score];
    [defaults removeObjectForKey:@"highScores"];
	[defaults removeObjectForKey:@"highScoresNames"];
    
	int highScoreCount;
	highScoreCount=[highScoresArray count];
    
    NSString *difLevel = @"";
    if (difficultyMode==1){
        difLevel=@" Mode: Beginner,       ";
    }
    else if (difficultyMode==2){
        difLevel=@" Mode: Intermediate, ";
    }
    else{
        difLevel=@" Mode: Advanced,     ";
    }

	if(highScoreCount>0){
		NSString *storedScoreString;
        NSString *scoreString;
        int storedScoreStringLength;
        int storedScore;
        BOOL scoreFound;
		scoreFound=NO;
        
		for(int i=0;i<highScoreCount;i++){	
            storedScoreString = [highScoresArray objectAtIndex:i];
            storedScoreStringLength = [storedScoreString length];
            scoreString = [[[NSString alloc] initWithString:[storedScoreString substringFromIndex:storedScoreStringLength-4]]autorelease];
            
            
            
            storedScore = [scoreString intValue];
            if(score>=storedScore && scoreFound==NO){
                [highScoresArray insertObject:currentScore atIndex:i];
                [highScoresNamesArray insertObject:difLevel atIndex: i];
                scoreFound=YES;
                pickerIndexToShow=i;
            }
        }
        if(scoreFound==NO){
            [highScoresArray addObject: currentScore];
            [highScoresNamesArray addObject: difLevel];
            pickerIndexToShow = [highScoresArray count] - 1;
        }
	}
	else{
        [highScoresArray addObject: currentScore];
        [highScoresNamesArray addObject: difLevel];
        pickerIndexToShow = 0;
	}
	
	[defaults setObject:highScoresArray forKey:@"highScores"];
	[defaults setObject:highScoresNamesArray forKey:@"highScoresNames"];
	[defaults synchronize];
	[highScoresNamesArray release];
	[highScoresArray release];
    [pickerView reloadAllComponents];
    [pickerView selectRow: pickerIndexToShow inComponent:0 animated:YES];
}


#pragma mark Picker View Methods
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString *nameString=[[defaults arrayForKey:@"highScoresNames"]objectAtIndex:row];
	NSString *scoreString=[[defaults arrayForKey:@"highScores"]objectAtIndex:row];
	NSString * text=[[[NSString alloc]initWithFormat:@"%d %@ %@",row+1, nameString, scoreString]autorelease];
	return text;
}
*/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
    NSString *nameString=[[defaults arrayForKey:@"highScoresNames"]objectAtIndex:row];
	NSString *scoreString=[[defaults arrayForKey:@"highScores"]objectAtIndex:row];
	NSString *text=[[[NSString alloc]initWithFormat:@"%.2d %@ %@",row+1, nameString, scoreString]autorelease];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 460, 40)];
    label.font=[UIFont boldSystemFontOfSize:20];
    label.text=text;
    label.backgroundColor=[UIColor clearColor];
    label.opaque=NO;
    UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(460, 0, 40, 40)];
    im.image=[UIImage imageNamed:@"Smiling_Star.png"];
    im.backgroundColor=[UIColor clearColor];
    im.opaque=NO;
    [v addSubview:label];
    [v addSubview:im];
    return v;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[defaults arrayForKey:@"highScores"]count];
}


#pragma mark Other
-(IBAction) quit{
    if([timer isValid]){
        [timer invalidate];
        timer=nil;
    }
    GameOverView.frame= self.view.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [self saveScore];
   
    [self.view addSubview:GameOverView];
    [UIView commitAnimations];       
    [self updateStats];
}


-(void) updateStats{
    if((levelRight + levelWrong)>0){
        levelaccuracy=(float) (100.0 * levelRight)/(float)(levelRight + levelWrong) ;
        [(UILabel *) [levelSummaryView viewWithTag:30]setText:[NSString stringWithFormat:@"%.1f",levelaccuracy]];

    }
    else{
        levelaccuracy=0.0;
        [(UILabel *) [levelSummaryView viewWithTag:30]setText:[NSString stringWithFormat:@"0.0"]];

    }
    totalAccuracy=0.0;
    if((totalRight + totalWrong)>0){
          totalAccuracy=(float) (100.0 * totalRight)/(float)(totalRight + totalWrong) ;
    }
    
    gameLevel.text = [NSString stringWithFormat:@"%d", currentLevel];
    [(UILabel *) [levelSummaryView viewWithTag:10]setText:[NSString stringWithFormat:@"%d",levelRight]];
    [(UILabel *) [levelSummaryView viewWithTag:20]setText:[NSString stringWithFormat:@"%d",levelWrong]];
    [(UILabel *) [levelSummaryView viewWithTag:40]setText:[NSString stringWithFormat:@"%d",combo3]];
    [(UILabel *) [levelSummaryView viewWithTag:50]setText:[NSString stringWithFormat:@"%d",levelScore]];
    [(UILabel *) [GameOverView viewWithTag:10]setText:[NSString stringWithFormat:@"%d",totalRight]];
    [(UILabel *) [GameOverView viewWithTag:20]setText:[NSString stringWithFormat:@"%d",totalWrong]];
    [(UILabel *) [GameOverView viewWithTag:30]setText:[NSString stringWithFormat:@"%.1f", totalAccuracy]];
    [(UILabel *) [GameOverView viewWithTag:40]setText:[NSString stringWithFormat:@"%d",totalcombo3]];
    [(UILabel *) [GameOverView viewWithTag:50]setText:[NSString stringWithFormat:@"%lld",score]];
}


-(void)buildAnimations{  
    starCombo3.image=[UIImage imageNamed:@"comboStar.png"];
    singleStarView.image=[UIImage imageNamed:@"star.png"];
}


-(void) timerStart{
	if(![timer isValid]){	
		timer=[NSTimer timerWithTimeInterval:1 target: self selector: @selector(updateTimer)userInfo:nil repeats:YES];	
        //Creating an instance of run loop
		NSRunLoop *rloop=[NSRunLoop currentRunLoop];
		[rloop addTimer:timer forMode: NSDefaultRunLoopMode];
	}
}

-(void)updateTimer{
    if(seconds>0){
        seconds--;
    }
    else if(seconds<=0){
        if([timer isValid]){
            [timer invalidate];
            timer=nil;
        }
         GameOverView.frame= self.view.bounds;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
       
        [self.view addSubview:GameOverView];
       
        [UIView commitAnimations];           
        [self updateStats];
        [self saveScore];
    }
    secondsLabel.text=[NSString stringWithFormat:@"Time: %.2d",seconds];
}


-(void)drawNumbers{
    BOOL draw=FALSE;
    while(!draw){
        int op=arc4random()%4+1;
        number1=arc4random()%(gameSize*gameSize)+1;
        number2=arc4random()%(gameSize*gameSize)+1;
        if((op==1)&&(add)){ 
            if(number1+number2<=(gameSize*gameSize)){
                draw=TRUE;
                NSString *s=[NSString stringWithFormat:@"%d + %d", number1, number2];
                digitsLabel.text=s;
                resultToGuess=number1+number2;
            }
        }
        else if((op==2)&&(subtract)){
            if(number2-number1<=gameSize*gameSize){
                if(number2-number1>0){   
                    draw=TRUE;
                    NSString *s=[NSString stringWithFormat:@"%d - %d", number2, number1];
                    digitsLabel.text=s;
                    resultToGuess=number2-number1;
                }
            }
        }
        else if((op==3)&&(multiply)) {
            if(number1*number2<=gameSize*gameSize){
                draw=TRUE;
                NSString *s=[NSString stringWithFormat:@"%d × %d", number1, number2];
                digitsLabel.text=s;
                resultToGuess=number1*number2;
            }
        }
        else if ((op==4)&&(divide)) {
            int i=number2/number1;
            if(i<gameSize*gameSize&&number2%number1==0){
                draw=TRUE;
                NSString *s=[NSString stringWithFormat:@"%d ÷ %d", number2, number1];
                digitsLabel.text=s; 
                resultToGuess=number2/number1;
            }
        } 
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentLevel = 1;
        pickerIndexToShow = 0;
        secondsLabel.text=[NSString stringWithFormat:@"Time: 00"];
        scoreLabel.text = [NSString stringWithFormat:@"Score: 0000"];
        buttonsView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    /*[[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(enteredBackground) 
                                                     name: @"didEnterBackground" 
                                                   object: nil];
      [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(becomeActive) 
                                                     name: @"didBecomeActive" 
                                                   object: nil];
    */
     }
    return self;
}


- (void)dealloc{
    [digitsLabel release];
    [scoreLabel release];
    [secondsLabel release];
    [LevelView release];
    [bigLevelLabel release];
    [GameOverView release];
    [singleStarView release];
    [levelSummaryView release];
    [summaryBigLabel release];
    [highScoreView release];
    [pickerView release];
    [activityIndicator release];
    [gameLevel release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {   
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];	
    
    [activityIndicator startAnimating];
    // Do any additional setup after loading the view from its nib.
 }


-(void) viewDidAppear:(BOOL)animated{
    [activityIndicator setHidden:NO];
    defaults=[NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Music"] isEqualToString:@"Off"]){
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
        [audioPlayer stop];
    }
    else{
        if(![audioPlayer play]){
            [self playBackgroundMusic];    
        }
    }
}

- (void)viewDidUnload{   
    [audioPlayer pause];
    audioPlayer = nil;
    [digitsLabel release];
    digitsLabel = nil;
    [scoreLabel release];
    scoreLabel = nil;
    [secondsLabel release];
    secondsLabel = nil;
    [LevelView release];
    LevelView = nil;
    [bigLevelLabel release];
    bigLevelLabel = nil;
    [GameOverView release];
    GameOverView = nil;
    [singleStarView release];
    singleStarView = nil;
    [levelSummaryView release];
    levelSummaryView = nil;
    [summaryBigLabel release];
    summaryBigLabel = nil;
    [highScoreView release];
    highScoreView = nil;
    [pickerView release];
    pickerView = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [gameLevel release];
    gameLevel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

-(void) buildLevel:(int)level{
    float maxSpace=self.view.frame.size.width;
    
    //Reset Stats
    levelScore=0;
    levelRight=0;
    levelWrong=0;
    levelaccuracy=0;
    combo3=0;
    
    switch (level) {
        case 1:
        {
            gameSize=GAME_SIZE_LEVEL1;
            currentScoreIncrement=BASE_SCORE_LEVEL1;
            questionCount=QUESTION_COUNT_LEVEL1;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL1;
            break;
        }
        case 2:
        {
            gameSize=GAME_SIZE_LEVEL2;        
            currentScoreIncrement=BASE_SCORE_LEVEL2;
            questionCount=QUESTION_COUNT_LEVEL2;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL2;
            break;
        }   
        case 3:
        {
            gameSize=GAME_SIZE_LEVEL3;
            currentScoreIncrement=BASE_SCORE_LEVEL3;
            questionCount=QUESTION_COUNT_LEVEL3;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL3;
            break;
        }   
        case 4:
        {
            gameSize=GAME_SIZE_LEVEL4;
            currentScoreIncrement=BASE_SCORE_LEVEL4;        
            questionCount=QUESTION_COUNT_LEVEL4;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL4;
            break;
        }
        case 5:
        {
            gameSize=GAME_SIZE_LEVEL5;
            currentScoreIncrement=BASE_SCORE_LEVEL5;
            questionCount=QUESTION_COUNT_LEVEL5;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL5;
            break;
        }   
        case 6:
        {
            gameSize=GAME_SIZE_LEVEL6;
            currentScoreIncrement=BASE_SCORE_LEVEL6;
            questionCount=QUESTION_COUNT_LEVEL6;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL6;
            break;
        }   
        case 7:
        {
            gameSize=GAME_SIZE_LEVEL7;
            questionCount=QUESTION_COUNT_LEVEL7;
            currentScoreIncrement=BASE_SCORE_LEVEL7;
             size=0.95 * maxSpace/GAME_SIZE_LEVEL7;
            break;
        }
        case 8:
        {
            gameSize=GAME_SIZE_LEVEL8;
            questionCount=QUESTION_COUNT_LEVEL8;
            currentScoreIncrement=BASE_SCORE_LEVEL8;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL8;
            break;
        } 
        case 9:
        {
            gameSize=GAME_SIZE_LEVEL9;
            questionCount=QUESTION_COUNT_LEVEL9;
            currentScoreIncrement=BASE_SCORE_LEVEL9;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL9;
            break;
        } 
        case 10:
        {
            gameSize=GAME_SIZE_LEVEL9;
            questionCount=QUESTION_COUNT_LEVEL10;
            currentScoreIncrement=BASE_SCORE_LEVEL10;
            size=0.95 * maxSpace/GAME_SIZE_LEVEL10;
            break;
        }
        default:
            return;
    }
    
    // Reduce the size of the buttons view to accommodate scaled down buttons for levels 1 through 3
    if(level==1)
            buttonsView.frame=CGRectMake((self.view.frame.size.width-size * gameSize)/2.0 + 100, 360 +(280 - size * gameSize)/2.0 + 75, 0.75 * size * gameSize, 0.75 * size * gameSize);
    else if (level == 2)
            buttonsView.frame=CGRectMake((self.view.frame.size.width-size * gameSize)/2.0 + 50, 360 +(280 - size * gameSize)/2.0 + 50, 0.89 * size * gameSize, 0.89 * size * gameSize);
    else if (level == 3)
            buttonsView.frame=CGRectMake((self.view.frame.size.width-size * gameSize)/2.0 + 15, 360 +(280 - size * gameSize)/2.0 + 10, 0.97 * size * gameSize, 0.97 * size * gameSize);
    else
            buttonsView.frame=CGRectMake((self.view.frame.size.width-size * gameSize)/2.0, 360 +(280 - size * gameSize)/2.0, size *gameSize, size * gameSize);
    //[buttonsView setBackgroundColor:[UIColor whiteColor]];
    [self setButtons];
    bigLevelLabel.text = [NSString stringWithFormat:@"Level: %d", level];
    [self.view addSubview:buttonsView];
}


-(void) setButtons{
    int buttonTitle=0;
    for(UIButton *b in buttonsView.subviews){
        [UIView beginAnimations:@"nil" context:nil];
        [UIView setAnimationDuration:1];
        b.alpha=0; 
        [UIView commitAnimations];
        [b removeFromSuperview];
    }
    UIImage *im=[UIImage imageNamed:@"Number_Star100.png"];
    for(int y=0; y<gameSize; y++){ 
        for(int x=0; x<gameSize; x++){        
            [UIView beginAnimations:@"nil" context:nil];
            [UIView setAnimationDuration:0.5];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:im forState:UIControlStateNormal];
            
            //Calculate where the button should be in the view
            buttonTitle++;
            NSString *title=[NSString stringWithFormat:@"%d",buttonTitle] ;
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            CGRect buttonFrame;
            // Scale the buttons to reduce their size when their are less than 16 so they are not too big
            if(currentLevel == 1)
                buttonFrame=CGRectMake(x*size, y*size, size * 0.5, size * 0.5);
            else if(currentLevel == 2)
                buttonFrame=CGRectMake(x*size, y*size, size * 0.67, size * 0.67);
            else if(currentLevel == 3)
                buttonFrame=CGRectMake(x*size, y*size, size * 0.84, size * 0.84);
            else
                buttonFrame=CGRectMake(x*size, y*size, size, size);
            button.frame=buttonFrame;
            button.titleLabel.font=[UIFont boldSystemFontOfSize:24];
            [buttonsView addSubview:button];
            button.tag=buttonTitle;
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
            [UIView commitAnimations];
        }
    }
}


- (IBAction)startLevel:(id)sender { 
    [self buildAnimations];
    [self buildLevel:currentLevel];
    [self drawNumbers];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionCurlUp];
    [UIView setAnimationDuration:1.0];
    LevelView.frame= self.view.bounds;

    [self.view addSubview:LevelView];
    [UIView commitAnimations];   
    
    if([sender tag]!=0){
        difficultyMode=[sender tag]/10;
    }
    else {
        difficultyMode = 1;
    }  
    switch (difficultyMode) {
        case 1:
        {
           seconds=BASE_TIME_BEG;
           difficultyMode=1;
        }
        break;
        case 2:
        {
            seconds=BASE_TIME_INT;
            difficultyMode=2;
        }
        break;
        case 3:
        {
            seconds=BASE_TIME_ADV; 
            difficultyMode=3;
        }
        break;
        default:
            seconds=BASE_TIME_BEG; 
            break;  
    }
    
    @try {
        if([timer isValid])
        {
            [timer invalidate];
            timer=nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error %@",exception);
    }
    @finally {
        [self timerStart];

    }
    levelSummaryView.frame=CGRectMake(-1024, 1000, levelSummaryView.frame.size.width, levelSummaryView.frame.size.height);
}

- (IBAction)nextLevel:(id)sender {
    [self buildAnimations];
    [self buildLevel:currentLevel];
    [self drawNumbers];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationOptionTransitionCurlUp];
    [UIView setAnimationDuration:1.0];
    [self.view addSubview:LevelView];
    LevelView.frame= self.view.bounds;
    [UIView commitAnimations]; 
    levelSummaryView.frame=CGRectMake(-1024, 1000, levelSummaryView.frame.size.width, levelSummaryView.frame.size.height);
    [self timerStart];
}

- (IBAction)gameOver:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animationStop{
    [starCombo3 removeFromSuperview];
    [singleStarView removeFromSuperview];
}


-(void)buttonTap:(id)sender{
    int k = [[(UIButton *)sender titleForState:UIControlStateNormal]intValue];
      
    if(resultToGuess==0){
       // [self drawNumbers];
    }
    
    if(k==resultToGuess){
        levelRight++;
        totalRight++;
        [self playYes];
        int scoreIncrement=currentScoreIncrement;
        progressTracker++;
        if(progressTracker>0&& progressTracker%3==0){
            //triple star combo
            combo3++;
            totalcombo3++;
            scoreIncrement *=3;
            [self.view addSubview:starCombo3];
            CGRect temp=[(UIButton*) sender frame];
            CGRect temp1=buttonsView.frame;
            int x=temp.origin.x+temp1.origin.x;
            int y=temp.origin.y+temp1.origin.y-30;
            starCombo3.frame=CGRectMake(x,y,60,55);
            [UIView beginAnimations:@"Combo3" context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationStop)];
            starCombo3.frame=CGRectMake(x,-100,60,55);
            [UIView commitAnimations];
        }
        else{
            [singleStarView setAnimationDuration:1.5];
            [self.view addSubview:singleStarView];
            CGRect temp=[(UIButton*) sender frame];
            CGRect temp1=buttonsView.frame;
            int x=temp.origin.x+temp1.origin.x;
            int y=temp.origin.y+temp1.origin.y-15;
            singleStarView.frame=CGRectMake(x,y,30,30);
            [UIView beginAnimations:@"1" context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationStop)];
            singleStarView.frame=CGRectMake(x,-100,30,30);
            [UIView commitAnimations];
        }
        score+=scoreIncrement;
        levelScore+=scoreIncrement;
        scoreLabel.text=[NSString stringWithFormat:@"Score: %.4lld", score];
            
        //Updating seconds;
        seconds+=2;
        [self drawNumbers];
        [self setButtons];     
        if(questionCount>0){
            questionCount--;
        }  
        if(questionCount==0){
            currentLevel++;
            progressTracker=0;
            if(currentLevel<=GAMELEVELS){
                bigLevelLabel.text=[NSString stringWithFormat:@"Level: %d", currentLevel];
                CGContextRef context = UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:1.0];
                if([timer isValid]){
                    [timer invalidate];
                    timer=nil;
                }
                levelSummaryView.frame= self.view.bounds;
                [self.view addSubview:levelSummaryView];
                [UIView commitAnimations];       
                [self updateStats];
                levelSummaryView.frame=CGRectMake(0, 0, levelSummaryView.frame.size.width, levelSummaryView.frame.size.height);
                summaryBigLabel.text=[NSString stringWithFormat:@"Level %d Summary",currentLevel-1];
            }
        }
    }       
    else{
        [self playNo];
        [(UIButton *)sender setTitle:@"" forState:UIControlStateNormal];
        UIImage *im=[UIImage imageNamed:@"NonSmiling_Star200.png"];
        [(UIButton *)sender setBackgroundImage:im forState:UIControlStateNormal];

        //resetting progress tracker
        progressTracker=0;
        levelWrong++;
        totalWrong++;
    }
}


@end
