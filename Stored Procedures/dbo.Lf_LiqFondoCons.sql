SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoCons]
@RucE nvarchar(11),
@Cd_Liq char(10),
@RegCtb nvarchar(15),
@msj varchar(100) output
as
	if not exists (select * from Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq)
	set @msj = 'Liquidacion de Fondo no existe.'
else	
	select lq.RucE,Cd_Liq,RegCtb,FechaAper,FecCierre,UsuAper,FecAper,UsuCierre,FecCierre,ae.Cd_Area,ae.Descrip,
			cc.Cd_CC,cc.Descrip,cs.Cd_SC,cs.Descrip,ss.Cd_SS,ss.Descrip,Cd_MIS,Cd_Mda,CamMda,MtoAnt,MtoAsig,MtoAper,MtoCierre,
			MtoAnt_ME,MtoAsig_ME,MtoAper_ME,MtoCierre_ME,lq.CA01,lq.CA02,lq.CA03,lq.CA04,lq.CA05,
			lq.CA06,lq.CA07,lq.CA08,lq.CA09,lq.CA10
	 from Liquidacion lq 
	 inner join CCostos cc on cc.RucE=lq.RucE and cc.Cd_CC = lq.Cd_CC
	 inner join CCSub cs on cs.RucE = lq.RucE and cs.Cd_CC = lq.Cd_CC and cs.Cd_SC = lq.Cd_SC
	 inner join CCSubSub ss on ss.RucE = lq.RucE and ss.Cd_CC = lq.Cd_CC and ss.Cd_SC = lq.Cd_SC and ss.Cd_SS = lq.Cd_SS
	 inner join Area ae on ae.RucE = lq.RucE and ae.Cd_Area = lq.Cd_Area
	 where lq.RucE = '11111111111'
	 
print @msj
--Leyenda
--BG : 28/02/2013 <se creo el SP--(°)> >}
--bg : 01/03/2013 <se agrego 2 campos mas Cd_Mda y CamMda>
GO
