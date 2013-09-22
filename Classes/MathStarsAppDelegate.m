//
//  Math Stars


#import "MathStarsAppDelegate.h"
#import "MathStarsViewController.h"

@implementation MathStarsAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize player;


#pragma mark player

-(void)preparePlayer{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Pinball.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    error=nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    player.numberOfLoops = 10;
    if(error!=nil)
    {
        NSLog(@"%@ Error", error);
        
    }
}






#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    self.window.rootViewController = viewController;
    // Add the view controller's view to the window and display.
    //[self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
     BOOL k=isGameCenterAPIAvailable();
    if(k)
    {
    }
    else{
        
    }
    
    return YES;
}


BOOL isGameCenterAPIAvailable()
{
    // Check for presence of GKLocalPlayer class.
    BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
    
    // The device must be running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (localPlayerClassAvailable && osVersionSupported);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //[(MyAppDelegate *)[[UIApplication sharedApplication] delegate];  
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didEnterBackground" 
                                                        object: nil 
                                                      userInfo: nil];
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didBecomeActive"
                                                        object: nil
                                                      userInfo: nil];
    

    
}



//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    /*
//     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     */
//    
//}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
