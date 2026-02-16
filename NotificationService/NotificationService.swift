import UserNotifications
import UniformTypeIdentifiers

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        
        // 1. Проверяем URL изображения в payload Firebase
        if let fcmOptions = request.content.userInfo["fcm_options"] as? [String: Any],
           let imageUrlString = fcmOptions["image"] as? String,
           let url = URL(string: imageUrlString) {
            
            // 2. Загружаем изображение
            downloadImage(from: url) { [weak self] attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        } else {
            // Если нет изображения — показываем обычный пуш
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    // Загрузка изображения
    private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completion(nil)
                return
            }
            
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            do {
                let attachment = try UNNotificationAttachment(
                    identifier: "pushImage",
                    url: urlPath,
                    options: [
                        UNNotificationAttachmentOptionsTypeHintKey: UTType.jpeg.identifier // Современный аналог kUTTypeJPEG
                    ]
                )
                completion(attachment)
            } catch {
                print("Ошибка создания вложения: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

}
