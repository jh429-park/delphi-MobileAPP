unit Com_Emp_Summary01;

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
  FMX.TMSGrid, FMX.ListBox, FMX.GridExcelIO;

type
  TfrmCom_Emp_Summary01 = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout1: TLayout;
    cboCompany: TComboBox;
    TMSFMXGrid1: TTMSFMXGrid;
    AniIndicator1: TAniIndicator;
    Timer_Query: TTimer;
    Chart1: TChart;
    btnClose: TButton;
    SpeedButton1: TSpeedButton;
    TMSFMXGridExcelIO1: TTMSFMXGridExcelIO;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    procedure ComboBoxChange(Sender: TObject);
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
  frmCom_Emp_Summary01: TfrmCom_Emp_Summary01;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Emp_Summary01.FormCreate(Sender: TObject);
var i:integer;
begin
//cboCompany.BeginUpdate;
  for i:=Low(c_Company2Name) to High(c_Company2Name) do begin
    cboCompany.Items.Add(c_Company2Name[i]);
    if g_User_Company=c_Company2[i] then cboCompany.ItemIndex := i;
  end;
//cboCompany.EndUpdate;
  chart1.visible := false;
end;


procedure TfrmCom_Emp_Summary01.FormShow(Sender: TObject);
begin
  Label_Title.Text := g_Sel_Title;
  chart1.visible := true;
  btnQueryClick(Sender);
end;





procedure TfrmCom_Emp_Summary01.TMSFMXGrid1GetCellAppearance(Sender: TObject;
  ACol, ARow: Integer; Cell: TFmxObject; ACellState: TCellState);
begin
  p_TMSFMXGrid_GetCellAppearance(Self,TMSFMXGrid1,ACol,ARow,Cell,ACellState);
end;

procedure TfrmCom_Emp_Summary01.ComboBoxChange(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
end;

procedure TfrmCom_Emp_Summary01.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Emp_Summary01.btnQueryClick(Sender: TObject);
begin
  Timer_Query.Enabled   := false;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;
  Application.ProcessMessages;
  Timer_Query.Enabled   := true;
end;

procedure TfrmCom_Emp_Summary01.Timer_QueryTimer(Sender: TObject);
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
          ParamByName('arg_Company').AsString := c_Company2[cboCompany.ItemIndex];
          ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
          ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
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


procedure TfrmCom_Emp_Summary01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


initialization
   RegisterClasses([TfrmCom_Emp_Summary01]);

finalization
   UnRegisterClasses([TfrmCom_Emp_Summary01]);


end.

