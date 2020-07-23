# Udacity iOS Development Final Project: GIFU

## Overview
This is an iPhone app targeting iOS 13.0+. It allows users to search for GIF pictures using their keyword, as well as to explore trending GIF pictures.

## Technology Requirements
- iOS 13.0+
- Xcode 11.0+
- Swift 5.1+

## Dependency
This app uses an open source Swift package `SDWebImageSwiftUI`, which is for displaying animated images such as GIF pictures. It is listed in the XCode project file as a dependency.

## User Guide
This app has two tabs: "Search" and "Trending".

In the "Search" tab, users can type in a keyword in the search field. When they tap return on the keyboard, a search will occur to fetch GIF pictures related to the keyword. A loading spinner will appear while the search is happening. When the search finished, all the GIF pictures will show in a waterfall grid structure. If there aren't any GIF pictures returned, a text will show indicating so. If the search failed, a text will also show to indicate the failure.

In the "Trending" tab, the app will automatically fetch the trending GIF pictures from the internet, not requiring any user input.

## Technical Details
### User Interface
- All the user interfaces are built with SwiftUI.
- Displaying each GIF picture relies on the third-party library `SDWebImageSwiftUI` because neither UIKit nor SwiftUI has built-in components for showing animated images.
- The waterfall grid layout is implemented by real-time calculation based on the screen dimension and each GIF size.

### GIF Data Source
- All the GIF pictures are fetched from Giphy using their public APIs https://developers.giphy.com/docs/api. 
- Specifically, the search tab uses the search API, and the trending tab uses the trending API.

### Data Persistence
- This app uses the Core Data as well as User Default for data persistence.
- User Default is used to store the latest search keyword, so that when the user re-opens the app, or switches back to the search tab from the trending tab, the last search keyword, as well as the search result, are still there.
- The search results for the last 5 searches are persistent in Core Data, which means if a search keyword was already used within the last 5 searches, the results should appear immediately.
- The trending results are also persistent in Core Data. If the trending results were fetched within the last hour, it would just use the results that are already persistent in Core Data. Otherwise it would refetch the trending GIFs from the Internet and refresh the data in Core Data.