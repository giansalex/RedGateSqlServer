SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Vta_CuotaCrea]
@RucE nvarchar(11),
@Cd_EC int,
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

if exists (select * from Cuota where RucE=@RucE and Cd_EC=dbo.Cod_Cuota(@RucE))
	set @msj = 'Cuota ya existe'
else 
begin
	insert into Cuota(RucE,Cd_EC,Cd_Cuo,FecED,FecVD,FecCbr,Total,FecReg,FecMdf,
						UsuCrea,UsuModf,IB_Fact,IB_Cbdo,CA01,CA02,CA03,CA04,CA05,
						CA06,CA07,CA08,CA09,CA10)
	values(@RucE,@Cd_EC,dbo.Cod_Cuota(@RucE),@FecED,@FecVD,@FecCbr,@Total,
			@FecReg,@FecMdf,@UsuCrea,@UsuModf,@IB_Fact,@IB_Cbdo,
			@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
	if @@rowcount <= 0
		set @msj = 'Cuota no pudo ser registrado'
end
print @msj


----------------------LEYENDA----------------------
--MP: 27/05/2011 <Creacion del Procedimiento Almacenado>

GO
