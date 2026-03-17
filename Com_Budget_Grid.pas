unit Com_Budget_Grid;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMX.StdCtrls,
  System.Threading,
  System.UIConsts,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts,
  FMX.Objects, FMX.DateTimeCtrls, FMX.TMSBaseControl, FMX.TMSDateTimeEdit,
  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
  FMX.TMSGrid, FMX.ListBox;

type
  TfrmCom_Budget_Grid = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    TMSFMXGrid1: TTMSFMXGrid;
    DateEdit_Fr: TDateEdit;
    Layout1: TLayout;
    Layout2: TLayout;
    cboYear: TComboBox;
    cboMonth: TComboBox;
    Timer_Query: TTimer;
    AniIndicator1: TAniIndicator;
    btnClose: TButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cboMonthChange(Sender: TObject);
    procedure cboYearChange(Sender: TObject);
    procedure TMSFMXGrid1GetCellAppearance(Sender: TObject; ACol, ARow: Integer;
      Cell: TFmxObject; ACellState: TCellState);
    procedure Timer_QueryTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Budget_Grid: TfrmCom_Budget_Grid;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Budget_Grid.FormCreate(Sender: TObject);
var i:integer;
var Year, Month, Day: Word;
begin
  DecodeDate(Now,Year,Month,Day);

//cboYear.BeginUpdate;
  for i:=Year downto Year-1 do cboYear.Items.Add(i.ToString);
  cboYear.ItemIndex := 0;
//cboYear.EndUpdate;

//cboMonth.BeginUpdate;
  for i:=Low(c_Bunki_Name) to High(c_Bunki_Name) do begin
    cboMonth.Items.Add(c_Bunki_Name[i]);
  end;
  if      Month<=03 then cboMonth.ItemIndex := 0
  else if Month<=06 then cboMonth.ItemIndex := 1
  else if Month<=09 then cboMonth.ItemIndex := 2
  else if Month<=12 then cboMonth.ItemIndex := 3;
//cboMonth.EndUpdate;
  TMSFMXGrid1.Visible := false;
end;


procedure TfrmCom_Budget_Grid.FormShow(Sender: TObject);
begin
  Label_Title.Text := g_Sel_Title;
  btnQueryClick(Sender);
end;




procedure TfrmCom_Budget_Grid.TMSFMXGrid1GetCellAppearance(Sender: TObject;
  ACol, ARow: Integer; Cell: TFmxObject; ACellState: TCellState);
begin
  p_TMSFMXGrid_GetCellAppearance(Self,TMSFMXGrid1,ACol,ARow,Cell,ACellState);
end;

procedure TfrmCom_Budget_Grid.cboYearChange(Sender: TObject);
begin
  btnQueryClick(Sender);
end;

procedure TfrmCom_Budget_Grid.cboMonthChange(Sender: TObject);
begin
  btnQueryClick(Sender);
end;


procedure TfrmCom_Budget_Grid.Timer_QueryTimer(Sender: TObject);
begin
  Timer_Query.Enabled   := false;
  AniIndicator1.BringToFront;
  AniIndicator1.Visible := true;
  AniIndicator1.Enabled := true;
  Application.ProcessMessages;
  Timer_Query.Enabled   := true;
end;

procedure TfrmCom_Budget_Grid.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Budget_Grid.btnQueryClick(Sender: TObject);
begin
  Timer_Query.Enabled := false;
  TThread.CreateAnonymousThread(procedure ()
  begin
    TThread.Synchronize (TThread.CurrentThread, procedure ()
    begin
      try
        with frmCom_DataModule.ClientDataSet_Proc do begin
          Close;
          p_CreatePrams;
          ParamByName('arg_ModCd'  ).AsString := 'Com_Budget_Grid'; //g_Sel_Url;
          ParamByName('arg_Company').AsString := g_User_Company;
          ParamByName('arg_Dept'   ).AsString := g_User_Dept;
          ParamByName('arg_EmpNo'  ).AsString := g_User_EmpNo;
          ParamByName('Arg_Text01' ).AsString := cboYear.Items[cboYear.ItemIndex];
          ParamByName('Arg_Text02' ).AsString := c_Bunki[cboMonth.ItemIndex];
          f_TMSFMXGrid_SetData (Self,frmCom_DataModule.ClientDataSet_Proc,TMSFMXGrid1);
        end;
      finally
      end;
    end);
  end).Start;
  TMSFMXGrid1.Visible   := true;
  AniIndicator1.Visible := false;
  AniIndicator1.Enabled := false;
end;


procedure TfrmCom_Budget_Grid.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Budget_Grid]);

finalization
   UnRegisterClasses([TfrmCom_Budget_Grid]);


end.
