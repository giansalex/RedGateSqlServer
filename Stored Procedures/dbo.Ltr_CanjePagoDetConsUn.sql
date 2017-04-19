SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjePagoDetConsUn]

@RucE nvarchar(11),
@Cd_Cnj char(10),

@msj varchar(100) output

AS

Select Ltr.RucE,Ltr.Cd_Cnj,Ltr.Cd_Com,Ltr.Cd_Ltr,
	Ltr.Cd_TD,
	t.NCorto As NomTD,
	Ltr.NroSre,
	Ltr.NroDoc,
	Ltr.Cd_Mda,
	Ltr.Importe,
	Ltr.DsctPor,
	Ltr.DsctImp,
	Ltr.Total
From
(	Select 
		d.RucE,d.Cd_Cnj,
		d.Cd_Com,d.Cd_Ltr,
		Case When isnull(v.Cd_Com,'')<>'' Then v.Cd_TD Else '39' End Cd_TD,
		Case When isnull(v.Cd_Com,'')<>'' Then v.NroSre Else '' End NroSre,
		Case When isnull(v.Cd_Com,'')<>'' Then v.NroDoc Else l.NroLtr End NroDoc,
		d.Cd_Mda,
		d.Importe,
		d.DsctPor,
		d.DsctImp,
		d.Total
	From 
		CanjePagoDet d
		Left Join Compra v On v.RucE=d.RucE and v.Cd_Com=d.Cd_Com
		Left Join Letra_Pago l On l.RucE=d.RucE and l.Cd_Ltr=d.Cd_Ltr
) As Ltr
Left Join TipDoc t On t.Cd_TD=Ltr.Cd_TD
Where Ltr.RucE=@RucE and Ltr.Cd_Cnj=@Cd_Cnj

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
	
GO
