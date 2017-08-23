package io.callstack.react.opentok;

import android.util.Log;
import android.widget.FrameLayout;

import com.facebook.react.uimanager.ThemedReactContext;

/**
 * PublisherView
 *
 * React Component extending SessionView that publishes stream of video and audio to the stream
 */
public class PublisherView  extends FrameLayout {

    private boolean initialized;

    public PublisherView(ThemedReactContext reactContext) {
        super(reactContext);
        initialized = false;
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        initPublisherView();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        deinitPublisherView();
    }

    private void initPublisherView() {
        if (!initialized) {
            OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
            if (sharedInfo.outgoingVideoPublisher != null) {
                //attach frame to my view
                addView(sharedInfo.outgoingVideoPublisher.getView(), new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
                initialized = true;
                Log.d("OPENTOK","OpenTokPublisherView.initPublisherView initialized");
            } else {
                Log.d("OPENTOK","OpenTokPublisherView.initPublisherView no publisher");
            }
        } else {
            Log.d("OPENTOK","OpenTokPublisherView.initPublisherView already initialized");
        }
    }

    private void deinitPublisherView() {
        if (initialized) {
            OpenTokSharedInfo sharedInfo = OpenTokSharedInfo.getInstance();
            if (sharedInfo.outgoingVideoPublisher != null) {
                removeView(sharedInfo.outgoingVideoPublisher.getView());
                Log.d("OPENTOK","OpenTokPublisherView.deinitPublisherView deinitialized");
            } else {
                Log.d("OPENTOK","OpenTokPublisherView.deinitPublisherView no publisher");
            }
        } else {
            Log.d("OPENTOK","OpenTokPublisherView.deinitPublisherView already deinitialized");
        }
    }

}
