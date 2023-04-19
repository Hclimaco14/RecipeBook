//
//  RecipeCell.swift
//  RecipeBook
//
//  Created by Hector Climaco on 13/04/23.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    public static let identifier = String(describing: RecipeCell.self)
//    Variables
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var titleFoodLbl: UILabel!
    @IBOutlet weak var descriptionFoodLbl: UILabel!
    
    var delegate: RecipeHomeDisplayLogic?
    
    var recipe: RecipeResponse?{
        didSet {
            DispatchQueue.main.async {
                self.setupRecipe()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    fileprivate func configureCell(){
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.contentView.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToDetail))

        self.contentView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupRecipe() {
        if let recipe = recipe {
            let recipeVM = RecipeHome.ViewModel(recipe: recipe)
            foodImg.downloaded(from: recipeVM.imageURL)
            titleFoodLbl.text = recipeVM.recipeName
            descriptionFoodLbl.text = recipeVM.recipDescription
        }
    }
    
    @objc func goToDetail() {
        guard let recipe = recipe else { return }
        delegate?.goToDetail(recipe: recipe)
    }
}
