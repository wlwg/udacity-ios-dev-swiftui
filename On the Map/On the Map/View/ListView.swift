//
//  ListView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct ListRow: View {
    var studentLocation: StudentLocation
    
    var body: some View {
         HStack {
            Image("icon_pin").resizable().frame(maxWidth: 30, maxHeight: 30)
            VStack(alignment: .leading) {
                Text(studentLocation.fullName)
                Text(studentLocation.mediaURL).font(.footnote).foregroundColor(.gray)
            }
         }
    }
}

struct ListView: View {
    @EnvironmentObject var appState: AppState
    
    let onTapItem: (String?) -> Void

    var body: some View {
        List(appState.studentLocations, id: \.objectId) { location in
            ListRow(studentLocation: location)
                .onTapGesture {
                    self.onTapItem(location.mediaURL)
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(onTapItem: {string in})
    }
}
