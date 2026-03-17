unit Com_QueryDetail03;

interface

uses
  IdHttp,
  FMX.VirtualKeyboard,
  FMX.Platform,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Objects, FMX.StdCtrls, FMX.TabControl, FMX.TMSCustomEdit,
  FMX.TMSEdit, FMX.TMSCalendar, FMX.Layouts, System.ImageList, FMX.ImgList,
  FMX.Ani, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.WebBrowser;

type
  TfrmCom_QueryDetail03 = class(TForm)
    Layout_Detail: TLayout;
    Layout_BaseInfo: TLayout;
    ListView_BaseInfo: TListView;
    Rectangle2: TRectangle;
    Text_BdName: TText;
    Image2: TImage;
    TabControl_BdInfo: TTabControl;
    tabItem_Position: TTabItem;
    WebBrowser1: TWebBrowser;
    TabItem1: TTabItem;
    WebBrowser2: TWebBrowser;
    TabItem_Memo: TTabItem;
    TabItem_gong: TTabItem;
    ListView_Gong: TListView;
    TabItem_Tenant: TTabItem;
    ListView_Tenant: TListView;
    HeaderToolBar: TToolBar;
    btnQuery: TButton;
    Label_Title: TLabel;
    btnClose: TButton;
    ListView1: TListView;
    AniIndicator1: TAniIndicator;
    ListView_Memo: TListView;
    procedure p_GetIamge(a_ImageName:String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure WebBrowser1DidFinishLoad(ASender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WebBrowser1DidStartLoad(ASender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_QueryDetail03: TfrmCom_QueryDetail03;
  v_YYYYMM,
  v_BdCode,
  v_URL,v_ImageName:String;

implementation

Uses Com_DataModule,
     Com_Function,
     Com_Variable,
     Mainmenu,Com_WebBrowser;
const
    c_URL_Image_Bd       = 'http://www.genstarre.com/upload/trade/';
    c_URL_Image_Bd_Ipv6  = 'http://[www.genstarre.com]/upload/trade/';

    c_URL_Daum_Map       = 'http://www.genstarre.com/SARA/Daum/Daum_Map.asp';     //?p1=36.53713&p2=127.00544
    c_URL_Daum_Road      = 'http://www.genstarre.com/SARA/Daum/Daum_RoadView.asp';//?p1=36.53713&p2=127.00544
    c_URL_Daum_Map_Ipv6  = 'http://[www.genstarre.com]/SARA/Daum/Daum_Map.asp';     //?p1=36.53713&p2=127.00544
    c_URL_Daum_Road_Ipv6 = 'http://[www.genstarre.com]/SARA/Daum/Daum_RoadView.asp';//?p1=36.53713&p2=127.00544

{$R *.fmx}


procedure TfrmCom_QueryDetail03.FormCreate(Sender: TObject);
begin
//Self.ApplyStyleLookup;
  Label_Title.Text      := g_Sel_Title;
  Layout_Detail.Align   := Fmx.Types.TAlignLayout.Client;
  ListView1.Align       := Fmx.Types.TAlignLayout.Client;
  Layout_Detail.Visible := false;
  ListView1.Visible     := true;
  btnQueryClick(Sender);
end;


procedure TfrmCom_QueryDetail03.btnCloseClick(Sender: TObject);
begin
  if Layout_Detail.Visible then begin
     Layout_Detail.Visible := false;
     ListView1.Visible     := true;
  end
  else begin
     Close;
  end;
end;


procedure TfrmCom_QueryDetail03.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      if Layout_Detail.Visible then begin
         Layout_Detail.Visible := false;
         ListView1.Visible     := true;
         Key := 0;
      end
      else begin
         Self.Close;
      end;
    end;
  end;
end;


procedure TfrmCom_QueryDetail03.Button1Click(Sender: TObject);
begin
  Application.CreateForm(TfrmCom_WebBrowser,frmCom_WebBrowser);
  frmCom_WebBrowser.Show;
end;

procedure TfrmCom_QueryDetail03.Button2Click(Sender: TObject);
begin
  if v_URL='' then Exit;
  {$IFDEF IOS}
  WebBrowser1.URL := c_URL_Daum_Map_Ipv6+v_URL;
  WebBrowser1.Navigate(c_URL_Daum_Map_Ipv6+v_URL);
  {$ENDIF}
  {$IFDEF Android}
  WebBrowser1.URL := c_URL_Daum_Map+v_URL;
  WebBrowser1.Navigate(c_URL_Daum_Map+v_URL);
  {$ENDIF}
end;

procedure TfrmCom_QueryDetail03.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;


procedure TfrmCom_QueryDetail03.p_GetIamge(a_ImageName:String);
var
  HTTP:TIdHTTP;
  MS  :TMemoryStream;
  bmp,th: TBitmap;
begin
  if a_ImageName='' then begin
    Text_BdName.Text :='사진없음';
    Exit;
  end;
  Image2.Bitmap.Assign(nil);
  HTTP := TIdHTTP.Create(nil);
  MS   := TMemoryStream.Create;
  MS.Clear;
//p_toast  (c_URL_Image_Bd+a_ImageName);
  {$IFDEF IOS}
  Http.Get (c_URL_Image_Bd_Ipv6+a_ImageName,MS);
  {$ENDIF}
  {$IFDEF Android}
  Http.Get (c_URL_Image_Bd+a_ImageName,MS);
  {$ENDIF}
  if MS.Size <> 0 then begin
    try
      bmp := TBitmap.CreateFromStream(MS);
      th  := bmp.CreateThumbnail(20,30);
      th.SaveToStream(MS);
      Ms.Position:=0;
      Image2.Bitmap.LoadFromStream(MS);
      Application.ProcessMessages;
    finally
      th.Free;
      bmp.Free;
      HTTP.Free;
      MS.Free;
    end;
  end;
end;


procedure TfrmCom_QueryDetail03.WebBrowser1DidFinishLoad(ASender: TObject);
begin
  AniIndicator1.Visible := false;
  AniIndicator1.Enabled := false;
  Application.ProcessMessages;
end;

procedure TfrmCom_QueryDetail03.WebBrowser1DidStartLoad(ASender: TObject);
begin
  AniIndicator1.Visible := true;
  AniIndicator1.Enabled := true;
  Application.ProcessMessages;
end;

procedure TfrmCom_QueryDetail03.btnQueryClick(Sender: TObject);
begin
  if ListView1.Visible then begin
    with frmCom_DataModule.ClientDataSet_Proc do begin
      p_CreatePrams;
      ParamByName('arg_ModCd' ).AsString := 'Com_DB_Office_Gong_List';
      ParamByName('arg_TEXT01').AsString := g_Sel_TagString[0]; //YYYYMM
      ParamByName('arg_TEXT02').AsString := g_Sel_TagString[1]; //RESION
    end;
    f_Query_ListViewList(ListView1);
  end
  else begin
    ListView1ItemClick(ListView1,ListView1.Items[ListView1.ItemIndex]);
  end;
end;


procedure TfrmCom_QueryDetail03.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var x_TagString:   TStringList;
begin

  try
    v_YYYYMM := '';
    v_BdCode := '';
    x_TagString := TStringList.Create;
    x_TagString.Clear;
  finally
    ExtractStrings([':'],[#0],PChar(AItem.TagString),X_TagString);
    v_YYYYMM := X_TagString[0];
    v_BdCode := X_TagString[1];
  //x_TagString.Free;
  end;

  Layout_Detail.Visible := true;
  ListView1.Visible     := false;


  v_URL := '';
  v_ImageName := '';
  Text_BdName.Text:='';
  AniIndicator1.BringToFront;
  AniIndicator1.Visible := true;
  AniIndicator1.Enabled := true;
  Application.ProcessMessages;
  TThread.CreateAnonymousThread(procedure () begin
    TThread.Synchronize (TThread.CurrentThread, procedure ()
    var i,j,k:integer;
        LItem: TListViewItem;
    begin
      with frmCom_DataModule.ClientDataSet_Proc do begin
      //--------------------------------------------------------
        with ListView_BaseInfo do begin
          try
            p_CreatePrams;
            ParamByName('arg_ModCd' ).AsString := 'Query_Detail37_0';
            ParamByName('arg_Text01').AsString := v_YYYYMM;
            ParamByName('arg_Text02').AsString := v_BdCode;
            ParamByName('arg_Text11').AsString := v_BdCode; //;AItem.TagString;
            Open;
            v_ImageName := FieldByName('_ImageName').AsString;
            if (FieldByName('_POSITION1').AsString <> '') AND
               (FieldByName('_POSITION2').AsString <> '') THEN BEGIN
                v_URL:= '?p1='+FieldByName('_POSITION1').AsString+
                        '&p2='+FieldByName('_POSITION2').AsString;
            END;
            BeginUpdate;
            Items.Clear;
            SearchVisible := false;
            CanSwipeDelete:= false;
            k:=0;
            for i:=0 to FieldCount-1 do begin
              if FieldS[i].AsString='' then continue;
              if Copy(FieldS[i].FullName,1,1) = '_' then continue;
              K:=K+1;
            end;
            for i:=0 to FieldCount-1 do begin
              if FieldS[i].AsString='' then continue;
              if Copy(FieldS[i].FullName,1,1) = '_' then continue;
              LItem        := Items.Add;
              LItem.Height := Trunc(Height/k);
              LItem.Text   := Fields[i].AsString;
              LItem.Detail := FieldS[i].FullName;
            end;
            if ItemCount>0 then ScrollTo(0);
            Application.ProcessMessages;
          finally
            Close;
            EndUpdate;
          end;
        end;
        if v_URL='' then TabControl_BdInfo.ActiveTab := TabItem_Memo;
        Application.ProcessMessages;
        p_GetIamge(v_ImageName);

        if v_URL<>'' then begin
          {$IFDEF IOS}
          WebBrowser1.URL := c_URL_Daum_Map_Ipv6+v_URL;
          WebBrowser1.Navigate(c_URL_Daum_Map_Ipv6+v_URL);
          WebBrowser2.URL := c_URL_Daum_Road_Ipv6+v_URL;
          WebBrowser2.Navigate(c_URL_Daum_Road_Ipv6+v_URL);
          {$ENDIF}
          {$IFDEF Android}
          WebBrowser1.URL   := c_URL_Daum_Map+v_URL;
          WebBrowser1.Navigate(c_URL_Daum_Map+v_URL);
          WebBrowser2.URL   := c_URL_Daum_Road+v_URL;
          WebBrowser2.Navigate(c_URL_Daum_Road+v_URL);
          {$ENDIF}
        end;

        p_CreatePrams;
        ParamByName('arg_ModCd' ).AsString := 'Query_Detail37_1';
        ParamByName('arg_Text01').AsString := v_YYYYMM;
        ParamByName('arg_Text02').AsString := v_BdCode;
        ParamByName('arg_Text11').AsString := v_BdCode;
        f_Query_ListViewDetail(ListView_Memo);
        ListView_Memo.SearchVisible := false;




        p_CreatePrams;
        ParamByName('arg_ModCd' ).AsString := 'Query_Detail37_2';
        ParamByName('arg_Text01').AsString := v_YYYYMM;
        ParamByName('arg_Text02').AsString := v_BdCode;
        ParamByName('arg_Text11').AsString := v_BdCode;
        f_Query_ListViewList(ListView_Tenant);
        ListView_Tenant.SearchVisible := false;


        p_CreatePrams;
        ParamByName('arg_ModCd' ).AsString := 'Query_Detail37_3';
        ParamByName('arg_Text01').AsString := v_YYYYMM;
        ParamByName('arg_Text02').AsString := v_BdCode;
        ParamByName('arg_Text11').AsString := v_BdCode;
        f_Query_ListViewList(ListView_Gong);
        ListView_Gong.SearchVisible := false;

      end;
    end);
  end).Start;
end;




end.
