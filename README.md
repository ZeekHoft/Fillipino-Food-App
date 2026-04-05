
# Dappli 🍴

A food and recipe mobile application featuring Filipino food. Built with [Flutter](https://flutter.dev/).
## Preview ⭐
![BeFunky-collage](https://github.com/user-attachments/assets/0dcc20aa-1dfb-4b50-a9c9-ce8c176ded92)



## Features

### AI Recipe Scanning ✨

- Scan raw ingredients in your kitchen to discover suggested recipes
- AI automatically finds the best recipes based on the ingredients

### Dietary Considerations ⚠️

- Profile setup includes allergies and calorie intake limit
- Automatically detects allergies present or exceeding calories in recipes

### Social Features 🌐

- Follow and interact other users
- Post your own recipes to share with other users
- Browse the latest and trending recipes

## Getting Started

Instructions for building the project

### Prerequisites

- Flutter `3.38.3` (stable)
- Dart `3.10.1`

### Setup Project

- Open Terminal in a directory to store the code. Clone the repository with:

```
git clone https://github.com/ZeekHoft/Fillipino-Food-App.git
```

- Move to inside the folder

```
cd .\Fillipino-Food-App\
```

- Download all dependencies:

```
flutter pub get
```

### Running the project

Use an Android Emulator from [Android Studio](https://developer.android.com/studio) or from a manual install of [command line tools](https://developer.android.com/studio#command-line-tools-only). You can also connect to a physical Android device with USB debugging turned on. Use the following command:

```
flutter run
```

## Project Structure

```bash
Fillipino-Food-App/lib/
├── common_widgets/                 # widgets used throughout multiple files
├── models/                         # model classes
├── pages/                          # frontend layer
|   ├── authentication_page/        # login and register pages
|   └── camera/                     # camera scanning features
|   └── favorite/                   # bookmarked and saved recipes page
|   └── home_page/                  # homepage
|   └── settings/                   # settings
|   └── social/                     # social page
├── services/                       # services
├── themes/                         # themes
|   └── app_theme.dart              # theme class with predefined colors
├── util/                           # utilities
├── firebase_options.dart           # Firebase config
├── main.dart                       # app starts here
```

## Developer Team

<table>
	<tbody>
		<tr>
      <td align="center">
        <img src="https://github.com/ZeekHoft.png" width="100;" alt="lead dev"/>
        <br />
        <sub>Lead/Backend Programmer</sub>
        <br />
        <a href="https://github.com/ZeekHoft"><b>ZeekHoft</b></a>
      </td>
      <td align="center">
        <img src="https://github.com/h1tmd.png" width="100;" alt="frontend dev"/>
        <br />
        <sub>Frontend Developer</sub>
        <br />
        <a href="https://github.com/h1tmd"><b>h1tmd</b></a>
      </td>
      <td align="center">
        <img src="https://github.com/jvvpns.png" width="100;" alt="dev"/>
        <br />
        <sub>Developer</sub>
        <br />
        <a href="https://github.com/jvvpns"><b>jvvpns</b></a>
      </td>
		</tr>
	<tbody>
</table>
