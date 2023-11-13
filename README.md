#Video Player App Documentation
##App Architecture

The Video Player App follows a modular and organized architecture. The project is structured into several directories to maintain clean code and separate concerns. Here's an overview of the key components:

**Project Structure:**

- `lib/main.dart`: The entry point of the application.
- `lib/screens`:	
  - `SplashScreen.dart`: Fetches and stores the JSON file, handling internet connectivity issues and storing the file for offline use.
  - `VideoList.dart`: Displays a ListView of videos, retrieves background color from JSON, and implements "Rate App" and "Share" buttons at the appBar.
- `lib/player/video_player.dart`: Plays the selected video in landscape mode.
- `lib/model/videoListModel.dart`: Defines the structure of a video, including title, thumbnail, and description considering sometimes the elements can be null and handling when those errors happen.
- `lib/utils`:
  - `colors.dart`: Converts the received Hex code of the color to flutter readable code.
  - `customdialog.dart`: A widget to display a custom dialog when there is an error from the server or no internet connection.

**Dependencies:**

The app relies on several Flutter packages for enhanced functionality:

- Dio for making HTTP requests.
- pod_player: for video playback.
- Flutter_share: for sharing the app.
- Google_mobile_ads: for integrating AdMob interstitial ads.
- Shared_preferences: for saving retrieved JSON file locally for later use.
- Connectivity: For checking the device's data status, determining if there is an internet connection.

**Key Decisions:**

**Data Fetching and Storage:**

The app fetches video information from a server-hosted JSON file using the dio package.

In case of no internet or server access, the app gracefully falls back to using the locally stored JSON file.

**Video Playback:**

Video playback is handled by the pod_player package, ensuring a seamless experience.

Landscape mode is properly supported for an optimal video viewing experience.

**AdMob Integration:**

AdMob interstitial ads are seamlessly integrated using the Google_mobile_ads package.

Ads automatically reload for subsequent video plays, providing a non-intrusive ad experience.

**Error Handling:**

The app gracefully handles scenarios where there is no internet or server access, ensuring a smooth user experience.

Custom dialogs, implemented with `customdialog.dart`, provide informative messages for error situations.
