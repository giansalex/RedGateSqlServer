SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Gfm_TipCltCrea](
	@Cd_TClt char(3) output,
	@RucE nvarchar(11),
	@Descrip varchar(100),
	@Estado bit,
	@msj varchar(100) output
)
as
set @Cd_TClt = dbo.Cod_TpClt(@RucE)
insert into TipClt(Cd_TClt,RucE,Descrip,Estado)
values(@Cd_TClt,@RucE,@Descrip,@Estado)
if @@rowcount <= 0
	set @msj = 'Tipo de cliente no pudo ser registrado'
	
--JV 19/07/2011 <Se agrega RucE> 
GO
