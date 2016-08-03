unit Amazon.Response;

interface

uses Amazon.Interfaces;

type
  TAmazonResponse = class(TInterfacedObject, IAmazonResponse)
  private
    FResponseCode: Integer;
    FReponseText: UTF8String;
    FResponse: UTF8STring;
  protected
    procedure SetResponseCode(Value: Integer);
    procedure SetReponseText(Value: UTF8String);
    procedure SetReponse(Value: UTF8String);
    function GetResponseCode: Integer;
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
  FResponseCode := Value;
end;

procedure TAmazonResponse.SetReponseText(Value: UTF8String);
begin
  FReponseText := Value;
end;

procedure TAmazonResponse.SetReponse(Value: UTF8String);
begin
  FResponse := Value;
end;

function TAmazonResponse.GetResponseCode: integer;
begin
  Result := FResponseCode;
end;

function TAmazonResponse.GetReponseText: UTF8String;
begin
  Result := FReponseText;
end;

function TAmazonResponse.GetReponse: UTF8String;
begin
  Result := FResponse;
end;

end.
