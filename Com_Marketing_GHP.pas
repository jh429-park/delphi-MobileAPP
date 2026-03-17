unit Com_Marketing_GHP;

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
  TfrmCom_Marketing_GHP = class(TForm)
    HeaderToolBar: TToolBar;
    btnMenu: TButton;
    btnQuery: TButton;
    Label_Title: TLabel;
    TMSFMXGrid1: TTMSFMXGrid;
    BitmapAnimation1: TBitmapAnimation;
    Chart1: TChart;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Marketing_GHP: TfrmCom_Marketing_GHP;
  l_Height:Single;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Marketing_GHP.FormCreate(Sender: TObject);
begin
  chart1.visible := false;
end;


procedure TfrmCom_Marketing_GHP.FormShow(Sender: TObject);
begin
  chart1.visible := true;
  Label_Title.Text := g_Sel_Title;
  btnQueryClick(Sender);
end;



procedure TfrmCom_Marketing_GHP.btnMenuClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmCom_Marketing_GHP.btnQueryClick(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc,Chart1 do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    f_TMSFMXGrid_SetData (Self,frmCom_DataModule.ClientDataSet_Proc,TMSFMXGrid1);
    p_MakeChart(Self,TMSFMXGrid1,Chart1,TMSFMXGrid1.Cells[2,0],1,TMSFMXGrid1.FixedColumns);
  end;
end;

procedure TfrmCom_Marketing_GHP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Marketing_GHP]);

finalization
   UnRegisterClasses([TfrmCom_Marketing_GHP]);


end.
