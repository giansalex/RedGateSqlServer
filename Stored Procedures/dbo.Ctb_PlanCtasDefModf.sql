SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasDefModf]
@RucE nvarchar(11),
@Ejer varchar(4),
@IGV nvarchar(10),
@ISC nvarchar(10),
@QCtg nvarchar(10),
@RCons nvarchar(10),
@Perc nvarchar(10),
@Det nvarchar(10),
@Ret nvarchar(10),
@LCm nvarchar(10),
@DC_MN nvarchar(10),
@DC_ME nvarchar(10),
@DP_MN nvarchar(10),
@DP_ME nvarchar(10),
@DCPer nvarchar(10),
@DCGan nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from Empresa where Ruc=@RucE)
	set @msj = 'Empresa no existe no se puede modificar la definicion plan de cuentas'
else
begin
	update PlanCtasDef set IGV=@IGV, ISC=@ISC, QCtg=@QCtg, RCons=@RCons, Perc=@Perc, Det=@Det,
			       Ret=@Ret, LCm=@LCm, DC_MN=@DC_MN, DC_ME=@DC_ME, DP_MN=@DP_MN, 
			       DP_ME=@DP_ME, DCPer=@DCPer, DCGan=@DCGan
	where  RucE=@RucE and Ejer=@Ejer
	
	if @@rowcount <= 0 
		set @msj = 'No se pudo modificar informacion'
end
print @msj
GO
