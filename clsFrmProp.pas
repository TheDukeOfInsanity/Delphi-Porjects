unit clsFrmProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, pngimage, math;

type
  TclsfrmProps = class
  private

  public
    Procedure frmFont(Form : TForm);
    Procedure LabelBorders(Selectedform : TForm);
    Procedure makeLarger(Sender: TObject);
    Procedure makeNormal(Sender: TObject);
    Procedure AdjustBorder(lblRedo : Tlabel);
    Procedure AddBorderLine(lnwidth:integer; sender:Timage; colour : Tcolor);
    Procedure FillBorder(fromLine:integer; sender:Timage; colour : Tcolor);
    procedure direcrionEnter(sender : tobject);
    procedure direcrionleave(sender : tobject);
    procedure highlightlabel(sender : tlabel);
  end;


implementation

uses
  Login;

Procedure TclsFrmProps.frmFont(Form: TForm);
begin
  //sets form's font's settings
  with (form as TFORM).Font do
    begin
      Name := 'Arial';
      Size := 14 - ceil((1920*1080) / (screen.Height * screen.Width) - 1);
      color := clBlack;
      charset := DEFAULT_CHARSET;
    end;
  (form as TFORM).Color := clwindow;
end;

Procedure TclsFrmProps.LabelBorders(Selectedform :Tform);
var
  imgbtnBack : tImage;
  a : integer;
begin
//Gives every label on a form a black border
  for a := 0 to (SelectedForm as TFOrm).ComponentCount-1 do
    if (SelectedForm as TFOrm).Components[a] is TLabel then
      if ((SelectedForm as Tform).Components[a] as tLabel).Parent = SelectedForm then
        begin
          imgbtnBack := Timage.Create(SelectedForm as TForm);
          imgbtnBack.Parent := (SelectedForm as TForm);

          ((SelectedForm as Tform).Components[a] as TLabel).OnMouseEnter := makelarger;
          ((SelectedForm as Tform).Components[a] as TLabel).OnMouseLeave:= MakeNormal;
          with imgbtnBack do
            begin
              onclick := ((SelectedForm as Tform).Components[a] as TLabel).OnClick;
              name := 'imglblBack_' + ((SelectedForm as Tform).Components[a] as TLabel).name;
              left := ((SelectedForm as Tform).Components[a] as TLabel).Left-2;
              top := ((SelectedForm as Tform).Components[a] as TLabel).Top-2;
              Width := ((SelectedForm as Tform).Components[a] as TLabel).Width+4;
              Height := ((SelectedForm as Tform).Components[a] as TLabel).Height+4;
              stretch := true;
              SendToBack;
              tag := ((SelectedForm as Tform).Components[a] as Tlabel).Tag;
              visible := ((SelectedForm as Tform).Components[a] as TLabel).Visible;

              addborderline(1,imgbtnback,clblack);
            end;
        end;
end;

procedure TclsFrmProps.makeLarger(Sender: TObject);
var
  form : Tform;
  a: Integer;
begin
//Makes labels larger when mouse hovers over
  form := ((Sender as Tlabel).owner) as TFORM;
  for a := 0 to form.ComponentCount - 1 do
    if form.Components[a].name = 'imglblBack_' + (Sender as TLabel).Name then
      begin
        (form.Components[a] as Timage).Left := (form.Components[a] as Timage).Left - 1;
        (form.Components[a] as Timage).top := (form.Components[a] as Timage).Top - 1;

        (form.Components[a] as Timage).width := (form.Components[a] as Timage).width +2;
        (form.Components[a] as Timage).Height := (form.Components[a] as Timage).Height +2;

        FillBorder(3,(form.Components[a] as Timage),clCream)
      end;
end;

procedure TclsFrmProps.makeNormal(Sender: TObject);
var
  form : Tform;
  a : integer;
begin
//Makes labels default size when mouse leaves label
  form := ((Sender as Tlabel).owner) as TFORM;
  for a := 0 to form.ComponentCount - 1 do
    if form.Components[a].name = 'imglblBack_' + (Sender as TLabel).Name then
      begin
        (form.Components[a] as Timage).Left := (form.Components[a] as Timage).Left + 1;
        (form.Components[a] as Timage).top := (form.Components[a] as Timage).Top + 1;

        (form.Components[a] as Timage).width := (form.Components[a] as Timage).width - 2;
        (form.Components[a] as Timage).Height := (form.Components[a] as Timage).Height - 2;

        FillBorder(1,(form.Components[a] as Timage),clWhite)
      end;
end;

Procedure TclsFrmProps.AdjustBorder(lblRedo : Tlabel);
var
  a : integer;
  form : Tform;
begin
  //moves border along with label
  form := ((lblRedo as Tlabel).owner) as TFORM;
  for a := 0 to form.ComponentCount - 1 do
    begin
      if form.Components[a].name = 'imglblBack_' + (lblRedo as TLabel).Name then
        with (form.Components[a] as Timage) do
          begin
            left := lblRedo.Left-2;
            top := lblRedo.Top-2;
            Width := lblRedo.Width+4;
            Height := lblRedo.Height+4;
            visible := lblRedo.Visible;

            picture := nil;
            AddBorderLine(1,(form.Components[a] as Timage),clblack)
          end;

      if form.Components[a].name = 'Dropdown_' + (lblRedo as TLabel).Name then
        begin
          (form.Components[a] as Timage).Top := lblRedo.Top-2;
          (form.Components[a] as Timage).Visible := lblRedo.Visible;
        end;
    end;
end;

Procedure TclsFrmProps.AddBorderLine(lnwidth:integer; sender: Timage; colour : Tcolor);
begin
  //adds border line to Timage
  with sender do
    begin
      picture := nil;
      Canvas.Pen.Color := colour;
      Canvas.Pen.Width := lnwidth;
      Canvas.Pen.Style := psSolid;

      Canvas.PenPos := Point(0,0);
      Canvas.LineTo(width,0);

      Canvas.PenPos := Point(0,0);
      Canvas.LineTo(0,height);

      Canvas.PenPos := Point(width-1,height);
      Canvas.LineTo(width-1,0);

      Canvas.PenPos := Point(width,height-1);
      Canvas.LineTo(0,height-1);
    end;
end;

Procedure TclsFrmProps.FillBorder(fromLine:integer; sender:Timage; colour : Tcolor);
var
  Rec : TRect;
begin
  //Fills and image with a colour
  Rec.Left:= fromLine;
  Rec.Top:= fromLine;
  Rec.Right:=  sender.width-fromLine;
  Rec.Bottom:= sender.Height-fromLine;


  sender.Canvas.Brush.Color:= colour;
  sender.Canvas.Brush.Style:= bsSolid;
  sender.Canvas.Pen.Style:= psClear;
  sender.Canvas.FillRect(Rec);
end;

Procedure TclsFrmProps.direcrionEnter(sender: TObject);
begin
  //when mouse goes over a label, the border size increases
  (sender as Timage).Left := (sender as Timage).Left - 1;
  (sender as Timage).top := (sender as Timage).Top - 1;

  (sender as Timage).width := (sender as Timage).width + 2;
  (sender as Timage).Height := (sender as Timage).Height + 2;
end;

Procedure TclsFrmProps.direcrionleave(sender: TObject);
begin
  //when mouse leaves a label, the border size decreases
  (sender as Timage).Left := (sender as Timage).Left + 1;
  (sender as Timage).top := (sender as Timage).Top + 1;

  (sender as Timage).width := (sender as Timage).width - 2;
  (sender as Timage).Height := (sender as Timage).Height - 2;
end;

Procedure TclsFrmProps.highlightlabel(sender: TLabel);
var
  imgHLlbl : timage;
begin
//Gives every label on a form a black border

  imgHLlbl := Timage.Create(sender.Owner as TForm);
  imgHLlbl.Parent := (sender.Owner as TForm);

  with imgHLlbl do
    begin
      name := 'imgHLlbl_' + (sender as TLabel).name;
      left := (sender as TLabel).Left-4;
      top := (sender as TLabel).Top-4;
      Width := (sender as TLabel).Width+8;
      Height := (sender as TLabel).Height+8;
      stretch := true;
      bringtofront;

      ((sender as TLabel).Parent.findcomponent((sender as TLabel).name) as tlabel).BringToFront;
    end;
   fillborder(0,imgHLlbl,clred);
end;
end.
