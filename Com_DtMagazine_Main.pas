unit Com_DtMagazine_Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMX.Ani, FMX.Objects, FMX.Layouts;
//  ,
//  FMXTee.Procs, FMXTee.Chart, FMXTee.Series, FMX.StdCtrls,
//  System.Threading,
//  System.UIConsts,
//  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
//  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Layouts, FMXTee.Chart.Functions,
//  FMX.Objects, FMX.DateTimeCtrls, FMX.TMSBaseControl, FMX.TMSDateTimeEdit,
//  FMX.TMSGridCell, FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid,
//  FMX.TMSGrid, FMX.ListBox, FMX.Ani;

type
  TfrmCom_DtMagazine_Main = class(TForm)
    Layout_DtMagazine: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCom_DtMagazine_Main: TfrmCom_DtMagazine_Main;

implementation

{$R *.fmx}

uses Com_function,Com_Variable,Com_DataModule;

procedure TfrmCom_DtMagazine_Main.FormCreate(Sender: TObject);
begin
//
end;


procedure TfrmCom_DtMagazine_Main.FormShow(Sender: TObject);
begin
//
end;



procedure TfrmCom_DtMagazine_Main.btnMenuClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmCom_DtMagazine_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

initialization
   RegisterClasses([TfrmCom_DtMagazine_Main]);

finalization
   UnRegisterClasses([TfrmCom_DtMagazine_Main]);


end.
