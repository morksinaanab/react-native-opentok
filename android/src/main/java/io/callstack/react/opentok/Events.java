package io.callstack.react.opentok;

enum Events {
    EVENT_SESSION_CONNECTED("onSessionConnected"),
    EVENT_SESSION_DISCONNECTED("onSessionDisconnected"),
    EVENT_MESSAGE_RECEIVED("onMessageReceived"),
    EVENT_RECEIVING_FOUND("onReceivingFound"),
    EVENT_RECEIVING_LOST("onReceivingLost"),
    EVENT_RECEIVING_CONNECTED("onReceivingConnected"),
    EVENT_RECEIVING_RECONNECTED("onReceivingReconnected"),
    EVENT_RECEIVING_DISCONNECTED("onReceivingDisconnected"),
    EVENT_PUBLISHING_STARTED("onPublishingStarted"),
    EVENT_PUBLISHING_ENDED("onPublishingEnded"),
    EVENT_SESSION_ERROR("onSessionError"),
    EVENT_CAMERA_FACING_FRONT("onCameraFacingFront"),
    EVENT_CAMERA_FACING_BACK("onCameraFacingBack");

    private final String mName;

    Events(final String name) {
        mName = name;
    }

    @Override
    public String toString() {
        return mName;
    }
}
