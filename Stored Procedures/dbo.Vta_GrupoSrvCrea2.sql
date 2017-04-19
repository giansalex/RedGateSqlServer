SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvCrea2]
@RucE nvarchar(11),
@Cd_GS nvarchar(6),
@Descrip varchar(50),
@NCorto varchar(6),
--@Estado bit,
@UsuCrea nvarchar(10),
@Cd_Area nvarchar(6),
@msj varchar(100) output
as
if exists (select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)
	set @msj = 'Ya existe Grupo de servicio con el mismo codigo'
else
begin
	insert into GrupoSrv(RucE,Cd_GS,Descrip,NCorto,Estado)
	              values(@RucE,@Cd_GS,@Descrip,@NCorto,1)
	if @@rowcount <= 0
	   set @msj = 'Grupo Servicio no pudo ser registrado'

	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------	
	Declare @Cd_Tab nvarchar(3), @Descrip1 varchar(50), @Descrip2 varchar(50), @FecMov datetime
	Set @Cd_Tab = 'V03'
	Set @Descrip1 = @Cd_GS 
	Set @Descrip2 = @Descrip
	Set @FecMov = getdate()
	exec Gsp_GeneralRMCrea @RucE, @Cd_Tab, @Cd_Area, '01', @Descrip1, @Descrip2, @UsuCrea, @FecMov, @msj output
	-----------------------------------------------------------------------------------	
end
print @msj
--DI: 16/02/2009
GO
