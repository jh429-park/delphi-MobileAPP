 unit Com_MasterDetail_Emp;

interface

uses
  System.IOUtils,
  System.IniFiles,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.ListView.Appearances, Data.Bind.GenData,
  Fmx.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.ListBox,
  System.UIConsts,
  FMX.VirtualKeyboard,
  FMX.TabControl, FMX.Objects, FMX.MobilePreview, FMX.Controls.Presentation,
  FMX.ListView.Adapters.Base, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, System.ImageList, FMX.ImgList, System.Math.Vectors,
  FMX.Controls3D, FMX.Objects3D, FMX.Viewport3D, FMX.Layouts,
  FMX.Layers3D,
  Fmx.Ani,
  FMX.Platform, Datasnap.DSClientRest, System.Actions, FMX.ActnList,
  FMX.Gestures, FMX.TMSBaseControl, FMX.TMSCustomPicker, FMX.TMSRadioGroupPicker,
  FMX.DateTimeCtrls, FMX.Edit;

type
  TfrmCom_MasterDetail_Emp = class(TForm)
    Timer_Rotation: TTimer;
    MViewport3D: TViewport3D;
    Grid3D: TGrid3D;
    Camera: TCamera;
    Layout_SlideButton: TLayout;
    sbtLeft: TSpeedButton;
    sbtRight: TSpeedButton;
    sbtRight_Auto: TSpeedButton;
    sbtLeft_Auto: TSpeedButton;
    sbtPause: TSpeedButton;
    HeaderToolBar: TToolBar;
    Layout_Master: TLayout;
    ActionList1: TActionList;
    Action_Left: TAction;
    Action_Right: TAction;
    Action_Left_Auto: TAction;
    Action_Right_Auto: TAction;
    Text_ImageName: TText;
    btnQuery: TButton;
    Label_Title: TLabel;
    Timer_Query: TTimer;
    AniIndicator1: TAniIndicator;
    btnClose: TButton;
    ListView_EmpList: TListView;
    Layout_Date: TLayout;
    Text_Date: TText;
    edtDate: TDateEdit;
    Layout_Keyword: TLayout;
    Label1: TLabel;
    edtKeyword: TEdit;
    Layout_Dept: TLayout;
    TxtDept: TText;
    ComboBox_DeptCode: TComboBox;
    ComboBox_DeptName: TComboBox;
    cbxPicture: TCheckBox;

    procedure onImage3DClick(Sender:TObject);
    procedure p_UploadImage;
    procedure ToggleEditModeClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure sbtPauseClick(Sender: TObject);
    procedure Timer_RotationTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure Action_LeftExecute(Sender: TObject);
    procedure Action_RightExecute(Sender: TObject);
    procedure Action_Left_AutoExecute(Sender: TObject);
    procedure Action_Right_AutoExecute(Sender: TObject);
    procedure Button_DocumentClick(Sender: TObject);
    procedure Timer_QueryTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure ListView_EmpListItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure cboDeptRadioGroupSelected(Sender: TObject; Index: Integer);
    procedure ComboBox_DeptNameChange(Sender: TObject);
    procedure edtDateClosePicker(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

    Cur_imgNo: integer;    // 중앙 PSlide : 결정값
    PrePosX:   single;       // PSlide 우측 첫번째 IMG 좌표
    PMouse:    Boolean;
    PDown:     TPointF;
    procedure p_Make_Image3D;
    procedure P_Slide_Rotate(aLeftToRight:Boolean; aImageNo:integer);

  end;

var
  frmCom_MasterDetail_Emp: TfrmCom_MasterDetail_Emp;
    l_Image3D_Emp: Array of TImage3D;
    l_LeftRight:   Boolean= true;
    l_Rotation :   Boolean= false;
    l_Landscape:   Boolean= false;
    l_StringList:  TStringList;
    l_Query_Cnt:   integer=0;



implementation

{$R *.fmx}

uses System.Math, FMX.Utils,Com_DataModule,Com_function,Com_Variable, Com_Image,
  Com_Emp_Detail;


procedure TfrmCom_MasterDetail_Emp.FormShow(Sender: TObject);
var i,c:integer;
var v_StringList1:TStringList;
var v_StringList2:TStringList;

var v_Dept_Cd:String;
var v_Dept_Nm:String;

var IniFile: TiniFile;
begin
  StyleComboBoxItems(ComboBox_DeptName, 13); //TCombobox사이즈변경
  edtDate.DateTime     := Now;
  Layout_Date.Visible     := g_Sel_ActionName=UpperCase('Com_Employee_Vacation');
  Layout_Keyword.Visible  := g_Sel_ActionName=UpperCase('Com_Employee_Vacation');
  cbxPicture.IsChecked := False;
  {try
    IniFile := TIniFile.Create(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath,c_iniFile));
  //cbxPicture.IsChecked := IniFile.ReadString ('SHOWICON','EMPNO','')<>'0';
    cbxPicture.IsChecked := IniFile.ReadString ('SHOWICON','EMPNO','') ='1';
  finally
    IniFile.Free;
  end; }
  MViewport3D.Visible   := cbxPicture.IsChecked;
  Timer_Query.Enabled   := false;


  v_Dept_Cd:=g_User_DeptList_CD;
  v_Dept_Nm:=g_User_DeptList_NM;

  if v_Dept_Cd='' then v_Dept_Cd:=g_User_Dept;
  if v_Dept_Nm='' then v_Dept_Nm:=g_User_DeptName;

  try
    v_StringList1 := TStringList.Create;
    v_StringList2 := TStringList.Create;
    v_StringList1.Clear;
    v_StringList2.Clear;
    ExtractStrings([':'],[#0],PChar(v_Dept_Cd),v_StringList1);
    ExtractStrings([':'],[#0],PChar(v_Dept_Nm),v_StringList2);

    Combobox_DeptCode.BeginUpdate;
    Combobox_DeptName.BeginUpdate;
    Combobox_DeptCode.Items.Clear;
    Combobox_DeptName.Items.Clear;

    c:=0;
    if v_StringList1.Count>1 then begin
      c:=c+1;
      Combobox_DeptCode.Items.Add('*');
      Combobox_DeptName.Items.Add('전체');
      Combobox_DeptCode.ItemIndex := 0;
      Combobox_DeptName.ItemIndex := 0;
    end;

    for i:=0 to v_StringList1.Count-1 do begin
      Combobox_DeptCode.Items.Add(v_StringList1[i]);
      Combobox_DeptName.Items.Add(v_StringList2[i]);
    end;

    if Combobox_DeptCode.Items.Count>0 then Combobox_DeptCode.ItemIndex := 0;

    Layout_Dept.Visible       := Combobox_DeptName.Items.Count>1;
    Combobox_DeptName.Visible := Combobox_DeptName.Items.Count>1;
    txtDept.Visible           := Combobox_DeptName.Visible;

    if (cbxPicture.IsChecked) and (Combobox_DeptCode.Items.Count>2) then begin
        cbxPicture.IsChecked := false;
    end;


  finally
    v_StringList1.Free;
    v_StringList2.Free;
    Combobox_DeptCode.EndUpdate;
    Combobox_DeptName.EndUpdate;
  end;


//    end;
//  end;

  if g_Sel_ActionName = UpperCase('Com_Employee_Basic') then begin
     btnQuery.Visible               := false;
     ListView_EmpList.SearchVisible := True;
  end;


  AniIndicator1.Align        := Fmx.Types.TAlignLayout.Client;
  AniIndicator1.BringToFront;
  Label_Title.Text           := g_Sel_Title;
  l_StringList               := TStringList.Create;
  Timer_Rotation.Enabled     := false;
  btnQueryClick(Sender);
end;

procedure TfrmCom_MasterDetail_Emp.cboDeptRadioGroupSelected(Sender: TObject;  Index: Integer);
begin
  btnQueryClick(Sender);
end;

procedure TfrmCom_MasterDetail_Emp.ComboBox_DeptNameChange(Sender: TObject);
begin
  ComboBox_DeptCode.ItemIndex := ComboBox_DeptName.ItemIndex;
end;

procedure TfrmCom_MasterDetail_Emp.edtDateClosePicker(Sender: TObject);
begin
  btnQueryClick(Sender);
end;

procedure TfrmCom_MasterDetail_Emp.btnQueryClick(Sender: TObject);
begin
  AniIndicator1.Visible := true;
  AniIndicator1.Enabled := true;
  AniIndicator1.BringToFront;
  Application.ProcessMessages;
  Timer_Query.Enabled   := true;
end;


procedure TfrmCom_MasterDetail_Emp.Timer_QueryTimer(Sender: TObject);
begin
  Timer_Query.Enabled := false;
//  ListView_EmpList.ItemAppearanceObjects.ItemObjects.GlyphButton.Visible := true;
//  ListView_EmpList.ItemAppearanceObjects.ItemObjects.Accessory.  Visible := true;
//  Application.ProcessMessages;
  Cur_imgNo  := 0;
  l_Rotation := Timer_Rotation.Enabled;
  Timer_Rotation.Enabled := false;



  with frmCom_DataModule.ClientDataSet_Proc do begin
    if g_Sel_Summary then begin   //인력통계면....
       g_Sel_Summary                       := false;
       btnQuery.Visible                    := false;
       p_CreatePrams;
       ParamByName('arg_ModCd'  ).AsString := 'Com_Employee';
       ParamByName('arg_Company').AsString := g_Sel_Company;
       ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
       ParamByName('arg_Text01' ).AsString := g_Sel_Text01; //'COMPANY'
       ParamByName('arg_Text02' ).AsString := g_Sel_Text02; //'DEPT'
       ParamByName('arg_Text03' ).AsString := g_Sel_Text03; //'JK
       ParamByName('arg_Text04' ).AsString := g_Sel_Text04; //'AGES'
       ParamByName('arg_Text05' ).AsString := g_Sel_Text05; //'SEX'
       ParamByName('arg_Text06' ).AsString := g_Sel_Text06; //'JC'
       ParamByName('arg_Text10' ).AsString := g_Sel_Text10; //'HEADER'
       ParamByName('arg_Text11' ).AsString := '01';
       ParamByName('arg_Text12' ).AsString := g_User_DeptList_CD;
       ParamByName('arg_Text13' ).AsString := '00';
    end else
    if g_Sel_ActionName = UpperCase('Com_Employee_Basic') then begin
       btnQuery.Visible                    := true;
       p_CreatePrams;
       ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_Basic';
       ParamByName('arg_Dept'   ).AsString := comboBox_DeptCode.Items[comboBox_DeptCode.ItemIndex];
       ParamByName('arg_Text12' ).AsString := g_User_DeptList_CD;
    end else
    if g_Sel_ActionName = UpperCase('Com_Employee_Vacation') then begin
       btnQuery.Visible                    := true;
       p_CreatePrams;
       ParamByName('arg_ModCd'  ).AsString := 'Com_Employee_Vacation';
       ParamByName('arg_Dept'   ).AsString := comboBox_DeptCode.Items[comboBox_DeptCode.ItemIndex];
       ParamByName('arg_Text12' ).AsString := g_User_DeptList_CD;
       ParamByName('arg_TEXT13' ).AsString := FormatDateTime('YYYYMMDD',edtDate.DateTime);
       ParamByName('arg_Text16').AsString := edtKeyWord.Text;

    end;

  end;

  f_Query_ListViewList(ListView_EmpList);

  if g_Sel_ActionName = UpperCase('Com_Employee_Vacation') then begin
     ListView_EmpList.SearchVisible := false;
  end;

  if cbxPicture.IsChecked then begin
     MViewport3D.Visible := true;
     p_loadImage_Emp_ListView(ListView_EmpList,1,MViewport3D.Visible,false,true);
     p_Make_Image3D;
  end
  else begin
     MViewport3D.Visible := false;
  end;



//MViewport3D.Visible := (ListView_EmpList.ItemCount>01) and (ListView_EmpList.ItemCount<=g_User_MaxImage);


  Timer_Rotation.Enabled := l_Rotation;
  AniIndicator1.Visible  := false;
  AniIndicator1.Enabled  := false;

  if MViewport3D.Visible then Action_Right_AutoExecute(Sender);

end;



//procedure TfrmCom_MasterDetail_Emp.p_QueryClick(Sender: TObject);
//begin
//  Timer_Query.Enabled := false;
//
//  ListView_EmpList.ItemAppearanceObjects.ItemObjects.GlyphButton.Visible := false;
//  ListView_EmpList.ItemAppearanceObjects.ItemObjects.Accessory.  Visible := false;
//
//  TThread.CreateAnonymousThread(procedure ()
//  begin
//    TThread.Synchronize (TThread.CurrentThread, procedure ()
//    begin
//      try
//        Cur_imgNo  := 0;
//        l_Rotation := Timer_Rotation.Enabled;
//        Timer_Rotation.Enabled := false;
//        with frmCom_DataModule.ClientDataSet_Proc do begin
//          p_CreatePrams;
//          ParamByName('arg_ModCd'  ).AsString := 'Com_Employee';
//
//          if g_Sel_Summary then begin   //인력통계면....
//             btnQuery.Visible := false;
//             ParamByName('arg_Company').AsString := g_Sel_Company;
//             ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
//             ParamByName('arg_Text01' ).AsString := g_Sel_Text01; //'COMPANY'
//             ParamByName('arg_Text02' ).AsString := g_Sel_Text02; //'DEPT'
//             ParamByName('arg_Text03' ).AsString := g_Sel_Text03; //'JK
//             ParamByName('arg_Text04' ).AsString := g_Sel_Text04; //'AGES'
//             ParamByName('arg_Text05' ).AsString := g_Sel_Text05; //'SEX'
//             ParamByName('arg_Text06' ).AsString := g_Sel_Text06; //'JC'
//             ParamByName('arg_Text10' ).AsString := g_Sel_Text10; //'HEADER'
//          end
//          else begin
//             btnQuery.Visible := true;
//             ParamByName('arg_Company').AsString := g_Sel_Company;
//             ParamByName('arg_Dept'   ).AsString := g_Sel_Dept;
//          end;
//          f_Query_ListViewList(ListView_EmpList);
//        end;
//      //p_Upload_EmpImage(ListView_EmpList,1,false);
//        p_loadImage_Emp_ListView(ListView_EmpList,1,false,true);
//        p_Make_Image3D;
//        Timer_Rotation.Enabled := l_Rotation;
//      finally
//      end;
//    end);
//  end).Start;
//  AniIndicator1.Visible := false;
//  AniIndicator1.Enabled := false;
//end;


procedure TfrmCom_MasterDetail_Emp.FormResize(Sender: TObject);
begin
 {$IF Defined(MSWINDOWS)}
  l_Landscape := false;
 {$ELSE}
  l_Landscape := f_Screen_Landscape(Sender);
 {$ENDIF}



  if not l_Landscape  then begin
     Self.FullScreen        := false;
     HeaderToolBar.Visible  := true;
     Layout_Master.Visible  := true;
     Layout_Master.Align    := Fmx.Types.TAlignLayout.Client;
     MViewport3D.Visible    := true;
     MViewport3D.Align      := Fmx.Types.TAlignLayout.Bottom;
     MViewport3D.Height     := Self.Height/4;
     MViewport3D.Visible    := true;
  end
  else begin
     Self.FullScreen        := true;
     HeaderToolBar.Visible  := false;
     Layout_Master.Visible  := false;
     Layout_Master.Align    := Fmx.Types.TAlignLayout.Top;

     MViewport3D.Visible    := true;
     MViewport3D.Align      := Fmx.Types.TAlignLayout.Client;
     MViewport3D.Visible    := true;
  end;

end;


procedure TfrmCom_MasterDetail_Emp.ListView_EmpListItemClick(
  const Sender: TObject; const AItem: TListViewItem);
begin
  l_Rotation := Timer_Rotation.Enabled;
  Timer_Rotation.Enabled := false;
  with ListView_EmpList.Items[ListView_EmpList.ItemIndex] do begin
    if g_Sel_ActionName = UpperCase('Com_Employee_Basic') then begin  //Com_Employee_Basic
      if Objects.AccessoryObject.Visible then begin;
         l_StringList.Clear;
         ExtractStrings([':'],[#0],PChar(TagString),l_StringList);
         g_Sel_Company := l_StringList[0];
         g_Sel_EmpNo   := l_StringList[1];
         {if (g_Sel_TagString[1] <> g_User_EmpNo) and
            (g_Sel_TagString[2] <> g_User_EmpNo) then Exit;}
         if (l_StringList[1] = g_User_EmpNo) or (l_StringList[2] = g_User_EmpNo) then begin
            Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
            frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
         end;
      end;
    end;
  end;
  Timer_Rotation.Enabled := l_Rotation;
end;

procedure TfrmCom_MasterDetail_Emp.onImage3DClick(Sender:TObject);
begin
  l_Rotation:=Timer_Rotation.Enabled;
  Timer_Rotation.Enabled := false;
  with ListView_EmpList.Items[Cur_imgNo] do begin
    if Objects.AccessoryObject.Visible then begin;
      l_StringList.Clear;
      ExtractStrings([':'],[#0],PChar(TagString),l_StringList);
      g_Sel_Company := l_StringList[0];
      g_Sel_EmpNo   := l_StringList[1];
      Application.CreateForm(TfrmCom_Emp_Detail,frmCom_Emp_Detail);
      frmCom_Emp_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
    end;
  end;
  Timer_Rotation.Enabled := l_Rotation;
end;

procedure TfrmCom_MasterDetail_Emp.Action_LeftExecute(Sender: TObject);
begin
  if ListView_EmpList.ItemCount<=1 then Exit;
  sbtLeft.Enabled := false;
  l_Rotation := false;
  Timer_Rotation.Enabled := false;
  Application.ProcessMessages;
  if (Cur_imgNo>0) then begin
    P_Slide_Rotate(false,Cur_imgNo);
    Application.ProcessMessages;
  end;
  sbtLeft.Enabled := true;
end;

procedure TfrmCom_MasterDetail_Emp.Action_Left_AutoExecute(Sender: TObject);
begin
  if ListView_EmpList.ItemCount<=1 then Exit;
  Timer_Rotation.Enabled := false;
  Application.ProcessMessages;
  l_LeftRight := false;
  Timer_Rotation.Enabled := true;
  Application.ProcessMessages;
end;

procedure TfrmCom_MasterDetail_Emp.Action_RightExecute(Sender: TObject);
begin
  if ListView_EmpList.ItemCount<=1 then Exit;
  sbtRight.Enabled := false;
  l_Rotation             := false;
  Timer_Rotation.Enabled := false;
  Application.ProcessMessages;
  if (Cur_imgNo<ListView_EmpList.ItemCount-1) then begin
    P_Slide_Rotate(true,Cur_imgNo);
    Application.ProcessMessages;
  end;
  sbtRight.Enabled := true;
end;

procedure TfrmCom_MasterDetail_Emp.Action_Right_AutoExecute(Sender: TObject);
begin
  if ListView_EmpList.ItemCount<=1 then Exit;
  Timer_Rotation.Enabled := false;
  Application.ProcessMessages;
  l_LeftRight := true;
  Timer_Rotation.Enabled := true;
  Application.ProcessMessages;
end;


procedure TfrmCom_MasterDetail_Emp.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;


procedure TfrmCom_MasterDetail_Emp.Button_DocumentClick(Sender: TObject);
begin
  p_Open_Url_New('www.genstarre.com/GenstarMobile/pdf/Sample_Emp.pdf');
end;

procedure TfrmCom_MasterDetail_Emp.p_UploadImage;
var i:integer;
begin
  for i:=0 to ListView_EmpList.ItemCount-1 do begin
    try
      l_StringList.Clear;
      ExtractStrings([':'],[#0],PChar(ListView_EmpList.Items[i].TagString),l_StringList);
      p_LoadImage_Emp_Small(ListView_EmpList.Items[i].Bitmap,l_StringList[0],l_StringList[1]);
    finally
    end;
  end;
end;

procedure TfrmCom_MasterDetail_Emp.sbtPauseClick(Sender: TObject);
begin
  l_Rotation             := false;
  Timer_Rotation.Enabled := false;
end;


procedure TfrmCom_MasterDetail_Emp.Timer_RotationTimer(Sender: TObject);
begin
  Application.ProcessMessages;
  if l_LeftRight = true then begin
    if Cur_imgNo<ListView_EmpList.ItemCount-1 then begin
       P_Slide_Rotate(true,Cur_imgNo);
     end
     else begin
       l_LeftRight := false;
       P_Slide_Rotate(false,Cur_imgNo);
     end;
  end else
  if l_LeftRight = false then begin
     if Cur_imgNo>0  then begin
        P_Slide_Rotate(false,Cur_imgNo);
     end
     else begin
       l_LeftRight := true;
       P_Slide_Rotate(true,Cur_imgNo);
     end;
  end;
end;

procedure TfrmCom_MasterDetail_Emp.ToggleEditModeClick(Sender: TObject);
begin
  ListView_EmpList.EditMode := not ListView_EmpList.EditMode;
end;



procedure TfrmCom_MasterDetail_Emp.p_Make_Image3D;
var i,c:integer;
begin
  Text_ImageName.Text := '';
  c:=ListView_EmpList.ItemCount;


  for i:=Length(l_Image3D_Emp)-1 Downto 0 do l_Image3D_Emp[i].DisposeOf;
  for i:=Length(l_Image3D_Emp)-1 Downto 0 do l_Image3D_Emp[i].Free;

  SetLength(l_Image3D_Emp,c);
  for i := 0 to c-1 do begin
    l_Image3D_Emp[i]           := TImage3D.Create( nil );
    l_Image3D_Emp[i].Parent    := MViewport3D;
    l_Image3D_Emp[i].Bitmap.Assign(ListView_EmpList.Items[i].Bitmap);
    l_Image3D_Emp[i].WrapMode  := TImageWrapMode.Fit;           // FMX.Objects
    l_Image3D_Emp[i].HitTest   := FALSE;                        // MViewport3D 를 터치함.
    l_Image3D_Emp[i].Tag       := i;
    l_Image3D_Emp[i].TagString := ListView_EmpList.Items[i].TagString;//
    l_Image3D_Emp[i].Width     := 8;
    l_Image3D_Emp[i].Height    := 8;
    l_Image3D_Emp[i].Depth     := 0.01;

    l_Image3D_Emp[i].Visible   := true;
    l_Image3D_Emp[i].HitTest   := true;
    l_Image3D_Emp[i].TagString := ListView_EmpList.Items[i].TagString;
    l_Image3D_Emp[i].OnClick   := nil;//onImage3DClick;

    if i = 0 then begin
       l_Image3D_Emp[i].Position.X := 0;
       l_Image3D_Emp[i].Position.Y := - l_Image3D_Emp[i].Height * 0.5;
       l_Image3D_Emp[i].Position.Z := -5.0;  // 중앙이미지는 앞으로 튀어나와 보이게
       l_Image3D_Emp[i].Opacity    := 1.0;
    end
    else begin
      l_Image3D_Emp[i].Position.X := l_Image3D_Emp[i].Width * (i+1) * 0.5;  // Width/2 만큼씩 X좌표 설정
      l_Image3D_Emp[i].Position.Y := - l_Image3D_Emp[i].Height * 0.5;
      l_Image3D_Emp[i].Position.Z := 10;
      l_Image3D_Emp[i].Opacity    := 0.4;
      l_Image3D_Emp[i].RotationAngle.Y := 70;
    end;
  end;

  try
    if c>1 then begin
       Cur_imgNo := 0;                             // PSlide_Rotate 한번 호출시 하나씩 증가.
       PrePosX   := l_Image3D_Emp[1].Position.X    // Rotate 처리위해 우측 첫번째 IMG 좌표 기억.
    end
    else begin
       sbtPauseClick(Self);
       Cur_imgNo := 0;                             // PSlide_Rotate 한번 호출시 하나씩 증가.
       PrePosX   := l_Image3D_Emp[0].Position.X    // Rotate 처리위해 우측 첫번째 IMG 좌표 기억.
    end;
  except
  end;


end;


procedure TfrmCom_MasterDetail_Emp.P_Slide_Rotate(aLeftToRight:Boolean; aImageNo:integer);
var
  i :integer;
  dr:single;
begin
  dr := 0.5;
  Cur_imgNo:=aImageNo;
  if ListView_EmpList.ItemCount<=1 then Exit;
  if aLeftToRight then begin
     Cur_imgNo := Cur_imgNo+1;
     for i:=0 to ListView_EmpList.ItemCount-1 do begin
       if l_Image3D_Emp[i].Position.X = 0 then begin // 중앙은 -X 축으로 빠짐
          l_Image3D_Emp[i].AnimateFloat('RotationAngle.Y', -70, dr);
          l_Image3D_Emp[i].AnimateFloat('Position.X', -PrePosX, dr);
          l_Image3D_Emp[i].AnimateFloat('Position.Z',       10, dr);
          l_Image3D_Emp[i].AnimateFloat('Opacity',         0.4, dr);
          l_Image3D_Emp[i].AnimateFloat('Opacity',         0.4, dr);
       end
       else if l_Image3D_Emp[i].Position.X = PrePosX then begin  // 우측 첫번째 중앙이동
          l_Image3D_Emp[i].AnimateFloat('RotationAngle.Y', 0, dr);
          l_Image3D_Emp[i].AnimateFloat('Position.X',      0, dr);
          l_Image3D_Emp[i].AnimateFloat('Position.Z',   -5.0, dr);
          l_Image3D_Emp[i].AnimateFloat('Opacity',       1.0, dr);
       end
       else begin   // 나머지는 한칸씩 좌로 이동
        if  i=0
          then l_Image3D_Emp[i].AnimateFloat('Position.X',l_Image3D_Emp[i].Position.X -PrePosX*0.5, dr)
          else l_Image3D_Emp[i].AnimateFloat('Position.X',l_Image3D_Emp[i-1].Position.X, dr);
       end;
     end;
  end
  else begin
    Cur_imgNo := Cur_imgNo-1;
    for i:=0 to ListView_EmpList.ItemCount-1 do begin
      l_Image3D_Emp[i].StopPropertyAnimation('Position.Z');
      l_Image3D_Emp[i].StopPropertyAnimation('Position.X');
      l_Image3D_Emp[i].StopPropertyAnimation('RotationAngle.Y');
      if l_Image3D_Emp[i].Position.X = 0 then begin        // 중앙은 +X 축으로 빠짐
         l_Image3D_Emp[i].AnimateFloat('RotationAngle.Y', 70, dr);
         l_Image3D_Emp[i].AnimateFloat('Position.X', PrePosX, dr);
         l_Image3D_Emp[i].AnimateFloat('Position.Z',      10, dr);
         l_Image3D_Emp[i].AnimateFloat('Opacity',        0.4, dr);
      end else
      if l_Image3D_Emp[i].Position.X = -PrePosX then begin  // 좌측 첫번째 중앙이동
         l_Image3D_Emp[i].AnimateFloat('RotationAngle.Y', 0, dr);
         l_Image3D_Emp[i].AnimateFloat('Position.X',      0, dr);
         l_Image3D_Emp[i].AnimateFloat('Position.Z',   -5.0, dr);
         l_Image3D_Emp[i].AnimateFloat('Opacity',       1.0, dr);
      end
      else begin   // 나머지는 한칸씩 우로 이동
        if  i = ListView_EmpList.ItemCount-1
          then l_Image3D_Emp[i].AnimateFloat('Position.X',l_Image3D_Emp[i].Position.X + PrePosX*0.5, dr)
          else l_Image3D_Emp[i].AnimateFloat('Position.X',l_Image3D_Emp[i+1].Position.X, dr);
      end;
    end;
  end;
  Text_ImageName.Text    := ListView_EmpList.Items[Cur_imgNo].Text;
  Text_ImageName.Visible := True;
//                 +' ('+ListView_EmpList.Items[Cur_imgNo].Detail+')';
end;

procedure TfrmCom_MasterDetail_Emp.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
  try
  if cbxPicture.isChecked
     then p_iniFile_Write('SHOWICON','EMPNO','1')
     else p_iniFile_Write('SHOWICON','EMPNO','0');
  finally
  end;

  for i:=Length(l_Image3D_Emp)-1 downto 0 do begin
    try
      if Assigned(l_Image3D_Emp[i]) then l_Image3D_Emp[i].DisposeOf;
      l_Image3D_Emp[i].FreeOnRelease;
    finally
    end;
  end;

  Action := TCloseAction.caFree;

end;



procedure TfrmCom_MasterDetail_Emp.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      Self.Close;
    end;
  end;
end;

initialization
   RegisterClasses([TfrmCom_MasterDetail_Emp]);

finalization
   UnRegisterClasses([TfrmCom_MasterDetail_Emp]);



end.
