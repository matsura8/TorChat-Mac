/*
 *  TCFilesWindowController.h
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

#import <Cocoa/Cocoa.h>

#import "TCFilesCommon.h"


NS_ASSUME_NONNULL_BEGIN


/*
** Forward
*/
#pragma mark - Forward

@class TCCoreManager;



/*
** TCFilesWindowController
*/
#pragma mark - TCFilesWindowController

// == Class ==
@interface TCFilesWindowController : NSWindowController

// -- Instance --
+ (TCFilesWindowController *)sharedController;

// -- Life --
- (void)startWithCoreManager:(TCCoreManager *)coreMananager completionHandler:(dispatch_block_t)handler;
- (void)stopWithCompletionHandler:(dispatch_block_t)handler;

@end


NS_ASSUME_NONNULL_END
