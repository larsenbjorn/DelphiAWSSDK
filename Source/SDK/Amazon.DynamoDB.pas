unit Amazon.DynamoDB;

interface

uses Amazon.Client, Amazon.Request, System.Classes, System.Generics.Collections,
    Amazon.Response, Amazon.Utils, Amazon.Marshaller, System.Rtti, System.TypInfo,
    Amazon.Interfaces, System.AnsiStrings, System.SysUtils;

Const
  cDynamoDB_targetPrefix = 'DynamoDB_20120810';
  cDynamoDB_service = 'dynamodb';

type
   TAmazonDynamoDBRequest = class(TAmazonRequest)
   public
     constructor Create; virtual;
   end;

   TAmazonDynamoDBMarshaller = class(TAmazonMarshaller)
   public
     function AmazonDynamoDBRequestToJSON(aAmazonDynamoDBRequest: TAmazonDynamoDBRequest): UTF8String;
   end;

   TAmazonDynamoDBResponse  = class(TAmazonResponse)
   public
     constructor Create(aAmazonResponse: IAmazonResponse);
   end;

   TAmazonDynamoDBClient = class(TAmazonClient)
   public
     //procedure InitClient(aSecret_Key: UTF8String; aAccess_Key: UTF8String); override;
     [TAmazonMarshallerAttribute('CreateTable')]
     function CreateTable(aAmazonDynamoDBRequest: TAmazonDynamoDBRequest): TAmazonDynamoDBResponse;
   end;

   [TAmazonMarshallerAttribute('ProvisionedThroughput')]
   TProvisionedThroughput = class(TObject)
   protected
   private
     fReadCapacityUnits: Integer;
     fWriteCapacityUnits: Integer;
   public
   published
     [TAmazonMarshallerAttribute('ReadCapacityUnits')]
     property ReadCapacityUnits: Integer read fReadCapacityUnits write fReadCapacityUnits;
     [TAmazonMarshallerAttribute('WriteCapacityUnits')]
     property WriteCapacityUnits: Integer read fWriteCapacityUnits write fWriteCapacityUnits;
   end;

   [TAmazonMarshallerAttribute('KeySchemaElement')]
   TKeySchemaElement = class(TObject)
   protected
   private
     fAttributeName: UTF8String;
     fKeyType: UTF8String;
   public
     constructor Create(aAttributeName: UTF8String = ''; aKeyType: UTF8String = '');
   published
     [TAmazonMarshallerAttribute('AttributeName')]
     property AttributeName: UTF8String read fAttributeName write fAttributeName;
     [TAmazonMarshallerAttribute('KeyType')]
     property KeyType: UTF8String read fKeyType write fKeyType;
   end;

   [TAmazonMarshallerAttribute('AttributeDefinition')]
   TAttributeDefinition = class(TObject)
   protected
   private
     fAttributeName: UTF8String;
     fAttributeType: UTF8String;
   public
     constructor Create(aAttributeName: UTF8String = ''; aAttributeType: UTF8String = '');
   published
     [TAmazonMarshallerAttribute('AttributeName')]
     property AttributeName: UTF8String read fAttributeName write fAttributeName;
     [TAmazonMarshallerAttribute('AttributeType')]
     property AttributeType: UTF8String read fAttributeType write fAttributeType;
   end;

   TCreateTableRequest = class(TAmazonDynamoDBRequest)
   protected
   private
     fTableName: UTF8String;
     fAttributeDefinitions: TList<TAttributeDefinition>;
     fKeySchema: TList<TKeySchemaElement>;
     fProvisionedThroughput: TProvisionedThroughput;
   public
     constructor Create; override;
     destructor Destory;
   published
     [TAmazonMarshallerAttribute('TableName')]
     property TableName: UTF8String read fTableName write fTableName;
     [TAmazonMarshallerAttribute('AttributeDefinitions')]
     property AttributeDefinitions: TList<TAttributeDefinition>  read fAttributeDefinitions write fAttributeDefinitions;
     [TAmazonMarshallerAttribute('KeySchema')]
     property KeySchema: TList<TKeySchemaElement> read fKeySchema write fKeySchema;
     [TAmazonMarshallerAttribute('ProvisionedThroughput')]
     property ProvisionedThroughput: TProvisionedThroughput read fProvisionedThroughput write fProvisionedThroughput;
   end;



implementation

constructor TAmazonDynamoDBRequest.Create;
begin
  TargetPrefix := cDynamoDB_targetPrefix;
end;

constructor TKeySchemaElement.Create(aAttributeName: UTF8String = ''; aKeyType: UTF8String = '');
begin
  fAttributeName := aAttributeName;
  fKeyType := aKeyType;
end;

constructor TAttributeDefinition.Create(aAttributeName: UTF8String = ''; aAttributeType: UTF8String = '');
begin
  fAttributeName := aAttributeName;
  fAttributeType := aAttributeType;
end;

constructor TCreateTableRequest.Create;
begin
  inherited;
  FAttributeDefinitions := TList<TAttributeDefinition>.Create;
  FKeySchema := TList<TKeySchemaElement>.Create;
  ProvisionedThroughput:= TProvisionedThroughput.Create;
end;

destructor TCreateTableRequest.Destory;
begin
  FProvisionedThroughput.Free;
  FKeySchema.Free;
  FAttributeDefinitions.Free;
end;

//procedure TAmazonDynamoDBClient.InitClient(aSecret_Key: UTF8String; aAccess_Key: UTF8String);
//begin
//  inherited InitClient(aSecret_Key, aAccess_Key);
//  Service := cDynamoDB_Service;
//end;

function TAmazonDynamoDBClient.CreateTable(aAmazonDynamoDBRequest: TAmazonDynamoDBRequest): TAmazonDynamoDBResponse;
var
  FAmazonDynamoDBMarshaller: TAmazonDynamoDBMarshaller;
  FAmazonResponse: IAmazonResponse;
begin
  try
    aAmazonDynamoDBRequest.OperationName := 'CreateTable';
    FAmazonDynamoDBMarshaller:= TAmazonDynamoDBMarshaller.Create;
    aAmazonDynamoDBRequest.Request_Parameters :=
      FAmazonDynamoDBMarshaller.AmazonDynamoDBRequestToJSON(aAmazonDynamoDBRequest);
    FAmazonResponse := MakeRequest(aAmazonDynamoDBRequest);
    Result := TAmazonDynamoDBResponse.Create(FAmazonResponse);
  finally
    FAmazonDynamoDBMarshaller := NIL;
    FAmazonResponse := NIl;
  end;
end;

function TAmazonDynamoDBMarshaller.AmazonDynamoDBRequestToJSON(aAmazonDynamoDBRequest: TAmazonDynamoDBRequest): UTF8String;
var
  CTX: TRttiContext;
  JSON: TStringList;
begin
  try
    CTX := TRttiContext.Create;
    JSON := TStringlist.Create;

    GetSubRttiAttributekeys(JSON, '', CTX, aAmazonDynamoDBRequest);
    Result := '{' + StringReplace(JSON.Text, #13#10, '', [rfReplaceAll]) + '}';
  finally
    JSON.Free;
    CTX.Free;
  end;
end;

constructor TAmazonDynamoDBResponse.Create(aAmazonResponse: IAmazonResponse);
begin
  ResponseText := aAmazonResponse.ResponseText;
  ResponseCode := aAmazonResponse.ResponseCode;
  Response := aAmazonResponse.Response;
end;

end.
