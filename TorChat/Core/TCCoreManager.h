/*
 *  TCCoreManager.h
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

@import Foundation;
@import SMFoundation;

#import "TCConfigCore.h"
#import "TCBuddy.h"


/*
** Globals
*/
#pragma mark - Globals

#define TCCoreManagerInfoDomain	@"TCCoreManagerInfoDomain"



/*
** Forward
*/
#pragma mark - Forward

@class TCCoreManager;
@class TCImage;



/*
** Types
*/
#pragma mark - Types

// == Info Code ==
typedef enum
{
	TCCoreEventStarted,
	TCCoreEventStopped,
	TCCoreEventStatus,			// context: NSNumber (TCStatus)
	
	TCCoreEventProfileAvatar,	// context: TCImage
	TCCoreEventProfileName,		// context: NSString (<name>)
	TCCoreEventProfileText,		// context: NSString (<text>)
	
	TCCoreEventBuddyNew,		// context: TCBuddy
	TCCoreEventBuddyRemove,		// context: TCBuddy

	TCCoreEventBuddyBlocked,	// context: TCBuddy
	TCCoreEventBuddyUnblocked,	// context: TCBuddy

	TCCoreEventClientStarted,
	TCCoreEventClientStopped,
} TCCoreEvent;

typedef enum
{
	TCCoreErrorServAccept,
	TCCoreErrorServAcceptAsync,
	
	TCCoreErrorSocket,			// info: SMInfo (SMSocketInfoDomain)
	TCCoreErrorSocketCreate,
	TCCoreErrorSocketOption,
	TCCoreErrorSocketBind,
	TCCoreErrorSocketListen,

	TCCoreErrorClientAlreadyPinged,
	TCCoreErrorClientMasquerade,
	TCCoreErrorClientAddBuddy,
	
	TCCoreErrorClientCmdUnknownCommand,		// context: NSString (<parser_error>)
	
	TCCoreErrorClientCmdPing,				// context: NSString (<parser_error>)
	TCCoreErrorClientCmdPong,				// context: NSString (<parser_error>)
	TCCoreErrorClientCmdStatus,				// context: NSString (<parser_error>)
	TCCoreErrorClientCmdVersion,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdClient,				// context: NSString (<parser_error>)
	TCCoreErrorClientCmdProfileText,		// context: NSString (<parser_error>)
	TCCoreErrorClientCmdProfileName,		// context: NSString (<parser_error>)
	TCCoreErrorClientCmdProfileAvatar,		// context: NSString (<parser_error>)
	TCCoreErrorClientCmdProfileAvatarAlpha,	// context: NSString (<parser_error>)
	TCCoreErrorClientCmdMessage,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdAddMe,				// context: NSString (<parser_error>)
	TCCoreErrorClientCmdRemoveMe,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileName,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileData,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileDataOk,			// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileDataError,		// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileStopSending,	// context: NSString (<parser_error>)
	TCCoreErrorClientCmdFileStopReceiving,	// context: NSString (<parser_error>)
} TCCoreError;

// -- Observer --
@protocol TCCoreManagerObserver <NSObject>

- (void)torchatManager:(TCCoreManager *)manager information:(SMInfo *)info;

@end




/*
** TCCoreManager
*/
#pragma mark - TCCoreManager

@interface TCCoreManager : NSObject


// -- Instance --
- (id)initWithConfiguration:(id <TCConfigCore>)config;

// -- Life --
- (void)start;
- (void)stopWithCompletionHandler:(dispatch_block_t)handler;

// -- Status --
@property (assign, atomic) TCStatus status;

// -- Profile --
@property (strong, atomic) TCImage	*profileAvatar;
@property (strong, atomic) NSString	*profileName;
@property (strong, atomic) NSString	*profileText;

// -- Buddies --
@property (copy, atomic, readonly) NSArray *buddies;

- (void)addBuddyWithIdentifier:(NSString *)identifier name:(NSString *)name;
- (void)addBuddyWithIdentifier:(NSString *)identifier name:(NSString *)name comment:(NSString *)comment;
- (void)removeBuddyWithIdentifier:(NSString *)identifier;
- (TCBuddy *)buddyWithIdentifier:(NSString *)identifier;
- (TCBuddy *)buddyWithRandom:(NSString *)random;

// -- Blocked Buddies --
- (void)addBlockedBuddyWithIdentifier:(NSString *)identifier;
- (void)removeBlockedBuddyWithIdentifier:(NSString *)identifier;

// -- Observers --
- (void)addObserver:(id <TCCoreManagerObserver>)observer;
- (void)removeObserver:(id <TCCoreManagerObserver>)observer;

@end
