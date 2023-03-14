//
//  AffirmationsView.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/25/23.
//

import UIKit

let affirmations: [String: [String]] = [ //this will be replaced with AffirmationData
    "Divine Healing": ["I receive Gods healing into my cells", "The power of Gods love heals me", "The Fountain of Gods love healed me", "The Power of God has healed me", "I am intuitively guided to my healing", "I knew I was healed like God promised", "I am divinely guided to my healing"],
    
    "Gratitude": ["My body corrected all irregularities", "My body perfectly repaired this", "I'm so grateful my body cleaned it up", "Thank you “body” for letting this go", "Thank you “body” for healing yourself", "I am grateful to be whole, I am healthy in my body"],

    "Self belief": ["I knew I could heal myself", "I knew I could recover from this", "I knew I would heal myself", "I am healed", "I am strong", "I trust my body to heal"],

    "Intuition": ["My Intuition guided me through this", "I knew Gods love could heal me", "I knew I'd discover ways to heal this", "I am intuitively guided to my healing"]
    ]

var showAffirmation = affirmations["Divine Healing"] //receiving var fromm sections CV

class AffirmationsView: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var affirmationCV: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!//SOURCE1
    let affirmationsString = AffirmationStings()

    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        affirmationCV.collectionViewLayout = configureLayout()
        configureDataSource()
    }
    
    //MARK: - Layout
    private func configureLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let groupItemCount = 1
        
        // Item definition
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        
        // Group definition
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.22)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: groupItemCount
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: 5,
            bottom: 5,
            trailing: 5
        )
        // Section and layout definition
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    //MARK: - DataSource
    private func configureDataSource() {
        ///CELL
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: affirmationCV, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffirmationCell.reuseidentifier, for: indexPath) as! AffirmationCell
            cell.layer.cornerRadius = CornerRadiusModifiers.normal.size
            cell.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
            cell.layer.borderWidth = BorderSize.small.size
            cell.layer.backgroundColor = UIColor.black.cgColor
            cell.selectedButton.layer.cornerRadius = CornerRadiusModifiers.small.size
            
            //cell.affirmationLabel.text = affirmationsString.affirmations[indexPath.item]
            //cell.affirmationLabel.text = lessonLabelName[item.description]
            
            //affirmationTexts = affirmations[item.description] ?? [] // get the array of affirmations for the given key, or an empty array if not found
            //let affirmationTexts = affirmations[item.description] ?? []
            cell.affirmationLabel.text = showAffirmation![indexPath.item] //showAfffirmation is an optional array built from affirmations Dict. Then Item bulds cells from string sentences.
            
            return cell
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()//SOURCE3
        
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(showAffirmation!)

        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
}
