//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    var currentGame: Game!
    var phrases: HangmanPhrases!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        let phrase: String = phrases.getRandomPhrase()
        print(phrase)
        currentGame = Game(word: phrase)
        updateOutlets()
    }
    
    //make a new instance of game and assign to currentGame. Update the outlets accordingly
    @IBAction func startOver(_ sender: Any) {
        let newPhrase = phrases.getRandomPhrase()
        currentGame = Game(word: newPhrase)
        updateOutlets()
    }
   
    //make the guess from the textEntry. Update the outlets accordingly.
    @IBAction func makeGuess(_ sender: UIButton) {
        var extractedStr = self.guessChar.text!
        extractedStr = extractedStr.uppercased()
        let extractedChars = [Character](extractedStr.characters)
        if extractedChars.count == 1 { // Conversion was successful
            if currentGame.incorrectGuess.contains(extractedChars[0]) || currentGame.correctGuess.contains(extractedChars[0]) {
                let errorAlert = UIAlertController(title: "Error", message: "You have already made this guess.", preferredStyle: UIAlertControllerStyle.alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            } else {
                currentGame.makeGuess(guess: extractedChars[0]);
                updateOutlets()
            }
        } else {
            let errorAlert = UIAlertController(title: "Error", message: "Please input only one character at a time", preferredStyle: UIAlertControllerStyle.alert)
            errorAlert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }
        
        if currentGame.progress == currentGame.word {
            displayWin()
        } else if currentGame.numTries == currentGame.totalTries {
            displayLoss()
        }
    }
    
    func updateOutlets() {
        var count = 0
        var wrongGuessesStr = ""
        for c in currentGame.incorrectGuess {
            wrongGuessesStr.append(c)
            count += 1
            if count != currentGame.numTries {
                wrongGuessesStr.append(" ")
            }
        }
        wrongGuess.text = wrongGuessesStr
        var tempProgress = "";
        let length = currentGame.progress.characters.count
        for i in 0...length - 1 {
            let index = currentGame.progress.index(currentGame.progress.startIndex, offsetBy: i)
            tempProgress.append(currentGame.progress[index])
            tempProgress.append(" ")
        }
        self.progress.text = tempProgress
        var image : UIImage!
        switch(currentGame.numTries){
        case 1: image = UIImage(named:"hangman2")!
        case 2: image = UIImage(named:"hangman3")!
        case 3: image = UIImage(named:"hangman4")!
        case 4: image = UIImage(named:"hangman5")!
        case 5: image = UIImage(named:"hangman6")!
        default: image = UIImage(named:"hangman1")!
        }
        img.image = image
        img.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        view.addSubview(img)
    }
    
    //checks if there is a loss and displays a pop-up
    func displayLoss() -> Void {
        let lossAlert = UIAlertController(title: "Game Over", message: "You Lose!", preferredStyle: UIAlertControllerStyle.alert)
        lossAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            let newPhrase = self.phrases.getRandomPhrase()
            self.currentGame = Game(word: newPhrase)
            self.updateOutlets()
        }))
        self.present(lossAlert, animated: true, completion: nil)
    }
    
    //checks if the game is a win and displays a pop-up
    func displayWin() -> Void {
        let winAlert = UIAlertController(title: "Game Over", message: "You Win!", preferredStyle: UIAlertControllerStyle.alert)
        winAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            let newPhrase = self.phrases.getRandomPhrase()
            self.currentGame = Game(word: newPhrase)
            self.updateOutlets()
        }))
        self.present(winAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var wrongGuess: UILabel!
    @IBOutlet weak var guessChar: UITextField!
    @IBOutlet weak var bg: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
