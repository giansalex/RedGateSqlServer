SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NumeracionMdf]
@RucE nvarchar(11),
@Cd_Num nvarchar(7),
@Cd_Sr nvarchar(4),
@Desde int,
@Hasta int,
@NroAutSunat varchar(20),
@msj varchar(100) output
as
if not exists (select * from Numeracion where RucE=@RucE and Cd_Num=@Cd_Num)
	set @msj = 'Numeracion no existe'
else
begin
	update Numeracion set Cd_Sr=@Cd_Sr, Desde=@Desde, Hasta=@Hasta, NroAutSunat=@NroAutSunat
	where RucE=@RucE and Cd_Num=@Cd_Num
	if @@rowcount <= 0
	   set @msj = 'Numeracion no pudo ser modificado'
end
print @msj
GO
