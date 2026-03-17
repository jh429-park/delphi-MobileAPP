unit Com_Sample;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmCom_Sample = class(TForm)
    HeaderToolBar: TToolBar;
    MenuButton: TButton;
    btnQuery: TButton;
    Label_Title: TLabel;
    ListView1: TListView;
    procedure FormShow(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Sample: TfrmCom_Sample;


implementation

{$R *.fmx}

uses Com_DataModule,Com_function,Com_Variable,MainMenu;

procedure TfrmCom_Sample.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_Sample.FormShow(Sender: TObject);
begin
  btnQueryClick(Sender);
end;

procedure TfrmCom_Sample.btnQueryClick(Sender: TObject);
begin
  Label_Title.Text  := g_Sel_Action_Name;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name;
    ParamByName('arg_Text01' ).AsString := g_Sel_Text01;
    ParamByName('arg_Text02' ).AsString := g_Sel_Text02;
    ParamByName('arg_Text03' ).AsString := g_Sel_Text03;
    Label_Title.Text := Label_Title.Text+'('+f_Query_Sample(ListView1).ToString+')';
  end;
end;


end.
