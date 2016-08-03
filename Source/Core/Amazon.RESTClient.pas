unit Amazon.RESTClient;

interface

uses IdSSLOpenSSL, IPPeerAPI, IdHttp, classes, SysUtils, IdStack, IdGlobal,
  IPPeerClient, Amazon.Interfaces;

type
  TAmazonRESTClient = class(TInterfacedObject, IAmazonRESTClient)
  private
    FContent_Type: string;
    FErrorCode: Integer;
    FErrorMessage: String;
  protected
    FIdHttp: IIPHTTP;
    function GetResponseCode: Integer;
    function GetResponseText: String;
    function GetContent_Type: String;
    function GetErrorCode: Integer;
    procedure SetContent_Type(Value: string);
    function GetErrorMessage: String;
  public
    constructor Create;
    destructor Destory;
    procedure AddHeader(aName, aValue: UTF8String);
    procedure Post(aUrl: string; aRequest: UTF8String; var aResponse: UTF8String);
    property ResponseCode: Integer read GetResponseCode;
    property ResponseText: string read GetResponseText;
    property Content_Type: String read GetContent_Type write SetContent_Type;
    property ErrorCode: Integer read GetErrorCode;
    property ErrorMessage: String read GetErrorMessage;
  end;

implementation

constructor TAmazonRESTClient.Create;
begin
  FContent_Type := '';
  FErrorCode := 0;
  FErrorMessage := '';

  FIdHttp := PeerFactory.CreatePeer('', IIPHTTP, nil) as IIPHTTP;
  FIdHttp.IOHandler := PeerFactory.CreatePeer('', IIPSSLIOHandlerSocketOpenSSL,
    nil) as IIPSSLIOHandlerSocketOpenSSL;

  FIdHttp.Request.CustomHeaders.FoldLines := false;
end;

destructor TAmazonRESTClient.Destory;
begin
  FreeandNil(FIdHttp);
end;

procedure TAmazonRESTClient.AddHeader(aName, aValue: UTF8String);
begin
  FIdHttp.Request.CustomHeaders.AddValue(aName, aValue);
end;

procedure TAmazonRESTClient.Post(aUrl: string; aRequest: UTF8String;
  var aResponse: UTF8String);
Var
  FSource, FResponseContent: TStringStream;
begin
  try
    FSource := TStringStream.Create(aRequest);
    FSource.Position := 0;
    FResponseContent := TStringStream.Create;

    FIdHttp.Request.ContentType := Content_Type;
    FIdHttp.DoPost(aUrl, FSource, FResponseContent);
    aResponse := FResponseContent.DataString;

    FResponseContent.Free;
    FSource.Free;
  except
    on E: EIPHTTPProtocolExceptionPeer do
    begin
      FErrorCode := E.ErrorCode;
      FErrorMessage := E.ErrorMessage;
      if Trim(aResponse) = '' then
        aResponse := FErrorMessage;
      FIdHttp.Disconnect;
    end;
  end;
end;

function TAmazonRESTClient.GetResponseCode: Integer;
begin
  Result := FIdHttp.ResponseCode;
end;

function TAmazonRESTClient.GetResponseText: String;
begin
  Result := FIdHttp.ResponseText;
end;

function TAmazonRESTClient.GetContent_Type: string;
begin
  Result := FContent_Type;
end;

function TAmazonRESTClient.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

procedure TAmazonRESTClient.SetContent_Type(Value: string);
begin
  FContent_Type := Value;
end;

function TAmazonRESTClient.GetErrorMessage: String;
begin
  Result := FErrorMessage;
end;

end.
