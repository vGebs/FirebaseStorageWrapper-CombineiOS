# FirebaseStorageWrapper-CombineiOS

`FirebaseStorageWrapper-CombineiOS` is a simple and easy-to-use wrapper class for Firebase Storage that uses Combine to process requests. It provides an easy way to upload, download and delete files, as well as manage metadata.

## Features

- push data to storage
- fetch from storage
- delete from storage
- update meta data
- fetch meta data

## Installation

### Swift Package Manager

You can install `FirebaseStorageWrapper-CombineiOS` using the [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, open your project and navigate to File > Swift Packages > Add Package Dependency.
2. Enter the repository URL `https://github.com/vGebs/FirebaseStorageWrapper-CombineiOS.git` and click Next.
3. Select the version you want to install, or leave the default version and click Next.
4. In the "Add to Target" section, select the target(s) you want to use `FirebaseStorageWrapper-CombineiOS` in and click Finish.

To use `FirebaseStorageWrapper-CombineiOS` in your project, you need to have:
- Firebase Storage and 
- Combine framework

You can add them to your project by following the instructions in the Firebase documentation and Apple documentation

## Usage 

Here is an example service class that demonstrates how to use the interface.

For more info, please look at the SampleUsage

```swift
class ProfileImageServiceCombine {
    private let storage: FirebaseStorageWrapperCombine
    private let baseURL: String
    
    init() {
        self.baseURL = "ProfileImages/"
        self.storage = FirebaseStorageWrapperCombine(maxFileSize: 30 * 1024 * 1024)
    }
    
    func pushImage(fileName: String, img: UIImage, metaData: [String: String]? = nil) throws -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        
        guard let imageData = img.jpegData(compressionQuality: 0.2) else {
            throw FirebaseStorageError.unknownError
        }
        
        return storage.uploadData(fileName: finalPath, fileData: imageData, metaData: metaData)
    }
    
    func fetchImage(fileName: String) -> AnyPublisher<UIImage?, Error> {
        let finalPath = self.baseURL + fileName
        
        return storage.downloadData(fileName: finalPath)
            .map { data in
                if let d = data {
                    return UIImage(data: d)
                } else {
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func deleteImage(fileName: String) -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        return storage.deleteFile(fileName: finalPath)
    }
    
    func getMetaData(fileName: String) -> AnyPublisher<[String: String]?, Error> {
        let finalPath = self.baseURL + fileName
        return storage.getMetaData(fileName: finalPath)
            .map { meta in
                if let m = meta {
                    return m.customMetadata
                } else {
                    return nil
                }
            }.eraseToAnyPublisher()
    }
    
    func updateMeta(fileName: String, metadata: [String: String]) -> AnyPublisher<Void, Error> {
        let finalPath = self.baseURL + fileName
        return storage.updateMetaData(fileName: finalPath, metadata: metadata)
    }
}
```

## Note

It's important to note that this is just an example, depending on your implementation and the architecture of your app, the `FirebaseStorageWrapper-CombineiOS` class could have more or less functionality and it is up to you to implement it in a way that fits your app.

## License 

This project is licensed under the MIT License - see the LICENSE file for details

## Contribution

If you want to contribute to this project, please follow these guidelines:

- Fork the repository and make the changes on your fork
- Test your changes to make sure they don't break existing functionality
- Create a pull request to the development branch of this repository

Please note that by contributing to this project, you agree to the terms and conditions of the MIT License.

Also, please make sure to follow the code of conduct when contributing.

