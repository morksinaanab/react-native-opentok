/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import UIKit;
#import "RCTOpenTokSessionProvider.h"
#import "RCTOpenTokPublisherView.h"
#import "React/RCTEventDispatcher.h"
#import "React/RCTUtils.h"

@interface RCTOpenTokPublisherView () <OTPublisherDelegate>

@end

@implementation RCTOpenTokPublisherView {
    OTSession *_session;
    OTPublisher *_publisher;
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
 * Calls `onStartFailure` in case an error happens during initial creation.
 *
 * Otherwise, `onSessionCreated` callback is called asynchronously
 */
- (void)mount {
  [self initSession];
}

- (void)initSession {
  RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
  [sessionManager initSessionWithApiKey:_apiKey sessionId:_sessionId token:_token];
  sessionManager.publisherView = self;
  _session = [sessionManager session];
  NSLog(@"RCTOpenTokPublisherView session %@",_session);

}

/**
 * Creates an instance of `OTPublisher` and publishes stream to the current
 * session
 *
 * Calls `onPublishError` in case of an error, otherwise, a camera preview is inserted
 * inside the mounted view
 */
- (void)startPublishing {
    _publisher = [[OTPublisher alloc] initWithDelegate:self];

    OTError *error = nil;
  
    RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
    _session = [sessionManager session];

    [_session publish:_publisher error:&error];

    if (error) {
        _onPublishError(RCTJSErrorFromNSError(error));
        return;
    }

    [self attachPublisherView];
}

/**
 * Attaches publisher preview
 */
- (void)attachPublisherView {
    [_publisher.view setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:_publisher.view];
}

/**
 * Cleans up publisher
 */
- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
}

#pragma mark - OTSession forwarded delegate callbacks


- (void)sessionDidConnect:(OTSession*)session {
  NSLog(@"RCTOpenTokPublisherView.sessionDidConnect %@",session);
  [self startPublishing];
}

- (void)sessionDidDisconnect:(OTSession*)session {
  NSLog(@"RCTOpenTokPublisherView.sessionDidDisconnect %@",session);
}

- (void)session:(OTSession*)session streamCreated:(OTStream *)stream {
  NSLog(@"RCTOpenTokPublisherView.streamCreated %@",stream);
}
- (void)session:(OTSession*)session streamDestroyed:(OTStream *)stream {
  NSLog(@"RCTOpenTokPublisherView.streamDestroyed %@",stream);
}
- (void)session:(OTSession *)session connectionCreated:(OTConnection *)connection {
  NSLog(@"RCTOpenTokPublisherView.connectionCreated %@",connection);
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
  
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *creationTimeString = [dateFormatter stringFromDate:connection.creationTime];
  
  NSLog(@"OPENTOK connection.connectionId: %@",connection.connectionId);
  NSLog(@"OPENTOK creationTimeString:%@",creationTimeString);
  NSLog(@"OPENTOK connection.data:%@",connection.data);
  
  if ( connection.data == nil) {
    _onClientConnected(@{
                         @"connectionId": connection.connectionId,
                         @"creationTime": creationTimeString,
                         });
  } else {
    _onClientConnected(@{
                         @"connectionId": connection.connectionId,
                         @"creationTime": creationTimeString,
                         @"data": connection.data,
                         });
  }
}

- (void)session:(OTSession *)session connectionDestroyed:(OTConnection *)connection {
  NSLog(@"RCTOpenTokPublisherView.connectionDestroyed %@",connection);
  _onClientDisconnected(@{ @"connectionId": connection.connectionId, });
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
  NSLog(@"RCTOpenTokPublisherView.didFailWithError %@",error);
    _onPublishError(RCTJSErrorFromNSError(error));
}

#pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit*)publisher streamCreated:(OTStream *)stream {
    _onPublishStart(@{});
}

- (void)publisher:(OTPublisherKit*)publisher streamDestroyed:(OTStream *)stream {
    _onPublishStop(@{});
    [self cleanupPublisher];
}

- (void)publisher:(OTPublisherKit*)publisher didFailWithError:(OTError*)error {
    _onPublishError(RCTJSErrorFromNSError(error));
    [self cleanupPublisher];
}

/**
 * Remove session when this component is unmounted
 */
- (void)dealloc {
    [self cleanupPublisher];
    RCTOpenTokSessionProvider *sessionManager = [RCTOpenTokSessionProvider sharedSession];
    _session = [sessionManager session];
    [_session disconnect:nil];
}

@end
