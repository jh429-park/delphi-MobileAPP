unit Com_DataModule;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient, Data.DBXCommon, Data.DB, Data.SqlExpr,
  Datasnap.DBClient, Datasnap.DSConnect, FMX.Listbox, FMX.Dialogs, Data.DbxHTTPLayer,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,FMX.Forms,System.UITypes,
  Data.Bind.Components, Data.Bind.ObjectScope, Data.FMTBcd, System.ImageList,
  FMX.ImgList, FMX.Types, FMX.Ani, IdHTTP, FMX.Controls,
  FMX.DialogService;

type
  TfrmCom_DataModule = class(TDataModule)
    DataSQLCon: TSQLConnection;
    DSProviderConnection: TDSProviderConnection;
    ClientDataSet_Proc:  TClientDataSet;
    ClientDataSet_Query: TClientDataSet;
    IdHTTP: TIdHTTP;
    ImageList: TImageList;
    ImageList_CI: TImageList;
    procedure DataSQLConAfterDisconnect(Sender: TObject);
    procedure DataSQLConAfterConnect(Sender: TObject);
    procedure ClientDataSet_ProcBeforeOpen(DataSet: TDataSet);
    procedure ClientDataSet_QueryBeforeOpen(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_DataModule: TfrmCom_DataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses Com_Function,MainMenu, {$IF Defined(MSWINDOWS)}Midaslib, {$ENDIF} Com_Variable;

procedure TfrmCom_DataModule.ClientDataSet_ProcBeforeOpen(DataSet: TDataSet);
begin
{$IF Defined(ANDROID)}
 if not f_NetworkIsConnected then begin
    TDialogService.MessageDialog(('네트워크 연결상태를 확인하세요.'),
      system.UITypes.TMsgDlgType.mtInformation,[system.UITypes.TMsgDlgBtn.mbOk],system.UITypes.TMsgDlgBtn.mbOk,0,
    procedure (const AResult: System.UITypes.TModalResult) begin
      frmMainMenu.Close;
      Application.Terminate;
      Self.DoDestroy;
    end);
 end;
{$ENDIF}
end;

procedure TfrmCom_DataModule.ClientDataSet_QueryBeforeOpen(DataSet: TDataSet);
begin
{$IF Defined(ANDROID)}
 if not f_NetworkIsConnected then begin
    TDialogService.MessageDialog(('네트워크 연결상태를 확인하세요.'),
      system.UITypes.TMsgDlgType.mtInformation,[system.UITypes.TMsgDlgBtn.mbOk],system.UITypes.TMsgDlgBtn.mbOk,0,
    procedure (const AResult: System.UITypes.TModalResult) begin
      frmMainMenu.Close;
      Application.Terminate;
      Self.DoDestroy;
    end);
 end;
{$ENDIF}
end;

procedure TfrmCom_DataModule.DataSQLConAfterConnect(Sender: TObject);
begin
  if TObject(frmMainMenu) <> nil then begin
    g_System_Db   := DataSQLCon.Connected;
  end;
end;

procedure TfrmCom_DataModule.DataSQLConAfterDisconnect(Sender: TObject);
begin
  if TObject(frmMainMenu) <> nil then begin
    TDialogService.MessageDialog(('서버연결이 종료되었습니다.'),
      system.UITypes.TMsgDlgType.mtInformation,[system.UITypes.TMsgDlgBtn.mbOk],system.UITypes.TMsgDlgBtn.mbOk,0,
    procedure (const AResult: System.UITypes.TModalResult) begin
      frmMainMenu.Close;
      Application.Terminate;
    end);

//    g_System_Db := DataSQLCon.Connected;
//    frmMainMenu.MultiView_Menu.Enabled   := false;
//    frmMainMenu.btnMainMenu.Visible      := false;
//    frmMainMenu.Image_SARA. Visible      := false;
//    frmMainMenu.IconList_Favorit.Visible := false;
//    TDialogService.MessageDialog(('장시간 미사용으로 시스템을 종료합니다.'),
//          system.UITypes.TMsgDlgType.mtInformation,
//          [system.UITypes.TMsgDlgBtn.mbOk],system.UITypes.TMsgDlgBtn.mbOk,0,
//    procedure (const AResult: System.UITypes.TModalResult) begin
//      frmMainMenu.VertScrollBox1.Visible := false;
//      frmMainMenu.btnMainMenu.Visible    := false;
//      frmMainMenu.Image_SARA.Visible     := false;
//      frmMainMenu.Text_Msg.Text := '시스템을 다시 실행하세요.';
//      frmMainMenu.Text_Msg.TextSettings.FontColor := TAlphaColors.Red;
//     {$IFDEF ANDROID}
//      frmMainMenu.Close;
//      Application.Terminate;
//     {$ENDIF}
//    end);



  end;
end;

end.







