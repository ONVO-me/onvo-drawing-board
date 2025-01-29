import Foundation
import UIKit

struct ImageUploader {
    
    static func uploadImage(_ imageData: Data, toURL urlString: String, user: String, token: String, viewController: UIViewController, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion("{\"error\" : \"Invalid URL.\"}")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()
        httpBody.append(convertFormField(named: "api", value: "native", using: boundary))
        httpBody.append(convertFileData(fieldName: "canvasImage", fileName: "image.png", mimeType: "image/png", fileData: imageData, using: boundary))
        httpBody.appendString("--\(boundary)--\r\n")
        request.httpBody = httpBody as Data

        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "Uploading Image\n\n", preferredStyle: .alert)
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()

            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false

            alert.view.addSubview(spinner)
            alert.view.addSubview(progressView)

            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                spinner.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 70),
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
                        completion("{\"error\" : \"Error uploading Image.\",\"message\": \"\(error.localizedDescription)\"}")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion("{\"error\" : \"Error uploading Image.\",\"message\": \"No HTTP response found, check your internet.\"}")
                        return
                    }

                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                        completion(responseText)
                    } else {
                        completion("No response text")
                    }
                }

                var observation: NSKeyValueObservation?
                observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                    DispatchQueue.main.async {
                        progressView.progress = Float(progress.fractionCompleted)
                    }
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
