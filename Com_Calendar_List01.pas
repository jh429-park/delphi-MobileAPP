unit Com_Calendar_List01;

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
  TfrmCom_Calendar_List01 = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout1: TLayout;
    TMSFMXGrid1: TTMSFMXGrid;
    DateEdit_Fr: TDateEdit;
    cboYear: TComboBox;
    cboMonth: TComboBox;
    btnClose: TButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Calendar_List01: TfrmCom_Calendar_List01;
  l_Height:Single;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_Calendar_List01.FormShow(Sender: TObject);
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.RowCount:=1;
  btnQueryClick(btnQuery);
end;



procedure TfrmCom_Calendar_List01.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Calendar_List01.btnQueryClick(Sender: TObject);
var i:integer;
begin
  TMSFMXGrid1.Clear;
  TMSFMXGrid1.SelectionMode:= smSingleRow;
  TMSFMXGrid1.RowCount     := 1;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Url;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    ParamByName('arg_DateFr' ).AsString := FormatDateTime('YYYYMMDD',DateEdit_Fr.DateTime);
    ParamByName('arg_DateTo' ).AsString := cboYear.Items[cboYear.ItemIndex]+cboMonth.Items[cboMonth.ItemIndex]+'99';
    Open;
    for i:=1 to RecordCount do begin
      TMSFMXGrid1.Cells [0,i] := i.ToString;
     //MSFMXGrid1.Colors[1,i] := c;
      TMSFMXGrid1.Cells [2,i] := FieldByName('TEXT'  ).AsString;
      TMSFMXGrid1.Cells [3,i] := FormatFloat('#,###0',FieldByName('VALUE0').AsFloat);
      TMSFMXGrid1.Cells [4,i] := FormatFloat('#,###0',FieldByName('VALUE1').AsFloat);
      TMSFMXGrid1.Cells [5,i] := FormatFloat('##0.00',FieldByName('PER'   ).AsFloat);
      TMSFMXGrid1.Cells [6,i] := FieldByName('MEMO'  ).AsString;
      Next;
    end;
    Close;
  end;
end;


procedure TfrmCom_Calendar_List01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_Calendar_List01]);

finalization
   UnRegisterClasses([TfrmCom_Calendar_List01]);


end.
