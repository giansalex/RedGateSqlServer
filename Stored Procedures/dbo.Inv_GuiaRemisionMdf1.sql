SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionMdf1]
@RucE nvarchar(11),
@Cd_GR char(10),
@NroSre varchar(5),
@NroGR varchar(15),
@FecEmi smalldatetime,
@FecIniTras smalldatetime,
@FecFinTras smalldatetime,
@PtoPartida varchar(100),
@Cd_TO char(2),
@Cd_Tra char(7),
@DescripTra varchar(200),
@PesoTotalKg numeric(18,3),
@AutorizadoPor varchar (100),
@Obs varchar (200),
@Cd_Area nvarchar(6),
@UsuMdf nvarchar(10),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(100),
@CA10 varchar(100),
@Cd_TD nvarchar(2),
@IC_ES char(1),
@Cd_Clt char(10),
@Cd_Prv char(7),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@msj varchar(100) output
as

if not exists (select * from GuiaRemision where NroSre= @NroSre and NroGr = @NroGr)
	print 'GuÃ­a de RemisiÃ³n no existe'
else
	update GuiaRemision set NroSre=@NroSre, NroGR=@NroGR, FecEmi=@FecEmi, FecIniTras=@FecIniTras, FecFinTras=@FecFinTras, PtoPartida=@PtoPartida, Cd_TO=@Cd_TO, 
		Cd_Tra=@Cd_Tra, DescripTra=@DescripTra, PesoTotalKg=@PesoTotalKg, AutorizadoPor=@AutorizadoPor, Obs=@Obs, Cd_Area=@Cd_Area, FecMdf=getdate(), UsuMdf=@UsuMdf, 
		CA01=@CA01, CA02=@CA02, CA03=@CA03, CA04=@CA04, CA05=@CA05, CA06=@CA06, CA07=@CA07, CA08=@CA08, CA09=@CA09, CA10=@CA10,IC_ES=@IC_ES,
		Cd_TD=@Cd_TD, Cd_Clt=@Cd_Clt,Cd_Prv=@Cd_Prv, Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS
		where RucE=@RucE and Cd_GR=@Cd_GR
print @msj
-- Leyenda --
-- FL : 2010-09-06	: <Creacion del procedimiento almacenado con nuevo campo>
-- FL : 2010-10-06	: <Modificacion del procedimiento almacenado porque se removio cd_clt y cd_prv de la tabla>
-- FL : 2010-11-10	: <Modificacion del procedimiento almacenado porque se agrego cd_clt y cd_prv de la tabla>
--CAM : 2010-12-22	: <Correcion de Faltas Ortograficas>
-- FL : 2011-02-15	: <se agregaron los campos de centro de costos>


GO
