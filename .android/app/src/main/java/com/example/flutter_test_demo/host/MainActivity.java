package com.example.flutter_test_demo.host;

import com.idlefish.flutterboost.FlutterBoost;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    public void onBackPressed() {
        try {
            FlutterBoost.instance().getPlugin().onBackPressed();
        } catch (Exception ignore) {
            super.onBackPressed();
        }
    }
}
