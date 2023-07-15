unit clsFeatures;

interface
uses
  clsfrmprop, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pngimage;

type
  TclsFeatures = class
  private
    colourchange : boolean;
  public
    procedure dropdownCreate(Sender : Tlabel);
    procedure dropdownclick(Sender : Timage);
    procedure VisibleToggle(Sender:Tlabel; Bopen : boolean);
    function GetToggle(Sender : Timage) : boolean;
    function GetToggleint(Sender : Timage) : Integer;
    procedure colourcode(form : tform);
    constructor colourvar(colour : boolean);
    function Openimage(Form : Tform): string;
  end;

var
  objClsFrmProp : TclsfrmProps;

implementation

uses
  DMGW,MainEditor, login;


function TclsFeatures.Openimage(Form : Tform): string;
var
  openDialog : topendialog;
  sFileExtension : string;
begin
//Opens dialog to get image location
  openDialog := TOpenDialog.Create(Form);
  openDialog.InitialDir := 'Desktop';
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'Image Files|*.jpeg;*.png;*.bmp;*.ico;*.gif;*.jpg;';
  if openDialog.Execute then
    begin
      Result := openDialog.FileName;
      sFileExtension := ExtractFileExt(Result);
      Delete(sFileExtension,1,1);
    end;
//Tests if image is valid
    if Result <> '' then
      begin
        sFileExtension := lowercase(sFileExtension);;
        if (sFileExtension = 'jpeg') OR (sFileExtension = 'png') OR (sFileExtension = 'ico') OR (sFileExtension = 'bmp') OR (sFileExtension = 'gif') OR (sFileExtension = 'jpg') then
          else
            begin
              Result := 'Not';
              with CreateMessageDialog('Please select a image file',mtError,[mbYes,MbNo]) do
                try
                  TButton(FindComponent('Yes')).Caption := 'Ok';
                  TButton(FindComponent('No')).Caption := 'New file';
                  ShowModal;
                  if ModalResult = mrYes then
                    exit;
                  if ModalResult = mrNo then
                    Openimage(Form);
                finally
                  Free;
                end;
            end;
      openDialog.Free;
      end
    else
      Result := 'Not';
end;

constructor TclsFeatures.colourvar(colour: Boolean);
begin
  //sets colourcode variable
  colourchange := colour;
end;

procedure TclsFeatures.colourcode(form : tform);
var
  a: Integer;
const
  arrcolour : array[-1..10] of Tcolor = (clLime,clBlack,clRed,clblue,clOlive,clPurple,clActivecaption,claqua,clmaroon,clMoneyGreen,clgreen,clFuchsia);
begin
  //colourcodes a form's buttons
  colourchange := frmmain.bcolour;
  for a := 0 to form.ComponentCount - 1 do
    if form.Components[a] is Tlabel then
      if colourchange = true then
        objClsFrmProp.AddBorderLine(1,form.FindComponent('imglblBack_' + form.Components[a].Name) as TImage,arrcolour[form.Components[a].Tag])
      else
        objClsFrmProp.AddBorderLine(1,form.FindComponent('imglblBack_' + form.Components[a].Name) as TImage,arrcolour[0]);
end;

procedure TclsFeatures.dropdownclick(Sender: Timage);
begin
  //sets object to open or closed state
  colourcode(sender.Owner as TFOrm);
  if sender.Tag = 0 then
    begin
      sender.Picture.Assign(frmdm.m_minus);
      sender.Tag := 1;
    end
  else
    begin
      sender.Picture.Assign(frmdm.m_plus);
      sender.Tag := 0;
    end;
end;

procedure TclsFeatures.dropdownCreate(Sender: TLabel);
var
  a : integer;
  dropdown : Timage;
begin
  //creates a dropdown button
  dropdown := Timage.Create(Sender.Owner);
  dropdown.Parent := Sender.Parent;
  with dropdown do
    begin
      onclick :=sender.OnClick;
      name := 'Dropdown_' + sender.name;
      left := sender.Left - 35;
      top := sender.Top -2;
      Width := sender.Height + 4;
      Height := width;
      stretch := true;
      SendToBack;
      tag := 0;
      visible := sender.Visible;

      picture.Assign(frmdm.m_plus);
    end;
end;

procedure TclsFeatures.VisibleToggle(Sender: Tlabel; Bopen: Boolean);
begin
  //sets label to be visable or invisable, as well as it's border
  Sender.Visible := bOpen;
  objfrmprop.AdjustBorder(Sender);
end;

Function TclsFeatures.GetToggle(Sender : Timage) : boolean;
begin
  //tests if section opens or closes
  if Sender.Tag = 0 then
    Result := true
  else
    Result := false;
end;

function TclsFeatures.GetToggleint(Sender : Timage) : Integer;
begin
  //tests if section opens or closes
  if Sender.Tag = 0 then
    Result := 1
  else
    Result := -1;

end;
end.
