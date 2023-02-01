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
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var reverbButtonView: UIView!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    
    @IBOutlet weak var saveButtton: UIButton!
    
    var cornerRadiusModifier: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        micBackgroundView.layer.cornerRadius = cornerRadiusModifier
        recordButtonView.layer.cornerRadius = cornerRadiusModifier
        reverbButtonView.layer.cornerRadius = cornerRadiusModifier
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
}
