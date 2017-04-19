SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionMdf]
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
--@FecReg datetime,
--@FecMdf datetime,
--@UsuCrea nvarchar(10),
@UsuMdf nvarchar(10),
--@Estado bit,
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
@msj varchar(100) output
as

if not exists (select * from GuiaRemision where NroSre= @NroSre and NroGr = @NroGr)
	print 'Guia Remision no existe'
else
	update GuiaRemision set NroSre=@NroSre, NroGR=@NroGR, FecEmi=@FecEmi, FecIniTras=@FecIniTras, FecFinTras=@FecFinTras, PtoPartida=@PtoPartida, Cd_TO=@Cd_TO, 
		Cd_Tra=@Cd_Tra, DescripTra=@DescripTra, PesoTotalKg=@PesoTotalKg, AutorizadoPor=@AutorizadoPor, Obs=@Obs, Cd_Area=@Cd_Area, FecMdf=getdate(), UsuMdf=@UsuMdf, 
		CA01=@CA01, CA02=@CA02, CA03=@CA03, CA04=@CA04, CA05=@CA05, CA06=@CA06, CA07=@CA07, CA08=@CA08, CA09=@CA09, CA10=@CA10
		where RucE=@RucE and Cd_GR=@Cd_GR
print @msj
-- Leyenda --
-- PP : 2010-05-07 11:47:45.063	: <Creacion del procedimiento almacenado>

GO
