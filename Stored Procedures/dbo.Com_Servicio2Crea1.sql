SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Servicio2Crea1]
@RucE nvarchar(11),
@CodCo varchar(30),
@Nombre varchar(100),
@Descrip varchar(300),
@NCorto varchar(10),
@Cta1 nvarchar(10),
@Cta2 nvarchar(10),
@Img image,
@Cd_GS varchar(6),
@Cd_CGP char(4),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@UsuCrea varchar(50),
@Ic_TipServ char(1),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),
@CA06 varchar(100),
@CA07 varchar(100),
@CA08 varchar(100),
@CA09 varchar(300),
@CA10 varchar(300),
@Cd_Srv char(7) output,
@msj varchar(100) output
as
if exists (select * from Servicio2 where RucE=@RucE and Ic_TipServ = @Ic_TipServ and CodCo = @CodCo )
	set @msj = 'Ya existe ese Servicio x'
else
begin
	if(@Ic_TipServ='V')
		set @Cd_Srv=User321.Cod_Srv2(@RucE)
	else
		set @Cd_Srv=User123.Cod_Srv2Com(@RucE)

	insert into Servicio2(RucE,CodCo,Cd_Srv,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,Usucrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Ic_TipServ)
		    values(@RucE,@CodCo,@Cd_Srv,@Nombre,@Descrip,@NCorto,@Cta1,@Cta2,@Img,@Cd_GS,@Cd_CGP,@Cd_CC,@Cd_SC,@Cd_SS,@UsuCrea,null,getdate(),null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Ic_TipServ)
	
	if @@rowcount <= 0
	   set @msj = 'El Servicio no pudo ser creado'
end

print @msj
GO
