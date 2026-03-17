unit Com_Emp_List;

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
  TfrmCom_Emp_List = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    ListView_EmpList: TListView;
    AniIndicator1: TAniIndicator;
    Timer_Query: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnMenuClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer_QueryTimer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Emp_List: TfrmCom_Emp_List;
  l_Height:Single;
  l_Kind:String;


implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule, Com_MasterDetail_Office;

procedure TfrmCom_Emp_List.btnMenuClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmCom_Emp_List.FormShow(Sender: TObject);
begin
  Label_Title.Text := g_Sel_Title;
  btnQueryClick(Sender);
end;



procedure TfrmCom_Emp_List.Timer_QueryTimer(Sender: TObject);
begin
  Timer_Query.Enabled := false;
  TThread.CreateAnonymousThread(procedure ()
  begin
    TThread.Synchronize (TThread.CurrentThread, procedure ()
    var i:integer;
    begin
      try
        with frmCom_DataModule.ClientDataSet_Proc do begin
          p_CreatePrams;
       // ParamByName('arg_ModCd'  ).AsString := 'Com_Emp_List';
          ParamByName('arg_ModCd'  ).AsString := 'Com_Employee';
          ParamByName('arg_COMPANY').AsString := g_Sel_Company;
          ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
          ParamByName('arg_Text01' ).AsString := g_Sel_Text01; //'COMPANY'
          ParamByName('arg_Text02' ).AsString := g_Sel_Text02; //'DEPT'
          ParamByName('arg_Text03' ).AsString := g_Sel_Text03; //'JK
          ParamByName('arg_Text04' ).AsString := g_Sel_Text04; //'AGES'
          ParamByName('arg_Text05' ).AsString := g_Sel_Text05; //'SEX'
          ParamByName('arg_Text06' ).AsString := g_Sel_Text06; //'JC'
          ParamByName('arg_Text10' ).AsString := g_Sel_Text10; //'HEADER'
          f_Query_ListViewList(ListView_EmpList);
        end;
        p_loadImage_Emp_ListView(ListView_EmpList,1,true,false,false);
      finally
      end;
    end);
  end).Start;
  AniIndicator1.Visible := false;
  AniIndicator1.Enabled := false;



end;

procedure TfrmCom_Emp_List.btnQueryClick(Sender: TObject);
begin
  Timer_Query.Enabled   := false;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;
  Timer_Query.Enabled   := true;
end;

procedure TfrmCom_Emp_List.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;




end.



