//
//  DetailRecipeViewController.swift
//  RecipeBook
//
//  Created by Hector Climaco on 14/04/23.
//  
//

import UIKit
import MapKit

protocol DetailRecipeDisplayLogic {
    
}

class DetailRecipeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBOutlet weak var nameRecipeLbl: UILabel!
    @IBOutlet weak var descriptionRecipeLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var locationRecipeNameLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressTitleLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    @IBOutlet weak var openMapBtn: UIButton!
    
    
    // MARK: - Variables
    
    var interactor: DetailRecipeBusinessLogic?
    var router: DetailRecipeRoutingLogic?
    var titleScreen: String = "DETAILS"
    var recipe = RecipeResponse(){
        didSet {
            recipeVM = DetailRecipe.ViewModel(recipe: self.recipe)
        }
    }
    
    var recipeVM:DetailRecipe.ViewModel = DetailRecipe.ViewModel()
    // MARK: - Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleScreen
        loadDetailView()
        configureView()
    }
    
    // MARK: - Configurators
    
    fileprivate func setup() {
        
        let viewcontroller   = self
        let interactor      = DetailRecipeInteractor()
        let presenter       = DetailRecipePresenter()
        let router          = DetailRecipeRouter()
        
        viewcontroller.interactor = interactor
        viewcontroller.router     = router
        interactor.presenter      = presenter
        presenter.view            = viewcontroller
        router.view               = viewcontroller
    }
    
    func configureView() {
        openMapBtn.backgroundColor = RecipeBookColor.Purple
        openMapBtn.layer.cornerRadius = 10
        openMapBtn.layer.masksToBounds = true
        openMapBtn.tintColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openMap))
        openMapBtn.addGestureRecognizer(tap)
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
    }
    
    func loadDetailView() {
        DispatchQueue.main.async {
            self.recipeImg.downloaded(from: self.recipe.image)
            self.recipeImg.contentMode = .scaleAspectFill
            self.nameRecipeLbl.text = self.recipe.name
            self.descriptionRecipeLbl.text = self.recipe.description
            self.ingredientsLbl.text = "\u{2022}" + self.recipe.ingredients.joined(separator: "\n\u{2022}")
            self.locationRecipeNameLbl.text = "Origen de \(self.recipeVM.titleRecipe)"
            self.configureLocation()
            self.adressLbl.text = self.recipeVM.adress
        }
    }
    
    func configureLocation() {
        let distance = CLLocationDistance(1000)
        let region = MKCoordinateRegion.init(center: recipeVM.location, latitudinalMeters: distance, longitudinalMeters: distance)
        let anotation = MKPointAnnotation()
        anotation.coordinate = recipeVM.location
        anotation.title = recipeVM.titleRecipe
        mapView.addAnnotation(anotation)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Private
    
    
    // MARK: - Actions
    
    @objc func openMap() {
        router?.goToMap(recipe: recipe)
    }
    
}

extension DetailRecipeViewController: DetailRecipeDisplayLogic {
    
}
