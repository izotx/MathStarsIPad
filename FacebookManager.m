//
//  FacebookManager.m
//  NameItIs
//
//  Created by Computer Science on 6/14/11.
//  Copyright 2011 University of West Florida. All rights reserved.
//

#import "FacebookManager.h"
#import "Facebook.h"


@implementation FacebookManager
static NSString* kAppId = @"216969365000418";
//@synthesize nameController;
@synthesize facebook = _facebook;

//////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

/**
 * initialization
 */
- (id)init {
    if (!kAppId) {
       // NSLog(@"missing app id!");
        return nil;
    }
    
    
    if ((self = [super init])) {
        _permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"publish_stream", @"offline_access",nil] retain];
         _facebook = [[Facebook alloc] initWithAppId:kAppId];
    }
    
    return self;
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    [_facebook authorize:_permissions delegate:self];
    //    [_facebook authorizeWithFBAppAuth:NO safariAuth:NO];
}

- (void)fbDidLogin {
   }

-(void)fbDidNotLogin:(BOOL)cancelled {
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Error during connecting to Facebook. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];

}

- (void)publishStream:(NSString *) message {
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"app_id",
                                  // @"http://developers.facebook.com/docs/reference/dialogs/", @"link",
                                   @"http://fbrell.com/f8.jpg", @"picture",
                                   @"NameItIs", @"name",
                                   @"Download the NameIs App from the iTunes App Store to find out your Jedi name.\r\n", @"caption",
                                   @"Fun it is!", @"description",
                                  message,  @"message",
                                   nil];
    
    [_facebook dialog:@"feed" andParams:params andDelegate:self];
    [_facebook dialog:@"stream.publish"
            andParams:params
          andDelegate:self];
}

- (void)dialogDidComplete:(FBDialog *)dialog {
   // NSLog(@"publish successfully");
}

-(void)dealloc{
    [_facebook release];
    [_permissions release];
    [super dealloc];
}


@end
