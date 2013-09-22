//
//  MathStarsViewController.m
//  Math Board


#import "MathStarsViewController.h"
#import "GameViewController.h"
#import "MathStarsAppDelegate.h"

@implementation MathStarsViewController
@synthesize addSwitch;
@synthesize subtractSwitch;
@synthesize multiplySwitch;
@synthesize divideSwitch;

AVAudioPlayer *player;
MathStarsAppDelegate *app;

-(void)viewDidAppear:(BOOL)animated{   
    startButton.transform = CGAffineTransformMakeScale(1,1);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationDuration:1.5];
    startButton.transform = CGAffineTransformMakeScale(2,2);
    [UIView commitAnimations];
}


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    app= (MathStarsAppDelegate *)[[UIApplication sharedApplication] delegate];
    player=[app.player retain];
    [activityIndicator startAnimating];
    startButton.frame=CGRectMake(110, 180, 100, 100);
    defaults=[NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Music"] isEqualToString:@"Off"]){
        [musicSwitch setOn:NO];   
    }
    else{
        [musicSwitch setOn:YES];   
    }
    if([[defaults objectForKey:@"Sounds"] isEqualToString:@"Off"]){
        [soundSwitch setOn:NO];   
    }
    else{
        [soundSwitch setOn:YES]; 
    }

    [self soundChanged:nil];
    [self musicOnOff:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setDivideSwitch:nil];
    [self setMultiplySwitch:nil];
    [self setSubtractSwitch:nil];
    [self setAddSwitch:nil];
    [InfoView release];
    InfoView = nil;
    [soundSwitch release];
    soundSwitch = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [musicSwitch release];
    musicSwitch = nil;
    [startButton release];
    startButton = nil;
}


- (void)dealloc {
    [startButton release];
    [musicSwitch release];
    [activityIndicator release];
    [soundSwitch release];
    [InfoView release];
    [addSwitch release];
    [subtractSwitch release];
    [multiplySwitch release];
    [divideSwitch release];
    [super dealloc];
}


- (IBAction)startGame:(id)sender {
    // Make sure the user selected one or more arithmetic operations
    if(((addSwitch.on)||(subtractSwitch.on)||(multiplySwitch.on)||(divideSwitch.on)) != TRUE){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"What?" 
                                                     message:@"Please turn on the switch for one or more types of problems that you want to do." 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil];
        [alert show];
    }
    else {
        // Creat game view
        GameViewController *c=[[GameViewController alloc]initWithNibName:@"GameViewController" bundle:nil];
    
        // Select operations
        if(addSwitch.on)
            c.add=TRUE;
        else 
            c.add=FALSE;
        if(subtractSwitch.on)
            c.subtract = TRUE;
        else 
            c.subtract=FALSE;
        if (multiplySwitch.on)
            c.multiply = TRUE;
        else 
            c.multiply=FALSE;
        if (divideSwitch.on)
            c.divide = TRUE;
        else 
            c.divide=FALSE;
    
        // Launch game
        [c startLevel:sender];

        [self presentViewController:c animated:YES completion:nil];
        [c release];
    }
}


- (IBAction)musicOnOff:(id)sender {

    if([sender isOn]||musicSwitch.on){ 
        [defaults setObject:@"On" forKey:@"Music"];
        if(player==nil){
           [app preparePlayer];
           player=app.player;
        }
        [player play];
    }
    else{
        [defaults setObject:@"Off" forKey:@"Music"];
        if(app.player!=nil){
            [player stop];
        }
      }
    [defaults synchronize];
    [activityIndicator stopAnimating];
    [activityIndicator setHidden:YES];
   // [activityIndicator setHidesWhenStopped:YES];
}

- (IBAction)soundChanged:(id)sender {
    if([sender isOn]||soundSwitch.on){  
        [defaults setObject:@"On" forKey:@"Sounds"];
    }
    else{
        [defaults setObject:@"Off" forKey:@"Sounds"];
    }
    [defaults synchronize];
}

- (IBAction)showInfo:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
   	[self.view addSubview:InfoView];
    [UIView commitAnimations];
}

- (IBAction)dismissInfo:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:[self.view superview] cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [InfoView removeFromSuperview];
    [UIView commitAnimations];
}

@end
