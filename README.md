ios_twitter_redux
=================

Twitter iOS App (Redux Version)

Build a simple Twitter client that supports HAMBURGER menu.

## Walkthrough of all user stories

[![image](https://raw.githubusercontent.com/wiki/stanleyhlng/ios_twitter_redux/assets/ios_twitter_redux.gif)](https://raw.githubusercontent.com/wiki/stanleyhlng/ios_twitter_redux/assets/ios_twitter_redux.gif)

## Completed user stories

 * Hamburger menu
   * [x] Required: Dragging anywhere in the view should reveal the menu.
   * [x] Required: The menu should include links to your profile, the home timeline, and the mentions view.
   * [x] Required: The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
 * Profile page
   * [x] Required: Contains the user header view
   * [x] Optional: Implement the paging view for the user description.
   * [x] Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   * [x] Optional: Pulling down the profile page should blur and resize the header image.
   * [ ] Optional: Contains a section with the users basic stats: # tweets, # following, # followers
 * Home Timeline
   * [x] Required: Tapping on a user image should bring up that user's profile page
 * Account switching
   * [x] Optional: Long press on tab bar to bring up Account view with animation
   * [ ] Optional: Tap account to switch to
   * [ ] Optional: Include a plus button to Add an Account
   * [ ] Optional: Swipe to delete an account

## Time spent
15 hours spent in total

## Libraries
```
platform :ios, '7.0'

pod 'AFNetworking', '~> 2.2.0'
pod 'GSProgressHUD', '~> 0.2'
pod 'Reveal-iOS-SDK', '~> 1.0.4'
pod 'SDWebImage', '~> 3.6'
pod 'UIActivityIndicator-for-SDWebImage', '~> 1.0.5'
pod 'AVHexColor', '~> 1.2.0'
pod 'BDBOAuth1Manager', '~> 1.2.1'
pod 'Mantle', '~> 1.5'
pod 'DateTools', '~> 1.3.0'
pod "AMSlideMenu", "~> 1.5.3"
pod 'LBBlurredImage', '~> 0.2.0'
```
