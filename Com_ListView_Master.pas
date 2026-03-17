 unit Com_ListView_Master;

interface

uses
  System.DateUtils,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.DB,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox, FMX.SearchBox,
  System.UIConsts,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  System.IniFiles,
  System.IOUtils,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  FMX.VirtualKeyboard,
  Fmx.Ani, FMX.MultiView,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo,
  FMXTee.Engine, FMXTee.Series,
  FMXTee.Procs, FMXTee.Chart, FMXTee.Chart.Functions, FMX.Edit,
  FMX.DateTimeCtrls, FMX.TMSBaseControl, FMX.TMSGridCell, FMX.TMSGridOptions,
  FMX.TMSGridData, FMX.TMSCustomGrid, FMX.TMSGrid, FMX.TMSCustomPicker,
  FMX.TMSRadioGroupPicker, FMX.TMSPlannerBase, FMX.TMSPlannerData,
  FMX.TMSPlanner, FMX.EditBox, FMX.NumberBox;

type
  TfrmCom_ListView_Master = class(TForm)
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    Timer_Query: TTimer;
    Chart1: TChart;
    btnClose: TButton;
    Layout_Date: TLayout;
    edtDateFr: TDateEdit;
    edtDateTo: TDateEdit;
    Text_DateTo: TText;
    Label_Date: TLabel;
    btnExcel: TButton;
    Layout_Insa_GroupBy: TLayout;
    Label4: TLabel;
    cboGroupBy: TTMSFMXRadioGroupPicker;
    Grid1: TTMSFMXGrid;
    BitmapAnimation1: TBitmapAnimation;
    Layout_Insert: TLayout;
    sbtInsert: TSpeedButton;
    Planner1: TTMSFMXPlanner;
    GestureManager1: TGestureManager;
    ListView1: TListView;
    Timer1: TTimer;
    Layout_JC: TLayout;
    Label2: TLabel;
    Layout_Sort: TLayout;
    Label3: TLabel;
    cboSort: TComboBox;
    RadioBtn_Boss: TRadioButton;
    RadioBtn_Team: TRadioButton;
    RadioBtn_All: TRadioButton;
    Layout_Keyword: TLayout;
    Label1: TLabel;
    edtKeyword: TEdit;
    AniIndicator1: TAniIndicator;
    procedure ChangeTab_Left;
    procedure ChangeTab_Right;

    function  f_Query_TMSFMXGrid(aTMSFMXGrid:TTMSFMXGrid; aFooterRow:integer): integer;
    procedure p_ShowDetail(Sender: TObject; aActionName,aTitle: String);
    procedure p_MakeChart_ListView(aListView:TListView; aZeroValue:Boolean);
    procedure p_MakeChart_Grid(aTMSFMXGrid:TTMSFMXGrid; aCol:Integer);
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormResize(Sender: TObject);
    procedure Timer_QueryTimer(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure sbtCrm_Marketing_CustomerClick(Sender: TObject);
    procedure sbtCrm_Marketing_ProjectClick(Sender: TObject);
    procedure sbtCrm_Marketing_ActivityClick(Sender: TObject);
    procedure sbtInsertClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure cboGroupByGroupCheckBoxChange(Sender: TObject);
    procedure Planner1GetPositionText(Sender: TObject; APosition: Integer;
      AKind: TTMSFMXPlannerCacheItemKind; var AText: string);
    procedure Planner1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure Planner1AfterSelectItem(Sender: TObject;
      AItem: TTMSFMXPlannerItem);
    procedure Timer1Timer(Sender: TObject);
    procedure RadioBtn_Change;
    procedure RadioBtnClick(Sender: TObject);
    procedure Grid1GetCellLayout(Sender: TObject; ACol, ARow: Integer;
      ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_ListView_Master: TfrmCom_ListView_Master;
  l_Action_Name:  String='';
  l_Action_Title: String='';
  l_Radio_Value:  String='';

implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable,MainMenu,
  Com_RentCar_Detail,Com_WebBrowser,
  Com_Memo, Crm_Customer_Detail,Rch_Building_List01, Crm_Marketing_Detail,
  Crm_Project_Detail,Com_NewsPaper_Detail,
  Com_ListView_Detail, Com_Vacation_Insert, Com_Emp_Detail,
  Com_MasterDetail_Emp, Com_NoticeBoard_Detail, Dtm_TTime_Detail,
  Rch_DownLoad_Detail;

procedure TfrmCom_ListView_Master.FormShow(Sender: TObject);
begin

//Grid1.Visible := false;

Grid1.SendToBack;

{$IF Defined(MSWINDOWS)}
  btnExcel.Visible := true;
{$ELSE}
  btnExcel.Visible := false;
{$ENDIF}

  Chart1.Visible         := false;
  Timer_Query.Enabled    := false;
  Label_Title.Text       := g_Sel_Title;
  l_Action_Name          := UpperCase(g_Sel_Action_Name);
  l_Action_Title         := g_Sel_Title;
  edtKeyword.HelpKeyword := '성명or 직책or 회사or 부서or 담당업무';
  edtKeyword.text        := g_Sel_Keyword;
  StyleComboBoxItems(cboSort, 13); //TCombobox사이즈변경

  Layout_Keyword.Visible := (UpperCase(l_Action_Name)=UpperCase('Crm_Marketing_Customer')) or
                            (UpperCase(l_Action_Name)=UpperCase('Crm_Marketing_Activity')) or
                            (UpperCase(l_Action_Name)=UpperCase('Mis_Marketing_List01'  )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Vacation_List01'  )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Enter_List01'     )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Retire_List01'    )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Report_List01'    )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Report_List02'    )) or
                            (UpperCase(l_Action_Name)=UpperCase('Emp_Vacation_List01'   )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Vacation_List02'  )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_OnOff_Grid01'     ));


  Layout_Sort.Visible    := (UpperCase(l_Action_Name)=UpperCase('Crm_Marketing_Activity')) or
                            (UpperCase(l_Action_Name)=UpperCase('Com_Marketing_Activity')) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Vacation_List01'  )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Vacation_List02'  )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Retire_List01'    )) or
                            (UpperCase(l_Action_Name)=UpperCase('Insa_Enter_List01'     )) or
                            (UpperCase(l_Action_Name)=UpperCase('Crm_Marketing_Project' )) or
                            (UpperCase(l_Action_Name)=UpperCase('Mis_Marketing_List01'  )) ;

  Layout_JC.Visible       := (UpperCase(l_Action_Name)=UpperCase('Mis_Marketing_List01')) ;
  RadioBtn_Boss.IsChecked := (UpperCase(l_Action_Name)=UpperCase('Mis_Marketing_List01')) ;


  Layout_Insert.Visible  := (l_Action_Name = UpperCase('Crm_Marketing_Activity')) or
                            (l_Action_Name = UpperCase('Com_Marketing_Activity')) or
                            (l_Action_Name = UpperCase('Crm_Marketing_Project' )) or
                            (l_Action_Name = UpperCase('Emp_Vacation_List01'   )) or
                            (l_Action_Name = UpperCase('Com_Newspaper'         )) or
                            (l_Action_Name = UpperCase('Com_NoticeBoard_List01')) or
                            (l_Action_Name = UpperCase('Dtm_TTime_List01'      )) or
                            (l_Action_Name = UpperCase('Com_RentCar_Planner'   )) or
                            (l_Action_Name = UpperCase('Rch_Download_List01'   )) or
                            (l_Action_Name = UpperCase('Com_RentCar_List01'    ));

  Layout_Date.Visible                := (l_Action_Name = UpperCase('Crm_Marketing_Activity')) or
                                        (l_Action_Name = UpperCase('Com_Marketing_Activity')) or
                                        (l_Action_Name = UpperCase('Insa_Vacation_List01'  )) or
                                        (l_Action_Name = UpperCase('Insa_Vacation_List02'  )) or
                                        (l_Action_Name = UpperCase('Insa_Retire_List01'    )) or
                                        (l_Action_Name = UpperCase('Insa_Enter_List01'     )) or
                                        (l_Action_Name = UpperCase('Com_RentCar_Planner'   )) or
                                        (l_Action_Name = UpperCase('Rch_Download_List01'   )) or
                                        (l_Action_Name = UpperCase('Mis_Marketing_Summary01')) or
                                        (l_Action_Name = UpperCase('Mis_Marketing_Grid01'  )) or
                                        (l_Action_Name = UpperCase('Mis_Marketing_List01'  )) or

                                        (l_Action_Name = UpperCase('Mis_Report_List01'     )) or
                                        (l_Action_Name = UpperCase('Mis_Report_List02'     )) or
                                        (l_Action_Name = UpperCase('Mis_Report_List03'     )) or
                                        (l_Action_Name = UpperCase('Mis_Report_Grid01'     )) or
                                        (l_Action_Name = UpperCase('Mis_Report_Grid02'     )) or
                                        (l_Action_Name = UpperCase('Mis_Report_Grid03'     )) or

                                        (l_Action_Name = UpperCase('Insa_Report_List01'    )) or
                                        (l_Action_Name = UpperCase('Insa_Report_List02'    )) or
                                        (l_Action_Name = UpperCase('Insa_Report_List03'    )) or
                                        (l_Action_Name = UpperCase('Insa_Report_Grid01'    )) or
                                        (l_Action_Name = UpperCase('Insa_Report_Grid02'    )) or
                                        (l_Action_Name = UpperCase('Insa_Report_Grid03'    )) or
                                        (l_Action_Name = UpperCase('Insa_OnOff_Grid01'     )) or
                                        (l_Action_Name = UpperCase('Emp_Vacation_List01'   ));


  if (l_Action_Name = UpperCase('Insa_EmpInfo_List01'    )) or
     (l_Action_Name = UpperCase('Com_NoticeBoard_List01' )) then begin
      btnQuery.Visible        := false;
      ListView1.SearchVisible := True;
  end;



  if (l_Action_Name = UpperCase('Mis_Report_List01' )) or
     (l_Action_Name = UpperCase('Mis_Report_List02' )) or
     (l_Action_Name = UpperCase('Mis_Report_Grid01' )) or
     (l_Action_Name = UpperCase('Mis_Report_Grid02' )) or
     (l_Action_Name = UpperCase('Insa_Report_List01')) or
     (l_Action_Name = UpperCase('Insa_Report_List02')) or
     (l_Action_Name = UpperCase('Insa_Report_Grid01')) or
     (l_Action_Name = UpperCase('Insa_Report_Grid02')) or
     (l_Action_Name = UpperCase('Insa_OnOff_Grid01' ))
     then
      edtDateTo.Visible := false;

  Text_DateTo.Visible := edtDateTo.Visible;


  if ((l_Action_Name = UpperCase('Mis_Report_List01'  )))  or
     ((l_Action_Name = UpperCase('Mis_Report_List02'  )))  or
     ((l_Action_Name = UpperCase('Mis_Report_List03'  )))  or
     ((l_Action_Name = UpperCase('Mis_Report_Grid01'  )))  or
     ((l_Action_Name = UpperCase('Mis_Report_Grid02'  )))  or
     ((l_Action_Name = UpperCase('Mis_Report_Grid03'  )))  or
     ((l_Action_Name = UpperCase('Insa_Report_List01' )))  or
     ((l_Action_Name = UpperCase('Insa_Report_List02' )))  or
     ((l_Action_Name = UpperCase('Insa_Report_List03' )))  or
     ((l_Action_Name = UpperCase('Insa_Report_Grid01' )))  or
     ((l_Action_Name = UpperCase('Insa_Report_Grid02' )))  or
     ((l_Action_Name = UpperCase('Insa_Report_Grid03' )))  or
     ((l_Action_Name = UpperCase('Insa_OnOff_Grid01'  )))  or
     ((l_Action_Name = UpperCase('Com_RentCar_Planner')))  then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),0);
      edtDateTo.DateTime := IncDay(Trunc(Now),0);
  end else
  if (l_Action_Name = UpperCase('Mis_Marketing_Grid01')) then begin
      edtDateFr.DateTime := f_StrToDate(FormatDateTime('YYYY'+'0101',Now));
      edtDateTo.DateTime := f_StrToDate(FormatDateTime('YYYY'+'1231',Now));
  end else
  if (l_Action_Name = UpperCase('Rch_Download_List01')) then begin
      edtDateFr.DateTime := IncMonth(Trunc(Now),-6);
      edtDateTo.DateTime := IncMonth(Trunc(Now),+0);
  end else
  if (l_Action_Name = UpperCase('Crm_Marketing_Activity')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),0);
      edtDateTo.DateTime := IncDay(Trunc(Now),0);
  end else
  if (l_Action_Name = UpperCase('Mis_Marketing_List01')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),0);
      edtDateTo.DateTime := IncDay(Trunc(Now),0);
      cboSort.ItemIndex  := 2;
  end else
  if (l_Action_Name = UpperCase('Emp_Vacation_List01')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),-07);
      edtDateTo.DateTime := IncDay(Trunc(Now),+15);
  end else
  if (l_Action_Name = UpperCase('Com_Marketing_Activity')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),-1);
      edtDateTo.DateTime := IncDay(Trunc(Now),+1);
  end else
  if (l_Action_Name = UpperCase('Crm_Marketing_Project')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),-365);
      edtDateTo.DateTime := IncDay(Trunc(Now),+03);
  end else
  if (l_Action_Name = UpperCase('Insa_Vacation_List01')) or
     (l_Action_Name = UpperCase('Insa_Vacation_List02')) then begin
      edtDateFr.DateTime := IncDay(Trunc(Now),0);
      edtDateTo.DateTime := IncDay(Trunc(Now),1);
  end else
  if (l_Action_Name = UpperCase('Insa_Retire_List01')) then begin
      Label_Date.Text    := '퇴직일자';
      edtDateFr.DateTime := IncMonth(Trunc(Now),-6);
      edtDateTo.DateTime := IncDay(Trunc(Now),0);
  end else
  if (l_Action_Name = UpperCase('Insa_Enter_List01')) then begin
      Label_Date.Text    := '입사일자';
      edtDateFr.DateTime := IncMonth(Trunc(Now),-6);
      edtDateTo.DateTime := IncDay(Trunc(Now),0);
  end
  else begin
      edtDateFr.DateTime := IncDay(Trunc(Now),-07);
      edtDateTo.DateTime := IncDay(Trunc(Now),+07);
  end;

  if (l_Action_Name = UpperCase('Insa_InwonCount_Grid01')) then begin
      Layout_Insa_GroupBy.Visible := true;
      p_SetComboBox(cboGroupBy,'INSA_GROUPBY');
      cboGroupBy.ItemIndex := 0;
  end
  else begin
      Layout_Insa_GroupBy.Visible := false;
  end;

  if (l_Action_Name = UpperCase('Crm_Marketing_Activity')) then begin
      cboSort.ItemIndex := 2;
  end;



  if g_Sel_Keyword = '' then begin
    if l_Action_Name=UpperCase('Crm_Marketing_Customer') then begin
      g_Sel_Keyword   := '자산';
    end;
    edtKeyword.text := g_Sel_Keyword;
  end;
  btnQueryClick(Sender);
end;


procedure TfrmCom_ListView_Master.btnCloseClick(Sender: TObject);
begin
  cboGroupBy.Free;
  //ListView1.EndUpdate;
  Close;
end;

procedure TfrmCom_ListView_Master.btnQueryClick(Sender: TObject);
begin
  //ListView1.SearchVisible := False;
  //Layout_Keyword.Visible := (l_Action_Name=UpperCase('Crm_Marketing_Customer'));
  if Layout_Keyword.Visible then begin
    if l_Action_Name=UpperCase('Crm_Marketing_Customer') then
      if Length(Trim(edtKeyword.Text))<2 then begin
         p_Toast('검색조건을 2글자 이상 입력하세요.');
         edtKeyword.Text := Trim(edtKeyword.Text);
         edtKeyword.SetFocus;
         Exit;
      end;
  end;
  AniIndicator1.Enabled := true;
  AniIndicator1.Visible := true;
  AniIndicator1.BringToFront;
  Application.ProcessMessages;
  Timer_Query.Enabled   := true;
end;


procedure TfrmCom_ListView_Master.btnExcelClick(Sender: TObject);
begin
  if Grid1.Visible
     then p_Excel_DownLoad_Grid(Grid1)
     else p_Excel_DownLoad_ListView(self,l_Action_Name,'','','','','');
end;


procedure TfrmCom_ListView_Master.Timer_QueryTimer(Sender: TObject);
var IniFile: TiniFile;
begin
  Timer_Query.Enabled   := false;
  edtKeyword.text := Trim(edtKeyword.text);
  if l_Action_Name=UpperCase('Crm_Marketing_Customer') then begin
    if (g_Sel_Keyword <> edtKeyword.text) then begin
       try
         g_Sel_Keyword := edtKeyword.text;
         IniFile := TIniFile.Create(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath,c_iniFile));
         IniFile.WriteString('KEYWORD','CRM_NAME',edtKeyword.text);
       finally
         IniFile.Free;
       end;
    end;
  end;
//------------------------------------------------------------------------------
// DB
//------------------------------------------------------------------------------
  with frmCom_DataModule.ClientDataSet_Proc do begin
    p_CreatePrams;
    ParamByName('arg_ModCd').AsString := l_Action_Name;
    if (l_Action_Name = UpperCase('Mis_Report_List01'   )) or
       (l_Action_Name = UpperCase('Mis_Report_List02'   )) or
       (l_Action_Name = UpperCase('Mis_Report_List03'   )) or
       (l_Action_Name = UpperCase('Mis_Report_Grid01'   )) or
       (l_Action_Name = UpperCase('Mis_Report_Grid02'   )) or
       (l_Action_Name = UpperCase('Mis_Report_Grid03'   )) or
       (l_Action_Name = UpperCase('Insa_Report_List01'  )) or
       (l_Action_Name = UpperCase('Insa_Report_List02'  )) or
       (l_Action_Name = UpperCase('Insa_Report_List03'  )) or
       (l_Action_Name = UpperCase('Insa_Report_Grid01'  )) or
       (l_Action_Name = UpperCase('Insa_Report_Grid02'  )) or
       (l_Action_Name = UpperCase('Insa_Report_Grid03'  )) or
       (l_Action_Name = UpperCase('Insa_OnOff_Grid01'   )) or
       (l_Action_Name = UpperCase('Mis_Marketing_Grid01')) or
       (l_Action_Name = UpperCase('Rch_Download_List01' )) or
       (l_Action_Name = UpperCase('Com_RentCar_Planner' )) then begin
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Crm_Marketing_Customer')) then begin
        ParamByName('arg_Text01').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Crm_Marketing_Activity')) then begin
        ParamByName('arg_ModCd' ).AsString := 'Crm_Marketing_Activity';
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text11').AsString := g_My_boss;
        ParamByName('arg_Text12').AsString := g_My_boss_upper;
        ParamByName('arg_Text13').AsString := g_My_boss_all;
        ParamByName('arg_Text14').AsString := g_My_dept_all;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Mis_Marketing_List01')) then begin
        RadioBtn_Change;
        ParamByName('arg_ModCd' ).AsString := 'Mis_Marketing_List01';
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text11').AsString := g_My_boss;
        ParamByName('arg_Text12').AsString := g_My_boss_upper;
        ParamByName('arg_Text13').AsString := g_My_boss_all;
        ParamByName('arg_Text14').AsString := g_My_dept_all;
        ParamByName('arg_Text15').AsString := l_Radio_Value;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Com_Marketing_Activity')) then begin
        ParamByName('arg_ModCd' ).AsString := 'Crm_Marketing_Activity';
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text11').AsString := g_My_boss;
        ParamByName('arg_Text12').AsString := g_My_boss_upper;
        ParamByName('arg_Text13').AsString := g_My_boss_all;
        ParamByName('arg_Text14').AsString := g_My_dept_all;
    end else
    if (l_Action_Name = UpperCase('Emp_Vacation_List01'   )) then begin
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text04').AsString := g_User_DeptList_CD;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Insa_Vacation_List01'  )) or
       (l_Action_Name = UpperCase('Insa_Vacation_List02'  )) then begin
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Insa_Retire_List01'  )) then begin
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Insa_Enter_List01'  )) then begin
        ParamByName('arg_Text01').AsString := FormatDateTime('YYYYMMDD',edtDateFr.DateTime);
        ParamByName('arg_Text02').AsString := FormatDateTime('YYYYMMDD',edtDateTo.DateTime);
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
        ParamByName('arg_Text16').AsString := edtKeyWord.Text;
    end else
    if (l_Action_Name = UpperCase('Insa_InwonCount_Grid01'   )) then begin
        ParamByName('arg_Text01').AsString := cboGroupBy.Items[cboGroupBy.ItemIndex].Value;
    end else
    if (l_Action_Name = UpperCase('Crm_Marketing_Project')) then begin
        ParamByName('arg_Text03').AsString := cboSort.ItemIndex.ToString;
    end;
  end;


  ListView1.Visible := false;
  Grid1.    Visible := false;
  Planner1. Visible := false;


  if      Pos('_GRID',   l_Action_Name)>0 then begin
    Grid1.Visible := true;
    f_Query_TMSFMXGrid(Grid1,0);
  end
  else if Pos('_PLANNER',l_Action_Name)>0 then begin
    Planner1.Visible := true;
    f_Query_PlanerList(Self,Planner1,edtDateFr.DateTime,edtDateTo.DateTime,true,30,08,18,08,18);
  end
  else begin
    ListView1.Visible := true;
    f_Query_ListViewList(ListView1);
  end;


  //ListView1.SearchVisible := ListView1.Visible;  //2021.02.05 수정

//-------------------------------------------------------\-----------------------
// Image
//------------------------------------------------------------------------------
  if g_ShowEmpImage then begin
    if      (l_Action_Name = UpperCase('Com_Newspaper'         )) then p_loadImage_Emp_ListView(ListView1,2,true,true,false)
    else if (l_Action_Name = UpperCase('Emp_Vacation_List01'   )) then p_loadImage_Emp_ListView(ListView1,2,true,true,false)
    else if (l_Action_Name = UpperCase('Com_RentCar_List01'    )) then p_loadImage_Emp_ListView(ListView1,1,true,true,false)
    else if (l_Action_Name = UpperCase('Crm_Marketing_Activity')) then p_loadImage_Emp_ListView(ListView1,1,true,true,false)
    else if (l_Action_Name = UpperCase('Com_Marketing_Activity')) then p_loadImage_Emp_ListView(ListView1,1,true,true,false)
    else if (l_Action_Name = UpperCase('Crm_Marketing_Project' )) then p_loadImage_Emp_ListView(ListView1,2,true,true,false);
  end;
//------------------------------------------------------------------------------
// Chart
//------------------------------------------------------------------------------

//if      (l_Action_Name = UpperCase('Com_Newspaper'         )) then p_MakeChart_ListView(ListView1,false)
//  if      (l_Action_Name = UpperCase('Rch_Building_DB'       )) then p_MakeChart_ListView(ListView1,true)
//  else if (l_Action_Name = UpperCase('Insa_InwonCount_Grid01')) then p_MakeChart_Grid(Grid1,2);

//else if (l_Action_Name = UpperCase('Crm_Marketing_Activity')) then p_MakeChart_ListView(ListView1,false);
//------------------------------------------------------------------------------
// Detail
//------------------------------------------------------------------------------


//  for i:=0 to ListView1.ItemCount-1 do begin
//    ListView1.Items[i].Objects.AccessoryObject.Visible := g_Item_Detail[i]>0;
//  end;



//------------------------------------------------------------------------------



  if Chart1.Visible then Chart1.Title.Caption := g_ChartTitle else Chart1.Title.Caption:='';

  AniIndicator1.Enabled := false;
  AniIndicator1.Visible := false;

  if Grid1.Visible then Timer1.Enabled := true;

end;

procedure TfrmCom_ListView_Master.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  Grid1.AutoSizeColumns;
end;




procedure TfrmCom_ListView_Master.p_MakeChart_ListView(aListView:TListView; aZeroValue:Boolean);
var i,k:integer;
    v:Double;
    s:String;
    c:TAlphaColor;
begin
  k:=-1;
  Chart1.BeginUpdate;
  Chart1.Visible:= true;
  Chart1.Title.Visible  := false;
  Chart1.Legend.Visible := false;
  Chart1.RemoveAllSeries;
  Chart1.Title.Visible  := True;
  Chart1.Title.Caption  := Label_Title.Text;
  with ListView1,Chart1 do begin
    AddSeries(TLineSeries.Create(Self));
    AddSeries(TBarSeries.Create(Self));
    Series[0].Clear;
    Series[1].Clear;
    TBarSeries(Series[1]).Marks.Arrow.Visible := true;
    TBarSeries(Series[1]).Marks.Visible       := true;
    TBarSeries(Series[1]).Marks.Style         := smsValue;
    TBarSeries(Series[1]).Marks.Font.Size     := 7;
    for i:=0 to ItemCount-1 do begin
      if (aZeroValue) or (ListView1.items[i].Tag<>0) then begin
        k := k+1;
        c := f_Chart_Color(i);
        v := ListView1.items[i].Tag;
        s := ListView1.items[i].ButtonText;
        Series[0].AddXY(k,v,s,c);
        Series[1].AddXY(k,v,s,c);
      end;
    end;

  end;
  Chart1.EndUpdate;
end;




procedure TfrmCom_ListView_Master.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var i,s:integer;
begin
  g_Data_Updated   := false;
  g_Sel_ActionKind := 1;

  if Chart1.Visible then begin
    for s:=0 to Chart1.SeriesCount-1 do begin
      if ListView1.ItemCount = Chart1.Series[s].Count then begin
        for i:=0 to Chart1.Series[s].Count-1 do begin
          if i = AItem.Index
            then Chart1.Series[s].ValueColor[i] := TAlphaColors.Black
            else Chart1.Series[s].ValueColor[i] := f_Chart_Color(i);
        end;
      end;
    end;
  end;

  if not AItem.Objects.AccessoryObject.Visible then Exit;

  AItem.Objects.TextObject.TextColor   := TAlphaColors.Purple;
//AItem.Objects.DetailObject.TextColor := TAlphaColors.Purple;
  try
    g_Sel_TagString := TStringList.Create;
    g_Sel_TagString.Clear;
  finally
    ExtractStrings([':'],[#0],PChar(AItem.TagString),g_Sel_TagString);
  end;

  if (l_Action_Name = UpperCase('Emp_Vacation_List01'   )) then begin
    if (g_Sel_TagString[2] <> g_User_EmpNo) and
       (g_Sel_TagString[6] <> g_User_EmpNo) then Exit;
  end;

//p_ShowDetail(Sender,l_Action_Name,AItem.Text);
  p_ShowDetail(Sender,l_Action_Name,AItem.TagString);

end;


procedure TfrmCom_ListView_Master.Planner1GetPositionText(Sender: TObject;
  APosition: Integer; AKind: TTMSFMXPlannerCacheItemKind; var AText: string);
begin
  AText := FormatDateTime('MM-DD(DDD)',edtDateFr.DateTime+APosition);
//  Case cboPeriod.ItemIndex of
//    0: AText := FormatDateTime('YYYY-MM-DD(DDD)',edtDateTime.DateTime+APosition);
//    1: AText := FormatDateTime('MM-DD(DDD)',edtDateTime.DateTime+APosition);
//    2: AText := FormatDateTime('D(DDD)',edtDateTime.DateTime+APosition);
//    3: AText := FormatDateTime('D',edtDateTime.DateTime+APosition);
//  End;
end;

procedure TfrmCom_ListView_Master.p_ShowDetail(Sender: TObject; aActionName,aTitle: String);
begin
  g_Data_Updated := false;
  TThread.CreateAnonymousThread(procedure()
  begin
    TThread.Synchronize(TThread.CurrentThread,procedure()
    begin
      if aActionName = UpperCase('Rch_Download_List01') then begin
         Application.CreateForm(TfrmRch_Download_Detail,frmRch_Download_Detail);
         frmRch_Download_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Com_RentCar_Planner') then begin
         Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
         frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Com_RentCar_List01') then begin
         Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
         frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Emp_Vacation_List01') then begin
         Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
         frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if (aActionName = UpperCase('Com_Report_Leasing' )) or
         (aActionName = UpperCase('Com_Report_Research')) or
         (aActionName = UpperCase('Dtm_TTime_List01'   )) then begin
         g_Sel_Title       := '';    //g_Sel_TagString[0];
         g_Sel_Url         := aTitle;//g_Sel_TagString[1];
        {$IFDEF ANDROID}
         p_Open_Url_New(aTitle);
        {$ENDIF}
        {$IFDEF IOS}
         p_LaunchURL(aTitle);
        {$ENDIF}
      end else
      if aActionName = UpperCase('Com_Newspaper') then begin
         if (g_Sel_TagString[3]='W') and (g_Sel_TagString[4]<>'') then begin
           g_Sel_Title       := '부동산뉴스';
           g_Sel_Url         := g_Sel_TagString[4];//AItem.ButtonText;
           g_Sel_Code        := g_Sel_TagString[5];
           g_Sel_Text01      := g_Sel_TagString[0];
           g_Sel_Text02      := g_Sel_TagString[1];
           g_Sel_Text03      := g_Sel_TagString[2];
           g_Sel_Text04      := g_Sel_TagString[3];
           g_Sel_Text05      := g_Sel_TagString[4];
           g_Sel_Text06      := g_Sel_TagString[5];
           Application.CreateForm(TfrmCom_WebBrowser,frmCom_WebBrowser);
           frmCom_WebBrowser.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end
         else begin
           g_Sel_Title       := '부동산뉴스';
           g_Sel_Url         := '';
           g_Sel_Code        := '';
           Application.CreateForm(TfrmCom_Memo,frmCom_Memo);
           frmCom_Memo.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end;
      end else
      if aActionName = UpperCase('Rch_Building_DB') then begin
         g_Sel_Title       := aTitle;//AItem.Text;
         Application.CreateForm(TfrmRch_Building_List01,frmRch_Building_List01);
         frmRch_Building_List01.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Crm_Marketing_Customer') then begin
         Application.CreateForm(TfrmCrm_Customer_Detail,frmCrm_Customer_Detail);
         frmCrm_Customer_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Crm_Marketing_Activity') then begin
         Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
         frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Mis_Marketing_List01') then begin
         Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
         frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_Report_List01') then begin
         Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
         frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Com_Marketing_Activity') then begin
         Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
         frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Mis_Report_List01') then begin
         Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
         frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Crm_Marketing_Project') then begin
         Application.CreateForm(TfrmCrm_Project_Detail,frmCrm_Project_Detail);
         frmCrm_Project_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_EmpInfo_List01') then begin
        g_Sel_Company := g_Sel_TagString[0];
        g_Sel_EmpNo   := g_Sel_TagString[1];
        Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
        frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if (aActionName = UpperCase('Insa_Vacation_List01')) or
         (aActionName = UpperCase('Insa_Vacation_List02')) then begin
         Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
         frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_DeptInfo_List01') then begin
        g_Sel_Summary := true;
        g_Sel_Title   := Label_Title.Text;
        g_Sel_Company := g_Sel_TagString[0]; //'Company'
        g_Sel_Dept    := g_Sel_TagString[1]; //'DEPT'
        g_Sel_Text01  := g_Sel_TagString[0]; //'Company'
        g_Sel_Text02  := g_Sel_TagString[1]; //'DEPT'
        Application.CreateForm(TfrmCom_MasterDetail_Emp,frmCom_MasterDetail_Emp);
        frmCom_MasterDetail_Emp.ShowModal(procedure(ModalResult : TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_Evaluate_List01') then begin
        g_Sel_Company := g_Sel_TagString[0];
        g_Sel_EmpNo   := g_Sel_TagString[1];
        Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
        frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Com_NoticeBoard_List01') then begin
        Application.CreateForm(TfrmCom_NoticeBoard_Detail,frmCom_NoticeBoard_Detail);
        frmCom_NoticeBoard_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_Evaluate_Grid01') then begin
        g_Sel_Company := g_Sel_TagString[0];
        g_Sel_EmpNo   := g_Sel_TagString[1];
        Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
        frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_Enter_List01') then begin
        g_Sel_Company := g_Sel_TagString[0];
        g_Sel_EmpNo   := g_Sel_TagString[1];
        Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
        frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      if aActionName = UpperCase('Insa_Retire_List01') then begin
        g_Sel_Company := g_Sel_TagString[0];
        g_Sel_EmpNo   := g_Sel_TagString[1];
        Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
        frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end else
      begin
         Application.CreateForm(TfrmCom_ListView_Detail,frmCom_ListView_Detail);
         frmCom_ListView_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
      end;

      if g_Data_Updated then btnQueryClick(Sender);

    end);
  end).Start;


end;









procedure TfrmCom_ListView_Master.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,s:integer;
begin
  for s:=0 to Chart1.SeriesCount-1 do begin
    if ListView1.ItemCount = Chart1.Series[s].Count then begin
      for i:=0 to Chart1.Series[s].Count-1 do begin
         Chart1.Series[s].ValueColor[i] := f_Chart_Color(i);
      end;
      Chart1.Series[s].ValueColor[ValueIndex] := TAlphaColors.Black;
      ListView1.ItemIndex := ValueIndex;
      ListView1.ScrollTo(ValueIndex);
    end;
  end;

end;


procedure TfrmCom_ListView_Master.FormActivate(Sender: TObject);
begin
  if g_Data_Updated then begin
     g_Data_Updated := false;
     btnQueryClick(Sender);
  end;
end;

procedure TfrmCom_ListView_Master.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if Assigned(g_Sel_TagString) then g_Sel_TagString.Free;
  Action := TCloseAction.caFree;
end;


procedure TfrmCom_ListView_Master.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
       // Tastatur ist eingeblendet .. also nix tun
    end
    else begin
      Self.Close;
    end;
  end;
end;



procedure TfrmCom_ListView_Master.FormResize(Sender: TObject);
begin
 Chart1.Height   := Self.Height/3;
// sbtInsert.Position.X := Self.Width -sbtInsert.Width*2;
// sbtInsert.Position.Y := Self.Height-sbtInsert.Height*2;
end;



procedure TfrmCom_ListView_Master.sbtInsertClick(Sender: TObject);
begin
  g_Sel_ActionKind := 0;
  g_Sel_Gubun      :='0';
  g_Data_Updated   := false;

  g_Sel_DateTimeFr := Now;
  g_Sel_DateTimeTo := Now;

  if l_Action_Name = UpperCase('Rch_DownLoad_List01') then begin
     Application.CreateForm(TfrmRch_DownLoad_Detail,frmRch_DownLoad_Detail);
     frmRch_DownLoad_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Dtm_TTime_List01') then begin
     Application.CreateForm(TfrmDtm_TTime_Detail,frmDtm_TTime_Detail);
     frmDtm_TTime_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Com_Newspaper') then begin
     Application.CreateForm(TfrmCom_NewsPaper_Detail,frmCom_NewsPaper_Detail);
     frmCom_NewsPaper_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Crm_Marketing_Customer') then begin
     Application.CreateForm(TfrmCrm_Customer_Detail,frmCrm_Customer_Detail);
     frmCrm_Customer_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Crm_Marketing_Activity') then begin
     Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
     frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Com_Marketing_Activity') then begin
     Application.CreateForm(TfrmCrm_Marketing_Detail,frmCrm_Marketing_Detail);
     frmCrm_Marketing_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Crm_Marketing_Project') then begin
     Application.CreateForm(TfrmCrm_Project_Detail,frmCrm_Project_Detail);
     frmCrm_Project_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Com_RentCar_List01') then begin
     Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
     frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Com_RentCar_Planner') then begin
     g_Sel_DateTimeFr := Planner1.SelectedStartDateTime;
     g_Sel_DateTimeTo := Planner1.SelectedEndDateTime;
     Application.CreateForm(TfrmCom_RentCar_Detail,frmCom_RentCar_Detail);
     frmCom_RentCar_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);

  end else
  if l_Action_Name = UpperCase('Emp_Vacation_List01') then begin
     Application.CreateForm(TfrmCom_Vacation_Insert,frmCom_Vacation_Insert);
     frmCom_Vacation_Insert.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end else
  if l_Action_Name = UpperCase('Com_NoticeBoard_List01') then begin
     Application.CreateForm(TfrmCom_NoticeBoard_Detail,frmCom_NoticeBoard_Detail);
     frmCom_NoticeBoard_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
  end;

  if g_Data_Updated then btnQueryClick(Sender);

end;



procedure TfrmCom_ListView_Master.sbtCrm_Marketing_ProjectClick(Sender: TObject);
begin
//  p_ActExecute(frmMainMenu.Crm_Marketing_Project);
//  Close;
end;

procedure TfrmCom_ListView_Master.sbtCrm_Marketing_ActivityClick(Sender: TObject);
begin
//  p_ActExecute(frmMainMenu.Crm_Marketing_Activity);
//  Close;
end;

procedure TfrmCom_ListView_Master.sbtCrm_Marketing_CustomerClick(Sender: TObject);
begin
//  p_ActExecute(frmMainMenu.Crm_Marketing_Customer);
//  Close;
end;


function TfrmCom_ListView_Master.f_Query_TMSFMXGrid(aTMSFMXGrid:TTMSFMXGrid; aFooterRow:integer): integer;
var r,c,k:integer;
ALayout: TTMSFMXGridCellLayout;
begin
  Result := -1;
  ListView1.SearchVisible := false;
//Grid1.BringToFront;
  aTMSFMXGrid.Visible := true;
  aTMSFMXGrid.FixedFooterRows := aFooterRow;
  p_TMSFMXGrid_Clear(Self,aTMSFMXGrid);
  aTMSFMXGrid.BeginUpdate;
  aTMSFMXGrid.Align := Fmx.Types.TAlignLayout.Client;
  with frmCom_DataModule.ClientDataSet_Proc,aTMSFMXGrid do begin
    try
      Open;
      Result      := RecordCount;
      RowCount    := RecordCount+1;
      ColumnCount := FieldCount +1;
      Clear;
     k:=-1;
      for c:=0 to FieldCount-1 do begin
        Cells [c+1,0]         := Fields[c].FullName;
        HorzAlignments[c+1,0] := Fmx.Types.TTextAlign.Center;

      end;
      for r:=0 to RecordCount-1 do begin
        RowHeights[r+1]       := RowHeights[0];
        Cells [0,r+1]         := (r+1).toString;
        HorzAlignments[0,r+1] := Fmx.Types.TTextAlign.Center;
        for c:=0 to FieldCount-1 do begin
//        if (c+1)=k
//          then aTMSFMXGrid.AddProgressBar(c+1,r+1,Fields[c].AsFloat)
//          else p_TMSFMXGrid_SetField(Self,aTMSFMXGrid,Fields,c,c+1,r+1);
           p_TMSFMXGrid_SetField(Self,aTMSFMXGrid,Fields,c,c+1,r+1);

        end;
        Next;
      end;
    //AutoSizeColumn(0,true);
    finally
      Close;
      AutoSizeColumns;
    end;
  end;
  aTMSFMXGrid.EndUpdate;
end;


procedure TfrmCom_ListView_Master.Grid1GetCellLayout(Sender: TObject; ACol,
  ARow: Integer; ALayout: TTMSFMXGridCellLayout; ACellState: TCellState);
begin
    if (ACol = 4) and (ARow >= Grid1.FixedRows) then
     if Grid1.Cells[ACol,ARow] = '지각' then
     ALayout.Fill.Color := claTomato;
end;

procedure TfrmCom_ListView_Master.cboGroupByGroupCheckBoxChange(Sender: TObject);
begin
  btnQueryClick(Sender);
end;



procedure TfrmCom_ListView_Master.p_MakeChart_Grid(aTMSFMXGrid:TTMSFMXGrid; aCol:Integer);
var i,k:integer;
    v:Double;
    s:String;
    c:TAlphaColor;
begin
  k:=-1;
  Chart1.Visible:= true;
  Chart1.BeginUpdate;
  Chart1.Title.Visible  := false;
  Chart1.Legend.Visible := false;
  Chart1.RemoveAllSeries;
  Chart1.Title.Visible  := True;
  Chart1.Title.Caption  := Label_Title.Text;
  with aTMSFMXGrid,Chart1 do begin
    AddSeries(TLineSeries.Create(Self));
    AddSeries(TBarSeries.Create(Self));
    Series[0].Clear;
    Series[1].Clear;
    TBarSeries(Series[1]).Marks.Arrow.Visible := true;
    TBarSeries(Series[1]).Marks.Visible       := true;
    TBarSeries(Series[1]).Marks.Style         := smsValue;
    TBarSeries(Series[1]).Marks.Font.Size     := 7;
    for i:=1 to aTMSFMXGrid.RowCount-2 do begin
      try
        k := k+1;
        c := f_Chart_Color(i);
        v := StrToFloat(aTMSFMXGrid.Cells[aCol,i]);
        s := aTMSFMXGrid.Cells[1,i];
        Series[0].AddXY(k,v,s,c);
        Series[1].AddXY(k,v,s,c);
      except
        v := 0;
      end;
    end;

  end;
  Chart1.EndUpdate;
end;



procedure TfrmCom_ListView_Master.Planner1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  Case EventInfo.GestureID of
    sgiLeft : ChangeTab_Left();
    sgiRight: ChangeTab_Right();
  End;
end;



procedure TfrmCom_ListView_Master.ChangeTab_Left;
var c:integer;
begin
  if edtDateFr.DateTime>edtDateTo.DateTime then Exit;
  c := Trunc(edtDateTo.DateTime)-Trunc(edtDateFr.DateTime);
  edtDateFr.DateTime := IncDay(Trunc(edtDateTo.DateTime),1);
  edtDateTo.DateTime := IncDay(Trunc(edtDateFr.DateTime),c);
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_ListView_Master.ChangeTab_Right;
var c:integer;
begin
  if edtDateFr.DateTime>edtDateTo.DateTime then Exit;
  c := Trunc(edtDateTo.DateTime)-Trunc(edtDateFr.DateTime);
  edtDateTo.DateTime := IncDay(Trunc(edtDateFr.DateTime),-1);
  edtDateFr.DateTime := IncDay(Trunc(edtDateTo.DateTime),-1*c);
  btnQueryClick(btnQuery);
end;

procedure TfrmCom_ListView_Master.RadioBtnClick(Sender: TObject);
begin
  btnQueryClick(Sender);
end;

procedure TfrmCom_ListView_Master.RadioBtn_Change;
var v_Value:String;
begin
  l_Radio_Value := '';   //초기화

  if      RadioBtn_Boss.IsChecked then v_Value       := '1'   //사업부장(본부장)
  else if RadioBtn_Team.IsChecked then v_Value       := '2'   //팀장
  else                                 v_Value       := '9';  //전체
  l_Radio_Value := v_Value;
  //btnQueryClick(Sender);
end;


procedure TfrmCom_ListView_Master.Planner1AfterSelectItem(Sender: TObject; AItem: TTMSFMXPlannerItem);
begin
  if not AItem.DataBoolean then Exit;
  try
    g_Data_Updated   := false;
    g_Sel_ActionKind := 1;
    g_Sel_TagString  := TStringList.Create;
    g_Sel_TagString.Clear;
  finally
    ExtractStrings([':'],[#0],PChar(Planner1.Items[AItem.Index].DataString),g_Sel_TagString);
  end;
  p_ShowDetail(Sender,l_Action_Name,Label_Title.Text);
end;



initialization
   RegisterClasses([TfrmCom_ListView_Master]);

finalization
   UnRegisterClasses([TfrmCom_ListView_Master]);

end.








































