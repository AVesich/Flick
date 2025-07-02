//
//  Searchable.swift
//  Flick
//
//  Created by Austin Vesich on 6/18/25.
//

protocol Searchable {
    associatedtype T: SearchableItem, Identifiable
    func search(withQuery queryString: String) async -> [T]
}
