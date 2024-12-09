//
//  SignUpVC.swift
//  MoodMateApp
//
//  Created by Rıdvan Karslı on 7.08.2024.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClicked))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func nextButtonClicked(){
        self.performSegue(withIdentifier: "toInterestsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if datasOk() {
            
            if segue.identifier == "toInterestsVC"{
                if let destinationVC = segue.destination as? InterestsVC {
                    
                    destinationVC.name = nameText.text
                    destinationVC.birthDate = birthDate.date
                    destinationVC.email = emailText.text
                    destinationVC.userName = userNameText.text
                    destinationVC.password = passwordText.text
                }
            }
        }else{
            //hata mesajı
        }
        
    }
    
    func datasOk() -> Bool {
        if passwordText.text == passwordAgainText.text{
            return true
        }else{
            return false
        }
    }

}
