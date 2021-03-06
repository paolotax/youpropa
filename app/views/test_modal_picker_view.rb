class TestModalPickerView < UIViewController

  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']
  
  extend IB

  attr_accessor :items

  outlet :pickResultLabel

  def viewDidLoad
    super

    # edit = UITextField.alloc.initWithFrame([[10,200], [120,44]])
    # self.view.addSubview(edit)


    # @pickResultLabel.text = TIPI_CLIENTI[0]

    # tapRecognizer = UITapGestureRecognizer.alloc.initWithTarget(@pickResultLabel, action:"sendPick")
    # @pickResultLabel.addGestureRecognizer(tapRecognizer)
  end

  def sendPick
    pickerView = TAXModalPickerView.alloc.initWithValues(TIPI_CLIENTI)
    pickerView.setSelectedValue @pickResultLabel.text
    pickerView.presentInView(self.view, withBlock: lambda do | madeChoice, value |
        if madeChoice == true
          @pickResultLabel.text = value
        end
      end
    )
  end

  def killApp
    exit(0)
  end

  def login
    App.delegate.login
  end

end