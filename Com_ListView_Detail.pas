 unit Com_ListView_Detail;

interface

uses
  System.DateUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmCom_ListView_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Layout_Master: TLayout;
    btnQuery: TButton;
    Label_Title: TLabel;
    btnClose: TButton;
    ListView1: TListView;
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_ListView_Detail: TfrmCom_ListView_Detail;
  l_Action_Name:  String='';
  l_Action_Title: String='';
  arg_Text01: String='';
  arg_Text02: String='';
  arg_Text03: String='';
  arg_Text04: String='';
  arg_Text05: String='';

implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;

procedure TfrmCom_ListView_Detail.FormShow(Sender: TObject);
begin
  l_Action_Name          := g_Sel_Action_Name+'_Detail';
  Label_Title.Text       := g_Sel_Title;
  arg_Text01             := g_Sel_TagString[0];
  arg_Text02             := g_Sel_TagString[1];
  arg_Text03             := g_Sel_TagString[2];
  arg_Text04             := g_Sel_TagString[3];
  arg_Text05             := g_Sel_TagString[4];
  btnQueryClick(Sender);
end;

procedure TfrmCom_ListView_Detail.FormActivate(Sender: TObject);
begin
  btnQueryClick(Sender);
end;


procedure TfrmCom_ListView_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_ListView_Detail.btnQueryClick(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd' ).AsString := l_Action_Name;
    ParamByName('arg_Text01').AsString := arg_Text01;
    ParamByName('arg_Text02').AsString := arg_Text02;
    ParamByName('arg_Text03').AsString := arg_Text03;
    ParamByName('arg_Text04').AsString := arg_Text04;
    ParamByName('arg_Text05').AsString := arg_Text05;
    f_Query_ListViewList(ListView1);
  end;
end;



procedure TfrmCom_ListView_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


initialization
   RegisterClasses([TfrmCom_ListView_Detail]);

finalization
   UnRegisterClasses([TfrmCom_ListView_Detail]);

end.

