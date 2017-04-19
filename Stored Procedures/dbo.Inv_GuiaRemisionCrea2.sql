SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionCrea2]
@RucE nvarchar(11),
@Cd_GR char(10) output,
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
@UsuCrea nvarchar(10),
--@UsuMdf nvarchar(10),
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
@Cd_TD nvarchar(2),
@IC_ES char(1),
@Cd_Clt char(10),
@Cd_Prv char(7),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@IB_Anulado bit,
@msj varchar(100) output
as

if exists (select * from GuiaRemision where RucE = @RucE and Cd_TD=@Cd_TD and NroSre= @NroSre and NroGr = @NroGr)
	set @msj = 'Ya existe numero de Guia Remision'
else
	begin
		set @Cd_GR = user123.Cd_GR(@RucE)
		insert into GuiaRemision(Cd_TD,RucE,Cd_GR,NroSre,NroGR,FecEmi,FecIniTras,FecFinTras,PtoPartida,Cd_TO,Cd_Tra,DescripTra,PesoTotalKg,AutorizadoPor,Obs,Cd_Area,FecReg,FecMdf,UsuCrea,UsuMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IC_ES,Cd_Clt,Cd_Prv,Cd_CC,Cd_SC,Cd_SS,IB_Anulado)
			values(@Cd_TD,@RucE,@Cd_GR,@NroSre,@NroGR,@FecEmi,@FecIniTras,@FecFinTras,@PtoPartida,@Cd_TO,@Cd_Tra,@DescripTra,@PesoTotalKg,@AutorizadoPor,@Obs,@Cd_Area,getdate(),null,@UsuCrea,null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IC_ES,@Cd_Clt,@Cd_Prv,@Cd_CC,@Cd_SC,@Cd_SS,@IB_Anulado)
		if @@rowcount <= 0
			set @msj = 'Guia Remision no pudo ser registrado'	
	end
print @msj
-- Leyenda --
-- FL : 2010-09-07 : <Creacion del procedimiento almacenado con nuevos campos>
-- FL : 2010-10-06 : <Se modifico el sp, se removio cd_clt y cd_prv porque se sacaron de la tabla>
-- FL : 2010-12-14 : <se agrego cd_clt y cd_prv al procedimiento almacenado, se guardan nulos si son de varios> 
-- FL : 2011-02-15 : <se agregaron los campos para centro de costos>



GO
