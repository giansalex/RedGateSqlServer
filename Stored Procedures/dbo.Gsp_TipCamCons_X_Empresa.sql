SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_TipCamCons_X_Empresa]
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Empresa where Ruc=@RucE)
	set @msj = 'Empresa no registrada'
else	select c.FecTC,e.Cd_MdaS,m.Nombre,c.TCCom,c.TCVta,c.TCPro from Empresa e, Moneda m, TipCam c where Ruc=@RucE and e.Cd_MdaS=m.Cd_Mda and m.Cd_Mda=c.Cd_Mda Order by year(c.FecTC) desc ,month(c.FecTC) desc,day(c.FecTC) desc
print @msj
GO
