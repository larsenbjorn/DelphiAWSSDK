unit AWS.DymoDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmDymoDB = class(TForm)
    meResponse: TMemo;
    btnTest: TButton;
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDymoDB: TfrmDymoDB;

implementation

uses
  Amazon.DynamoDB;

{$R *.dfm}

procedure TfrmDymoDB.btnTestClick(Sender: TObject);
var
  DymoDB: TAmazonDynamoDBClient;
  TableRequest: TCreateTableRequest;
  Response: TAmazonDynamoDBResponse;
begin
  DymoDB := TAmazonDynamoDBClient.Create;

  DymoDB.Access_Key := '';
  DymoDB.Secret_Key := '';
  DymoDB.EndPoint := 'https://dynamodb.eu-west-1.amazonaws.com/';

  TableRequest := TCreateTableRequest.Create;
  TableRequest.Tablename := 'TestTable';
  TableRequest.AttributeDefinitions.Add(TAttributeDefinition.Create('Id', 'S'));
  TableRequest.KeySchema.Add(TKeySchemaElement.Create('Id', 'HASH'));
  with TableRequest.ProvisionedThroughput do
  begin
    ReadCapacityUnits := 5;
    WriteCapacityUnits := 5;
  end;

  Response := DymoDB.CreateTable(TableRequest);
  meResponse.Lines.Add(Response.Response);
end;

end.
