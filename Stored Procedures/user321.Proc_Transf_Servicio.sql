SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_Servicio]
@RucE nvarchar(11)
as

declare @Consulta varchar(4000)
set @Consulta='
insert into Servicio2(RucE,Cd_Srv,Cd_GS,UsuCrea,UsuMdf,FecReg,FecMdf,Estado,Nombre,Descrip,Cta1,Cta2,Cd_CC,Cd_SC,Cd_SS,IC_TipServ)
	SELECT 
		RucE,Cd_Srv,Cd_GS,UsuCrea,UsuMdf,FecReg,FecMdf,Estado, Nombre,Descrip,Cta1,Cta2,Cd_CC,Cd_SC,Cd_SS,''V'' as IC_TipServ
	from 
		OPENROWSET(''SQLOLEDB'',''netserver'';''Usu123_1'';''user123'',
			  ''select 
				a.RucE,a.Cd_Srv,a.Cd_GS,a.UsuCrea,a.UsuMdf,a.FecReg,a.FecMdf,
			           	a.Estado,b.Nombre, b.Descrip,b.Cta1,b.Cta2,b.Cd_CC,b.Cd_SC,b.Cd_SS
			   from 
				Servicio a inner join producto b on a.RucE=b.RucE and a.Cd_Srv=b.Cd_Pro
			   where 
				a.RucE='''''+@RucE+''''' '')
	where
		Cd_Srv not in (Select Cd_Srv from Servicio2 where RucE='''+@RucE+''')
' 
print @Consulta
exec(@Consulta)
--[user321].[Proc_Transf_Servicio] '11111111111'
-- Leyenda 
--JJ <11/01/2011>: creacion de procedimiento
GO
