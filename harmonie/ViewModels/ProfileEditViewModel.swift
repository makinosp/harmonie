//
//  ProfileEditViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/23.
//

import Foundation
import VRCKit

class ProfileEditViewModel: ObservableObject {
    @Published var editingUserInfo: EditableUserInfo
    
    init(user: User) {
        editingUserInfo = EditableUserInfo(detail: user)
    }
}
