//
//  RCTOpenTokSharedInfo.h
//  KijkBijMij
//
//  Created by Harrie van der Lubbe on 04-08-17.
//  Copyright © 2017 Facebook. All rights reserved.
//
#import <foundation/Foundation.h>
#import <OpenTok/OpenTok.h>

@interface RCTOpenTokSharedInfo : NSObject

@property OTSession *session;
@property OTStream *latestIncomingVideoStream;
@property OTSubscriber *incomingVideoSubscriber;
@property OTPublisher *outgoingVideoPublisher;
@property OTStream *outgoingVideoStream;

+ (id)sharedInstance;

@end
