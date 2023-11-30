//
//  AvatarView.swift
//  RandomUser
//
//  Created by ksd on 21/09/2023.
//

import SwiftUI

struct AvatarView: View {
    
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 7)
            .frame(width: 80, height: 80)
    }
}

#Preview {
    AvatarView(image: Image(systemName: "person.fill"))
}
