SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_VentaDet]
@RucE nvarchar(11),
@Ejer varchar(4)
as

declare @Consulta varchar(4000)
set @Consulta='
insert into VentaDet(RucE,Cd_Vta,Nro_RegVdt,Cant,Valor,DsctoP,DsctoI,IMP,IGV,Total,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,FecReg,FecMdf,UsuCrea,UsuModf,Cd_CC,Cd_SC,Cd_SS,Cd_Srv,Descrip,ID_UMP,PU,Obs,Cd_Alm)
SELECT 
	RucE, Cd_Vta, Nro_RegVdt, Cant, Valor, DsctoP, DsctoI, 
	IMP, IGV, Total, CA01, CA02, CA03, CA04, CA05, CA06,
	CA07, CA08, CA09, CA10, FecReg, FecMdf, UsuCrea, UsuModf,
	Cd_CC, Cd_SC, Cd_SS, Cd_Srv, Descrip, ID_UMP, PU, Obs, Cd_Alm
from 
	OPENROWSET(''SQLOLEDB'', ''netserver'';''Usu123_1'';''user123'',
        	''SELECT 
			vd.RucE, vd.Cd_Vta, vd.Nro_RegVdt, vd.Cant, vd.Valor, vd.DsctoP, vd.DsctoI, vd.IMP, vd.IGV, vd.Total, vd.CA01, vd.CA02, vd.CA03, vd.CA04, vd.CA05,
			vd.CA06, vd.CA07, vd.CA08, vd.CA09, vd.CA10, vd.FecReg, vd.FecMdf, vd.UsuCrea, vd.UsuModf, vd.Cd_CC, vd.Cd_SC, vd.Cd_SS, vd.Cd_Pro Cd_Srv, vd.Descrip,
			vd.ID_UMP, vd.PU, vd.Obs, vd.Cd_Alm
		FROM 
			dbo.VentaDet vd inner join Venta ve on ve.RucE=vd.RucE and ve.Cd_Vta=vd.Cd_Vta
		where 
			vd.RucE='''''+@RucE+''''' and ve.Eje='''''+@Ejer+'''''
		order by 
			vd.Cd_Vta'') '
Print @Consulta
Exec(@Consulta)

--user321.Proc_Transf_VentaDet '20492317251','2011'
GO
