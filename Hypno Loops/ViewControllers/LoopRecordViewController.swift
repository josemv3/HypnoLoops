//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit

class LoopRecordViewController: UIViewController {

    @IBOutlet weak var affirmationNameLabel: UILabel!
    @IBOutlet weak var affirmationNameTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var micBackgroundView: UIView!
    @IBOutlet weak var micImageView: UIImageView!
    
    @IBOutlet weak var controlsBackgroundView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    
    @IBOutlet weak var saveButtton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        micBackgroundView.layer.cornerRadius = 10
        controlsBackgroundView.layer.cornerRadius = 10
        //recordButton.layer.cornerRadius = 0.5 * recordButton.bounds.size.width
        //playButton.layer.cornerRadius = 0.5 * playButton.bounds.size.width
        
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
}
