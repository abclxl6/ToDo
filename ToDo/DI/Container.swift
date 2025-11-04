//
//  Container+Dependencies.swift
//  ToDo
//
//  Registers app-wide dependencies for Factory DI.
//

import Foundation
import Factory

extension Container {
    @MainActor
    var authenticationViewModel: Factory<AuthenticationViewModel> {
        self { @MainActor  in AuthenticationViewModel() }.shared
    }
}


