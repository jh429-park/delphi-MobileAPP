 unit Com_MasterDetail_Office;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.DB,Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  Fmx.Ani, FMX.MultiView,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, FMX.WebBrowser;

type
  TfrmCom_MasterDetail_Office = class(TForm)
    ListView_List: TListView;
    HeaderToolBar: TToolBar;
    Layout_Master: TLayout;
    MultiView_Detail: TMultiView;
    MenuButton: TButton;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Detail: TLayout;
    Layout_Detail_Header: TLayout;
    Image_Detail: TImageControl;
    FloatAnimation1: TFloatAnimation;
    ListView_Detail_Basic: TListView;
    Layout_Detail_Body: TLayout;
    TabControl_Detail: TTabControl;
    TabItem0: TTabItem;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    ListView_DetailList: TListView;
    Button_Document: TButton;
    WebBrowser_Detail: TWebBrowser;
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure ListView_ListItemClick(const Sender: TObject; const AItem: TListViewItem);


    procedure FormResize(Sender: TObject);
    procedure ComboBox_SelClosePopup(Sender: TObject);
    procedure TabControl_DetailChange(Sender: TObject);
    procedure Image_DetailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_MasterDetail_Office: TfrmCom_MasterDetail_Office;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu,
  Com_Image;


procedure TfrmCom_MasterDetail_Office.FormShow(Sender: TObject);
begin
  Label_Title.Text := g_Sel_Title;
  btnQueryClick(Sender);
end;


procedure TfrmCom_MasterDetail_Office.Image_DetailClick(Sender: TObject);
begin
  g_Sel_Url      := c_URL_Research_Image;
  g_Sel_FileName := Image_Detail.TagString;
  Application.CreateForm(TfrmCom_Image,frmCom_Image);
  frmCom_Image.Show;
end;

procedure TfrmCom_MasterDetail_Office.TabControl_DetailChange(Sender: TObject);
begin
  Case TabControl_Detail.ActiveTab.Index of
    0:begin
        WebBrowser_Detail.Visible   := true;
        ListView_DetailList.Visible := false;
        WebBrowser_Detail.Navigate(Format(c_URL_Daum_Map,[g_Sel_Latitude,g_Sel_Longitude]));
       //frmCom_Location := TfrmCom_Location.Create(nil);
       //frmCom_Location.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);
      end;
    1:begin
        WebBrowser_Detail.Visible   := true;
        ListView_DetailList.Visible := false;
        WebBrowser_Detail.Navigate(Format(c_URL_Daum_RoadView,[g_Sel_Latitude,g_Sel_Longitude]));
       //frmCom_Location := TfrmCom_Location.Create(nil);
       //frmCom_Location.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);
      end;
    2:with frmCom_DataModule.ClientDataSet_Proc do begin
        WebBrowser_Detail.Visible   := false;
        ListView_DetailList.Visible := true;
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_DB_Office_Detail_Basic';
        ParamByName('arg_Company').AsString := g_Sel_Company;
        ParamByName('arg_Text11' ).AsString := g_Sel_Code;
        f_Query_ListViewDetail(ListView_DetailList);
      end;
    3:with frmCom_DataModule.ClientDataSet_Proc do begin
        WebBrowser_Detail.Visible   := false;
        ListView_DetailList.Visible := true;
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_DB_Office_Detail_Gong';
        ParamByName('arg_Company').AsString := g_Sel_Company;
        ParamByName('arg_Text11' ).AsString := g_Sel_Code;
        f_Query_ListViewList(ListView_DetailList);
      end;
    4:with frmCom_DataModule.ClientDataSet_Proc do begin
        WebBrowser_Detail.Visible   := false;
        ListView_DetailList.Visible := true;
        p_CreatePrams;
        ParamByName('arg_ModCd'  ).AsString := 'Com_DB_Office_Detail_Tenant';
        ParamByName('arg_Company').AsString := g_Sel_Company;
        ParamByName('arg_Text11' ).AsString := g_Sel_Code;
        f_Query_ListViewList(ListView_DetailList);
      end;
  end;
end;

procedure TfrmCom_MasterDetail_Office.ComboBox_SelClosePopup(Sender: TObject);
begin
  btnQueryClick(Sender);
end;



procedure TfrmCom_MasterDetail_Office.btnQueryClick(Sender: TObject);
begin
  MultiView_Detail.HideMaster;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name;
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    ParamByName('arg_TEXT11' ).AsString := g_Sel_Text01;
    ParamByName('arg_TEXT12' ).AsString := g_Sel_Text02;
    f_Query_ListViewList(ListView_List);
  end;
end;


procedure TfrmCom_MasterDetail_Office.ListView_ListItemClick(const Sender: TObject; const AItem: TListViewItem);
var i:integer;
var v_ListViewItem:  TListViewItem;
begin
  ListView_Detail_Basic.BeginUpdate;
  ListView_Detail_Basic.Items.Clear;
  ListView_Detail_Basic.CanSwipeDelete:= false;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    try
      g_Sel_Code                := AItem.TagString;
      p_CreatePrams;
      ParamByName('arg_ModCd'  ).AsString := g_Sel_Action_Name+'_Detail';
      ParamByName('arg_Company').AsString := g_Sel_Company;
      ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
      ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
      ParamByName('arg_TEXT11' ).AsString := AItem.TagString;
      Open;
      for i:=0 to FieldCount-1 do begin
        v_ListViewItem      := ListView_Detail_Basic.Items.Add;
        v_ListViewItem.Text := Fields[i].AsString;
      end;
      Image_Detail.TagString := FieldByName('ImageName').AsString;
      g_Sel_Latitude         := FieldByName('POSITION1').AsString;
      g_Sel_Longitude        := FieldByName('POSITION2').AsString;
    finally
      Close;
    end;
  end;
  if ListView_Detail_Basic.ItemCount>0 then ListView_Detail_Basic.ScrollTo(0);
  ListView_Detail_Basic.EndUpdate;

  p_LoadImage_Building(Image_Detail.Bitmap,Image_Detail.TagString);
  Application.ProcessMessages;
  MultiView_Detail.ShowMaster;
end;


procedure TfrmCom_MasterDetail_Office.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


procedure TfrmCom_MasterDetail_Office.FormResize(Sender: TObject);
begin
  MultiView_Detail.Width := Self.Width-(Self.Width/9);
end;





procedure TfrmCom_MasterDetail_Office.MenuButtonClick(Sender: TObject);
begin
  Close;
end;


end.

