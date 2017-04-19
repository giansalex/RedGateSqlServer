SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClienteXVentaCons]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@Cd_GR char(10),
@msj varchar(100) output
as
begin
select c.Cd_Clt,c.Cd_TDI,c.NDoc,c.Nom,c.ApPat,c.ApMat,c.RSocial from venta v
inner join cliente2 c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
--inner join guiaxventa g on g.RucE=v.Ruce and g.Cd_Vta=v.Cd_Vta and g.Cd_GR=@Cd_GR
where v.RucE=@RucE and v.Eje=@Eje and v.Cd_Vta=@Cd_Vta
end
print @msj
------------
--FL : 15-10-2010 - <Creacion del sp para jalar cliente en guia de remision>
GO
