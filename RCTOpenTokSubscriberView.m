/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import UIKit;
#import "RCTOpenTokSubscriberView.h"
#import "RCTOpenTokSessionProvider.h"
#import "React/RCTEventDispatcher.h"
#import "React/RCTUtils.h"

@interface RCTOpenTokSubscriberView () <OTSessionDelegate, OTSubscriberDelegate>

@end

@implementation RCTOpenTokSubscriberView {
    OTSession *_session;
    OTSubscriber *_subscriber;
}

/**
 * Mounts component after all props were passed
 */
- (void)didMoveToWindow {
    [super didMoveToSuperview];
    [self mount];
}

/**
 * Creates a new session with a given apiKey, sessionID and token
 *
 * Calls `onSubscribeError` in case an error happens during initial creation.
 */
- (void)mount {
    [self cleanupSubscriber];
    [self initSession];
}

- (void)initSession {
    RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
    [sessionManager initSessionWithApiKey:_apiKey sessionId:_sessionId token:_token];
    sessionManager.subscriberView = self;
    _session = [sessionManager session];
    NSLog(@"RCTOpenTokPublisherView session %@",_session);
  
}
/**
 * Creates an instance of `OTSubscriber` and subscribes to stream in current
 * session
 */
- (void)doSubscribe:(OTStream*)stream {
    _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    OTError *error = nil;

    RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
    _session = [sessionManager session];

    [_session subscribe:_subscriber error:&error];

    if (error)
    {
      _onSubscribeError(RCTJSErrorFromNSError(error));
      return;
    }

    [self attachSubscriberView];
}

/**
 * Attaches subscriber preview
 */
- (void)attachSubscriberView {
    [_subscriber.view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_subscriber.view];
}

/**
 * Cleans subscriber
 */
- (void)cleanupSubscriber {
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

#pragma mark - OTSession forwarded callbacks
- (void)sessionDidConnect:(OTSession*)session {}
- (void)sessionDidDisconnect:(OTSession*)session {}
- (void)session:(OTSession*)session streamCreated:(OTStream*)stream {
  NSLog(@"session stream created");
  if (_subscriber == nil) {
    [self doSubscribe:stream];
  }
}
- (void)session:(OTSession*)session streamDestroyed:(OTStream*)stream {
  _onSubscribeStop(@{});
}
- (void)session:(OTSession*)session connectionCreated:(OTConnection *)connection {}
- (void)session:(OTSession*)session connectionDestroyed:(OTConnection *)connection {}
- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
  _onSubscribeError(RCTJSErrorFromNSError(error));
}


#pragma mark - OTSubscriber delegate callbacks

- (void)subscriber:(OTSubscriberKit*)subscriber didFailWithError:(OTError*)error {
    _onSubscribeError(RCTJSErrorFromNSError(error));
    [self cleanupSubscriber];
}

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber {
    _onSubscribeStart(@{});
}

- (void)subscriberDidDisconnectFromStream:(OTSubscriberKit*)subscriber {
    _onSubscribeStop(@{});
    [self cleanupSubscriber];
}

- (void)subscriberDidReconnectToStream:(OTSubscriberKit*)subscriber {
    _onSubscribeStart(@{});
}

/**
 * Remove session when this component is unmounted
 */
- (void)dealloc {
    [self cleanupSubscriber];
    RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
    _session = [sessionManager session];

    [_session disconnect:nil];
}

@end
