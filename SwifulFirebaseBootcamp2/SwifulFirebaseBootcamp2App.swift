import SwiftUI
import Firebase
import FirebaseAnalyticsSwift
import FirebaseAnalytics



@main
struct YourApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
          RootView()
        }
    }
    ///d
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure() // Inicializar Firebase
        
        return true
    }
}

func applicationDidBecomeActive() {
    logEvent()
}

// Que muestre un evento en la consola
func logEvent() {
    Analytics.logEvent("test_event", parameters: nil)
}
