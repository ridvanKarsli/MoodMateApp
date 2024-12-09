import UIKit
import CoreData

class InterestsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var interestsTableView: UITableView!
    
    // Kategoriler ve ilgi alanları
    let categories = [
        "Sanat ve Eğlence": ["Müzik", "Sanat", "Sinema", "Tiyatro", "Dans", "Fotoğrafçılık", "Resim", "Heykel"],
        "Spor ve Aktif Yaşam": ["Spor", "Yüzme", "Koşu", "Fitness", "Yoga", "Dağ Yürüyüşü", "Bisiklet", "Basketbol", "Futbol"],
        "Teknoloji ve Bilim": ["Yazılım", "Teknoloji", "Bilim", "Astronomi", "Elektronik", "Programlama", "Yapay Zeka", "Robotik"],
        "Eğitim ve Kişisel Gelişim": ["Okuma", "Kitaplar", "Kişisel Gelişim", "Ders Çalışma", "Yabancı Diller", "Hobi Kursları"],
        "Seyahat ve Kültür": ["Seyahat", "Yerli Kültürler", "Yabancı Kültürler", "Mutfak", "Tarihi Yerler", "Doğa Gezileri"],
        "Sosyal ve Topluluk": ["Gönüllülük", "Topluluk Etkinlikleri", "Sosyal Medya", "Aile Zamanı", "Arkadaşlarla Zaman Geçirme"],
        "Yaratıcılık ve Hobi": ["Yazı Yazma", "Şiir", "El Sanatları", "Örgü", "Takı Tasarımı", "Bahçecilik"],
        "Sağlık ve Wellness": ["Meditasyon", "Sağlıklı Beslenme", "Aromaterapi", "Masaj", "Kişisel Bakım", "Zihinsel Sağlık"]
    ]
    
    var selectedInterests: Set<String> = []
    
    var name : String?
    var birthDate : Date?
    var email : String?
    var userName : String?
    var password : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigate sign up button
        let signUp = UIBarButtonItem(title: "Sign up", style: .plain, target: self, action: #selector(signUpButtonClicked))
        navigationItem.rightBarButtonItem = signUp
        
        
        // TableView ayarları
        interestsTableView.dataSource = self
        interestsTableView.delegate = self
        interestsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "InterestCell")
    }
    
    @objc func signUpButtonClicked(){
        saveUser()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(categories.keys)[section]
        return categories[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestCell", for: indexPath)
        
        let category = Array(categories.keys)[indexPath.section]
        let interest = categories[category]?[indexPath.row] ?? ""
        
        cell.textLabel?.text = interest
        
        // Seçili durumu kontrol et
        if selectedInterests.contains(interest) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(categories.keys)[section]
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = Array(categories.keys)[indexPath.section]
        let interest = categories[category]?[indexPath.row] ?? ""
        
        // Seçim işlemi
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
        
        // Tabloyu yeniden yükle
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func saveUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(birthDate, forKey: "birthDate")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(userName, forKey: "userName")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(selectedInterests, forKey: "interests")
        
        // Veriyi kaydedin
        do {
            try context.save()
            UserDefaults.standard.setValue(userName, forKey: "userName")
            self.performSegue(withIdentifier: "toMainFromInterests", sender: nil)
        } catch let error as NSError {
            print("Could not save user. \(error), \(error.userInfo)")
        }
    }
    
}
