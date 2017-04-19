SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_NumeracionCrea]
@RucE nvarchar(11),
--@Cd_Num nvarchar(7),
@Cd_Sr nvarchar(4),
@Desde int,
@Hasta int,
@NroAutSunat varchar(20),
@msj varchar(100) output
as
if exists (select * from Numeracion where RucE=@RucE and NroAutSunat=@NroAutSunat)
	set @msj = 'Ya existe enumeracion con la misma autorizacion'
else
begin
	insert into Numeracion(RucE,Cd_Num,Cd_Sr,Desde,Hasta,NroAutSunat) 
		        values(@RucE,user123.Cod_Num(@RucE),@Cd_Sr,@Desde,@Hasta,@NroAutSunat)

	if @@rowcount <= 0
	   set @msj = 'Numeracion no pudo ser registrado'
end
print @msj
GO
