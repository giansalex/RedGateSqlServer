SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServClienteConsxClt]

--exec [Vta_ServClienteConsxClt] '20507826467','CLT0000002','''SRV0002'',''SRV0003'',''SRV0004''',null

@RucE nvarchar(11),
@Cd_Clt char(10),
@msj varchar(100) output
as
--'fwsfwf','fafasf','gfsgsgs',


select 
	s.RucE,s.ID_ServClt,s.Cd_Clt,s.Cd_Srv,s2.Nombre as NombreSrv, s.Precio, s.IB_IncIGV,m.Nombre ,s.Estado, s.Cd_Mda
from 
	ServCliente s 
	inner join Moneda m on s.Cd_Mda = m.Cd_Mda 
	inner join Servicio2 s2 on s2.RucE = s.RucE and s2.Cd_Srv = s.Cd_Srv 
where 
	s.RucE=@RucE and s.Cd_Clt =@Cd_Clt 



--print @msj


-- Leyenda --
-- MP : 2012-10-21 : <Creacion del procedimiento almacenado>
GO
