 unit Crm_Customer_Detail;

interface

uses
  FMX.DialogService,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.ListView.Adapters.Base, FMX.TabControl, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ListView.Appearances, FMX.ListView;

type
  TfrmCrm_Customer_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    TabControl1: TTabControl;
    TabItem_EmpList: TTabItem;
    TabItem_Contact: TTabItem;
    TabItem_Update: TTabItem;
    ListView_Detail: TListView;
    btnQuery: TButton;
    ListView1: TListView;
    TabItem_Project: TTabItem;
    AniIndicator1: TAniIndicator;
    procedure btnQueryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCrm_Customer_Detail: TfrmCrm_Customer_Detail;
implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;

procedure TfrmCrm_Customer_Detail.FormShow(Sender: TObject);
var i:integer;
begin
  AniIndicator1.BringToFront;
  AniIndicator1.Visible := false;

//  if (g_Sel_TabIndex>=0) and (g_Sel_TabIndex<=TabControl1.TabCount-1)
//     then TabControl1.ActiveTab.Index := g_Sel_TabIndex
//     else TabControl1.ActiveTab.Index := TabItem_EmpList.Index;

  TabControl1.ActiveTab := TabItem_EmpList;
  Label_Title.Text := g_Sel_Title;
  with TabControl1 do begin
    for i:=0 to TabControl1.TabCount-1 do begin
      Tabs[i].TagString := Tabs[i].Text;
    end;
  end;
  Application.ProcessMessages;
  btnQueryClick(Sender);
end;


procedure TfrmCrm_Customer_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCrm_Customer_Detail.btnQueryClick(Sender: TObject);
var i:integer;
var v_StringList: TStringList;
begin
  ListView_Detail.Items.Clear;
  ListView1.Items.Clear;
  with TabControl1 do begin
    for i:=0 to TabControl1.TabCount-1 do begin
      Tabs[i].Text := Tabs[i].TagString;
    end;
  end;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    ListView_Detail.Items.Clear;
    p_CreatePrams;
    ParamByName('arg_ModCd' ).AsString := 'Crm_Customer_Detail';
    ParamByName('arg_Text01').AsString := g_Sel_TagString[0];
    f_Query_ListViewList(ListView_Detail);
    ListView_Detail.Height := ListView_Detail.Items[0].Height+1;
  //------------------------------------------------------------------------
  // 탭별 데이타 건수
  //------------------------------------------------------------------------
    try
      v_StringList := TStringList.Create;
      v_StringList.CommaText := g_Sel_TabCnt;
      with TabControl1 do begin
        for i:=0 to TabControl1.TabCount-1 do begin
          Tabs[i].Text := Tabs[i].TagString+' ('+v_StringList[i]+')';
        end;
      end;
    finally
      v_StringList.Free;
    end;
  //------------------------------------------------------------------------
  end;
  TabControl1Change(Sender);
end;


procedure TfrmCrm_Customer_Detail.TabControl1Change(Sender: TObject);
begin
  AniIndicator1.BringToFront;
  AniIndicator1.Visible := true;
  Application.ProcessMessages;

//g_Sel_TabIndex := TabControl1.ActiveTab.Index;

  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_Text01').AsString := g_Sel_TagString[0];
    Case TabControl1.ActiveTab.Index of
      0:ParamByName('arg_ModCd' ).AsString := 'Crm_Customer_Detail_EmpList';
      1:ParamByName('arg_ModCd' ).AsString := 'Crm_Customer_Detail_Contact';
      2:ParamByName('arg_ModCd' ).AsString := 'Crm_Customer_Detail_Project';
      3:ParamByName('arg_ModCd' ).AsString := 'Crm_Customer_Detail_Update';
    else
      begin
        ListView1.Items.Clear;
        Close;
        Exit;
      end;
    end;
    f_Query_ListViewList(ListView1);

    TabControl1.Tabs[TabControl1.ActiveTab.Index].Text :=
    TabControl1.Tabs[TabControl1.ActiveTab.Index].TagString+' ('+ListView1.ItemCount.ToString+')';

    if      TabControl1.ActiveTab = TabItem_EmpList then p_loadImage_Emp_ListView(ListView1,1,true,true,false)
    else if TabControl1.ActiveTab = TabItem_EmpList then p_loadImage_Emp_ListView(ListView1,1,true,true,false);

  end;
  AniIndicator1.Visible := false;
end;




procedure TfrmCrm_Customer_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;




procedure TfrmCrm_Customer_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCrm_Customer_Detail]);

finalization
   UnRegisterClasses([TfrmCrm_Customer_Detail]);

end.


