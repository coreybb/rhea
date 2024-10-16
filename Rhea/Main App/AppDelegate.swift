//
//  AppDelegate.swift
//  Rhea
//
//  Created by Corey Beebe on 10/12/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {

        let container = NSPersistentCloudKitContainer(name: "Rhea")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}




func createDummyFileSystem() -> [FileDirectoryEntry] {
    var rootDirectory = Directory(name: "Root")
    
    // Documents directory
    var documentsDirectory = Directory(name: "Documents")
    documentsDirectory.entries.append(File(name: "Resume.pdf"))
    documentsDirectory.entries.append(File(name: "Budget.xlsx"))
    
    // Projects directory
    var projectsDirectory = Directory(name: "Projects")
    
    // Swift project
    var swiftProjectDirectory = Directory(name: "SwiftApp")
    swiftProjectDirectory.entries.append(File(name: "AppDelegate.swift"))
    swiftProjectDirectory.entries.append(File(name: "ViewController.swift"))
    swiftProjectDirectory.entries.append(File(name: "Main.storyboard"))
    
    // Resources subdirectory in Swift project
    var resourcesDirectory = Directory(name: "Resources")
    resourcesDirectory.entries.append(File(name: "logo.png"))
    resourcesDirectory.entries.append(File(name: "background.jpg"))
    swiftProjectDirectory.entries.append(resourcesDirectory)
    
    projectsDirectory.entries.append(swiftProjectDirectory)
    
    // Python project
    var pythonProjectDirectory = Directory(name: "PythonScript")
    pythonProjectDirectory.entries.append(File(name: "main.py"))
    pythonProjectDirectory.entries.append(File(name: "utils.py"))
    projectsDirectory.entries.append(pythonProjectDirectory)
    
    // Photos directory
    var photosDirectory = Directory(name: "Photos")
    photosDirectory.entries.append(File(name: "Vacation2023.jpg"))
    photosDirectory.entries.append(File(name: "Family.png"))
    
    // Add all top-level directories to root
    rootDirectory.entries.append(documentsDirectory)
    rootDirectory.entries.append(projectsDirectory)
    rootDirectory.entries.append(photosDirectory)
    
    // Some files in root
    rootDirectory.entries.append(File(name: "Notes.txt"))
    rootDirectory.entries.append(File(name: "Todo.md"))
    
    return [rootDirectory]
}
