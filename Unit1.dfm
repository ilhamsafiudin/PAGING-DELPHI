object frmmain: Tfrmmain
  Left = 165
  Top = 138
  BorderStyle = bsToolWindow
  Caption = 
    'Membuat fitur paging sederhana (mengikuti style datatables js) -' +
    ' Wak Ilham 2018'
  ClientHeight = 493
  ClientWidth = 849
  Color = 14120960
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 75
    Top = 26
    Width = 108
    Height = 13
    Caption = 'Show entries per page'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 600
    Top = 26
    Width = 37
    Height = 13
    Caption = 'Search:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LblRecord: TLabel
    Left = 15
    Top = 451
    Width = 141
    Height = 13
    Caption = 'Showing 1 to 10 of 17 entries'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object LbPages: TLabel
    Left = 431
    Top = 451
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Caption = 'Page 1 / 100'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object CbLimit: TComboBox
    Left = 16
    Top = 18
    Width = 57
    Height = 24
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 0
    Text = '10'
    OnChange = CbLimitChange
    Items.Strings = (
      '10'
      '25'
      '50'
      '100')
  end
  object Edit_Search: TEdit
    Left = 640
    Top = 18
    Width = 193
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = Edit_SearchChange
  end
  object Grid_Data: TDBGrid
    Left = 16
    Top = 51
    Width = 817
    Height = 390
    BorderStyle = bsNone
    Color = clWhite
    DataSource = DsData
    FixedColor = 15658734
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = Grid_DataDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Title.Alignment = taCenter
        Title.Caption = 'ID'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'kelurahan'
        Title.Caption = 'Kelurahan'
        Width = 169
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'kecamatan'
        Title.Caption = 'Kecamatan'
        Width = 138
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'kota'
        Title.Caption = 'Kota'
        Width = 151
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'propinsi'
        Title.Caption = 'Propinsi'
        Width = 111
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'waktu'
        Title.Caption = 'Waktu'
        Width = 134
        Visible = True
      end>
  end
  object PanelButton: TPanel
    Left = 568
    Top = 449
    Width = 165
    Height = 25
    BevelOuter = bvNone
    Color = 14120960
    TabOrder = 5
  end
  object btnprev: TButton
    Left = 534
    Top = 449
    Width = 33
    Height = 25
    Hint = 'Prev'
    Caption = 'Prev'
    TabOrder = 4
    OnClick = btnprevClick
  end
  object btnfirst: TButton
    Left = 501
    Top = 449
    Width = 33
    Height = 25
    Hint = 'First'
    Caption = 'First'
    TabOrder = 3
    OnClick = btnfirstClick
  end
  object btnlast: TButton
    Left = 767
    Top = 449
    Width = 33
    Height = 25
    Hint = 'Last'
    Caption = 'Last'
    TabOrder = 7
    OnClick = btnlastClick
  end
  object btnnext: TButton
    Left = 734
    Top = 449
    Width = 33
    Height = 25
    Hint = 'Next'
    Caption = 'Next'
    TabOrder = 6
    OnClick = btnnextClick
  end
  object DsData: TDataSource
    DataSet = QData
    Left = 288
    Top = 10
  end
  object Connection_Data: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = False
    HostName = 'localhost'
    Port = 3307
    Database = 'share'
    User = 'root'
    Protocol = 'mysql'
    Left = 320
    Top = 10
  end
  object QData: TZQuery
    Connection = Connection_Data
    SQL.Strings = (
      'select id, kelurahan,'
      'kecamatan, kota, propinsi, waktu from wilayah'
      'limit 100')
    Params = <>
    Left = 352
    Top = 10
  end
  object QCount: TZQuery
    Connection = Connection_Data
    Params = <>
    Left = 384
    Top = 10
  end
end
