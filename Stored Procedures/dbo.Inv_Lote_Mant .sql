SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_Lote_Mant ]
@RucE nvarchar(11),
@msj varchar(100) output
as
select l.RucE,l.Cd_Prov,p.NDoc,
case(isnull(len(p.RSocial),0)) when 0 then p.ApPat + ' ' + p.ApMat + ' ' + p.Nom else p.RSocial end as NombreProveedor,
l.Cd_Lote,l.NroLote,l.Descripcion,l.FecCaducidad,l.UsuCrea,l.FecReg,l.UsuModf,l.FecModf,l.FecFabricacion
from Lote l 
left join Proveedor2 p on p.RucE = l.RucE and p.Cd_Prv = l.Cd_Prov
where l.RucE = @RucE
GO
