unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Grids, DBGrids, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, ExtCtrls, ZAbstractConnection, Math;

type
  Tfrmmain = class(TForm)
    CbLimit: TComboBox;
    Label1: TLabel;
    Edit_Search: TEdit;
    Label2: TLabel;
    DsData: TDataSource;
    Grid_Data: TDBGrid;
    LblRecord: TLabel;
    Connection_Data: TZConnection;
    QData: TZQuery;
    PanelButton: TPanel;
    LbPages: TLabel;
    btnprev: TButton;
    btnfirst: TButton;
    btnlast: TButton;
    btnnext: TButton;
    QCount: TZQuery;
    procedure FormCreate(Sender: TObject);
    procedure CbLimitChange(Sender: TObject);
    procedure Edit_SearchChange(Sender: TObject);
    procedure Grid_DataDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure btnfirstClick(Sender: TObject);
    procedure btnprevClick(Sender: TObject);
    procedure btnnextClick(Sender: TObject);
    procedure btnlastClick(Sender: TObject);
  private
    { Private declarations }
    procedure pagingrecord(nhal: Integer);
    function SetCueBanner(const Edit: TEdit;
      const Placeholder: string): Boolean;
    procedure clickbuttonpaging(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmmain: Tfrmmain;
  posisiawal, tothal, hal, datatotal: integer;

const
  btn_perhalaman = 5;
  posisi_btn_bold = 3;

implementation

{$R *.dfm}

//source: http://kppdi.id/membuat-placeholder-text-pada-komponen-tedit/  
function Tfrmmain.SetCueBanner(const Edit: TEdit;
  const Placeholder: string): Boolean;
const
  EM_SETCUEBANNER = $1501;
var
  UniStr: WideString;
begin
  UniStr := Placeholder;
  SendMessage(Edit.Handle, EM_SETCUEBANNER, WParam(True), LParam(UniStr));
  Result := GetLastError() = ERROR_SUCCESS;
end;

procedure Tfrmmain.clickbuttonpaging(Sender: TObject);
begin
  pagingrecord(TButton(Sender).Tag);
end;

//membuat procedure paging 
procedure Tfrmmain.pagingrecord(nhal: Integer);
var
  i, posisiakhir: Integer;
begin
  Screen.Cursor := crHourGlass;
  if (nhal >= 1) then
  begin
    posisiawal := (nhal - 1) * StrToIntDef(CbLimit.Text, 25);
    hal := nhal;
  end
  else begin
    posisiawal := 0;
    hal := 1;
  end;
  //tampilkan data + limit
  with QData do
  begin
    FetchRow := StrToIntDef(CbLimit.Text, 25);
    SQL.Text := 'select id, kelurahan, kecamatan, kota, propinsi, waktu from wilayah ' +
      'where id like :paramsearch or kelurahan like :paramsearch or kecamatan like :paramsearch ' +
      'or kota like :paramsearch or propinsi like :paramsearch order by id ' +
      'limit :paramoffset, :paramcount';
    ParamByName('paramsearch').AsString := '%' + Edit_Search.Text + '%';
    ParamByName('paramoffset').AsInteger := posisiawal;
    ParamByName('paramcount').AsInteger := StrToIntDef(CbLimit.Text, 25);
    Open;
  end;
  //cari jumlah record
  with QCount do
  begin
    SQL.Text := 'select count(*) totrecord from wilayah ' +
      'where id like :paramsearch or kelurahan like :paramsearch or kecamatan like :paramsearch ' +
      'or kota like :paramsearch or propinsi like :paramsearch';
    ParamByName('paramsearch').AsString := '%' + Edit_Search.Text + '%';
    Open;
  end;
  datatotal := QCount.Fields[0].AsInteger;
  tothal := Ceil(datatotal / StrToIntDef(CbLimit.Text, 25));
  if hal = tothal then posisiakhir := datatotal else posisiakhir := StrToIntDef(CbLimit.Text, 25) * hal;
  LblRecord.Caption := 'Showing ' + IntToStr(posisiawal + 1) + ' to ' + IntToStr(posisiakhir) + ' of ' + IntToStr(datatotal) + ' entries';
  LbPages.Caption := 'Page ' + IntToStr(hal) + ' / ' + IntToStr(tothal);
  //
  for i := btn_perhalaman downto 1 do
  begin
    with TButton(FindComponent('btn' + IntToStr(i))) do
    begin
      if hal = 1 then Align := alLeft;
      if tothal > btn_perhalaman then
      begin
        if hal <= tothal - posisi_btn_bold then
        begin
          if hal > posisi_btn_bold then
            Tag := i + (hal - posisi_btn_bold)
          else
            Tag := i;
        end
        else
          Tag := i + (hal - btn_perhalaman) + (tothal - hal);
        Caption := IntToStr(Tag);
        Visible := True;
        Hint := 'Halaman ke ' + IntToStr(Tag);
      end
      else begin
        if i > tothal then
          Visible := False
        else begin
          Caption := IntToStr(Tag);
          Visible := True;
          Hint := 'Halaman ke ' + IntToStr(Tag);
        end;
      end;
      if hal = Tag then Font.Style := [fsbold] else Font.Style := [];
      if hal = 1 then Align := alRight;
    end;
  end;
  //
  btnfirst.Enabled := tothal > 1;
  btnnext.Enabled := tothal > 1;
  btnprev.Enabled := tothal > 1;
  btnlast.Enabled := tothal > 1;
  //
  Screen.Cursor := crDefault;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  CbLimit.ItemIndex := 1;
  SetCueBanner(Edit_Search, 'search here');
  try
    with Connection_Data do
    begin
      HostName := 'localhost';
      Port := 3307;
      User := 'root';
      Password := '';
      Database := 'share';
      Connect;
    end;
  except
    on E: Exception do begin
      MessageDlg('Koneksi ke database gagal..' + #13 + 'Pesan error: ' + E.Message, mtError, [mbOK], 0);
      Application.Terminate;
    end;
  end;
end;

procedure Tfrmmain.CbLimitChange(Sender: TObject);
begin
  pagingrecord(0);
end;

procedure Tfrmmain.Edit_SearchChange(Sender: TObject);
begin
  pagingrecord(0);
end;

procedure Tfrmmain.Grid_DataDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  grid: TDBGrid;
  row: integer;
begin
  grid := sender as TDBGrid;
  row := grid.DataSource.DataSet.RecNo;
  if Odd(row) then
    grid.Canvas.Brush.Color := $00F9F9F9
  else
    grid.Canvas.Brush.Color := clWhite;
  grid.Canvas.Font.Color := clBlack;
  grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure Tfrmmain.FormShow(Sender: TObject);
var
  ii: Integer;
  buttonpaging: TButton;
begin
  for ii := btn_perhalaman downto 1 do
  begin
    buttonpaging := TButton.Create(Self);
    with buttonpaging do
    begin
      Parent := PanelButton;
      Align := alRight;
      Height := 25;
      Width := 33;
      Name := 'btn' + IntToStr(ii);
      Tag := ii;
      Caption := IntToStr(ii);
      Hint := 'Halaman ke ' + IntToStr(ii);
      ShowHint := True;
      Visible := True;
      OnClick := clickbuttonpaging;
    end;
  end;
  pagingrecord(0);
end;

procedure Tfrmmain.btnfirstClick(Sender: TObject);
begin
  pagingrecord(0);
end;

procedure Tfrmmain.btnprevClick(Sender: TObject);
begin
  if hal > 1 then pagingrecord(hal - 1) else pagingrecord(0)
end;

procedure Tfrmmain.btnnextClick(Sender: TObject);
begin
  if hal < tothal then pagingrecord(hal + 1) else pagingrecord(tothal)
end;

procedure Tfrmmain.btnlastClick(Sender: TObject);
begin
  pagingrecord(tothal);
end;

end.

