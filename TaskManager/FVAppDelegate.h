//
//  FVAppDelegate.h
//  TaskManager
//
//  Created by Fernando Valente on 8/28/14.
//  Copyright (c) 2014 Fernando Valente. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FVAppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSTableView *tableView;
    
    IBOutlet NSImageView *appIcon;
    IBOutlet NSTextField *appName;
    IBOutlet NSTextField *appDomain;
    IBOutlet NSTextField *bundleURL;
    IBOutlet NSTextField *launchDate;
    
    IBOutlet NSButton *hideButton;
    IBOutlet NSButton *makeKeyAppButton;
    IBOutlet NSButton *showInFinderButton;
    
    NSArray *runningApps;
}

-(void)getRunningApps:(NSTimer *)timer;

-(IBAction)makeKeyApp:(id)sender;
-(IBAction)hideApp:(id)sender;
-(IBAction)showInFinder:(id)sender;
-(IBAction)forceQuit:(id)sender;
-(IBAction)quitApp:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
