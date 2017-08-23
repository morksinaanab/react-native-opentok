package io.callstack.react.opentok;

import android.util.Log;
import android.widget.FrameLayout;

import com.facebook.react.uimanager.ThemedReactContext;

public class SubscriberView extends FrameLayout {

    public boolean initialized;

    public SubscriberView(ThemedReactContext reactContext) {
        super(reactContext);
        initialized = false;
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        initSubscriberView();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        deinitSubscriberView();
    }

    private void initSubscriberView() {
        if (!initialized) {
            OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
            if (sharedInfo.incomingVideoSubscriber != null) {
                //attach frame to my view
                addView(sharedInfo.incomingVideoSubscriber.getView(), new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
                initialized = true;
                Log.d("OPENTOK","OpenTokSubscriberView.initSubscriberView initialized");
            } else {
                Log.d("OPENTOK","OpenTokSubscriberView.initSubscriberView no publisher");
            }
        } else {
            Log.d("OPENTOK","OpenTokSubscriberView.initSubscriberView already initialized");
        }
    }

    private void deinitSubscriberView() {
        if (initialized) {
            OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
            if (sharedInfo.incomingVideoSubscriber != null) {
                removeView(sharedInfo.incomingVideoSubscriber.getView());
                Log.d("OPENTOK","OpenTokPublisherView.deinitSubscriberView deinitialized");
            } else {
                Log.d("OPENTOK","OpenTokPublisherView.deinitSubscriberView no publisher");
            }
        } else {
            Log.d("OPENTOK","OpenTokPublisherView.deinitSubscriberView already deinitialized");
        }
    }

}