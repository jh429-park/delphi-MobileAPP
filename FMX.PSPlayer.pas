unit FMX.PSPlayer;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,

  FMX.Types,
  FMX.Media;

type
  TPSPlayer = class(TFmxObject)
  private
    FMedia: TMedia;
    FFileName: string;
    FURL: string;
    procedure SetFileName(const Value: string);
    procedure SetURL(const Value: string);
    function GetMediaState: TMediaState;
    function GetCurrent: TMediaTime;
    function GetDuration: TMediaTime;
    function GetMedia: TMedia;
    function GetVideoSize: TPointF;
    function GetVolume: Single;
    procedure SetCurrent(const Value: TMediaTime);
    procedure SetVolume(const Value: Single);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Play;
    procedure Stop;
    procedure Clear;
    property Media: TMedia read GetMedia;
    property Duration: TMediaTime read GetDuration;
    property CurrentTime: TMediaTime read GetCurrent write SetCurrent;
    property Volume: Single read GetVolume write SetVolume;
    property State: TMediaState read GetMediaState;
  published
    property FileName: string read FFileName write SetFileName;
    property URL: string read FURL write SetURL;
  end;


implementation

{$IFDEF MSWINDOWS}
uses FMX.PSPlayer.Win,
{$ENDIF}
{$IFDEF MACOS}
{$IFNDEF NEXTGEN}
//uses FMX.URLPlayer.Mac,
{$ENDIF}
{$ENDIF}
{$IFDEF IOS}
uses FMX.PSPlayer.iOS,
{$ENDIF}
{$IFDEF ANDROID}
uses FMX.PSPlayer.Android,
{$ENDIF ANDROID}
  System.SysConst;


{ TMediaPlayer }

procedure TPSPlayer.Clear;
begin
  FreeAndNil(FMedia);
  FFileName := '';
end;

constructor TPSPlayer.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TPSPlayer.Destroy;
begin
  FreeAndNil(FMedia);
  inherited;
end;

function TPSPlayer.GetCurrent: TMediaTime;
begin
  if Assigned(FMedia) then
    Result := FMedia.CurrentTime
  else
    Result := 0;
end;

function TPSPlayer.GetDuration: TMediaTime;
begin
  if Assigned(FMedia) then
    Result := FMedia.Duration
  else
    Result := 0;
end;

function TPSPlayer.GetMedia: TMedia;
begin
  Result := FMedia;
end;

function TPSPlayer.GetMediaState: TMediaState;
begin
  if Assigned(FMedia) then
    Result := FMedia.State
  else
    Result := TMediaState.Unavailable;
end;

function TPSPlayer.GetVideoSize: TPointF;
begin
  if Assigned(FMedia) then
    Result := FMedia.VideoSize
  else
    Result := TPointF.Create(0, 0);
end;

function TPSPlayer.GetVolume: Single;
begin
  if Assigned(FMedia) then
    Result := FMedia.Volume
  else
    Result := 1.0;
end;

procedure TPSPlayer.Stop;
begin
  if Assigned(FMedia) then
    FMedia.Stop;
end;

procedure TPSPlayer.Play;
begin
  if Assigned(FMedia) then
  begin
    FMedia.Play;
  end;
end;

procedure TPSPlayer.SetCurrent(const Value: TMediaTime);
begin
  if Assigned(FMedia) then
    FMedia.CurrentTime := Value;
end;

procedure TPSPlayer.SetFileName(const Value: string);
begin
  if csDesigning in ComponentState then
  begin
    if FFileName <> Value then
      FFileName := Value;
  end
  else
  begin
    // We shall recreate media object as the file content could change.
    // For example if we make recording in the same file
    if Assigned(FMedia) then
    begin
      FMedia.DisposeOf;
      FMedia := nil;
    end;
    FFileName := Value;
    if FileExists(FFileName) then
    begin
      {$IFDEF MSWINDOWS}
      FMedia := nil;
      {$ENDIF MSWINDOWS}

      {$IFDEF IOS}
      FMedia := TAVMedia10.Create(FFileName, false);
      {$ENDIF ANDROID}

      {$IFDEF ANDROID}
      FMedia := TAndroidMedia10.Create(FFileName, false);
      {$ENDIF ANDROID}
    end
    else
      raise ECaptureDeviceException.Create(SFileNotFound);
  end;
end;

procedure TPSPlayer.SetURL(const Value: string);
begin
  if csDesigning in ComponentState then
  begin
    if FURL <> Value then
      FURL := Value;
  end
  else
  begin
    // We shall recreate media object as the file content could change.
    // For example if we make recording in the same file
    if Assigned(FMedia) then
    begin
      FMedia.DisposeOf;
      FMedia := nil;
    end;
    FURL := Value;

    {$IFDEF MSWINDOWS}
//      FMedia := TMediaCodecManager.CreateFromFile(FFileName);
    {$ENDIF MSWINDOWS}

    {$IFDEF IOS}
    FMedia := TAVMedia10.Create(FURL, True);
    {$ENDIF IOS}

    {$IFDEF ANDROID}
    FMedia := TAndroidMedia10.Create(FURL, True);
    {$ENDIF ANDROID}
  end;
end;

procedure TPSPlayer.SetVolume(const Value: Single);
begin
  if Assigned(FMedia) then
    FMedia.Volume := Value;
end;



end.
