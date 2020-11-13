//
//  Constants.swift
//  junochallenge
//
//  Created by Eduardo Maia on 12/11/20.
//

import UIKit

let apiBaseUrl: String = "https://api.github.com/search/repositories?q="
let apiPage: String = "&page="
let apiPerPage: String = "&per_page="
let apiLimitPage = 25
var page = 1
var totalItems = 0
let colorPrimary = UIColor(red: 43 / 255, green: 47 / 255, blue: 250 / 255, alpha: 1)
let colorSecundary = UIColor(red: 9 / 255, green: 28 / 255, blue: 93 / 255, alpha: 1)
let defaultImage = UIImage(named: "placeholder")
