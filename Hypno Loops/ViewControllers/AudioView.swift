//
//  AudioView.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 4/30/23.
//

import UIKit

class AudioView: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var audioTable: UITableView!
   
    var audioURLs: [URL?] = []
    //var testText = ["Hello", "World", "Hal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recorded Affirmations"
       loadLastRecording()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        audioURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = audioTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = audioURLs[indexPath.row]?.lastPathComponent
        return cell
    }
    
    @IBAction func testButtonPushed(_ sender: UIButton) {
        //loadLastRecording()
    }
    
    func loadLastRecording() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil, options: [])
            audioURLs = files.filter { $0.pathExtension == "m4a" }
            print("URLS", audioURLs)
            
        } catch {
            print("Error loading last recording: \(error.localizedDescription)")
        }
    }

}
