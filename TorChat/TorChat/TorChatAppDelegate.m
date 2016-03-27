/*
 *  TorChatAppDelegate.m
 *
 *  Copyright 2016 Avérous Julien-Pierre
 *
 *  This file is part of TorChat.
 *
 *  TorChat is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  TorChat is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TorChat.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "TorChatAppDelegate.h"

#import "TCMainController.h"
#import "TCBuddiesWindowController.h"
#import "TCFilesWindowController.h"
#import "TCBuddyInfoWindowsController.h"
#import "TCLogsWindowController.h"
#import "TCPreferencesWindowController.h"
#import "TCChatWindowController.h"

#import "TCBuddy.h"
#import "TCCoreManager.h"


/*
** TorChatAppDelegate - Private
*/
#pragma mark - TorChatAppDelegate - Private

@interface TorChatAppDelegate () <TCCoreManagerObserver>
{
	BOOL _loaded;
	BOOL _quitting;
}

@property (strong, nonatomic) IBOutlet NSMenuItem	*buddyShowMenu;
@property (strong, nonatomic) IBOutlet NSMenuItem	*buddyDeleteMenu;
@property (strong, nonatomic) IBOutlet NSMenuItem	*buddyChatMenu;
@property (strong, nonatomic) IBOutlet NSMenuItem	*buddyBlockMenu;
@property (strong, nonatomic) IBOutlet NSMenuItem	*buddyFileMenu;


- (IBAction)showPreferences:(id)sender;

- (IBAction)showTransfers:(id)sender;
- (IBAction)showBuddies:(id)sender;
- (IBAction)showLogs:(id)sender;
- (IBAction)showMessages:(id)sender;

- (IBAction)doBuddyShowInfo:(id)sender;
- (IBAction)doBuddyAdd:(id)sender;
- (IBAction)doBuddyRemove:(id)sender;
- (IBAction)doBuddyChat:(id)sender;
- (IBAction)doBuddyToggleBlocked:(id)sender;
- (IBAction)doBuddySendFile:(id)sender;

- (IBAction)doEditProfile:(id)sender;

@end



/*
** TorChatAppDelegate
*/
#pragma mark - TorChatAppDelegate

@implementation TorChatAppDelegate


/*
** TorChatAppDelegate - Life
*/
#pragma mark - TorChatAppDelegate - Life

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Observe buddy select change.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buddySelectChanged:) name:TCBuddiesWindowControllerSelectChanged object:nil];

	// Start TorChat.
	[[TCMainController sharedController] startWithCompletionHandler:^(id <TCConfigAppEncryptable> configuration, TCCoreManager *core) {
		
		if (!configuration || !core)
		{
			[[NSApplication sharedApplication] terminate:nil];
			return;
		}
		
		[core addObserver:self];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			_loaded = YES;
		});
	}];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	_quitting = YES;
	
	[[TCMainController sharedController] stopWithCompletionHandler:^{
		[sender replyToApplicationShouldTerminate:YES];
	}];
	
	return NSTerminateLater;
}



/*
** TorChatAppDelegate - IBActions
*/
#pragma mark - TorChatAppDelegate - IBActions

#pragma mark Application

- (IBAction)showPreferences:(id)sender
{
	[[TCPreferencesWindowController sharedController] showWindow:nil];
}

- (IBAction)doQuit:(id)sender
{
	[[NSApplication sharedApplication] terminate:sender];
}


#pragma mark Windows

- (IBAction)showTransfers:(id)sender
{
	[[TCFilesWindowController sharedController] showWindow:sender];
}

- (IBAction)showBuddies:(id)sender
{
	[[TCBuddiesWindowController sharedController] showWindow:sender];
}

- (IBAction)showLogs:(id)sender
{
	[[TCLogsWindowController sharedController] showWindow:sender];
}

- (IBAction)showMessages:(id)sender
{
	[[TCChatWindowController sharedController] openChatWithBuddy:nil select:YES];
}


#pragma mark Buddies

- (IBAction)doBuddyShowInfo:(id)sender
{
	[[TCBuddiesWindowController sharedController] doShowInfo:sender];
}

- (IBAction)doBuddyAdd:(id)sender
{
	[[TCBuddiesWindowController sharedController] doAdd:sender];
}

- (IBAction)doBuddyRemove:(id)sender
{
	[[TCBuddiesWindowController sharedController] doRemove:sender];
}

- (IBAction)doBuddyChat:(id)sender
{
	[[TCBuddiesWindowController sharedController] doChat:sender];
}

- (IBAction)doBuddySendFile:(id)sender
{
	[[TCBuddiesWindowController sharedController] doSendFile:sender];
}

- (IBAction)doBuddyToggleBlocked:(id)sender
{
	[[TCBuddiesWindowController sharedController] doToggleBlock:sender];
}

- (IBAction)doEditProfile:(id)sender
{
	[[TCBuddiesWindowController sharedController] doEditProfile:sender];
}



/*
** TorChatAppDelegate - NSMenuItem
*/
#pragma mark - TorChatAppDelegate - NSMenuItem

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if (_loaded == NO)
		return NO;
	else
	{
		if (menuItem.action == @selector(doQuit:))
			return (_quitting == NO);

		return YES;
	}
}



/*
** TorChatAppDelegate - TCCoreManagerObserver
*/
#pragma mark - TCCoreManagerObserver

- (void)torchatManager:(TCCoreManager *)manager information:(SMInfo *)info
{
	if (info.kind == SMInfoInfo && (info.code == TCCoreEventBuddyBlocked || info.code == TCCoreEventBuddyUnblocked))
	{
		dispatch_async(dispatch_get_main_queue(), ^{

			TCBuddy		*buddy = info.context;
			NSString	*selected = [[[TCBuddiesWindowController sharedController] selectedBuddy] identifier];
			
			if ([buddy.identifier isEqualToString:selected])
			{
				if (info.code == TCCoreEventBuddyBlocked)
					[_buddyBlockMenu setTitle:NSLocalizedString(@"menu_unblock_buddy", @"")];
				else
					[_buddyBlockMenu setTitle:NSLocalizedString(@"menu_block_buddy", @"")];
			}
		});
	}
}



/*
** TorChatAppDelegate - NSNotification
*/
#pragma mark - TorChatAppDelegate - NSNotification

- (void)buddySelectChanged:(NSNotification *)notice
{
	NSDictionary	*ui = [notice userInfo];
	id				buddy = [ui objectForKey: TCBuddiesWindowControllerBuddyKey];
		
	if ([buddy isKindOfClass:[TCBuddy class]])
	{
		[_buddyShowMenu setTarget:self];
		[_buddyShowMenu setAction:@selector(doBuddyShowInfo:)];
		
		[_buddyDeleteMenu setTarget:self];
		[_buddyDeleteMenu setAction:@selector(doBuddyRemove:)];
		
		[_buddyChatMenu setTarget:self];
		[_buddyChatMenu setAction:@selector(doBuddyChat:)];
		
		[_buddyBlockMenu setTarget:self];
		[_buddyBlockMenu setAction:@selector(doBuddyToggleBlocked:)];
		
		if ([buddy blocked])
			[_buddyBlockMenu setTitle:NSLocalizedString(@"menu_unblock_buddy", @"")];
		else
			[_buddyBlockMenu setTitle:NSLocalizedString(@"menu_block_buddy", @"")];
		
		[_buddyFileMenu setTarget:self];
		[_buddyFileMenu setAction:@selector(doBuddySendFile:)];
	}
	else
	{
		[_buddyShowMenu setTarget:nil];
		[_buddyShowMenu setAction:NULL];
		
		[_buddyDeleteMenu setTarget:nil];
		[_buddyDeleteMenu setAction:NULL];
		
		[_buddyChatMenu setTarget:nil];
		[_buddyChatMenu setAction:NULL];
		
		[_buddyBlockMenu setTarget:nil];
		[_buddyBlockMenu setAction:NULL];
		[_buddyBlockMenu setTitle:NSLocalizedString(@"menu_block_buddy", @"")];

		[_buddyFileMenu setTarget:nil];
		[_buddyFileMenu setAction:NULL];
	}
}

@end
