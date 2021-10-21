//
//  CategoryViewModel.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/13.
//

import Foundation


class CategoryViewModel {
    
    var title: String
    
    var helperButtonTitle: String
    
    init(category: TDCategory) {
        self.title = category.title
        if self.title == "CategoryView_system_recently_deleted".localized {
            self.helperButtonTitle = "CategoryView_recently_delete_trailing_title".localized
        } else {
            self.helperButtonTitle = "CategoryView_trailing_delete_title".localized
        }
    }
}
