import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()

    // Add this line with your keys
    IntercomFlutterPlugin.initSdk(this, appId = "hivazykc", androidApiKey = "android_sdk-3337cce19e6e590feed33d6b48f39eae825fcfd0")
  }
}