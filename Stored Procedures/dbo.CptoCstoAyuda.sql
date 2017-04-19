SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CptoCstoAyuda]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
if not exists (select * from CptoCosto where RucE=@RucE )
	set @msj = 'No existe Conceptos'
else	
begin
if (@TipCons =3)
	begin
		select Cd_Cos,Cd_Cos,Descrip from CptoCosto where RucE=@RucE and Estado=1
	end
end
print @msj
GO
