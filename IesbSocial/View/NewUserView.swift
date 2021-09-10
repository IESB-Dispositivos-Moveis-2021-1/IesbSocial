//
//  UserFormView.swift
//  IesbSocial
//
//  Created by Pedro Henrique on 09/09/21.
//

import SwiftUI

struct NewUserView: View {
    
    @State
    private var name = ""
    
    @State
    private var email = ""
    
    @State
    private var phone = ""
    
    @State
    private var website = ""
    
    @State
    private var zipcode = ""
    
    @State
    private var street = ""
    
    @State
    private var suite = ""
    
    @State
    private var city = ""
    
    @State
    private var companyName = ""
    
    @State
    private var catchPhrase = ""
    
    @State
    private var bs = ""
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @EnvironmentObject
    private var viewModel: UserViewModel
    
    @ObservedObject
    var viaCepViewModel: ViaCepViewModel
    
    private var canSave: Bool {
        if name.isEmpty { return false }
        if email.isEmpty { return false }
        if phone.isEmpty { return false }
        if website.isEmpty { return false }
        if zipcode.isEmpty { return false }
        if street.isEmpty { return false }
        if city.isEmpty { return false }
        if suite.isEmpty { return false }
        if companyName.isEmpty { return false }
        if catchPhrase.isEmpty { return false }
        if bs.isEmpty { return false }
        return true
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Dados Pessoais")) {
                    
                    FormField(
                        label: "Nome Completo:",
                        placeholder: "Fulano da Silva",
                        text: $name
                    )
                    
                    FormField(
                        label: "E-mail:",
                        placeholder: "fulano@provedor.com",
                        text: $email
                    )
                    
                    FormField(
                        label: "Telefone:",
                        placeholder: "(00) 00000-0000",
                        text: $phone
                    )
                    
                    FormField(
                        label: "Site:",
                        placeholder: "https://www.fulano.com",
                        text: $website
                    )
                    
                }
        
                
                if viaCepViewModel.loading {
                    LoadingView()
                }else {
                    Section(header: Text("Endereço")) {
                        
                        FormField(
                            label: "CEP:",
                            placeholder: "00000-000",
                            text: $zipcode
                        )
                        
                        FormField(
                            label: "Cidade:",
                            placeholder: "Pindamonhangaba",
                            text: $city
                        )
                        
                        FormField(
                            label: "Logradouro:",
                            placeholder: "Rua do Swift",
                            text: $street
                        )
                        
                        FormField(
                            label: "Número:",
                            placeholder: "10",
                            text: $suite
                        )
                        
                    }
                }
                
                Section(header: Text("Empresa")) {
                    FormField(
                        label: "Razão Social:",
                        placeholder: "Vila do Chaves LTDA.",
                        text: $companyName
                    )
                    
                    FormField(
                        label: "Nome Fantasia:",
                        placeholder: "Vila do Chaves",
                        text: $bs
                    )
                    
                    FormField(
                        label: "Slogan:",
                        placeholder: "Pague o Aluguel",
                        text: $catchPhrase
                    )
                    
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(name)
            .navigationBarItems(
                leading: Button("\(Image(systemName: "xmark"))") {
                    presentationMode.wrappedValue.dismiss()
                }.font(Font.title2.weight(.light)),
                trailing: Button("\(Image(systemName: "checkmark"))") {
                    let user = User(
                        id: 0,
                        name: name,
                        username: email,
                        email: email,
                        address: Address(
                            street: street,
                            suite: suite,
                            city: city,
                            zipcode: zipcode,
                            geo: Geo(lat: "", lng: "")
                        ),
                        phone: phone,
                        website: website,
                        company: Company(
                            name: companyName,
                            catchPhrase: catchPhrase,
                            bs: bs
                        )
                    )
                    
                    viewModel.save(user)
                    presentationMode.wrappedValue.dismiss()
                }.font(Font.title2.weight(.light)).disabled(!canSave)
            )
            .onChange(of: zipcode) { zip in
                if zip.count == 8 {
                    viaCepViewModel.fetchAddress(with: zip)
                }
            }
            .onReceive(viaCepViewModel.$address) { address in
                city = address?.localidade ?? ""
                street = address?.logradouro ?? ""
            }
        }
    }
}

fileprivate struct FormField: View {
    
    let label: String
    let placeholder: String
    let text: Binding<String>
    let required = true
    let readonly = false
    
    let labelColor = Color.black.opacity(0.65)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                    .foregroundColor(labelColor)
                if required {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            .font(Font.caption)
            if readonly {
                Text(text.wrappedValue)
            }else {
                TextField(placeholder, text: text)
            }
        }
    }
    
}
