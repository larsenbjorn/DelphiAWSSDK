unit Amazon.Environment;

interface

Uses System.SysUtils;

type
  TAmazonEnvironment = class
  protected
    fSecret_Key: UTF8String;
    fAccess_Key: UTF8String;
    fRegion: UTF8String;
  private
    function GetSecret_Key: UTF8String;
    procedure SetSecret_Key(Value: UTF8String);
    function GetAccess_Key: UTF8String;
    procedure SetAccess_Key(Value: UTF8String);
    function GetRegion: UTF8String;
    procedure SetRegion(Value: UTF8String);
  public
    property Region: UTF8String read GetRegion write setregion;
    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
  end;

implementation

function TAmazonEnvironment.GetAccess_Key: UTF8String;
begin
  Result := fAccess_Key;
end;

procedure TAmazonEnvironment.SetAccess_Key(Value: UTF8String);
begin
  fAccess_Key := Value;
end;

function TAmazonEnvironment.GetSecret_Key: UTF8String;
begin
  Result := fSecret_Key;
end;

procedure TAmazonEnvironment.SetSecret_Key(Value: UTF8String);
begin
  fSecret_Key := Value;
end;

function TAmazonEnvironment.GetRegion: UTF8String;
begin
  Result := fRegion;
end;

procedure TAmazonEnvironment.SetRegion(Value: UTF8String);
begin
  fRegion := Value;
end;

end.
