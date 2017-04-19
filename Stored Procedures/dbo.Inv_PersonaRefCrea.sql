SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PersonaRefCrea]
--Creacion de Persona referencia
@RucE nvarchar(11),
@Cd_Clt char(10),
@Cd_TDI nvarchar(2),
@NDoc nvarchar(15),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Cd_Vin char(2),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@msj varchar(100) output
as
if exists (select * from PersonaRef where RucE=@RucE and Cd_Clt=@Cd_Clt and NDoc=@NDoc) --and Cd_Vin=@Cd_Vin)
	set @msj = 'Ya existe una Persona de Referencia'
else
begin
	insert into PersonaRef(RucE,Cd_Clt,Cd_Per,Cd_TDI,NDoc,ApPat,ApMat,Nom,Cd_Vin,CA01,CA02,CA03,CA04,CA05)
		   Values(@RucE,@Cd_Clt,user123.Cd_Per(@RucE),@Cd_TDI,@NDoc,@ApPat,@ApMat,@Nom,@Cd_Vin,@CA01,@CA02,@CA03,@CA04,@CA05)
	
	if @@rowcount <= 0
	set @msj = 'Persona de Referencia no pudo ser registrado'	
end
print @msj
GO
