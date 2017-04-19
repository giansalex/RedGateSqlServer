SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Fab_EtapaCrea]

@RucE	nvarchar	(11),
@Cd_Fab	char	(10),
@ID_Eta	int	output,
@Cd_Flujo	char	(10),
@ID_Prc	int	,
@Cd_Alm	varchar	(20),
@FecIni	datetime	,
@FecFin	datetime	,
@Cd_CC	nvarchar	(8),
@Cd_SC	nvarchar	(8),
@Cd_SS	nvarchar	(8),
@Descrip	varchar	(150),
@Trab	varchar	(100),
@FecReg	datetime output	,
@FecMdf	datetime output	,
@UsuCrea	nvarchar	(10),
@UsuModf	nvarchar	(10),
@CA01	varchar	(100),
@CA02	varchar	(100),
@CA03	varchar	(100),
@CA04	varchar	(100),
@CA05	varchar	(100),
@CA06	varchar	(100),
@CA07	varchar	(100),
@CA08	varchar	(100),
@CA09	varchar	(300),
@CA10	varchar	(300),
@IC_Estado	char	(1),
@Porc int,
@CantEta decimal(13,7),
@HorasTrab decimal(13,7),
@msj varchar(100) output  
as  
begin
set @ID_Eta = dbo.ID_Eta(@RucE, @Cd_Fab)

 insert into FabEtapa(RucE,Cd_Fab,ID_Eta,Cd_Flujo,ID_Prc,Cd_Alm,FecIni,FecFin,Cd_CC,Cd_SC,Cd_SS,Descrip,Trab,FecReg,FecMdf,UsuCrea,UsuModf,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,IC_Estado,Porc,CantEta,HorasTrab)  
       values(@RucE,@Cd_Fab,@ID_Eta,@Cd_Flujo,@ID_Prc,@Cd_Alm,@FecIni,@FecFin,@Cd_CC,@Cd_SC,@Cd_SS,@Descrip,@Trab,GETDATE(),null,@UsuCrea,null,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@IC_Estado,@Porc,@CantEta,@HorasTrab)  
  
 if @@rowcount <= 0  
    set @msj = 'Clase no pudo ser Etapa'  
  
end  
print @msj  
GO
