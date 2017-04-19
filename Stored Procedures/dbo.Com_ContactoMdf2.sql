SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Com_ContactoMdf2]
@ID_Gen int,
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Clt char(10),
@ApPat varchar(20),
@ApMat varchar(20),
@Nom varchar(20),
@Direc varchar(100),
@Telf varchar(20),
@Correo varchar(50),
@Cargo varchar(100),
@IB_Prin bit,
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

@msj varchar(100) output
as
if not exists (select * from contacto where ID_Gen=@ID_Gen)
	set @msj = 'Contacto no existe'
else
begin
	update Contacto set RucE = @RucE,Cd_Prv = @Cd_Prv,Cd_Clt = @Cd_Clt,ApPat = @ApPat,ApMat = @ApMat,Nom = @Nom,
		Direc = @Direc,Telf = @Telf,Correo = @Correo,Cargo = @Cargo,IB_Prin=@IB_Prin,Estado = @Estado,
		CA01 = @CA01,CA02 = @CA02,CA03 = @CA03,CA04 = @CA04,CA05 = @CA05
	where ID_Gen = @ID_Gen
	if @@rowcount <= 0
	set @msj = 'Contacto no pudo ser modificado'	
end
print @msj


-- Leyenda --
-- PP : 2010-02-17 : <Creacion del procedimiento almacenado>

GO
