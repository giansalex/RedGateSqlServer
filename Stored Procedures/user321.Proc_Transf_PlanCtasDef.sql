SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_PlanCtasDef]
@RucE nvarchar(11),
@Ejer varchar(4)
as

declare @Consulta varchar(4000)
set @Consulta='
declare @Ejer varchar(4)
declare @IGV varchar(15)
declare @ISC varchar(15)
declare @QCtg varchar(15)
declare @RCons varchar(15)
declare @Perc varchar(15)
declare @Det varchar(15)
declare @Ret varchar(15)
declare @LCm varchar(15)
declare @DC_MN varchar(15)
declare @DC_ME varchar(15)
declare @DP_MN varchar(15)
declare @DP_ME varchar(15)
declare @DCPer varchar(15)
declare @DCGan varchar(15)
declare @IN_DigCls varchar(1)

delete PlanCtasDef where RucE='''+@RucE+''' and Ejer='''+@Ejer+'''
insert into PlanCtasDef(RucE,Ejer,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls)
 SELECT RucE,'''+@Ejer+''' Ejer,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls 
	from OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
	''SELECT RucE,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls
	 from dbo.PlanCtasDef where RucE='''''+@RucE+''''' '')
'
print @Consulta
exec(@Consulta)
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
GO
