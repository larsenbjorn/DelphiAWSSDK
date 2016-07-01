unit Amazon.Response;

interface

Uses Amazon.Interfaces;

type
  TAmazonResponse = class(TInterfacedObject, IAmazonResponse)
  private
    fResponseCode: Integer;
    fReponseText: UTF8String;
    fResponse: UTF8STring;
  protected
    procedure SetResponseCode(Value: integer);
    procedure SetReponseText(Value: UTF8String);
    procedure SetReponse(Value: UTF8String);
    function GetResponseCode: integer;
    function GetReponseText: UTF8String;
    function GetReponse: UTF8String;
  public
    property ResponseText: UTF8String read GetReponseText write SetReponseText;
    property ResponseCode: Integer read GetResponseCode write SetResponseCode;
    property Response: UTF8String read GetReponse write SetReponse;
  end;

implementation

procedure TAmazonResponse.SetResponseCode(Value: integer);
begin
  fResponseCode := Value;
end;

procedure TAmazonResponse.SetReponseText(Value: UTF8String);
begin
  fReponseText := Value;
end;

procedure TAmazonResponse.SetReponse(Value: UTF8String);
begin
  fResponse := Value;
end;

function TAmazonResponse.GetResponseCode: integer;
begin
  Result := fResponseCode;
end;

function TAmazonResponse.GetReponseText: UTF8String;
begin
  Result := fReponseText;
end;

function TAmazonResponse.GetReponse: UTF8String;
begin
  Result := fResponse;
end;

end.
