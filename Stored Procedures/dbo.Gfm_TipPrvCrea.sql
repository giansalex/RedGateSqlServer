SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gfm_TipPrvCrea](
	@Cd_TPrv char(3) output,
	@RucE nvarchar(11),
	@Descrip varchar(100),
	@Estado bit,
	@msj varchar(100) output
)
AS
set @Cd_TPrv = dbo.Cod_TpProv(@RucE)
insert into TipProv(Cd_TPrv,RucE,Descrip,Estado)
values(@Cd_TPrv,@RucE,@Descrip,@Estado)
if @@rowcount <= 0
	set @msj = 'Tipo de proveedor no pudo ser registrado'
GO
