/*
 *  TCFileSend.h
 *
 *  Copyright 2018 Avérous Julien-Pierre
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
** TCFileSend
*/
#pragma mark - TCFileSend

@interface TCFileSend : NSObject

// -- Properties --
@property (nonatomic, readonly) NSString *uuid;

@property (assign, nonatomic, readonly)		uint64_t	fileSize;
@property (nonatomic, readonly)				NSString	*fileName;
@property (nullable, nonatomic, readonly)	NSString	*filePath;

@property (nonatomic, getter=isFinished, readonly) BOOL finished;

@property (nonatomic, readonly) uint16_t blockSize;
@property (nonatomic, readonly) uint64_t validatedSize;
@property (nonatomic, readonly) uint64_t readSize;

// -- Instance --
- (nullable instancetype)initWithFilePath:(NSString *)filePath NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFileData:(NSData *)data fileName:(NSString *)fileName NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

// -- Content --
- (nullable NSString *)readChunk:(void *)bytes chunkSize:(uint64_t *)chunkSize fileOffset:(uint64_t *)fileOffset;
- (void)setNextChunkOffset:(uint64_t)offset;
- (void)setValidatedOffset:(uint64_t)offset;

@end


NS_ASSUME_NONNULL_END
