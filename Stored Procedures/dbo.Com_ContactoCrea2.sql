SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Com_ContactoCrea2]
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
@Estado bit,
@IB_Prin bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

@msj varchar(100) output,
@ID_Gen int output

as
if exists (select * from Contacto where RucE = @RucE and Cd_Prv = @Cd_Prv and Nom = @Nom)
begin
	set @msj = 'Ya existe Contacto con el mismo nombre'
	set @ID_Gen = 0
end
else
	begin
		set @ID_Gen = dbo.Cod_Cont()
		insert into Contacto (ID_Gen,RucE,Cd_Prv,Cd_Clt,ApPat,ApMat,Nom,Direc,Telf,Correo,Cargo,IB_Prin,Estado,CA01,CA02,CA03,CA04,CA05)
		     values(@ID_Gen,@RucE,@Cd_Prv,@Cd_Clt,@ApPat,@ApMat,@Nom,@Direc,@Telf,@Correo,@Cargo,@IB_Prin,@Estado,@CA01,@CA02,@CA03,@CA04,@CA05)
		if @@rowcount <= 0
		begin
			set @msj = 'Contacto no pudo ser registrado'
			set @ID_Gen = 0
		end
	end
-- Leyenda --
-- PP : 2010-02-17 : <Creacion del procedimiento almacenado>
print @msj

GO
