//
//  ViewController.swift
//  MoodMateApp
//
//  Created by Rıdvan Karslı on 7.08.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func helpButtonClicked(_ sender: Any) {
        showAlert(message: "Please share your problem with us(moodMateHelpCenter@gmail.com)")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Help center", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

