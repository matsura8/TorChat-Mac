/*
 *  TCPanel_Security.m
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

#import "TCPanel_Security.h"

#import "TCLogsManager.h"

#import "TCDebugLog.h"
#import "TCConfigSQLite.h"


/*
** TCPanel_Security - Private
*/
#pragma mark - TCPanel_Security - Private

@interface TCPanel_Security ()
{
	IBOutlet NSButton *encryptCheckBox;
	
	IBOutlet NSTextField *passwordTitle;
	IBOutlet NSTextField *verifyTitle;
	
	IBOutlet NSSecureTextField *passwordField;
	IBOutlet NSSecureTextField *verifyField;
}

@end



/*
** TCPanel_Security
*/
#pragma mark - TCPanel_Security

@implementation TCPanel_Security

@synthesize panelProxy;
@synthesize panelPreviousContent;

- (void)dealloc
{
    TCDebugLog(@"TCPanel_Security dealloc");
}



/*
** TCPanel_Security - SMAssistantPanel
*/
#pragma mark - TCPanel_Security - SMAssistantPanel

+ (id <SMAssistantPanel>)panelInstance
{
	return [[TCPanel_Security alloc] initWithNibName:@"AssistantPanel_Security" bundle:nil];
}

+ (NSString *)panelIdentifier
{
	return @"ac_security";
}

+ (NSString *)panelTitle
{
	return NSLocalizedString(@"ac_title_security", @"");
}

- (NSView *)panelView
{
	return self.view;
}

- (id)panelContent
{
	// Build configuration path.
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	NSString *configPath = [[bundlePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"torchat.conf"];
	
	if (!configPath)
	{
		[[TCLogsManager sharedManager] addGlobalLogWithKind:TCLogError message:@"ac_error_build_path"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSAlert alertWithMessageText:NSLocalizedString(@"logs_error_title", @"") defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"ac_error_build_path", @"")] runModal];
			exit(0);
		});
	}
	
	// Build configuration file.
	NSError			*error = nil;
	TCConfigSQLite	*config = nil;
	
	if (encryptCheckBox.state == NSOnState)
	{
		config = [[TCConfigSQLite alloc] initWithFile:configPath password:passwordField.stringValue error:&error];
		
		config.saveTranscript = YES;
	}
	else
	{
		config = [[TCConfigSQLite alloc] initWithFile:configPath password:nil error:&error];
	}

	if (!config)
	{
		[[TCLogsManager sharedManager] addGlobalLogWithKind:TCLogError message:@"ac_error_build_path"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[NSAlert alertWithMessageText:NSLocalizedString(@"logs_error_title", @"") defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"ac_error_write_file", @""), configPath] runModal];
			exit(0);
		});

		return nil;
	}
	
	// Return config.
	return config;
}

- (void)panelDidAppear
{
	[self.panelProxy setIsLastPanel:NO];
	[self.panelProxy setNextPanelID:@"ac_mode"];
	
	[self checkValidity];
}


/*
** TCPanel_Security - IBAction
*/
#pragma mark - TCPanel_Security - IBAction

- (IBAction)doEncrypt:(id)sender
{
	passwordTitle.enabled = (encryptCheckBox.state == NSOnState);
	verifyTitle.enabled = (encryptCheckBox.state == NSOnState);
	passwordField.enabled = (encryptCheckBox.state == NSOnState);
	verifyField.enabled = (encryptCheckBox.state == NSOnState);
	
	[self checkValidity];
}



/*
** TCPanel_Security - NSControlDelegate
*/
#pragma mark - TCPanel_Security - NSControlDelegate

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	[self checkValidity];
}



/*
** TCPanel_Security - Tools
*/
#pragma mark - TCPanel_Security - Tools

- (void)checkValidity
{
	if (encryptCheckBox.state == NSOnState)
		[self.panelProxy setDisableContinue:(passwordField.stringValue.length == 0 || [passwordField.stringValue isEqualToString:verifyField.stringValue] == NO)];
	else
		[self.panelProxy setDisableContinue:NO];
}

@end
