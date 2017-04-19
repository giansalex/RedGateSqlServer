SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_JalaPlanCtasDef_Crea2]
@RucE nvarchar(11),
@RucBase nvarchar(11),
@EjerBase varchar(4),
@Ejer varchar(4),
@msj varchar(100) output
as
			delete PlanCtasDef where RucE=@RucE and Ejer=@Ejer
			
			insert into PlanCtasDef(RucE,Ejer,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls,CtaClt,CtaPrv,Rejer)
				SELECT @RucE, @Ejer, IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls,CtaClt,CtaPrv,Rejer
				from dbo.PlanCtasDef where RucE=@RucBase and Ejer=@EjerBase
			if @@rowcount <= 0
				set @msj = 'No se pudo efectuar los cambios'	
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
--KJ 22/01/2013:<Se agregó las columnas CtaClt,CtaPrv>
GO
