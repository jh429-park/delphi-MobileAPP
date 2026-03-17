 unit Com_MasterDetail02;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  Fmx.Ani, FMX.MultiView,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo;

type
  TfrmCom_MasterDetail02 = class(TForm)
    ListView_List: TListView;
    HeaderToolBar: TToolBar;
    Layout_Master: TLayout;
    MultiView_Detail: TMultiView;
    Layout_Detail_Memo: TLayout;
    MenuButton: TButton;
    btnQuery: TButton;
    Label_Title: TLabel;
    Memo_Body: TMemo;
    Text_Detail_Top: TText;
    Text_Detail_Bottom: TText;
    Layout_Combo: TLayout;
    ComboBox_Sel: TComboBox;
    Label1: TLabel;
    Layout_Detail_ListView: TLayout;
    Layout_Detail_Header: TLayout;
    Image_Detail: TImageControl;
    FloatAnimation1: TFloatAnimation;
    ListView_Detail: TListView;
    Layout_Detail_Body: TLayout;
    TabControl_Detail: TTabControl;
    TabItem0: TTabItem;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    ListView_Detail_Body: TListView;
    Button_Document: TButton;
    Text_DetailTitle: TText;
    procedure p_SetComboBox(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure ListView_ListItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure p_Detail_Memo    (const Sender: TObject; const AItem: TListViewItem);
    procedure p_Detail_ListView(const Sender: TObject; const AItem: TListViewItem);


    procedure FormResize(Sender: TObject);
    procedure ComboBox_SelClosePopup(Sender: TObject);
    procedure TabControl_DetailChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_MasterDetail02: TfrmCom_MasterDetail02;
  l_ItemCode: Array of String;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu;


procedure TfrmCom_MasterDetail02.FormShow(Sender: TObject);
begin
  Label_Title.Text := g_Sel_Title;
  p_SetComboBox(Sender);
  btnQueryClick(Sender);
end;

procedure TfrmCom_MasterDetail02.p_SetComboBox(Sender: TObject);
var i:integer;
begin
  ComboBox_Sel.BeginUpdate;
  ComboBox_Sel.Items.Clear;
  if g_Sel_Action_Name = 'Com_DB_Office' then begin
    with frmCom_DataModule.ClientDataSet_Proc do begin
      try
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Combo_Com_DB_Office';
        ParamByName('arg_Company').AsString := g_Sel_Company;
        ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
        Open;
        SetLength(l_ItemCode,RecordCount);
        for i:=0 to RecordCount-1 do begin
          l_ItemCode[i] := FieldByName('TagString').AsString;
          ComboBox_Sel.Items.Add(FieldByName('Text').AsString);
          Next;
        end;
        if RecordCount>0 then ComboBox_Sel.ItemIndex := 0;
      finally
        Close;
      end;
    end;
  end;
  ComboBox_Sel.EndUpdate;
  Layout_Combo.Visible := ComboBox_Sel.Items.Count>0;
end;


procedure TfrmCom_MasterDetail02.TabControl_DetailChange(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    if g_Sel_Action_Name = 'Com_DB_Office' then begin
      p_CreatePrams;
      ParamByName('arg_Company').AsString := g_Sel_Company;
      ParamByName('arg_Text11' ).AsString := g_Sel_Code;
      Case TabControl_Detail.ActiveTab.Index of
        2:begin
            ParamByName('arg_ModCd'  ).AsString := 'Query_DETAIL37_1';
            f_Query_ListViewDetail(ListView_Detail_Body);
          end;
        3:begin
            ParamByName('arg_ModCd'  ).AsString := 'Query_Detail37_3';
            f_Query_ListViewList(ListView_Detail_Body);
          end;
        4:begin
            ParamByName('arg_ModCd'  ).AsString := 'Query_Detail37_2';
            f_Query_ListViewList(ListView_Detail_Body);
          end;
      end;
    end;


  end;
end;

procedure TfrmCom_MasterDetail02.ComboBox_SelClosePopup(Sender: TObject);
begin
  btnQueryClick(Sender);
end;



procedure TfrmCom_MasterDetail02.btnQueryClick(Sender: TObject);
begin
  MultiView_Detail.HideMaster;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name;
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    if ComboBox_Sel.Items.Count>0
      then ParamByName('arg_TEXT01' ).AsString := l_ItemCode[ComboBox_Sel.ItemIndex]
      else ParamByName('arg_TEXT01' ).AsString := '';
    f_Query_ListViewList(ListView_List);
  end;
end;


procedure TfrmCom_MasterDetail02.ListView_ListItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  LayOut_Detail_Memo.Visible     := false;
  LayOut_Detail_ListView.Visible := false;
  Text_Detail_Top.Text           := '';
  Text_Detail_Bottom.Text        := '';
  Memo_Body.ClearContent;

  if g_Sel_Action_Name = 'Com_Newspaper' then begin
     p_Detail_Memo(Sender,AItem);
  end
  else begin
     p_Detail_ListView(Sender,AItem);
  end;
  Application.ProcessMessages;
  MultiView_Detail.ShowMaster;
end;


procedure TfrmCom_MasterDetail02.p_Detail_Memo(const Sender: TObject; const AItem: TListViewItem);
begin
  LayOut_Detail_Memo.Visible     := true;
  with frmCom_DataModule.ClientDataSet_Proc,ListView_List do begin
    try
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name+'_Detail';
      ParamByName('arg_Company').AsString := g_Sel_Company;
      ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
      ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
      ParamByName('arg_TEXT01' ).AsString := AItem.TagString;
    //ParamByName('arg_TEXT01' ).AsString := Items[ItemIndex].TagString;
      Open;
      if RecordCount=1 then begin
        Text_Detail_Top.Text    := FieldByName('Text_Top'   ).AsString;
        Text_Detail_Bottom.Text := FieldByName('Text_Bottom').AsString;
        Memo_Body.Text          := FieldByName('Detail'     ).AsString;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TfrmCom_MasterDetail02.p_Detail_ListView(const Sender: TObject; const AItem: TListViewItem);
begin
  LayOut_Detail_ListView.Visible := true;
//Image_Detail.Bitmap.Assign(g_Sel_EmpImage);
//Image_Detail.TagString    := g_Sel_EmpNo;

  with frmCom_DataModule.ClientDataSet_Proc,ListView_List do begin
    g_Sel_Code                := AItem.TagString;
    Text_DetailTitle.Text     := AItem.Text;
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name+'_Detail';
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    ParamByName('arg_TEXT01' ).AsString := AItem.TagString;
    f_Query_ListViewDetail(ListView_Detail);
  end;
end;


procedure TfrmCom_MasterDetail02.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


procedure TfrmCom_MasterDetail02.FormResize(Sender: TObject);
begin
  MultiView_Detail.Width := Self.Width-(Self.Width/9);
end;





procedure TfrmCom_MasterDetail02.MenuButtonClick(Sender: TObject);
begin
  Close;
end;


end.
