SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2Crea]
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
--@UsuMdf varchar(50),
--@FecReg datetime,
--@FecMdf datetime,
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
@msj varchar(100) output
as

set @msj='Actualizar version para crear servicio'
/*if exists (select * from Servicio2 where RucE='11111111111' and Nombre='9999')
	set @msj = 'Ya existe ese Servicio'
else
begin
	insert into Servicio2(RucE,CodCo,Cd_Srv,Nombre,Descrip,NCorto,Cta1,Cta2,Img,Cd_GS,Cd_CGP,Cd_CC,Cd_SC,Cd_SS,Usucrea,UsuMdf,FecReg,FecMdf,Estado,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10)
		    values(@RucE,@CodCo,user321.Cod_Srv2(@RucE),@Nombre,@Descrip,@NCorto,@Cta1,@Cta2,@Img,@Cd_GS,@Cd_CGP,@Cd_CC,@Cd_SC,@Cd_SS,@UsuCrea,null,getdate(),null,1,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10)
	
	if @@rowcount <= 0
	   set @msj = 'El Servicio no pudo ser creado'
end*/
print @msj


GO
