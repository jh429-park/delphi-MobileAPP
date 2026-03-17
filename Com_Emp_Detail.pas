 unit Com_Emp_Detail;

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
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.DateTimeCtrls;

type
  TfrmCom_Emp_Detail = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Layout_Combo: TLayout;
    cboCompany: TComboBox;
    btnClose: TButton;
    Layout_Detail: TLayout;
    Layout_Detail_Header: TLayout;
    Image_Detail: TImageControl;
    FloatAnimation1: TFloatAnimation;
    ListView_Detail: TListView;
    Layout_Detail_Body: TLayout;
    TabControl_Detail: TTabControl;
    TabItem_School: TTabItem;
    TabItem_Emp_Bal: TTabItem;
    TabItem6: TTabItem;
    TabItem_family: TTabItem;
    TabItem7: TTabItem;
    TabItem8: TTabItem;
    TabItem9: TTabItem;
    ListView_Detail_Body: TListView;
    Button_Document: TButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure TabControl_DetailChange(Sender: TObject);
    procedure Image_DetailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_Emp_Detail: TfrmCom_Emp_Detail;

implementation

{$R *.fmx}

uses System.Math, FMX.Utils, Com_DataModule, Com_function, Com_Variable,MainMenu, Com_Image;

procedure TfrmCom_Emp_Detail.FormShow(Sender: TObject);
begin
  TabControl_Detail.ActiveTab := TabItem_Emp_Bal;
  Label_Title.Text            := g_Sel_Title;
  btnQueryClick(Sender);
end;


procedure TfrmCom_Emp_Detail.Image_DetailClick(Sender: TObject);
begin
  g_Sel_Url      := c_Image_Emp;
  g_Sel_FileName := Image_Detail.TagString+'.jpg';
  g_Sel_Title    := ListView_Detail.Items[0].Text;
  Application.CreateForm(TfrmCom_Image,frmCom_Image);
  frmCom_Image.Show;
end;

procedure TfrmCom_Emp_Detail.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_Emp_Detail.btnQueryClick(Sender: TObject);
begin
  p_LoadImage_Emp_Small(Image_Detail.Bitmap,g_Sel_Company,g_Sel_EmpNo);
  Image_Detail.TagString := g_Sel_EmpNo;
  with frmCom_DataModule.ClientDataSet_Proc do begin
    ListView_Detail.Items.Clear;
    p_CreatePrams;
    ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_Detail';
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    f_Query_ListViewDetail(ListView_Detail);
  end;
  TabControl_DetailChange(TabControl_Detail);
end;

procedure TfrmCom_Emp_Detail.TabControl_DetailChange(Sender: TObject);
begin
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_Company').AsString := g_Sel_Company;
    ParamByName('arg_EmpNo'  ).AsString := g_Sel_EmpNo;
    Case TabControl_Detail.ActiveTab.Index of
      0:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_Schocare';
      1:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_BAL';
      2:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_EVALUATE';
      3:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_FAMILY';
      4:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_NOTWORK';
      5:ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_LICENSE';
    else
      begin
        ListView_Detail_Body.Items.Clear;
        Close;
        Exit;
      end;
    end;
    f_Query_ListViewList(ListView_Detail_Body);
  end;
end;


procedure TfrmCom_Emp_Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;



procedure TfrmCom_Emp_Detail.MenuButtonClick(Sender: TObject);
begin
  Close;
end;

initialization
   RegisterClasses([TfrmCom_Emp_Detail]);

finalization
   UnRegisterClasses([TfrmCom_Emp_Detail]);

end.


