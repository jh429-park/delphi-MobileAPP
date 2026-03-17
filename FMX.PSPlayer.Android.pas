unit FMX.PSPlayer.Android;

interface

uses
  Androidapi.JNI.Media, System.Types, FMX.Media, Androidapi.JNI.VideoView,
  Androidapi.JNI.App, Androidapi.JNI.Widget, FMX.Messages;

type
  TAndroidMedia10 = class(TMedia)
  private
    FPlayer: JMediaPlayer;
    FVolume: Single;
  protected
    procedure SeekToBegin;
    function GetDuration: TMediaTime; override;
    function GetCurrent: TMediaTime; override;
    procedure SetCurrent(const Value: TMediaTime); override;
    function GetVideoSize: TPointF; override;
    function GetMediaState: TMediaState; override;
    function GetVolume: Single; override;
    procedure SetVolume(const Value: Single); override;
    procedure UpdateMediaFromControl; override;
    procedure DoPlay; override;
    procedure DoStop; override;
  public
    constructor Create(const AFileName: string; IsUrl: Boolean); overload;
    destructor Destroy; override;
  end;

implementation


uses
  Androidapi.Bitmap, Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Hardware, System.RTLConsts, System.Math, System.SysUtils, System.SyncObjs, FMX.Consts, FMX.Types,
  FMX.PixelFormats, FMX.Surfaces, FMX.Graphics, FMX.Helpers.Android, FMX.Forms, Androidapi.Gles;


constructor TAndroidMedia10.Create(const AFileName: string; IsUrl: Boolean);
var
  AudioService: JObject;
  AudioManager: JAudioManager;
  MaxVolume : Integer;

begin
  inherited Create(AFileName);
  FPlayer := TJMediaPlayer.JavaClass.init;
  if IsUrl then
    FPlayer.setDataSource(SharedActivityContext, StrToJURI(FileName))
  else
    FPlayer.setDataSource(StringToJString(FileName));
  // Stream Àç»ý
  // FPlayer.setDataSource(TJFileInputStream.JavaClass.init(StringToJString(Filename)).getFD);
  FPlayer.prepare;

  AudioService := SharedActivity.getSystemService(TJContext.JavaClass.AUDIO_SERVICE);
  if Assigned(AudioService) then
    AudioManager := TJAudioManager.Wrap((AudioService as ILocalObject).GetObjectID);
  if Assigned(AudioManager) then
  begin
    MaxVolume := AudioManager.getStreamMaxVolume(TJAudioManager.JavaClass.STREAM_MUSIC);
    FVolume := AudioManager.getStreamVolume(TJAudioManager.JavaClass.STREAM_MUSIC);
    if MaxVolume > 0 then
      FVolume := FVolume / MaxVolume ;
    if FVolume > 1 then
      FVolume := 1 ;
  end;
end;

destructor TAndroidMedia10.Destroy;
begin
  FPlayer.release;
  FPlayer := nil;
  inherited Destroy;
end;

function TAndroidMedia10.GetCurrent: TMediaTime;
begin
  if Assigned(FPlayer) then
    Result := FPlayer.getCurrentPosition
  else
    Result := 0;
end;

function TAndroidMedia10.GetDuration: TMediaTime;
begin
  Result := FPlayer.getDuration;
end;

function TAndroidMedia10.GetMediaState: TMediaState;
begin
  if Assigned(FPlayer) then
  begin
    if FPlayer.isPlaying then
      Result := TMediaState.Playing
    else
      Result := TMediaState.Stopped;
  end
  else
    Result := TMediaState.Unavailable;
end;

function TAndroidMedia10.GetVideoSize: TPointF;
begin
  if Assigned(FPlayer) then
    Result := TPointF.Create(FPlayer.getVideoWidth, FPlayer.getVideoHeight)
  else
    Result := TPointF.Create(0, 0);
end;

function TAndroidMedia10.GetVolume: Single;
begin
  if Assigned(FPlayer) then
    Result := FVolume
  else
    Result := 0;
end;

procedure TAndroidMedia10.SeekToBegin;
begin
  FPlayer.seekTo(0);
end;

procedure TAndroidMedia10.SetCurrent(const Value: TMediaTime);
var
  NewPos : Integer;
begin
  if Assigned(FPlayer) then
  begin
    NewPos := Value;
    if NewPos < 0 then
      NewPos := 0;
    FPlayer.seekTo(NewPos);
  end;
end;

procedure TAndroidMedia10.SetVolume(const Value: Single);
begin
  FVolume := Value;

  if FVolume < 0 then
    FVolume := 0
  else if FVolume > 1 then
    FVolume := 1;

  if Assigned(FPlayer) then
    FPlayer.setVolume(FVolume, FVolume);
end;

procedure TAndroidMedia10.UpdateMediaFromControl;
begin
end;

procedure TAndroidMedia10.DoStop;
begin
  FPlayer.stop;
end;

procedure TAndroidMedia10.DoPlay;
begin
  FPlayer.start;
end;
end.
