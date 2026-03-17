unit Com_Sel_Dept;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TfrmCom_Sel_Dept = class(TForm)
    ListView1: TListView;
    procedure FormShow(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Sel_Dept: TfrmCom_Sel_Dept;

implementation

{$R *.fmx}

uses Com_DataModule,Com_Function,Com_Variable, Com_MasterDetail_Emp;

procedure TfrmCom_Sel_Dept.FormShow(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := 'SEL_Employee_DEPT';
    f_Query_ListViewList(ListView1);
    p_Toast('조회완료');
  end;
end;

procedure TfrmCom_Sel_Dept.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var v_StringList:TStringList;
begin
  v_StringList := TStringList.Create;
  v_StringList.Clear;
  ExtractStrings([':'],[#0],PChar(AItem.TagString),v_StringList);
  g_Sel_Company := v_StringList[0];
  g_Sel_Dept    := v_StringList[1];
  v_StringList.Free;
//frmCom_MasterDetail.btnQueryClick(frmCom_MasterDetail.btnQuery);
  Close;

//
//
//  TThread.CreateAnonymousThread(procedure()
//  begin
//    TThread.Synchronize(TThread.CurrentThread,procedure()
//    begin
//      Application.ProcessMessages;
//      frmCom_MasterDetail.btnQueryClick(frmCom_MasterDetail.btnQuery);
//    end);
//  end).Start;
//  Close;

end;

end.
