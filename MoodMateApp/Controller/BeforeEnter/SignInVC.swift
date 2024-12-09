import UIKit
import CoreData

class SignInVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let signInButton = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(signInButtonClicked))
        navigationItem.rightBarButtonItem = signInButton
    }

    @objc func signInButtonClicked() {
        guard let userName = userNameText.text, !userName.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
            // Kullanıcı adı ve şifre girilmedi
            showAlert(message: "Please enter both username and password.")
            return
        }
        authenticateUser(userName: userName, password: password)
    }
    
    private func authenticateUser(userName: String, password: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        // Fetch Request oluşturma
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND password == %@", userName, password)

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // Kullanıcı adı veya şifre yanlış
                showAlert(message: "Incorrect username or password.")
            } else {
                UserDefaults.standard.setValue(userName, forKey: "userName")
                self.performSegue(withIdentifier: "toMainFromSignIn", sender: nil)
            }
        } catch let error as NSError {
            print("Could not fetch users. \(error), \(error.userInfo)")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
