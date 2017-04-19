SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Vta_CuotaMdf]
@RucE nvarchar(11),
@Cd_EC int,
@Cd_Cuo int,
@FecED smalldatetime,
@FecVD smalldatetime,
@FecCbr smalldatetime,
@Total numeric(13,2),
@FecReg datetime,
@FecMdf datetime,
@UsuCrea nvarchar(10),
@UsuModf nvarchar(10),
@IB_Fact bit,
@IB_Cbdo bit,
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
--print dbo.Cd_SCoEnv('11111111111')

if not exists (select * from Cuota where RucE=@RucE and Cd_EC= @Cd_EC)
	Set @msj = 'No existe Cuota' 
else
begin 
	update Cuota 
	set FecED=@FecED, FecVD=@FecVD, FecCbr=@FecCbr, @Total=@Total, FecReg=@FecReg, 
		FecMdf=@FecMdf, UsuCrea=@UsuCrea, UsuModf=@UsuModf, IB_Fact=@IB_Fact,
		IB_Cbdo=@IB_Cbdo,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,
		CA06=@CA06, CA07=@CA07, CA08=@CA08, CA09=@CA09, CA10=@CA10
	where RucE = @RucE and Cd_EC = @Cd_EC and Cd_Cuo = @Cd_Cuo
	if @@rowcount <= 0
		Set @msj = 'Error al modificar Cuota'
end

-- Leyenda --
-- MP : 2011-05-27 : <Creacion del procedimiento almacenado>
GO
