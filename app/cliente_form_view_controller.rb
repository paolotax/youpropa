class ClienteFormViewController < UITableViewController
  
  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']

  extend IB

  attr_accessor :cliente_id

  outlet :saveItem
  outlet :nome_text_field
  outlet :comune_text_field
  outlet :provincia_text_field
  outlet :cliente_tipo_text_field

  def viewDidLoad
    @cliente = Cliente.new
    true
  end

  def viewWillAppear(animated)
    load_cliente if cliente_id
  end

  def pickClienteTipo
    self.resignFirstResponder

    saveItem.enabled = false
    pickerView = TAXModalPickerView.alloc.initWithValues(TIPI_CLIENTI)
    
    if @cliente_tipo_text_field.text == ""
      pickerView.setSelectedValue "Cartolibreria"
    else
      pickerView.setSelectedValue @cliente_tipo_text_field.text
    end

    pickerView.presentInView(self.view, withBlock: lambda do | madeChoice, value |
        if madeChoice == true
          @cliente_tipo_text_field.text = value
        end
        saveItem.enabled = true
      end
    )
  end

  def pickProvincia
    self.resignFirstResponder

    saveItem.enabled = false
    pickerView = TAXModalPickerView.alloc.initWithValues(["BO", "MO", "RA", "RE"])
    
    if @provincia_text_field.text == ""
      pickerView.setSelectedValue "BO"
    else
      pickerView.setSelectedValue @provincia_text_field.text
    end

    pickerView.presentInView(self.view, withBlock: lambda do | madeChoice, value |
        if madeChoice == true
          @provincia_text_field.text = value
        end
        saveItem.enabled = true
      end
    )
  end

  def textFieldShouldReturn(field)
    field.resignFirstResponder
  end

  def save_button_pressed(sender)
    @cliente.nome      = nome_text_field.text
    @cliente.comune    = comune_text_field.text
    @cliente.provincia = provincia_text_field.text
    @cliente.cliente_tipo = cliente_tipo_text_field.text

    if @cliente.remote_id
      update_cliente
    else
      create_cliente
    end
  end

  def delete_button_pressed(sender)
    if @cliente.remote_id
      delete_cliente
    else
      App.alert("No cliente to delete, silly.")
    end
  end

  private

  def load_cliente
    @cliente = Cliente.new(remote_id: cliente_id)
    App.delegate.backend.getObject(@cliente, path:nil, parameters:nil, 
                              success: lambda do |operation, result|
                                                cliente_nome = result.firstObject.nome 
                                                nome_text_field.text = cliente_nome || ""
                                                comune_text_field.text = result.firstObject.comune || ""
                                                provincia_text_field.text = result.firstObject.provincia || ""
                                                cliente_tipo_text_field.text = result.firstObject.cliente_tipo || ""
                                              end,
                              failure: lambda do |operation, error|
                                                App.delegate.alert error.localizedDescription
                                              end)
  end

  def create_cliente
    puts "Creating new cliente #{@cliente.nome}"
    App.delegate.backend.postObject(@cliente, path:nil, parameters:nil,
                               success: lambda do |operation, result|
                                          self.navigationController.popViewControllerAnimated true 
                                        end,
                               failure: lambda do |operation, error|
                                                 App.alert error.localizedDescription
                                               end)
  end

  def update_cliente
    puts "Updating name for #{@cliente.remote_id} to #{@cliente.nome}"
    App.delegate.backend.putObject(@cliente, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                                puts "updated"
                                                self.navigationController.popViewControllerAnimated true
                                              end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end

  def delete_cliente
    puts "Deleting cliente #{@cliente.remote_id}"
    App.delegate.backend.deleteObject(@cliente, path:nil, parameters:nil,
                              success: lambda do |operation, result|
                                          self.navigationController.popViewControllerAnimated true    
                                       end,
                              failure: lambda do |operation, error|
                                                App.alert error.localizedDescription
                                              end)
  end

end