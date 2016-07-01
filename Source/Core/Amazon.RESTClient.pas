unit Amazon.RESTClient;

interface

uses IdSSLOpenSSL, IPPeerAPI, IdHttp, classes, SysUtils, IdStack, IdGlobal,
  IPPeerClient, Amazon.Interfaces;

type
  TAmazonRESTClient = class(TInterfacedObject, IAmazonRESTClient)
  private
    fContent_Type: string;
    fErrorCode: Integer;
    fErrorMessage: String;
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
  fContent_Type := '';
  fErrorCode := 0;
  fErrorMessage := '';

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
      fErrorCode := E.ErrorCode;
      fErrorMessage := E.ErrorMessage;
      if Trim(aResponse) = '' then
        aResponse := fErrorMessage;
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
  Result := fContent_Type;
end;

function TAmazonRESTClient.GetErrorCode: Integer;
begin
  Result := fErrorCode;
end;

procedure TAmazonRESTClient.SetContent_Type(Value: string);
begin
  fContent_Type := Value;
end;

function TAmazonRESTClient.GetErrorMessage: String;
begin
  Result := fErrorMessage;
end;

end.
