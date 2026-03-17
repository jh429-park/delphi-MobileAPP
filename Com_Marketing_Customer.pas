unit Com_Marketing_Customer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMXTee.Series, FMX.StdCtrls,
  System.Threading,
  System.UIConsts,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts, FMXTee.Chart.Functions,
  FMX.Objects, FMX.DateTimeCtrls, FMX.TMSBaseControl, FMX.TMSDateTimeEdit,
  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
  FMX.TMSGrid, FMX.ListBox;

type
  TfrmCom_Marketing_Customer = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Chart: TLayout;
    Chart1: TChart;
    Layout1: TLayout;
    Series1: TBarSeries;
    cboYear: TComboBox;
    cboMonth: TComboBox;
    cbxFM: TCheckBox;
    cboCompany: TComboBox;
    Layout2: TLayout;
    Text2: TText;
    Text1: TText;
    TMSFMXGrid1: TTMSFMXGrid;
    DateEdit_Fr: TDateEdit;
    btnClose: TButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);

    procedure ComboBoxChange(Sender: TObject);
    procedure TMSFMXGrid1GetCellAppearance(Sender: TObject; ACol, ARow: Integer;
      Cell: TFmxObject; ACellState: TCellState);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Marketing_Customer: TfrmCom_Marketing_Customer;
  l_Height:Single;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Marketing_Customer.FormCreate(Sender: TObject);
var i,c:integer;
var v_Date:TDateTime;
var Year, Month, Day: Word;
begin
//cboCompany.BeginUpdate;
  for i:=Low(c_CompanyName) to High(c_CompanyName) do begin
    cboCompany.Items.Add(c_CompanyName[i]);
    if g_User_Company=c_Company[i] then cboCompany.ItemIndex := i;
  end;
//cboCompany.EndUpdate;

  c:=0;
  for i:=0 to Self.ComponentCount-1 do begin
    if Pos('BUTTON',UpperCase(Self.Components[i].Name))>0 then begin
       c:=c+1;
    end;
  end;

  for i:=0 to Self.ComponentCount-1 do begin
    if Pos('BUTTON',UpperCase(Self.Components[i].Name))>0 then begin
       TButton(Self.Components[i]).Width := Self.Width/c;
    end;
  end;

  v_Date := System.SysUtils.IncMonth(Now,-1);

  DecodeDate(v_Date,Year,Month,Day);

//cboYear.BeginUpdate;
//cboMonth.BeginUpdate;
  for i:=Year downto Year-5 do cboYear.Items.Add(i.ToString);
  for i:=1    to 12         do cboMonth.Items.Add(FormatFloat('00',i));
  cboYear.ItemIndex    := cboYear. Items.IndexOf(FormatDateTime('YYYY',v_Date));
  cboMonth.ItemIndex   := cboMonth.Items.IndexOf(FormatDateTime('MM',  v_Date));
//cboYear.EndUpdate;
//cboMonth.EndUpdate;

  DateEdit_Fr.DateTime := EncodeDate(Year-5,1,1);
  chart1.visible := false;
end;


procedure TfrmCom_Marketing_Customer.FormShow(Sender: TObject);
begin
  l_Height := Layout_Chart.Height;
  Label_Title.Text := g_Sel_Title;
  chart1.visible := true;
  btnQueryClick(Sender);

//  TTask.Run(procedure
//  begin
//    sleep(35);
//    TThread.Synchronize(nil, procedure
//    begin
//      chart1.visible := true;
//      btnQueryClick(Sender);
//    end);
//  end);


end;



procedure TfrmCom_Marketing_Customer.ComboBoxChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;




procedure TfrmCom_Marketing_Customer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Marketing_Customer.btnQueryClick(Sender: TObject);
    var i:integer;
        v,w:Double;
        s:String;
        c:TAlphaColor;
begin
        g_Sel_Title      := '';
        for i:=0 to Self.ComponentCount-1 do begin
          if Pos('BUTTON',UpperCase(Self.Components[i].Name))>0 then begin
             TButton(Self.Components[i]).FontColor := TAlphaColors.Gray;
          end;
        end;
        TButton(Sender).FontColor := TAlphaColors.Green;

//      Chart1.BeginUpdate;
        Chart1.View3D         := false;
        Chart1.Title.Visible  := true;
        Chart1.Legend.Visible := false;
        Chart1.RemoveAllSeries;
        w:=0;
//      TMSFMXGrid1.BeginUpdate;
        TMSFMXGrid1.Clear;
        TMSFMXGrid1.SelectionMode:= smSingleRow;
        TMSFMXGrid1.RowCount     := 1;
        with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;
      //  ParamByName('arg_Company').AsString := g_Sel_Company;
          ParamByName('arg_Company').AsString := c_Company[cboCompany.ItemIndex];
          ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
          ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
          ParamByName('arg_DateFr' ).AsString := FormatDateTime('YYYYMMDD',DateEdit_Fr.DateTime);
          ParamByName('arg_DateTo' ).AsString := cboYear.Items[cboYear.ItemIndex]+cboMonth.Items[cboMonth.ItemIndex]+'99';
          ParamByName('arg_TEXT01' ).AsInteger:= cbxFM.IsChecked.ToInteger;
          Open;
          AddSeries(TBarSeries.Create(Self));
          AddSeries(TLineSeries.Create(Self));
          Series[0].Clear;
          Series[1].Clear;
          Series[0].Title := FieldByName('Title' ).AsString;
          Series[1].Title := FieldByName('Title' ).AsString;

          TBarSeries(Series[0]).Marks.Arrow.Visible := true;
          TBarSeries(Series[0]).Marks.Visible       := true;
          TBarSeries(Series[0]).Marks.Style         := smsValue;
          TBarSeries(Series[0]).Marks.Font.Size     := 7;
          TBarSeries(Series[0]).Marks.Font.Color    := TAlphaColors.Green;

          TMSFMXGrid1.Cells [0,0] := FieldByName('ColName00').AsString;
          TMSFMXGrid1.Cells [1,0] := FieldByName('ColName01').AsString;
          TMSFMXGrid1.Cells [2,0] := FieldByName('ColName02').AsString;
          TMSFMXGrid1.Cells [3,0] := FieldByName('ColName03').AsString;
          TMSFMXGrid1.Cells [4,0] := FieldByName('ColName04').AsString;
          TMSFMXGrid1.Cells [5,0] := FieldByName('ColName05').AsString;
          TMSFMXGrid1.Cells [6,0] := FieldByName('ColName06').AsString;

          TMSFMXGrid1.MergeCells(1,0,2,1);
          TMSFMXGrid1.Cells [1,0] := FieldByName('ColName02').AsString;

          for i:=0 to TMSFMXGrid1.ColumnCount-1 do begin
            TMSFMXGrid1.HorzAlignments[i,0] := Fmx.Types.TTextAlign.Center;
          end;

          TMSFMXGrid1.RowCount    := RecordCount+1;
          for i:=1 to RecordCount do begin
            c := f_Chart_Color(i);
            v := FieldByName('VALUE1').AsFloat/1000000;
            s := FieldByName('CODE'  ).AsString;
            if (i<RecordCount) AND (i<=20) then begin
              Series[0].AddXY(i,v,s,c);
              Series[1].AddXY(i,v,s,c);
            end;

            TMSFMXGrid1.Cells [0,i] := i.ToString;
            TMSFMXGrid1.Colors[1,i] := c;
            TMSFMXGrid1.Cells [2,i] := FieldByName('TEXT'  ).AsString;
            TMSFMXGrid1.Cells [3,i] := FormatFloat('#,###0',FieldByName('VALUE0').AsFloat);
            TMSFMXGrid1.Cells [4,i] := FormatFloat('#,###0',FieldByName('VALUE1').AsFloat);
            TMSFMXGrid1.Cells [5,i] := FormatFloat('##0.00',FieldByName('PER'   ).AsFloat);
            TMSFMXGrid1.Cells [6,i] := FieldByName('MEMO'  ).AsString;
            Next;
          end;
          Close;
          TMSFMXGrid1.Selected        :=-1;
          TMSFMXGrid1.FixedFooterRows := 1;
          TMSFMXGrid1.UpdateCalculations;
          for i:=0 to TMSFMXGrid1.ColumnCount-1 do TMSFMXGrid1.Columns[i].ReadOnly := true;
          for i:=0 to TMSFMXGrid1.ColumnCount-2 do w := w + TMSFMXGrid1.Columns[i].Width;
          TMSFMXGrid1.Columns[TMSFMXGrid1.ColumnCount-1].Width := Self.Width-w;
        end;
//      TMSFMXGrid1.EndUpdate;
//      Chart1.EndUpdate;
end;


procedure TfrmCom_Marketing_Customer.TMSFMXGrid1GetCellAppearance(Sender: TObject;
  ACol, ARow: Integer; Cell: TFmxObject; ACellState: TCellState);
begin
  case ACellState of
   //csNormal:        (Cell as TTMSFMXGridCell).Layout.Fill.Color := claRed;
   //csFocused:       (Cell as TTMSFMXGridCell).Layout.Fill.Color := claBlue;
     csFixed:         ;//(Cell as TTMSFMXGridCell).Layout.Fill.Color := claGreen;
     csFixedSelected: ;//(Cell as TTMSFMXGridCell).Layout.Fill.Color := claOrange;
     csSelected:      (Cell as TTMSFMXGridCell).Layout.Fill.Color := claSilver;
  end;
  case ACellState of
     csNormal:        (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claBlack;
     csFocused:       (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claBlue;
     csFixed:         (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claNavy;
     csFixedSelected: (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claNavy;
     csSelected:      (Cell as TTMSFMXGridCell).Layout.FontFill.Color := claWhite;
  end;

end;



procedure TfrmCom_Marketing_Customer.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j:integer;
begin
  for i:=0 to Series.Count-1 do begin
    for j:=0 to TMSFMXGrid1.RowCount-1 do begin
      if TMSFMXGrid1.Cells[0,j] = Series.Labels.Labels[i] then begin
         //Series.ValueColor[i] := f_Chart_Color(TMSFMXGrid1.Items[j].Tag);
      end;
    end;
  end;

  for i:=0 to TMSFMXGrid1.RowCount-1 do begin
    if TMSFMXGrid1.Cells[0,i] = Series.Labels.Labels[ValueIndex] then begin
       TMSFMXGrid1.ItemIndex  := i;
     //ListView1ItemClick(Sender,ListView1.Items[i]);
    end;
  end;
  Series.ValueColor[ValueIndex] := TAlphaColors.Black;
end;




procedure TfrmCom_Marketing_Customer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Marketing_Customer]);

finalization
   UnRegisterClasses([TfrmCom_Marketing_Customer]);


end.

