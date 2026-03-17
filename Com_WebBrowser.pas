unit Com_WebBrowser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts, FMX.Memo,
  FMX.VirtualKeyboard, FMX.Platform, REST.Client, REST.Types, System.JSON, IdHTTP,
  FMX.Ani, FMX.Objects, FMX.ListBox, System.Math;

type
  TfrmCom_WebBrowser = class(TForm)
    HeaderToolBar: TToolBar;
    Label_Title: TLabel;
    btnClose: TButton;
    ToolBar_Bottom: TToolBar;
    btnGoBack: TButton;
    btnGoForward: TButton;
    sbtRch_Building: TSpeedButton;
    sbtUpdate: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    WebBrowser: TWebBrowser;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label_TitleClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGoBackClick(Sender: TObject);
    procedure btnGoForwardClick(Sender: TObject);
    procedure WebBrowserDidFinishLoad(ASender: TObject);
    procedure WebBrowserDidStartLoad(ASender: TObject);
    procedure sbtRch_BuildingClick(Sender: TObject);
    procedure sbtUpdateClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure VertScrollBox1CalcContentBounds(Sender: TObject;
      var ContentBounds: TRectF);
    procedure FormCreate(Sender: TObject);
  private
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_WebBrowser: TfrmCom_WebBrowser;
  l_Action_Name:  String='';
  l_Action_Title: String='';
  l_Action_BdCode:String='';

implementation

{$R *.fmx}

uses Com_Variable,Com_DataModule,Com_Function, MainMenu, Com_NewsPaper_Detail;

procedure TfrmCom_WebBrowser.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCom_WebBrowser.btnGoBackClick(Sender: TObject);
begin
  if WebBrowser.CanGoBack then WebBrowser.GoBack;
end;

procedure TfrmCom_WebBrowser.btnGoForwardClick(Sender: TObject);
begin
  if WebBrowser.CanGoForward then WebBrowser.GoForward;
end;

procedure TfrmCom_WebBrowser.Button1Click(Sender: TObject);
var
   FRestClient : TRestClient;
   FRestRequest : TRestRequest;
   FRestResponse : TRestResponse;
   aParam : TRESTRequestParameter;

   jsonObj : TJSONObject;
 begin
     FRestRequest.Client := FRestClient;
     FRestRequest.Response := FRestResponse;

     jsonObj.AddPair( TJSONPair.Create ('UCOMPANY', g_Sel_Company));
     jsonObj.AddPair( TJSONPair.Create ('UID',      g_Sel_eMailId));
     jsonObj.AddPair( TJSONPair.Create ('UERP',     g_Sel_EmpNo));
     jsonObj.AddPair( TJSONPair.Create ('UROUTE',   'M'));

    {jsonObj.AddPair( TJSONPair.Create ('UID', 'jh429_s2.park'));
     jsonObj.AddPair( TJSONPair.Create ('UERP', 'G0115'));
     jsonObj.AddPair( TJSONPair.Create ('UCOMPANY', 'G1000'));
     jsonObj.AddPair( TJSONPair.Create ('UROUTE', 'M'));}


     FRestClient.BaseURL := 'https://work.genstarmate.com/user/siteBridge.asp';
     FRestClient.Accept := 'application/json';
     FRestClient.ContentType := 'application/json';
     FRestRequest.Resource := '/';

     FRestRequest.ClearBody;
     FRestRequest.Params.Clear;
     aParam := FRestRequest.Params.AddItem;
     aParam.Value := jsonObj.ToString;

     aParam.ContentType := ctAPPLICATION_JSON;
     FRestRequest.Method := rmPOST;
     FRestRequest.Execute;
 end;


procedure TfrmCom_WebBrowser.Button2Click(Sender: TObject);
var
  IDhttp: TIdHTTP;
  TRequest : TstringStream;
  TOut : TstringStream;
  URL, sString : String;
begin
  try
    IDhttp := TIdHTTP.Create(nil);
    URL := 'https://work.genstarmate.com/user/siteBridge.asp';

    TRequest := TStringStream.Create('');
    TOut := TStringStream.Create('');

    IDhttp.ConnectTimeout      := 3000;
    IDhttp.ReadTimeout         := 3000;
    IDhttp.Request.ContentType := 'application/json;charset=UTF-8';


    TRequest.Clear;
    TOut.Clear;


    sString := '';
    sString := '{                                   '+#13#10+
              '   "UCOMPANY": "G1000",              '+#13#10+
              '   "UID": "jh429_s2.park"            '+#13#10+
              '   "UERP": "G0115"                   '+#13#10+
              '   "UROUTE": "M"                     '+#13#10+
             '}                                   ';

    TRequest.WriteString(sString);

    TRequest.Position := 0;

    IDhttp.Post(URL, TRequest, TOut);

    //TOut.SaveToFile('C:\pierrot.pdf');
  finally
    IDhttp.Free;
    TRequest.Free;
    TOut.Free;
  end;


end;

procedure TfrmCom_WebBrowser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmCom_WebBrowser.FormCreate(Sender: TObject);
begin
  VKAutoShowMode := TVKAutoShowMode.Always;
  VertScrollBox1.OnCalcContentBounds := CalcContentBoundsProc;
end;

procedure TfrmCom_WebBrowser.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  FService : IFMXVirtualKeyboardService;
begin
  if (Key = vkHardwareBack) then begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then begin
    end
    else begin
      Key := 0;
      Self.Close;
    end;
  end;
end;

procedure TfrmCom_WebBrowser.FormResize(Sender: TObject);
begin
  HeaderToolBar.Visible := not f_Screen_Landscape(Sender);
end;

procedure TfrmCom_WebBrowser.FormShow(Sender: TObject);
begin
  if g_Sel_Action_Name = 'Com_Newspaper' then begin

  Label_Title.Text        := g_Sel_Title;
  l_Action_Name           := UpperCase(g_Sel_Action_Name);
  l_Action_Title          := g_Sel_Title;
  l_Action_BdCode         := g_Sel_Code;
  g_Sel_Code              := '';
  sbtRch_Building.Visible :=(l_Action_BdCode<>'');
  WebBrowser.BeginUpdate;
  WebBrowser.URL          := g_Sel_Url;
  WebBrowser.Navigate;

  sbtUpdate.Visible       :=(g_User_Company=g_Sel_TagString[1]) and
                            (g_User_EmpNo  =g_Sel_TagString[2]);
  WebBrowser.EndUpdate;
  end
  else
  if g_Sel_Action_Name = 'Rch_Building_Web' then begin

  Label_Title.Text        := g_Sel_Title;
  l_Action_Name           := UpperCase(g_Sel_Action_Name);
  l_Action_Title          := g_Sel_Title;
  l_Action_BdCode         := g_Sel_Code;
  g_Sel_Code              := '';
  sbtRch_Building.Visible :=(l_Action_BdCode<>'');
  WebBrowser.BeginUpdate;
  WebBrowser.URL          := g_Sel_Url;
  WebBrowser.Navigate;

  sbtUpdate.Visible       :=(g_User_Company=g_Sel_TagString[1]) and
                            (g_User_EmpNo  =g_Sel_TagString[2]);
  WebBrowser.EndUpdate;
  end
  else
  if g_Sel_Action_Name = 'Web_BuildingList' then begin

  Label_Title.Text        := g_Sel_Title;
  l_Action_Name           := UpperCase(g_Sel_Action_Name);
  l_Action_Title          := g_Sel_Title;
  l_Action_BdCode         := g_Sel_Code;
  g_Sel_Code              := '';
  sbtRch_Building.Visible :=(l_Action_BdCode<>'');
  WebBrowser.BeginUpdate;
  WebBrowser.URL          := g_Sel_Url;
  WebBrowser.Navigate;

  sbtUpdate.Visible       :=(g_User_Company=g_Sel_TagString[1]) and
                            (g_User_EmpNo  =g_Sel_TagString[2]);
  WebBrowser.EndUpdate;
  end
  else begin

  Label_Title.Text        := g_Sel_Title;
  ToolBar_Bottom.Visible  := False;
  WebBrowser.BeginUpdate;
  WebBrowser.URL          := 'https://work.genstarmate.com/user/siteBridge_get.asp?UCOMPANY='+g_Sel_Company+
                             '&UID='+g_Sel_eMailId+
                             '&UERP='+g_Sel_EmpNo+
                             '&UROUTE=M';
  //WebBrowser.URL          := 'https://work.genstarmate.com/user/siteBridge_get.asp?UID=jh429_s2.park&UERP=G0115&UCOMPANY=G1000&UROUTE=M';
  //showmessage(g_Sel_Company+'_'+g_Sel_eMailId+'_'+g_Sel_EmpNo);
  WebBrowser.EnableCaching := False;
  WebBrowser.Navigate;
  WebBrowser.EndUpdate;
  end;
end;


procedure TfrmCom_WebBrowser.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  //FKBBounds.Top := 0;
  //VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
  //VertScrollBox1.RealignContent;
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;

procedure TfrmCom_WebBrowser.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;

procedure TfrmCom_WebBrowser.Label_TitleClick(Sender: TObject);
begin
  WebBrowser.Reload;
end;

procedure TfrmCom_WebBrowser.sbtRch_BuildingClick(Sender: TObject);
begin
  g_Sel_ActionKind := 1;
  g_Sel_Title      := '대상빌딩정보';
  g_Sel_Text01     := '202005';
  g_Sel_Text02     := l_Action_BdCode;
  p_ActExecute(frmMainMenu.Rch_Building_List01);
end;

procedure TfrmCom_WebBrowser.sbtUpdateClick(Sender: TObject);
begin
  g_Sel_GUBUN  := '1';
  g_Sel_Text01 := g_Sel_TagString[0]; // A.SEQ
  g_Sel_Text02 := g_Sel_TagString[1]; // A.CD_COMPANY
  g_Sel_Text03 := g_Sel_TagString[2]; // A.SNO
  g_Sel_Text04 := g_Sel_TagString[3]; // A.FILE_PDF
  g_Sel_Text05 := g_Sel_TagString[4]; // A.WebAddr
  g_Sel_Text06 := g_Sel_TagString[5]; // A.STR_LOCAL

  Application.CreateForm(TfrmCom_NewsPaper_Detail,frmCom_NewsPaper_Detail);
  frmCom_NewsPaper_Detail.ShowModal(procedure(ModalResult:TModalResult) begin if ModalResult = mrOK then; end);
end;

procedure TfrmCom_WebBrowser.WebBrowserDidFinishLoad(ASender: TObject);
begin
  btnGoBack.Visible      := WebBrowser.CanGoBack;
  btnGoForward.Visible   := WebBrowser.CanGoForward;
  if g_Sel_Action_Name = 'Com_Newspaper' then begin
     ToolBar_Bottom.Visible := btnGoBack.Visible or btnGoForward.Visible or sbtRch_Building.Visible;
  end;
end;

procedure TfrmCom_WebBrowser.WebBrowserDidStartLoad(ASender: TObject);
begin
  btnGoBack.Visible      := false;
  btnGoForward.Visible   := false;
  if g_Sel_Action_Name = 'Com_Newspaper' then begin
     ToolBar_Bottom.Visible := btnGoBack.Visible or btnGoForward.Visible or sbtRch_Building.Visible;
  end;
end;

procedure TfrmCom_WebBrowser.CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then begin
     ContentBounds.Bottom := Max(ContentBounds.Bottom,2 * ClientHeight - FKBBounds.Top);
  end;
end;

procedure TfrmCom_WebBrowser.UpdateKBBounds;
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) Or
       (LFocusRect.Bottom > FKBBounds.Top) then begin
      FNeedOffset := True;
      MainLayout1.Align := TAlignLayout.Horizontal;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then RestorePosition;
end;

procedure TfrmCom_WebBrowser.RestorePosition;
begin
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
  MainLayout1.Align := TAlignLayout.Client;
  VertScrollBox1.RealignContent;
end;


procedure TfrmCom_WebBrowser.VertScrollBox1CalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FKBBounds.Top > 0 then begin
    ContentBounds.Bottom := ContentBounds.Bottom + (FKBBounds.Bottom - FKBBounds.Top);
  end;

end;

initialization
   RegisterClasses([TfrmCom_WebBrowser]);

finalization
   UnRegisterClasses([TfrmCom_WebBrowser]);

end.


