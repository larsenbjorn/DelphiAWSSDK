program DemoDymoDB;

uses
  Vcl.Forms,
  AWS.DymoDB in 'AWS.DymoDB.pas' {frmDymoDB};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDymoDB, frmDymoDB);
  Application.Run;
end.
