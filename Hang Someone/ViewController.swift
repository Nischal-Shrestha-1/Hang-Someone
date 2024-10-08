//
//  ViewController.swift
//  Hang Someone
//
//  Created by Nischal Shrestha on 2024-10-06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hangmanImageView: UIImageView!
    @IBOutlet var guessLetterLabels: [UILabel]!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet var keypadButtons: [UIButton]!
    
    let guessWord = "HANGMAN"
    var incorrectGuesses = 0
    var wins = 0
    var losses = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayWord()
    }

    func displayWord() {
        for (index, _) in guessWord.enumerated() {
            if index < guessLetterLabels.count {
                guessLetterLabels[index].text = "_"
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text else { return }
        
        sender.isEnabled = false
        
        if guessWord.contains(letter) {
            sender.backgroundColor = .systemGreen
            sender.layer.cornerRadius = 5
            sender.clipsToBounds = true
            updateDisplayedWord(with: letter)
        } else {
            sender.backgroundColor = .systemRed
            sender.layer.cornerRadius = 5
            sender.clipsToBounds = true
            incorrectGuesses += 1
            updateHangmanImage()
        }
    }
    
    func updateDisplayedWord(with letter: String) {
        for (index, char) in guessWord.enumerated() {
            if String(char) == letter {
                guessLetterLabels[index].text = letter
            }
        }
        
        for letter in guessLetterLabels {
            if (letter.text == "_") {
                return
            }
        }
        showGameWonAlert()
    }
    
    func updateHangmanImage() {
        let imageName = "Hangman_\(incorrectGuesses + 1)"
        hangmanImageView.image = UIImage(named: imageName)
            
        if incorrectGuesses >= 6 {
            showGameOverAlert()
        }
    }
    
    func showGameWonAlert() {
        hangmanImageView.image = UIImage(named: "Hangman_won")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.wins += 1
            self.updateScore()
            let alert = UIAlertController(title: "Woohoo!", message: "You saved me! Would you like to play again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: self.restartGame))
            alert.addAction(UIAlertAction(title: "No", style: .destructive))
            self.present(alert, animated: true)
        }
    }
    
    func showGameOverAlert() {
        losses += 1
        updateScore()
        let alert = UIAlertController(title: "Uh oh...", message: "The word was \(guessWord). Would you like to try again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: restartGame))
        alert.addAction(UIAlertAction(title: "No", style: .destructive))
        present(alert, animated: true)
    }
    
    func updateScore() {
        winsLabel.text = "\(wins)"
        lossesLabel.text = "\(losses)"
    }
    
    func restartGame(alert: UIAlertAction!) {
        incorrectGuesses = 0
        displayWord()
        updateHangmanImage()
        resetKeypad()
    }
    
    func resetKeypad() {
        for keypadButton in keypadButtons {
            keypadButton.isEnabled = true
            keypadButton.backgroundColor = .systemFill
            keypadButton.layer.cornerRadius = 5
            keypadButton.clipsToBounds = true
        }
    }
}

