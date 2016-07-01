unit Amazon.Request;

interface

Uses Amazon.Interfaces;

type
  TAmazonRequest = class(TInterfacedObject, IAmazonRequest)
  private
    fAuthorization_Header: UTF8String;
    fAWS_Date: UTF8String;
    fDate_Stamp: UTF8String;
    fSecret_Key: UTF8String;
    fAccess_Key: UTF8String;
    fService: UTF8String;
    fEndPoint: UTF8String;
    fTargetPrefix: UTF8String;
    fRegion: UTF8String;
    fRequest_Parameters: UTF8String;
    fHost: UTF8String;
    fOperationName: UTF8String;
  protected
    function GetSecret_Key: UTF8String;
    procedure SetSecret_Key(Value: UTF8String);
    function GetAccess_Key: UTF8String;
    procedure SetAccess_Key(Value: UTF8String);
    function GetRegion: UTF8String;
    procedure SetRegion(Value: UTF8String);
    function GetEndPoint: UTF8String;
    procedure SetEndPoint(Value: UTF8String);
    function GetService: UTF8String;
    procedure SetService(Value: UTF8String);
    function GetHost: UTF8String;
    procedure SetHost(Value: UTF8String);
    function GetTarget: UTF8String;
    function GetTargetPrefix: UTF8String;
    procedure SetTargetPrefix(Value: UTF8String);
    function GetRequest_Parameters: UTF8String;
    procedure SetRequest_Parameters(Value: UTF8String);
    function GetAWS_Date: UTF8String;
    procedure SetAWS_Date(Value: UTF8String);
    function GetDate_Stamp: UTF8String;
    procedure SetDate_Stamp(Value: UTF8String);
    function GetOperationName: UTF8String;
    procedure SetOperationName(Value: UTF8String);
    function GetAuthorization_Header: UTF8String;
    procedure SetAuthorization_Header(Value: UTF8String);
  public
    property Secret_Key: UTF8String read GetSecret_Key write SetSecret_Key;
    property Access_Key: UTF8String read GetAccess_Key write SetAccess_Key;
    property TargetPrefix: UTF8String read GetTargetPrefix write SetTargetPrefix;
    property OperationName: UTF8String read GetOperationName write SetOperationName;
    property Service: UTF8String read GetService write SetService;
    property EndPoint: UTF8String read getendpoint write setendpoint;
    property Host: UTF8String read GetHost write SetHost;
    property Region: UTF8String read getregion write setregion;
    property Request_Parameters: UTF8String read GetRequest_Parameters write SetRequest_Parameters;
    property AWS_Date: UTF8String read GetAWS_Date write SetAWS_Date;
    property Date_Stamp: UTF8String read GetDate_Stamp write SetDate_Stamp;
    property Authorization_Header: UTF8String read GetAuthorization_Header write SetAuthorization_Header;
    property Target: UTF8String read GetTarget;
  end;

implementation

function TAmazonRequest.getsecret_key: UTF8String;
begin
  Result := fSecret_Key;
end;

procedure TAmazonRequest.setsecret_key(Value: UTF8String);
begin
  fSecret_Key := Value;
end;

function TAmazonRequest.GetRequest_Parameters: UTF8String;
begin
  Result := fRequest_Parameters;
end;

procedure TAmazonRequest.SetRequest_Parameters(Value: UTF8String);
begin
  fRequest_Parameters := Value;
end;

function TAmazonRequest.getaccess_key: UTF8String;
begin
  Result := fAccess_Key;
end;

procedure TAmazonRequest.setaccess_key(Value: UTF8String);
begin
  fAccess_Key := Value;
end;

function TAmazonRequest.GetTargetPrefix: UTF8String;
begin
  Result := fTargetPrefix;
end;

procedure TAmazonRequest.SetTargetPrefix(Value: UTF8String);
begin
  fTargetPrefix := Value;
end;

function TAmazonRequest.getservice: UTF8String;
begin
  Result := fService;
end;

procedure TAmazonRequest.setservice(Value: UTF8String);
begin
  fService := Value;
end;

function TAmazonRequest.getregion: UTF8String;
begin
  Result := fRegion;
end;

procedure TAmazonRequest.setregion(Value: UTF8String);
begin
  fRegion := Value;
end;

function TAmazonRequest.gethost: UTF8String;
begin
  Result := fHost;
end;

procedure TAmazonRequest.sethost(Value: UTF8String);
begin
  fHost := Value;
end;

function TAmazonRequest.getendpoint: UTF8String;
begin
  Result := fEndPoint;
end;

procedure TAmazonRequest.setendpoint(Value: UTF8String);
begin
  fEndPoint := Value;
end;

function TAmazonRequest.GetAWS_Date: UTF8String;
begin
  Result := fAWS_Date;
end;

procedure TAmazonRequest.SetAWS_Date(Value: UTF8String);
begin
  fAWS_Date := Value;
end;

function TAmazonRequest.GetDate_Stamp: UTF8String;
begin
  Result := fDate_Stamp;
end;

procedure TAmazonRequest.SetDate_Stamp(Value: UTF8String);
begin
  fDate_Stamp := Value;
end;

function TAmazonRequest.GetOperationName: UTF8String;
begin
  Result := fOperationName;
end;

procedure TAmazonRequest.SetOperationName(Value: UTF8String);
begin
  fOperationName := Value;
end;

procedure TAmazonRequest.SetAuthorization_Header(Value: UTF8String);
begin
  fAuthorization_Header := Value;
end;

function TAmazonRequest.GetAuthorization_Header;
begin
  Result := fAuthorization_Header;
end;

function TAmazonRequest.GetTarget: UTF8String;
begin
  Result := TargetPrefix + '.' + OperationName;
end;

end.
