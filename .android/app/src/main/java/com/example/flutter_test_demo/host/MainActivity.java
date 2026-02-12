package com.example.flutter_test_demo.host;

import android.Manifest;
import android.content.pm.PackageManager;

import com.idlefish.flutterboost.containers.FlutterBoostActivity;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterBoostActivity {
    private static final String MAIN_ROUTE = "home";
    private static final String MAIN_UNIQUE_ID = "main_flutter_container";
    private static final String FACE_CHANNEL = "com.example.flutter_test_demo/face_verify";
    private static final int REQUEST_CAMERA_PERMISSION = 9931;
    private MethodChannel.Result pendingFaceResult;
    private String pendingCertifyId;
    private boolean pendingUseVideo;

    @Override
    public String getUrl() {
        return MAIN_ROUTE;
    }

    @Override
    public Map<String, Object> getUrlParams() {
        return new HashMap<>();
    }

    @Override
    public String getUniqueId() {
        return MAIN_UNIQUE_ID;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FACE_CHANNEL)
                .setMethodCallHandler(this::onFaceMethodCall);
    }

    private void onFaceMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getMetaInfo":
                result.success(getMetaInfoByReflection());
                break;
            case "startFaceVerify":
                startFaceVerify(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private String getMetaInfoByReflection() {
        try {
            Class<?> zimFacadeClass = Class.forName("com.alipay.face.api.ZIMFacade");
            try {
                Method installMethod = zimFacadeClass.getMethod("install", android.content.Context.class);
                installMethod.invoke(null, this);
            } catch (Exception ignored) {
            }
            Method getMetaInfosMethod = zimFacadeClass.getMethod("getMetaInfos", android.content.Context.class);
            Object metaInfo = getMetaInfosMethod.invoke(null, this);
            return metaInfo == null ? "" : String.valueOf(metaInfo);
        } catch (Exception e) {
            return "";
        }
    }

    private void startFaceVerify(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (pendingFaceResult != null) {
            result.error("busy", "人脸识别正在进行中", null);
            return;
        }
        String certifyId = call.argument("certifyId");
        Boolean useVideoArg = call.argument("useVideo");
        final boolean useVideo = useVideoArg != null && useVideoArg;
        if (certifyId == null || certifyId.trim().isEmpty()) {
            result.error("invalid_args", "certifyId 不能为空", null);
            return;
        }
        pendingFaceResult = result;
        pendingCertifyId = certifyId;
        pendingUseVideo = useVideo;
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    this,
                    new String[]{Manifest.permission.CAMERA},
                    REQUEST_CAMERA_PERMISSION
            );
            return;
        }
        startFaceVerifyInternal(certifyId, useVideo);
    }

    private void startFaceVerifyInternal(@NonNull String certifyId, boolean useVideo) {
        try {
            Class<?> zimFacadeBuilderClass = Class.forName("com.alipay.face.api.ZIMFacadeBuilder");
            Method createMethod = zimFacadeBuilderClass.getMethod("create", android.content.Context.class);
            Object zimFacade = createMethod.invoke(null, this);
            if (zimFacade == null) {
                resolveFaceResult(false, -1, "初始化失败");
                return;
            }

            Method verifyMethod = null;
            for (Method method : zimFacade.getClass().getMethods()) {
                if ("verify".equals(method.getName()) && method.getParameterTypes().length == 4) {
                    verifyMethod = method;
                    break;
                }
            }
            if (verifyMethod == null) {
                resolveFaceResult(false, -1, "未找到 verify 方法");
                return;
            }

            Map<String, String> extParams = new HashMap<>();
            extParams.put("ext_params_key_use_video", String.valueOf(useVideo));

            Class<?> callbackType = verifyMethod.getParameterTypes()[3];
            Object callback = Proxy.newProxyInstance(
                    callbackType.getClassLoader(),
                    new Class[]{callbackType},
                    new FaceVerifyCallbackHandler()
            );
            verifyMethod.invoke(zimFacade, certifyId, true, extParams, callback);
        } catch (ClassNotFoundException e) {
            resolveFaceResult(false, -1, "未集成人脸识别SDK");
        } catch (Exception e) {
            resolveFaceResult(false, -1, "人脸识别调用失败");
        }
    }

    @Override
    public void onRequestPermissionsResult(
            int requestCode,
            @NonNull String[] permissions,
            @NonNull int[] grantResults
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode != REQUEST_CAMERA_PERMISSION) {
            return;
        }
        if (pendingFaceResult == null) {
            return;
        }
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            if (pendingCertifyId != null && !pendingCertifyId.trim().isEmpty()) {
                startFaceVerifyInternal(pendingCertifyId, pendingUseVideo);
                return;
            }
            resolveFaceResult(false, -1, "certifyId 不能为空");
            return;
        }
        resolveFaceResult(false, -1, "权限已拒绝，请前往设置打开相机权限");
    }

    private class FaceVerifyCallbackHandler implements InvocationHandler {
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) {
            if (args != null && args.length > 0 && args[0] != null) {
                Object response = args[0];
                int code = readIntField(response, "code", -1);
                String reason = readStringField(response, "reason", "");
                resolveFaceResult(code == 1000, code, reason);
            } else {
                resolveFaceResult(false, -1, "认证失败");
            }
            return true;
        }
    }

    private int readIntField(Object target, String fieldName, int defaultValue) {
        try {
            Field field = target.getClass().getField(fieldName);
            field.setAccessible(true);
            Object value = field.get(target);
            if (value instanceof Number) {
                return ((Number) value).intValue();
            }
        } catch (Exception ignored) {
        }
        return defaultValue;
    }

    private String readStringField(Object target, String fieldName, String defaultValue) {
        try {
            Field field = target.getClass().getField(fieldName);
            field.setAccessible(true);
            Object value = field.get(target);
            return value == null ? defaultValue : String.valueOf(value);
        } catch (Exception ignored) {
        }
        return defaultValue;
    }

    private void resolveFaceResult(boolean success, int code, String reason) {
        final MethodChannel.Result callback = pendingFaceResult;
        pendingFaceResult = null;
        pendingCertifyId = null;
        pendingUseVideo = false;
        if (callback == null) {
            return;
        }
        runOnUiThread(() -> {
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("code", code);
            result.put("reason", reason);
            callback.success(result);
        });
    }
}
