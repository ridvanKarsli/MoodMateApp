//
//  FındMoodVC.swift
//  MoodMateApp
//
//  Created by Rıdvan Karslı on 7.08.2024.
//

import UIKit
import NaturalLanguage

class FindMoodVC: UIViewController {
    
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var textForMood: UITextField!
    
    var sentimentScore = 0.0
    var moodFind : String?
    var kindArr = [] as [Any]
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let userName = UserDefaults.standard.string(forKey: "userName"){
            welcomeMessage.text = "Welcome \(userName)"
        }else{
            welcomeMessage.text = "Welcome"
        }
        
    }
    
    
    @IBAction func findMoodButtonClicked(_ sender: Any) {
        
        analyzeSentiment()
        self.performSegue(withIdentifier: "toSuggestionfromFind", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSuggestionfromFind" {
            if let destinationVC = segue.destination as? SuggestionsVC{
                destinationVC.mood = moodFind
                destinationVC.kindArr = kindArr
            }
        }
    }
    
    func analyzeSentiment() {
        guard let text = textForMood.text, !text.isEmpty else {
            textForMood.text = "Please enter some text."
            return
        }

        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        
        if let sentiment {
            sentimentScore = Double(sentiment.rawValue) ?? 0
        }
        
        if sentimentScore < 0.0{
            //olumsuz
            kindArr = [35,35,"happy","happy","happy"]
        }else if sentimentScore > 0.0{
            //olumlu
            kindArr = [28,9648,"rap","science","science"]
        }else{
            //nötür
            kindArr = [28,9648,"rap","science","science"]
        }
        
        textForMood.text = moodFind
    }

}


/*
 movies:
 Aksiyon - ID: 28
 Macera - ID: 12
 Animasyon - ID: 16
 Komedi - ID: 35
 Korku - ID: 27
 Bilim Kurgu - ID: 878
 Romantik - ID: 10749
 Gerilim - ID: 53
 Suç - ID: 80
 Dram - ID: 18
 Müzik - ID: 10402
 Gizem - ID: 9648
 Savaş - ID: 10752
 Western - ID: 37
 Belgesel - ID: 99
 Fantastik - ID: 14
 Aile - ID: 10751
 TV Film - ID: 10770
 
 tv shows:
 Aksiyon - ID: 10759
 Macera - ID: 10759
 Animasyon - ID: 16
 Komedi - ID: 35
 Korku - ID: 27
 Bilim Kurgu - ID: 10765
 Romantik - ID: 10749
 Gerilim - ID: 53
 Suç - ID: 80
 Dram - ID: 18
 Müzik - ID: 10402
 Gizem - ID: 9648
 Savaş - ID: 10768
 Western - ID: 37
 Belgesel - ID: 99
 Fantastik - ID: 14
 Aile - ID: 10751
 Reality - ID: 10764
 Talk - ID: 10767
 News - ID: 10763
 */
