//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Александр Пичугин on 03.09.2023.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func updateNewCategory(newCategoryName: String?)
}

final class CategoryViewModel {
    
    weak var delegate: CategoryViewModelDelegate?
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    @Observable
    private(set) var selectedCategory: CategoryModel?
    
    @Observable
    private(set) var categories: [CategoryModel] = []
    
    init() {
        categories = trackerCategoryStore.trackerCategories.map {CategoryModel(categoryName: $0.header)}
    }
    
    func selected(categoryName: String?) {
        guard let categoryName else {return} 
        selectedCategory = CategoryModel(categoryName: categoryName)
        delegate?.updateNewCategory(newCategoryName: categoryName)
    }
}

extension CategoryViewModel: NewCategoryViewControllerDelegate {
    func updateNewCategory(newCategoryName: String) {
        
        let newCategory = CategoryModel(categoryName: newCategoryName)
        if !categories.contains(where: { $0.categoryName == newCategoryName}) {
            categories.insert(newCategory, at: 0)
            try? trackerCategoryStore.addNewCategoryName(newCategoryName)
        }
        selectedCategory = newCategory
    }
}

