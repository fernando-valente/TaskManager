//
//  FVAppDelegate.m
//  TaskManager
//
//  Created by Fernando Valente on 8/28/14.
//  Copyright (c) 2014 Fernando Valente. All rights reserved.
//

#import "FVAppDelegate.h"

@implementation FVAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [tableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [self getRunningApps:nil];
}

-(void)getRunningApps:(NSTimer *)timer{
    runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
    
    [tableView reloadData];
    
    [self tableViewSelectionDidChange:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getRunningApps:) userInfo:nil repeats:NO];
}

#pragma mark Buttons

-(IBAction)makeKeyApp:(id)sender{
    NSInteger selectedRow = [tableView selectedRow];
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    [app activateWithOptions:NSApplicationActivateAllWindows];
}

-(IBAction)hideApp:(id)sender{
    NSInteger selectedRow = [tableView selectedRow];
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    if([app isHidden]){
        [app unhide];
        [hideButton setTitle:@"Hide"];
    }
    else{
        [app hide];
        [hideButton setTitle:@"Show"];
    }
}

-(IBAction)showInFinder:(id)sender{
    NSInteger selectedRow = [tableView selectedRow];
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    NSURL *URL = [app bundleURL];
    NSArray *URLArray = [NSArray arrayWithObject:URL];
    
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:URLArray];
}

-(IBAction)forceQuit:(id)sender{
    NSInteger selectedRow = [tableView selectedRow];
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    [app forceTerminate];
}

-(IBAction)quitApp:(id)sender{
    NSInteger selectedRow = [tableView selectedRow];
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    [app terminate];
}

#pragma mark TableView

-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return [runningApps count];
}

-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    if([[[aTableColumn headerCell] stringValue] isEqualToString:@"Icon"]){
        return [[runningApps objectAtIndex:rowIndex] icon];
    }
    
    return [[runningApps objectAtIndex:rowIndex] localizedName];
}

-(void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    NSInteger selectedRow = [tableView selectedRow];
    
    if(selectedRow == -1)
        return;
    
    NSRunningApplication *app = [runningApps objectAtIndex:selectedRow];
    
    NSImage *icon = [app icon];
    NSString *name = [app localizedName];
    NSString *bundle = [app bundleIdentifier];
    NSString *location = [[app bundleURL] absoluteString];
    NSDate *date = [app launchDate];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formater stringFromDate:date];
    
    if(!dateString)
        dateString = @"Information not available";
    
    if(!bundle)
        bundle = @"Information not available";
    
    if(!location){
        location = @"Information not available";
        [showInFinderButton setEnabled:NO];
    }
    else{
        [showInFinderButton setEnabled:YES];
    }
    
    if([app isHidden]){
        [hideButton setTitle:@"Show"];
    }
    else{
        [hideButton setTitle:@"Hide"];
    }
    
    if([app activationPolicy] != NSApplicationActivationPolicyRegular){
        [hideButton setEnabled:NO];
        [makeKeyAppButton setEnabled:NO];
    }
    else{
        [hideButton setEnabled:YES];
        [makeKeyAppButton setEnabled:YES];
    }
    
    [icon setSize:NSMakeSize(512, 512)];
    
    [appName setStringValue:name];
    [appDomain setStringValue:bundle];
    [bundleURL setStringValue:location];
    [launchDate setStringValue:dateString];
    [appIcon setImage:icon];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    if([rowIndexes count] == 0 || [rowIndexes containsIndex:-1])
        return NO;
    
    NSRunningApplication *app = [[runningApps objectsAtIndexes:rowIndexes] objectAtIndex:0];
    
    NSData *name = [[app localizedName] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *image = [[app icon] TIFFRepresentation];
    
    [pboard declareTypes:[NSArray arrayWithObjects:NSPasteboardTypeString, NSPasteboardTypeTIFF, nil] owner:self];
    
    [pboard setData:name forType:NSPasteboardTypeString];
    [pboard setData:image forType:NSPasteboardTypeTIFF];
    
    return YES;
}

@end
