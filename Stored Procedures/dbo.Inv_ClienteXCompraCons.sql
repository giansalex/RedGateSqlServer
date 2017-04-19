SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClienteXCompraCons]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Com char(10),
@Cd_GR char(10),
@msj varchar(100) output
as
begin
select c.Cd_Prv,c.Cd_TDI,c.NDoc,c.Nom,c.ApPat,c.ApMat,c.RSocial from Compra v
inner join proveedor2 c on c.RucE=v.RucE and c.Cd_Prv=v.Cd_Prv
where v.RucE=@RucE and v.Ejer=@Eje and v.Cd_Com=@Cd_Com
end
print @msj
------------
--FL : 03-11-2010 - <Creacion del sp para jalar proveedor en guia de remision>


GO
