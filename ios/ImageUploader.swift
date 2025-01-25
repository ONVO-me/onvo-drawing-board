//
//  ImageUploader.swift
//  ONVO
//
//  Created by Abdelhamed Mohamed on 22/03/2024.
//


import Foundation
import UIKit

struct ImageUploader {
    
    static func uploadImage(_ imageData: Data, toURL urlString: String, draw: String, user: String, hide: Bool, viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(false)
            return
        }

        // Retrieve the token from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("No token found.")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create HTTP body with image data and other form fields
        let httpBody = NSMutableData()

        httpBody.append(convertFormField(named: "draw", value: draw, using: boundary))
        httpBody.append(convertFormField(named: "api", value: "native", using: boundary))

        // Append image data
        httpBody.append(convertFileData(fieldName: "canvasImage",
                                        fileName: "image.png",
                                        mimeType: "image/png",
                                        fileData: imageData,
                                        using: boundary))

        // Close the body with the boundary
        httpBody.appendString("--\(boundary)--\r\n")
        request.httpBody = httpBody as Data

        DispatchQueue.main.async {
            // Show the loading alert with a progress bar
            let alert = UIAlertController(title: nil, message: "Uploading Image\n\n", preferredStyle: .alert)

            // Adjust title and message alignment
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let attributedTitle = NSAttributedString(string: "Uploading Image", attributes: titleAttributes)
            alert.setValue(attributedTitle, forKey: "attributedTitle")

            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()

            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false

            alert.view.addSubview(spinner)
            alert.view.addSubview(progressView)

            // Constraints for spinner and progress view
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                spinner.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 70), // Adjust top spacing
                progressView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                progressView.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 20),
                progressView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
                progressView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20)
            ])

            viewController.present(alert, animated: true, completion: {
                let task = URLSession.shared.uploadTask(with: request, from: httpBody as Data) { data, response, error in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                    }

                    if let error = error {
                        DispatchQueue.main.async {
                            let errorAlert = UIAlertController(title: "Error uploading image", message: "\(error.localizedDescription)", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            viewController.present(errorAlert, animated: true)
                        }
                        completion(false)
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            let errorAlert = UIAlertController(title: "Error uploading image", message: "No HTTP response found, check your internet", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            viewController.present(errorAlert, animated: true)
                        }
                        completion(false)
                        return
                    }

                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                        if let data = data, let body = String(data: data, encoding: .utf8) {
                            DispatchQueue.main.async {

                            }
                        }
                        completion(true)
                    } else {
                        print("Server responded with status code: \(httpResponse.statusCode)")
                        completion(false)
                    }
                }

                // Declare the observation outside the closure
                var observation: NSKeyValueObservation?

                // Observe the task progress
                observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                    DispatchQueue.main.async {
                        progressView.progress = Float(progress.fractionCompleted)
                    }

                    // Remove observation when task completes
                    if progress.fractionCompleted == 1.0 {
                        observation?.invalidate()
                        observation = nil
                    }
                }

                task.resume()
            })
        }
    }

    
    private static func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.appendString("\(value)\r\n")
        return data as Data
    }
    
    private static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
