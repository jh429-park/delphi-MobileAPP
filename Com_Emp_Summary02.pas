unit Com_Emp_Summary02;

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
  FMX.TMSGrid, FMX.ListBox, FMX.Ani;

type
  TfrmCom_Emp_Summary02 = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    TMSFMXGrid1: TTMSFMXGrid;
    Layout2: TLayout;
    Button0: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    BitmapAnimation1: TBitmapAnimation;
    Button5: TButton;
    AniIndicator1: TAniIndicator;
    Timer_Query: TTimer;
    Chart1: TChart;
    btnClose: TButton;

    procedure Timer_QueryTimer(Sender: TObject);
    procedure p_ButtonClick(Sender: TObject);
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
    procedure TMSFMXGrid1CellClick(Sender: TObject; ACol, ARow: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button0Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Emp_Summary02: TfrmCom_Emp_Summary02;
  l_Height:Single;
  l_Kind:String;


implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule, Com_MasterDetail_Emp;

procedure TfrmCom_Emp_Summary02.FormCreate(Sender: TObject);
begin
  chart1.visible := false;
end;


procedure TfrmCom_Emp_Summary02.FormShow(Sender: TObject);
begin
  g_Sel_Summary := True;
  p_SetButtonWidth(Self,'Button');
  Label_Title.Text := g_Sel_Title;
  chart1.visible := true;
  Button2Click(Button2);
end;




procedure TfrmCom_Emp_Summary02.TMSFMXGrid1GetCellAppearance(Sender: TObject;
  ACol, ARow: Integer; Cell: TFmxObject; ACellState: TCellState);
begin
  p_TMSFMXGrid_GetCellAppearance(Self,TMSFMXGrid1,ACol,ARow,Cell,ACellState);
end;

procedure TfrmCom_Emp_Summary02.ComboBoxChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;



procedure TfrmCom_Emp_Summary02.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Emp_Summary02.btnQueryClick(Sender: TObject);
begin
  Timer_Query.Enabled   := false;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;
  Application.ProcessMessages;
  Timer_Query.Enabled   := true;
end;

procedure TfrmCom_Emp_Summary02.Timer_QueryTimer(Sender: TObject);
begin
  Timer_Query.Enabled := false;
  TThread.CreateAnonymousThread(procedure ()
  begin
    TThread.Synchronize (TThread.CurrentThread, procedure ()
    begin
      try
        with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;
          ParamByName('arg_Company').AsString := g_Sel_Company;
          ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
          ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
          ParamByName('arg_TEXT01' ).AsString := l_Kind;
          f_TMSFMXGrid_SetData (Self,frmCom_DataModule.ClientDataSet_Proc,TMSFMXGrid1);
          p_MakeChart(Self,TMSFMXGrid1,Chart1,TMSFMXGrid1.Cells[2,0],1,TMSFMXGrid1.FixedColumns);
        end;
      finally
      end;
    end);
  end).Start;
  AniIndicator1.Visible := false;
  AniIndicator1.Enabled := false;
end;





procedure TfrmCom_Emp_Summary02.Button0Click(Sender: TObject);
begin
  l_Kind := 'COMPANY';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.Button1Click(Sender: TObject);
begin
  l_Kind := 'DEPT';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.Button2Click(Sender: TObject);
begin
  l_Kind := 'AGES';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.Button3Click(Sender: TObject);
begin
  l_Kind := 'SEX';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.Button4Click(Sender: TObject);
begin
  l_Kind := 'JK';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.Button5Click(Sender: TObject);
begin
  l_Kind := 'JC';
  p_ButtonClick(Sender);
end;

procedure TfrmCom_Emp_Summary02.p_ButtonClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to Self.ComponentCount-1 do begin
    if Pos('BUTTON',UpperCase(Self.Components[i].Name))>0 then begin
       TButton(Self.Components[i]).FontColor := TAlphaColors.Gray;
    end;
  end;
  TButton(Sender).FontColor := TAlphaColors.Green;
  btnQueryClick(Sender);
end;


procedure TfrmCom_Emp_Summary02.TMSFMXGrid1CellClick(Sender: TObject; ACol, ARow: Integer);
begin
  Application.ProcessMessages;
  if      Trim(TMSFMXGrid1.Cells[ACol,ARow])=''  then Exit
  else if Trim(TMSFMXGrid1.Cells[ACol,ARow])='0' then Exit;

  g_Sel_Title   := TMSFMXGrid1.Cells[01,ARow]+'('+TMSFMXGrid1.Cells[ACol,00]+')';

  g_Sel_Text01  := '';
  g_Sel_Text02  := '';
  g_Sel_Text03  := '';
  g_Sel_Text04  := '';
  g_Sel_Text05  := '';
  g_Sel_Text06  := '';
  g_Sel_Text10  := '';

  if      l_Kind='COMPANY' then  g_Sel_Text01 := TMSFMXGrid1.Cells[14,ARow]
  else if l_Kind='DEPT'    then  g_Sel_Text02 := TMSFMXGrid1.Cells[14,ARow]
  else if l_Kind='JK'      then  g_Sel_Text03 := TMSFMXGrid1.Cells[14,ARow]
  else if l_Kind='AGES'    then  g_Sel_Text04 := TMSFMXGrid1.Cells[14,ARow]
  else if l_Kind='SEX'     then  g_Sel_Text05 := TMSFMXGrid1.Cells[14,ARow]
  else if l_Kind='JC'      then  g_Sel_Text06 := TMSFMXGrid1.Cells[14,ARow];
  if ACol>3 then g_Sel_Text10 := IntToStr((ACol-4)) else g_Sel_Text10 := '';


  Application.CreateForm(TfrmCom_MasterDetail_Emp,frmCom_MasterDetail_Emp);
  frmCom_MasterDetail_Emp.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);


//Application.CreateForm(TfrmCom_Emp_List,frmCom_Emp_List);
//frmCom_Emp_List.Show;



//AForm.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_Emp_Summary02.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  p_TMSFMXGrid_ChartClickSeries(Self,TMSFMXGrid1,Series,ValueIndex,Button,Shift,X,Y);
end;




procedure TfrmCom_Emp_Summary02.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  g_Sel_Summary := false;
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Emp_Summary02]);

finalization
   UnRegisterClasses([TfrmCom_Emp_Summary02]);


end.



