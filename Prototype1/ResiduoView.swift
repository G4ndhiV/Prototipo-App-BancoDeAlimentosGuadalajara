import SwiftUI
import MapKit

struct ResiduoView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @StateObject private var viewModel = DonateClothesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("red-wp")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Logo and User Settings
                    HStack {
                        Image("RED-BAMX")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                        
                        Button(action: {
                            // Handle user settings action
                        }) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Formulario para los datos del residuo
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Reportar Ropa")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .bold()
                                .padding(.bottom, 10)
                            
                            Picker("Tipo de ropa", selection: $viewModel.clothType) {
                                                ForEach(viewModel.clothTypes, id: \.self) { type in
                                                    Text(type).tag(type)
                                                }
                                            }
                                            .pickerStyle(SegmentedPickerStyle())
                                            .padding()
                            
                            TextField("Talla de ropa (Ej: M, L, XL)", text: $viewModel.size)
                                               .textFieldStyle(RoundedBorderTextFieldStyle())
                                               .padding()
                            
                            TextField("Contacto (Email o Teléfono)", text: $viewModel.contactInfo)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .padding()
                            
                            if let location = viewModel.location {
                                                Text("Ubicación: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                                    .padding()
                                            }
                                            
                                            Button(action: {
                                                viewModel.requestLocation()
                                            }) {
                                                Text("Enviar Ubicación")
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                            .padding()
                            
                            // Foto de la prenda
                                            if let image = viewModel.image {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 200)
                                                    .cornerRadius(10)
                                            }
                                            
                                            Button(action: {
                                                viewModel.showImagePicker = true
                                            }) {
                                                Text("Tomar Foto")
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                            .padding()
                                            .sheet(isPresented: $viewModel.showImagePicker) {
                                                ImagePicker(image: $viewModel.image)
                                            }
                                            
                                            // Botón para enviar la donación
                                            Button(action: {
                                                viewModel.sendDonation()
                                            }) {
                                                Text("Enviar Donación")
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            }
                                            .padding()
                        }
                    }
                    .padding(.bottom, 70)
                }
                .navigationBarTitle("Reportar Residuo", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
            }
        }
        
    }
    
    
}

// ImagePicker struct para tomar una imagen desde el dispositivo
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}

#Preview {
    ResiduoView()
}
