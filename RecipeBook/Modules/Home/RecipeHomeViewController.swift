//
//  RecipeHomeViewController.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//

import UIKit

protocol RecipeHomeDisplayLogic {
    func displayRecipes(recipes:[RecipeResponse])
    func goToDetail(recipe:RecipeResponse)
}

class RecipeHomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    // MARK: - Variables
    fileprivate var barButton: UIBarButtonItem?
    fileprivate var titleViewAux: UIView?
    public var searchBar =  UISearchBar()
    var searchBarPlaceHolder: String = "Buscar"
    var titleScreen: String = "Home Recipes"
    
    var recipes:[RecipeResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipeCollectionView.reloadData()
            }
        }
    }
    
    var recipesFilter:[RecipeResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipeCollectionView.reloadData()
            }
        }
    }
    
    var isFilterActive:Bool = false
    
    var interactor: RecipeHomeBusinessLogic?
    var router: RecipeHomeRoutingLogic?
    
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
        
        configureNavigation()
        createSearchButton()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interactor?.getRecipes(page: 0)
        let _ = Commons.validateLocationPermissions(view: self)
    }
    // MARK: - Configurators
    
    fileprivate func setup() {
        
        let viewcontroller   = self
        let interactor      = RecipeHomeInteractor()
        let presenter       = RecipeHomePresenter()
        let router          = RecipeHomeRouter()
        
        viewcontroller.interactor = interactor
        viewcontroller.router     = router
        interactor.presenter      = presenter
        presenter.view            = viewcontroller
        router.view               = viewcontroller
    }
    
    fileprivate func configureNavigation() {
        
        if let nav =  self.navigationController?.navigationBar {
            nav.barTintColor = RecipeBookColor.Purple
            nav.tintColor = .white
            
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = RecipeBookColor.Purple
                appearance.titleTextAttributes = [ .foregroundColor : UIColor.white]
                nav.standardAppearance = appearance
                nav.scrollEdgeAppearance =  nav.standardAppearance
            }
        }
    }
    
    fileprivate func configureCollectionView() {
        recipeCollectionView.register(UINib(nibName: RecipeCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: RecipeCell.identifier)
        recipeCollectionView.dataSource = self
        recipeCollectionView.delegate = self
    }
    
    // MARK: - Private
    fileprivate func createSearchButton() {
        barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonAction))
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func createSearchBar() {
        //se guarda el title view
        titleViewAux =  self.navigationItem.titleView
        
        //se quita el searchbutton
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
        searchBar.sizeToFit()
        searchBar.placeholder = searchBarPlaceHolder
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .purple
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.titleView = searchBar
    }
    
    func restarView() {
        searchBar.removeFromSuperview()
        createSearchButton()
        self.navigationItem.titleView = titleViewAux
        self.isFilterActive = false
        self.recipesFilter = []
    }
    
    func searchRecipOrIngredient(word:String) {
        let result = recipes.filter { recipe in
            return recipe.name.lowercased().contains(word) || recipe.ingredients.filter{ $0.lowercased().contains(word) }.count > 0
        }
        self.recipesFilter = result
    }
    
    // MARK: - Actions

    
    @objc func searchButtonAction() {
        createSearchBar()
    }
    
}

extension RecipeHomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        restarView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            isFilterActive = true
            self.searchRecipOrIngredient(word: searchText.lowercased())
        } else{
            isFilterActive = false
            self.recipesFilter = []
        }
    }
}

extension RecipeHomeViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFilterActive {
            return recipes.count
        } else {
            return recipesFilter.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell {
            if !isFilterActive {
                cell.recipe = recipes[indexPath.row]
            } else {
                cell.recipe = recipesFilter[indexPath.row]
            }
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        router?.routeToDetail(recipes[indexPath.row])
    }
}

extension RecipeHomeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ( recipeCollectionView.layer.frame.width / 2) * 0.95
        let height = width * 1.75
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
}

extension RecipeHomeViewController: RecipeHomeDisplayLogic {
    func displayRecipes(recipes:[RecipeResponse]) {
        self.recipes = recipes
    }
    
    func goToDetail(recipe:RecipeResponse) {
        router?.routeToDetail(recipe)
    }
    
}


