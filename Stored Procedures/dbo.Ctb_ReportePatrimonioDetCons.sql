SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReportePatrimonioDetCons]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@msj varchar(100) output

AS

begin
	Select 
		d.RucE,d.Ejer,d.Cd_CPtrD,
		Case When isnull(d.Nombre,'')<>'' Then d.Nombre Else isnull(c.NomCta,'') End As Nombre,
		d.Cd_CPtr,d.NroCta,d.IB_esTitulo,d.Formula,d.Estado
		,p.NCorto
	From 
		ReportePatrimonioDet d
		Left Join ReportePatrimonio p On p.Cd_CPtr=d.Cd_CPtr
		Left Join PlanCtas c On c.RucE=d.RucE and c.Ejer=d.Ejer and c.NroCta=d.NroCta
	where d.RucE=@RucE and d.Ejer=@Ejer
end

-- Leyenda --
-- DI : 05/12/2012 <Creacion del SP>
GO
