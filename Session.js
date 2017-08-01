import { NativeModules, NativeAppEventEmitter, Platform } from 'react-native';
const SessionManager = NativeModules.OpenTokMessageHandler;

const listener = null;

export const connect = SessionManager.connect;
export const sendMessage = SessionManager.sendMessage;

export const onMessageReceived = (callback) => {
  listener = NativeAppEventEmitter.addListener(
      'onMessageReceived',
      (e) => callback(e)
    );
};

export const stopListener = () => listener.remove();
