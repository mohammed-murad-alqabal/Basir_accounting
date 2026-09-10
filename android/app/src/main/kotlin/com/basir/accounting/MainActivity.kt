package com.basir.accounting

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity لنظام بصير المحاسبي
 *
 * الميزات المدمجة:
 * 1. FlutterEngine Cache (تسريع الإقلاع)
 * 2. Deep Links معالجة (scheme: basir:// + https://app.basir.sa)
 * 3. Edge-to-Edge (Android 15+ / API 35)
 * 4. Runtime Permissions Handler عبر MethodChannel
 * 5. Automatic + Fallback Plugin Registration
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "BasirMainActivity"
        private const val ENGINE_ID = "basir_flutter_engine"
        private const val PERMISSIONS_CHANNEL = "basir/permissions"
        private const val DEEPLINK_CHANNEL = "basir/deeplink"
        private const val PERMISSION_REQUEST_CODE = 1001

        private val SUPPORTED_SCHEMES = setOf("basir", "https", "http")
        private val SUPPORTED_HOSTS = setOf("app.basir.sa", "basir.page.link")
    }

    private var pendingPermissionResult: MethodChannel.Result? = null
    private var pendingPermissionAliases: List<String> = emptyList()
    private var permissionsChannel: MethodChannel? = null
    private var deeplinkChannel: MethodChannel? = null
    private var pendingInitialLink: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        setupEdgeToEdge()
        super.onCreate(savedInstanceState)
        handleIncomingIntent(intent)
    }

    override fun provideFlutterEngine(context: android.content.Context): FlutterEngine? {
        val cached = FlutterEngineCache.getInstance().get(ENGINE_ID)
        if (cached != null) {
            Log.i(TAG, "FlutterEngineCache HIT — reused warmed engine")
            return cached
        }

        val engine = super.provideFlutterEngine(context)
        if (engine != null) {
            FlutterEngineCache.getInstance().put(ENGINE_ID, engine)
            Log.i(TAG, "FlutterEngineCache MISS — warmed engine and cached")
        }
        return engine
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        try {
            BasirPluginRegistrant.registerWith(flutterEngine)
            Log.i(TAG, "Automatic + Fallback plugin registration: OK")
        } catch (t: Throwable) {
            Log.w(TAG, "Fallback registrant threw (non-fatal)", t)
        }

        setupMethodChannels(flutterEngine)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        permissionsChannel?.setMethodCallHandler(null)
        deeplinkChannel?.setMethodCallHandler(null)
        permissionsChannel = null
        deeplinkChannel = null
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIncomingIntent(intent)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE && pendingPermissionResult != null) {
            val resultMap = HashMap<String, Boolean>()
            val permToAlias = permissions.mapNotNull { perm ->
                findAliasForPermission(perm)?.let { alias -> alias to perm }
            }.toMap()

            for (alias in pendingPermissionAliases) {
                val perm = permToAlias[alias]
                resultMap[alias] = if (perm != null && grantResults.isNotEmpty()) {
                    val index = permissions.indexOf(perm)
                    index >= 0 && grantResults[index] == PackageManager.PERMISSION_GRANTED
                } else {
                    true
                }
            }

            pendingPermissionResult?.success(resultMap)
            pendingPermissionResult = null
            pendingPermissionAliases = emptyList()
        }
    }

    private fun findAliasForPermission(perm: String): String? =
        when (perm) {
            Manifest.permission.CAMERA -> "camera"
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE -> "storage"
            Manifest.permission.READ_MEDIA_IMAGES -> "photos"
            Manifest.permission.READ_MEDIA_VIDEO -> "videos"
            Manifest.permission.RECORD_AUDIO -> "audio"
            Manifest.permission.POST_NOTIFICATIONS -> "notifications"
            Manifest.permission.ACCESS_FINE_LOCATION -> "location"
            Manifest.permission.ACCESS_COARSE_LOCATION -> "locationCoarse"
            Manifest.permission.CALL_PHONE -> "phone"
            Manifest.permission.READ_CONTACTS -> "contacts"
            Manifest.permission.SEND_SMS -> "sms"
            else -> null
        }

    private fun handleIncomingIntent(intent: Intent?) {
        val data: Uri? = intent?.data
        val action = intent?.action
        if (data == null || (action != Intent.ACTION_VIEW && action != Intent.ACTION_MAIN)) {
            return
        }

        val scheme = data.scheme ?: return
        val host = data.host
        if (scheme !in SUPPORTED_SCHEMES) return
        if (scheme.startsWith("http") && host != null && host !in SUPPORTED_HOSTS) return

        val link = data.toString()
        Log.i(TAG, "Deep link received: $link")

        val channel = deeplinkChannel
        if (channel == null) {
            pendingInitialLink = link
        } else {
            channel.invokeMethod("onLink", mapOf("link" to link, "source" to "intent"))
        }
    }

    @SuppressLint("ObsoleteSdkInt")
    private fun setupEdgeToEdge() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }
        if (Build.VERSION.SDK_INT >= 35) {
            runCatching {
                window.attributes = window.attributes.apply {
                    layoutInDisplayCutoutMode =
                        WindowManager.LayoutParams
                            .LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS
                }
            }.onFailure { Log.w(TAG, "Android 15 E2E setup skipped", it) }
        }
    }

    private fun setupMethodChannels(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        permissionsChannel = MethodChannel(messenger, PERMISSIONS_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkPermissions" -> result.success(checkPermissions(call))
                    "requestPermissions" -> requestPermissions(call, result)
                    "shouldShowRationale" -> result.success(shouldShowRationale(call))
                    "openAppSettings" -> {
                        openAppSettings()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
        }

        deeplinkChannel = MethodChannel(messenger, DEEPLINK_CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialLink" -> {
                        result.success(
                            mapOf(
                                "link" to pendingInitialLink.takeUnless { it.isNullOrBlank() },
                                "source" to "initial"
                            )
                        )
                        pendingInitialLink = null
                    }
                    else -> result.notImplemented()
                }
            }

            val cachedLink = pendingInitialLink
            if (!cachedLink.isNullOrBlank()) {
                Log.i(TAG, "Dispatching pending initial deep link")
                invokeMethod("onLink", mapOf("link" to cachedLink, "source" to "initial"))
                pendingInitialLink = null
            }
        }
    }

    private fun permissionName(alias: String): String? =
        when (alias) {
            "camera" -> Manifest.permission.CAMERA
            "photos", "gallery", "storage" ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    Manifest.permission.READ_MEDIA_IMAGES
                else Manifest.permission.READ_EXTERNAL_STORAGE
            "videos" ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    Manifest.permission.READ_MEDIA_VIDEO
                else Manifest.permission.READ_EXTERNAL_STORAGE
            "audio", "microphone" -> Manifest.permission.RECORD_AUDIO
            "notifications" ->
                if (Build.VERSION.SDK_INT >= 33) Manifest.permission.POST_NOTIFICATIONS
                else null
            "location" -> Manifest.permission.ACCESS_FINE_LOCATION
            "locationCoarse" -> Manifest.permission.ACCESS_COARSE_LOCATION
            "phone" -> Manifest.permission.CALL_PHONE
            "contacts" -> Manifest.permission.READ_CONTACTS
            "sms" -> Manifest.permission.SEND_SMS
            else -> null
        }

    private fun checkPermissions(call: MethodCall): Map<String, Boolean> {
        val aliases = call.argument<List<String>>("permissions").orEmpty()
        val out = HashMap<String, Boolean>(aliases.size)
        for (alias in aliases) {
            val perm = permissionName(alias)
            out[alias] = when {
                perm == null -> true
                else -> ContextCompat.checkSelfPermission(
                    this,
                    perm
                ) == PackageManager.PERMISSION_GRANTED
            }
        }
        return out
    }

    private fun requestPermissions(call: MethodCall, result: MethodChannel.Result) {
        if (pendingPermissionResult != null) {
            result.error("IN_PROGRESS", "Permission request already in progress", null)
            return
        }
        val aliases = call.argument<List<String>>("permissions").orEmpty()
        val androidPerms = aliases.mapNotNull(::permissionName).toTypedArray()
        if (androidPerms.isEmpty()) {
            result.success(aliases.associateWith { true })
            return
        }
        pendingPermissionResult = result
        pendingPermissionAliases = aliases
        ActivityCompat.requestPermissions(this, androidPerms, PERMISSION_REQUEST_CODE)
    }

    private fun shouldShowRationale(call: MethodCall): Map<String, Boolean> {
        val aliases = call.argument<List<String>>("permissions").orEmpty()
        val out = HashMap<String, Boolean>(aliases.size)
        for (alias in aliases) {
            val perm = permissionName(alias)
            out[alias] = perm != null &&
                ActivityCompat.shouldShowRequestPermissionRationale(this, perm)
        }
        return out
    }

    private fun openAppSettings() {
        val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            .apply {
                data = Uri.fromParts("package", packageName, null)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        runCatching { startActivity(intent) }.onFailure {
            Log.w(TAG, "Could not open app settings", it)
        }
    }
}