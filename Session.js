import { NativeModules, NativeAppEventEmitter, Platform } from 'react-native';
const SessionManager = NativeModules.OpenTokSessionManager;

const listeners = [];
export const connect          = SessionManager.connect;
export const sendMessage      = SessionManager.sendMessage;
export const startPublishing  = SessionManager.startPublishing;
export const stopPublishing   = SessionManager.stopPublishing;
export const startReceiving   = SessionManager.startReceiving;
export const stopReceiving    = SessionManager.stopReceiving;
export const audioOn          = SessionManager.audioOn;
export const audioOff         = SessionManager.audioOff;
export const videoOn          = SessionManager.videoOn;
export const videoOff         = SessionManager.videoOff;
export const cameraFront      = SessionManager.cameraFront;
export const cameraBack       = SessionManager.cameraBack;
export const forceScreenUpdate= SessionManager.forceScreenUpdate;

export const clearSession = SessionManager.clearSession;

export const onSessionConnected       = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onSessionConnected',       (e) => callback(e)) ) };
export const onSessionDisconnected    = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onSessionDisconnected',    (e) => callback(e)) ) };
export const onMessageReceived        = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onMessageReceived',        (e) => callback(e)) ) };
export const onReceivingFound         = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onReceivingFound',         (e) => callback(e)) ) };
export const onReceivingLost          = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onReceivingLost',          (e) => callback(e)) ) };
export const onReceivingConnected     = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onReceivingConnected',     (e) => callback(e)) ) };
export const onReceivingReconnected   = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onReceivingReconnected',   (e) => callback(e)) ) };
export const onReceivingDisconnected  = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onReceivingDisconnected',  (e) => callback(e)) ) };
export const onPublishingStarted      = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onPublishingStarted',      (e) => callback(e)) ) };
export const onPublishingEnded        = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onPublishingEnded',        (e) => callback(e)) ) };
export const onSessionError           = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onSessionError',           (e) => callback(e)) ) };
export const onCameraFacingFront      = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onCameraFacingFront',      (e) => callback(e)) ) };
export const onCameraFacingBack       = (callback) => { listeners.push( NativeAppEventEmitter.addListener('onCameraFacingBack',       (e) => callback(e)) ) };

export const stopListeners = () => {
  for (var i in listeners) {
    if(listeners[i]) listeners[i].remove();
  }
  listeners = [];
}
