//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    @IBOutlet weak var hangman: UIImageView!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var letterGuess: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var incorrectGuesses: UILabel!
    var phrase : String?
    var phraseChars : [Character]?
    var phraseLen : Int?
    var boolsArr : [Bool]?
    var wordChars : Set<String> = []
    var wrongGuesses : Set<String> = []
    var wrongCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HangmanViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = hangmanPhrases.getRandomPhrase()
        print(phrase)
        phraseChars = [Character](phrase.characters)
        phraseLen = phrase.characters.count
        
        boolsArr = [Bool](repeating: false, count: phraseLen!)
        for c in phraseChars! {
            wordChars.insert(String(c))
        }
        
        for i in 0...phraseLen!-1 {
            if (String(phraseChars![i]) == " ") {
                boolsArr![i] = true
            }
        }
        displayWord()
    }
    
    func displayWord() {
        word.text = ""
        for i in 0...phraseLen!-1 {
            if (boolsArr![i]) {
                word.text = word.text! + String(phraseChars![i]) + " "
            } else {
                word.text = word.text! + "- "
            }
        }
    }
    
    
    @IBAction func typing(_ sender: UIButton) {
        if (letterGuess.text!.characters.count > 2) {
            letterGuess.text = ""
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessAction(_ sender: UIButton) {
        let guess = letterGuess.text
        if (guess!.characters.count == 1) {
            if (wordChars.contains(guess!)) {
                for i in 0...phraseLen!-1 {
                    if (guess! == String(phraseChars![i])) {
                        boolsArr![i] = true
                    }
                }
                if (testWon()) {
                    let alert = UIAlertController(title: "Congratulations!",
                                                  message: "You won!",
                                                  preferredStyle: .alert)
                    let newGame = UIAlertAction(title: "Start over",
                                                style: .default) {
                                                    action in self.reset()
                    }
                    alert.addAction(newGame)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                if (!wrongGuesses.contains(String(guess!))) {
                    wrongGuesses.insert(String(guess!))
                    if (wrongCount < 7) {
                        wrongCount += 1
                        let imageName = "hangman" + String(wrongCount)
                        hangman.image = UIImage(named: imageName)
                    } else {
                        let alert = UIAlertController(title: "Dag nabbit!",
                                                      message: "You lost!",
                                                      preferredStyle: .alert)
                        let newGame = UIAlertAction(title: "Try again",
                                                    style: .default) {
                                                        action in self.reset()
                        }
                        alert.addAction(newGame)
                        self.present(alert, animated: true, completion: nil)
                    }
                    incorrectGuesses.text = "Incorrect Guesses: " + String(describing: wrongGuesses)
                }
            }
        }
        letterGuess.text = ""
        displayWord()
    }
    
    func testWon() -> Bool {
        for bool in boolsArr! {
            if (!bool) {
                return false
            }
        }
        return true
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        reset()
    }
    
    func reset() {
        let hangmanPhrases = HangmanPhrases()
        self.phrase = hangmanPhrases.getRandomPhrase()
        print(self.phrase!)
        self.phraseLen = self.phrase!.characters.count
        self.word.text = ""
        self.phraseChars = [Character](self.phrase!.characters)
        self.boolsArr = [Bool](repeating: false, count: self.phraseLen!)
        self.wordChars = Set<String>()
        self.wrongGuesses = Set<String>()
        self.wrongCount = 1
        
        for c in self.phraseChars! {
            self.wordChars.insert(String(c))
        }
        let imageName = "hangman" + String(wrongCount)
        hangman.image = UIImage(named: imageName)
        incorrectGuesses.text = "Incorrect Guesses: "
        self.displayWord()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
