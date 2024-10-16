import Foundation
import UniformTypeIdentifiers
import UIKit

// TODO: - Refactor for DI w/ protocols
class iCloudDriveAccessManager: NSObject, UIDocumentPickerDelegate {
    static let shared = iCloudDriveAccessManager()
    
    private var directoryCompletion: ((URL?) -> Void)?
    
    func pickiCloudDirectory(from viewController: UIViewController, completion: @escaping (URL?) -> Void) {
        self.directoryCompletion = completion
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        
        viewController.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else {
            print("No URL selected")
            directoryCompletion?(nil)
            return
        }
        
        print("Selected URL: \(selectedURL.path)")
        
        guard selectedURL.startAccessingSecurityScopedResource() else {
            print("Failed to access security-scoped resource")
            directoryCompletion?(nil)
            return
        }
        
        // Ensure we stop accessing the resource when we're done
        defer {
            selectedURL.stopAccessingSecurityScopedResource()
        }
        
        directoryCompletion?(selectedURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
        directoryCompletion?(nil)
    }
}
