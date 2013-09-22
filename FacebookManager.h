//
//  FacebookManager.h
//  NameItIs
//
//  Created by Computer Science on 6/14/11.
//  Copyright 2011 University of West Florida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
@class NameitIsViewController;// "NameItIsViewController.h"

@interface FacebookManager : NSObject<FBRequestDelegate, FBDialogDelegate,FBSessionDelegate> {
    Facebook* _facebook;
    NSArray* _permissions;
   // NameItIsViewController *nameController;
    //NameItIsViewController *nameController;
    
}
//@property(nonatomic, retain)NameItIsViewController *nameController;
@property(readonly) Facebook *facebook;

//-(IBAction)fbButtonClick:(id)sender;
-(void)publishStream:(NSString *) message;
-(void)login;

@end
