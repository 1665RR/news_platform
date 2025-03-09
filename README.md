# news_app_project

A Flutter app for reading news.

## Versions Used

This project was developed with the following versions:

### Flutter Version
- **Flutter**: 3.13.5
- **Dart Version**: 3.1.2
- **DevTools Version**: 2.25.0

## Getting Started

To get started with the project, follow these steps:

### Step 1: Install Flutter Version Manager (FVM)

FVM allows you to manage multiple versions of Flutter easily. To install FVM, follow the instructions from the official repository:

1. **Install FVM (if you haven't already)**:
   ```bash
    dart pub global activate fvm

2. **Install FVM (if you haven't already)**:
   ```bash
    fvm install 3.13.5

3. **Use installed version**:
   ```bash
    fvm use 3.13.5

4. **Clone the repository**:
   Clone the repository to your local machine:
   ```bash
   git clone https://github.com/1665RR/news_platform.git

5. **Navigate to the project directory: Change into the project folder:**
   ```bash
   cd news_app_project

6. **Install dependencies:**
   ```bash
   fvm flutter pub get

## Running the Project with a Signed App

To build and run the signed version of this Flutter project, you will need to configure the signing setup with a keystore file. 

### 1. Add the Keystore File

You will receive the `keystore.jks` file from the project owner. Once you have the file:

1. Place the `keystore.jks` file in the root directory of your project

### 2. Rename and Fill the `key.properties` File

1. In the `android` directory, you will find a `key.properties.example` file. Rename it to `key.properties`

2.  Open the `key.properties` file and populate it with the information provided from send key.properties file:

```properties
storePassword=your-keystore-password
keyPassword=your-key-password
keyAlias=your-key-alias
storeFile=../your-keystore.jks
```

### 3.Once the keystore and signing configuration are in place, you can build the signed APK

1. **Run the app:**
   ```bash
   fvm flutter run

2. **Building the App for testing purposes:**
   ```bash
    fvm flutter build apk --debug


