/*
 *  TCFileReceive.h
 *
 *  Copyright 2019 Avérous Julien-Pierre
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

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


/*
** TCFileReceive
*/
#pragma mark - TCFileReceive

@interface TCFileReceive : NSObject

// -- Properties --
@property (strong, nonatomic, readonly) NSString	*uuid;
@property (assign, nonatomic, readonly) uint64_t	fileSize;
@property (assign, nonatomic, readonly) uint64_t	blockSize;
@property (strong, nonatomic, readonly) NSString	*fileName;
@property (strong, nonatomic, readonly) NSString	*filePath;

@property (nonatomic, getter=isFinished, readonly) BOOL finished;
@property (nonatomic, readonly) uint64_t receivedSize;

// -- Instance --
- (nullable instancetype)initWithUUID:(NSString *)uuid folder:(NSString *)folder fileName:(NSString *)fileName fileSize:(uint64_t)fileSize blockSiz:(uint64_t)blockSize NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

// -- Tools --
- (BOOL)writeChunk:(const void *)bytes chunkSize:(uint64_t)chunkSize hash:(NSString *)hash offset:(uint64_t *)offset;

@end


NS_ASSUME_NONNULL_END
