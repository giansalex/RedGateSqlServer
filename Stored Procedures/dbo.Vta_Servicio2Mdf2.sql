SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2Mdf2]
@RucE nvarchar(11),
@Cd_Srv char(7),
@CodCo varchar(30),
@Nombre varchar(100),
@Descrip varchar(300),
@NCorto varchar(10),
@Cta1 nvarchar(10),
@Cta2 nvarchar(10),
@Cta3 nvarchar(10),
@Cta4 nvarchar(10),
@Cta5 nvarchar(10),
@Cta6 nvarchar(10),
@Cta7 nvarchar(10),
@Cta8 nvarchar(10),
@Img image,
@Cd_GS varchar(6),
@Cd_CGP char(4),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
--@UsuCrea varchar(50),
@UsuMdf varchar(50),
--@FecReg datetime,
--@FecMdf datetime,
@Estado bit,
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
if not exists (select * from Servicio2 where RucE=@RucE and Cd_Srv=@Cd_Srv)
	set @msj = 'No existe servicio'
else
begin
	Update Servicio2 set 
		CodCo = @CodCo,Nombre=@Nombre,Descrip=@Descrip,NCorto=@NCorto,Cta1=@Cta1,Cta2=@Cta2,Cta3=@Cta3,Cta4=@Cta4,Cta5=@Cta5,Cta6=@Cta6,Cta7=@Cta7,Cta8=@Cta8,Img=@Img,
		Cd_GS=@Cd_GS,Cd_CGP=@Cd_CGP,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,Cd_SS=@Cd_SS,UsuMdf=@UsuMdf,FecMdf=getdate(),Estado=@Estado,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04=@CA04,CA05=@CA05,
		CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10
	Where RucE=@RucE and Cd_Srv = @Cd_Srv		    

	if @@rowcount <= 0
	   set @msj = 'El Servicio no pudo ser modificado'
end
print @msj

GO
