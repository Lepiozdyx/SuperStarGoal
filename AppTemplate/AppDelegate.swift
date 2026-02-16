import UIKit
import SwiftUI
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var application: UIApplication?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
//        onGameStart()
//        return true
        
        showLoadingScreen()
        initApp()
        
        if let notification = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            onPushRecieved(content: notification)
        }
        return true
    }
    
    func onGameStart()
    {
        // Здесь происходит инициализация главного View
        // InitialView нужно заменить на ваш главный View
        let contentView = CustomHostingController(rootView: MainTabView())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = contentView

        // Также, контроль ориентации происходит за счет класса OrientationHelper
        // Ориентация задается за счет переменной orientaionMask
        // Если нужно отключить автоповорот, то нужно установить isAutoRotationEnabled в false
        OrientationHelper.orientaionMask = UIInterfaceOrientationMask.portrait
        OrientationHelper.isAutoRotationEnabled = false

        // Вся остальная логика приложения, которая должна быть выполнена до загрузки главного View
        // должна быть выполнена здесь. Например, инициализация аудио
        

        ///////////////////////////////

        // Показываем главный View
        window?.makeKeyAndVisible()
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return OrientationHelper.orientaionMask
    }

    override var shouldAutorotate: Bool {
        return OrientationHelper.isAutoRotationEnabled
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

class OrientationHelper
{
    public static var orientaionMask: UIInterfaceOrientationMask = .portrait
    public static var isAutoRotationEnabled: Bool = false
}
