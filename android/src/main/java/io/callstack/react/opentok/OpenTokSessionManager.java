package io.callstack.react.opentok;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.opentok.android.OpentokError;
import com.opentok.android.Publisher;
import com.opentok.android.PublisherKit;
import com.opentok.android.Subscriber;
import com.opentok.android.Session;
import com.opentok.android.Stream;
import com.opentok.android.Connection;
import com.opentok.android.SubscriberKit;

import java.util.Map;

public class OpenTokSessionManager extends ReactContextBaseJavaModule implements Subscriber.SubscriberListener, Subscriber.StreamListener, Publisher.PublisherListener, Publisher.CameraListener, Session.SessionListener, Session.ConnectionListener, Session.SignalListener {


//    android.permission.CAMERA
//    android.permission.INTERNET
//    android.permission.RECORD_AUDIO
//    android.permission.MODIFY_AUDIO_SETTINGS
//    android.permission.BLUETOOTH
//    android.permission.BROADCAST_STICKY

    protected OpenTokSharedInfo sharedInfo;
    protected Session mSession;

    public OpenTokSessionManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "OpenTokSessionManager";
    }

    @ReactMethod
    public void audioOn() {
        Log.d("OPENTOK","OpenTokSessionManager.audioOn");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.audioIsOn = true;
        }
        updateAudioState();
    }

    @ReactMethod
    public void audioOff() {
        Log.d("OPENTOK","OpenTokSessionManager.audioOff");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.audioIsOn = false;
        }
        updateAudioState();
    }

    @ReactMethod
    public void videoOn() {
        Log.d("OPENTOK","OpenTokSessionManager.videoOn");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.videoIsOn = true;
        }
        updateVideoState();
    }

    @ReactMethod
    public void videoOff() {
        Log.d("OPENTOK","OpenTokSessionManager.videoOff");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.videoIsOn = false;
        }
        updateVideoState();
    }

    @ReactMethod
    public void cameraFront() {
        Log.d("OPENTOK","OpenTokSessionManager.cameraFront");
        //this cannot be done the same way in android. quick hack for now
        updateCameraState();
    }

    @ReactMethod
    public void cameraBack() {
        Log.d("OPENTOK","OpenTokSessionManager.cameraBack");
        //this cannot be done the same way in android. quick hack for now
        updateCameraState();
    }

    @ReactMethod
    public void connect(String apiKey, String sessionId, String token) {
        //no exception or error handling?
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        sharedInfo.session = new Session(getReactApplicationContext(), apiKey, sessionId);
        sharedInfo.session.setSessionListener(this);
        sharedInfo.session.setSignalListener(this);
        sharedInfo.session.setConnectionListener(this);
        sharedInfo.session.connect(token);

    }

    @ReactMethod
    public void sendMessage(String message) {

        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.session.sendSignal("message",message);
        } else {
            Log.d("OPENTOK","OpenTokSessionManager.sendMessage session was null");
        }

    }

    @ReactMethod
    public void clearSession() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session == null) {
            sharedInfo.session.disconnect();
            sharedInfo.session = null;
            Log.d("OPENTOK","OpenTokSessionManager.clearSession cleared");
        } else {
            Log.d("OPENTOK","OpenTokSessionManager.clearSession was already null");
        }
    }

    @ReactMethod
    public void startPublishing() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null) {
            sharedInfo.outgoingVideoPublisher = new Publisher(getReactApplicationContext());
            sharedInfo.outgoingVideoPublisher.setCameraListener(this);
            sharedInfo.outgoingVideoPublisher.setPublisherListener(this);
            updatePublishState();
            sharedInfo.session.publish(sharedInfo.outgoingVideoPublisher);
            Log.d("OPENTOK","OpenTokSessionManager.startPublishing done");
        } else {
            Log.d("OPENTOK","OpenTokSessionManager.startPublishing session was null");
        }
    }

    @ReactMethod
    public void stopPublishing() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.outgoingVideoPublisher != null) {
            sharedInfo.session.unpublish(sharedInfo.outgoingVideoPublisher);
            Log.d("OPENTOK","OpenTokSessionManager.stopPublishing done");
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.stopPublishing session was null");
            if (sharedInfo.outgoingVideoPublisher == null) Log.d("OPENTOK","OpenTokSessionManager.stopPublishing publisher was null");
        }
    }


    @ReactMethod
    public void startReceiving() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.latestIncomingVideoStream != null) {
            sharedInfo.incomingVideoSubscriber = new Subscriber(getReactApplicationContext(),sharedInfo.latestIncomingVideoStream);
            sharedInfo.incomingVideoSubscriber.setSubscriberListener(this);

            sharedInfo.session.subscribe(sharedInfo.incomingVideoSubscriber);
            Log.d("OPENTOK","OpenTokSessionManager.startReceiving done");
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.startReceiving session was null");
            if (sharedInfo.latestIncomingVideoStream == null) Log.d("OPENTOK","OpenTokSessionManager.startReceiving videostream was null");
        }
    }

    @ReactMethod
    public void stopReceiving() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.incomingVideoSubscriber != null) {
            sharedInfo.session.unsubscribe(sharedInfo.incomingVideoSubscriber);
            Log.d("OPENTOK","OpenTokSessionManager.stopReceiving done");
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.stopReceiving session was null");
            if (sharedInfo.incomingVideoSubscriber == null) Log.d("OPENTOK","OpenTokSessionManager.stopReceiving subcriber was null");
        }
    }

    protected void sendEvent(Events event) {
        sendEvent(event, "");
    }

    protected void sendEvent(Events event, String data) {
        ReactContext reactContext = (ReactContext)getReactApplicationContext();
        reactContext.getJSModule(RCTNativeAppEventEmitter.class).emit(event.toString(), data);
    }


    /* Publisher manipulation */
    protected void updateAudioState() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.outgoingVideoPublisher != null) {
            sharedInfo.outgoingVideoPublisher.setPublishAudio(sharedInfo.audioIsOn);
            Log.d("OPENTOK","OpenTokSessionManager.updateAudioState to:" + (sharedInfo.audioIsOn?"TRUE":"FALSE"));
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.updateAudioState session was null");
            if (sharedInfo.outgoingVideoPublisher == null) Log.d("OPENTOK","OpenTokSessionManager.updateAudioState publisher was null");
        }
    }

    protected void updateVideoState() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.outgoingVideoPublisher != null) {
            sharedInfo.outgoingVideoPublisher.setPublishVideo(sharedInfo.videoIsOn);
            Log.d("OPENTOK","OpenTokSessionManager.updateVideoState to:" + (sharedInfo.audioIsOn?"TRUE":"FALSE"));
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.updateAudioState session was null");
            if (sharedInfo.outgoingVideoPublisher == null) Log.d("OPENTOK","OpenTokSessionManager.updateVideoState publisher was null");
        }
    }

    protected  void updateCameraState() {
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        if (sharedInfo.session != null && sharedInfo.outgoingVideoPublisher != null) {
            sharedInfo.outgoingVideoPublisher.cycleCamera();
            Log.d("OPENTOK","OpenTokSessionManager.cycledCamera");
        } else {
            if (sharedInfo.session == null) Log.d("OPENTOK","OpenTokSessionManager.updateAudioState session was null");
            if (sharedInfo.outgoingVideoPublisher == null) Log.d("OPENTOK","OpenTokSessionManager.updateVideoState publisher was null");
        }
    }

    protected void updatePublishState() {
        updateAudioState();
        updateVideoState();
        updateCameraState();
    }

    /* Session Listener Methods */

    @Override
    public void onConnected(Session session) {
        Log.d("OPENTOK","OpenTokSessionManager.session.sessionDidConnect");
        sendEvent(Events.EVENT_SESSION_CONNECTED);
    }

    @Override
    public void onDisconnected(Session session) {
        Log.d("OPENTOK","OpenTokSessionManager.session.sessionDidDisconnect");
        sendEvent(Events.EVENT_SESSION_DISCONNECTED);
    }

    @Override
    public void onStreamReceived(Session session, Stream stream) {
        Log.d("OPENTOK","OpenTokSessionManager.stream.streamReceived");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        sharedInfo.latestIncomingVideoStream = stream;
        sendEvent(Events.EVENT_RECEIVING_FOUND);
    }

    @Override
    public void onStreamDropped(Session session, Stream stream) {
        Log.d("OPENTOK","OpenTokSessionManager.stream.streamDropped");
        OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
        sharedInfo.latestIncomingVideoStream = stream;
        sendEvent(Events.EVENT_RECEIVING_LOST);
    }

    @Override
    public void onConnectionCreated(Session session, Connection connection) {
        Log.d("OPENTOK","OpenTokSessionManager.session.connectionCreated");
        //what could we do here?
    }

    @Override
    public void onConnectionDestroyed(Session session, Connection connection) {
        Log.d("OPENTOK","OpenTokSessionManager.session.connectionDestroyed");
        //what could we do here?
    }

    @Override
    public void onError(Session session, OpentokError opentokError) {
        Log.d("OPENTOK","OpenTokSessionManager.session.error:" +  opentokError.getMessage());
        //should we pass error?
        sendEvent(Events.EVENT_SESSION_ERROR);
    }

    @Override
    public void onCameraChanged(Publisher publisher, int cameraId) {
        Log.d("OPENTOK","OpenTokSessionManager.publisher.cameraChanged to:" +  cameraId);
        //how to know which is front and which is back???
        //docs say: 'This value is either 0 (for the back-facing camera) or 1 (for the front-facing camera)'
        //is that really true?
        //what if there are more camera's (like the new nokia 8 one for instance)
        if (cameraId == 0) {
            sendEvent(Events.EVENT_CAMERA_FACING_BACK);
        } else {
            sendEvent(Events.EVENT_CAMERA_FACING_FRONT);
        }
    }

    @Override
    public void onCameraError(Publisher publisher, OpentokError error) {
        Log.d("OPENTOK","OpenTokSessionManager.publisher.cameraerror:" +  error.getMessage());
        //should we pass error?
        sendEvent(Events.EVENT_SESSION_ERROR);
    }


    /* publisher listeners */
    @Override
    public void onStreamCreated(PublisherKit publisherKit, Stream stream) {
        Log.d("OPENTOK","OpenTokSessionManager.publisher.streamCreated:");
        sendEvent(Events.EVENT_PUBLISHING_STARTED);
    }

    @Override
    public void onStreamDestroyed(PublisherKit publisherKit, Stream stream) {
        Log.d("OPENTOK","OpenTokSessionManager.publisher.streamDestroyed:");
        sendEvent(Events.EVENT_PUBLISHING_ENDED);
    }

    @Override
    public void onError(PublisherKit publisherKit, OpentokError opentokError) {
        Log.d("OPENTOK","OpenTokSessionManager.publisher.error:" +  opentokError.getMessage());
        //should we pass error?
        sendEvent(Events.EVENT_SESSION_ERROR);
    }

    /* Subscriber listeners */

    @Override
    public void onError(SubscriberKit subscriberKit, OpentokError opentokError) {
        Log.d("OPENTOK","OpenTokSessionManager.subscriber.error:" +  opentokError.getMessage());
        //should we pass error?
        sendEvent(Events.EVENT_SESSION_ERROR);
    }

    public void onConnected(SubscriberKit subscriberKit) {
        Log.d("OPENTOK","OpenTokSessionManager.subscriber.connected:");
        //should we pass error?
        sendEvent(Events.EVENT_RECEIVING_CONNECTED);
    }

    public void onDisconnected(SubscriberKit subscriberKit) {
        Log.d("OPENTOK","OpenTokSessionManager.subscriber.connected:");
        //should we pass error?
        sendEvent(Events.EVENT_RECEIVING_DISCONNECTED);
    }

    public void onReconnected(SubscriberKit subscriberKit) {
        Log.d("OPENTOK","OpenTokSessionManager.subscriber.connected:");
        //should we pass error?
        sendEvent(Events.EVENT_RECEIVING_DISCONNECTED);
    }


//
//- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
//        NSLog(@"Received signal %@ %@ %@", type, string, session);
//  [self.bridge.eventDispatcher sendAppEventWithName:@"onMessageReceived" body:string];
//    }
//
//
    /* Signal Listener methods */
    @Override
    public void onSignalReceived(Session session, String type, String data, Connection connection) {
        sendEvent(Events.EVENT_MESSAGE_RECEIVED, data);
    }
}