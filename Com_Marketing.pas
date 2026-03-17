unit Com_Marketing;

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
  TfrmCom_Marketing = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Chart: TLayout;
    Chart1: TChart;
    Layout1: TLayout;
    TMSFMXGrid1: TTMSFMXGrid;
    DateEdit_Fr: TDateEdit;
    Series1: TBarSeries;
    cboYear: TComboBox;
    cboMonth: TComboBox;
    btnClose: TButton;
    cboKind: TComboBox;
    cboCompany: TComboBox;
    Text_MadeDateTime: TText;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure cboMonthChange(Sender: TObject);
    procedure cboYearChange(Sender: TObject);
    procedure cboCompanyChange(Sender: TObject);
    procedure cboCompanyClosePopup(Sender: TObject);
    procedure cboYearClosePopup(Sender: TObject);
    procedure cboMonthClosePopup(Sender: TObject);
    procedure cbxFMClick(Sender: TObject);
    procedure cbxFMChange(Sender: TObject);
    procedure TMSFMXGrid1GetCellAppearance(Sender: TObject; ACol, ARow: Integer;
      Cell: TFmxObject; ACellState: TCellState);
    procedure btnCloseClick(Sender: TObject);
    procedure cboKindClosePopup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Marketing: TfrmCom_Marketing;
  l_Height:Single;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Marketing.FormCreate(Sender: TObject);
var i,c:integer;
var Year, Month, Day: Word;
begin
//  p_SetButtonWidth(Self,'Button');
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

  DecodeDate(System.SysUtils.IncMonth(Now,-1),Year,Month,Day);

//cboYear.BeginUpdate;
//cboMonth.BeginUpdate;
  for i:=Year downto Year-5 do cboYear.Items.Add(i.ToString);
  for i:=1    to     12     do cboMonth.Items.Add(FormatFloat('00',i));
  cboYear.ItemIndex    := cboYear. Items.IndexOf(FormatDateTime('YYYY',System.SysUtils.IncMonth(Now,-1)));
  cboMonth.ItemIndex   := cboMonth.Items.IndexOf(FormatDateTime('MM',  System.SysUtils.IncMonth(Now,-1)));
//cboYear.EndUpdate;
//cboMonth.EndUpdate;

  DateEdit_Fr.DateTime := EncodeDate(Year-5,1,1);
  chart1.visible := false;
end;


procedure TfrmCom_Marketing.FormShow(Sender: TObject);
var i:integer;
begin

  Text_MadeDateTime.Text := ''; //최근데이타구성일자
  with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing_MadeDate';
      open;
      Text_MadeDateTime.Text := FieldByName('iDateTime').AsString;
    finally
      Close;
    end;
  end;

  cboCompany.Items.Clear;
//cboCompany.ItemIndex := -1;
  for i:=Low(c_Company4) to High(c_Company4) do begin
    cboCompany.Items.Add(c_Company4Name[i]);
    if c_Company4[i] = g_User_Company then cboCompany.ItemIndex := i;
  end;

  l_Height := Layout_Chart.Height;
  Label_Title.Text := g_Sel_Title;

  TTask.Run(procedure
  begin
    sleep(35);
    TThread.Synchronize(nil, procedure
    begin
      chart1.visible := true;
      btnQueryClick(btnQuery);
    end);
  end);


end;



procedure TfrmCom_Marketing.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  g_Sel_Title := AItem.Text;
end;


procedure TfrmCom_Marketing.cboCompanyChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboCompanyClosePopup(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboKindClosePopup(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboMonthChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboMonthClosePopup(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboYearChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cboYearClosePopup(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cbxFMChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Marketing.cbxFMClick(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;


procedure TfrmCom_Marketing.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Marketing.btnQueryClick(Sender: TObject);
var i:integer;
    v,w,h:Double;
    s:String;
    c:TAlphaColor;
begin
  g_Sel_Title      := '';
  for i:=0 to Self.ComponentCount-1 do begin
    if Pos('BUTTON',UpperCase(Self.Components[i].Name))>0 then begin
       TButton(Self.Components[i]).FontColor := TAlphaColors.Gray;
       c:=c+1;
    end;
  end;
  TButton(Sender).FontColor := TAlphaColors.Green;
//Chart1.BeginUpdate;
  Chart1.View3D         := false;
  Chart1.Title.Visible  := true;
  Chart1.Legend.Visible := false;
  Chart1.RemoveAllSeries;
  w:=0;
  h:=0;
//TMSFMXGrid1.BeginUpdate;
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.SelectionMode:= smSingleRow;
  TMSFMXGrid1.RowCount     := 1;
  with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;

    Case cboKind.ItemIndex of
      0: ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing0'; //전년동월
      1: ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing1'; //매출유형별
      2: ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing2'; //연도별
      3: ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing3'; //고객사별
      4: ParamByName('arg_ModCd'  ).AsString := 'Com_Marketing4'; //부서별
    end;

    ParamByName('arg_Company').AsString := c_Company4[cboCompany.ItemIndex];//g_User_Company;//c_Company[cboCompany.ItemIndex];
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    ParamByName('arg_DateFr' ).AsString := FormatDateTime('YYYYMMDD',DateEdit_Fr.DateTime);
    ParamByName('arg_DateTo' ).AsString := cboYear.Items[cboYear.ItemIndex]+cboMonth.Items[cboMonth.ItemIndex]+'99';
  //ParamByName('arg_TEXT01' ).AsInteger:= cbxFM.IsChecked.ToInteger;
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
//TMSFMXGrid1.EndUpdate;
//Chart1.EndUpdate;
end;


procedure TfrmCom_Marketing.TMSFMXGrid1GetCellAppearance(Sender: TObject;
  ACol, ARow: Integer; Cell: TFmxObject; ACellState: TCellState);
begin
  p_TMSFMXGrid_GetCellAppearance(Self,TMSFMXGrid1,ACol,ARow,Cell,ACellState);
end;



procedure TfrmCom_Marketing.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  p_TMSFMXGrid_ChartClickSeries(Self,TMSFMXGrid1,Series,ValueIndex,Button,Shift,X,Y);
end;




procedure TfrmCom_Marketing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Marketing]);

finalization
   UnRegisterClasses([TfrmCom_Marketing]);


end.
