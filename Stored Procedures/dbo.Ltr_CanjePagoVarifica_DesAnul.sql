SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_CanjePagoVarifica_DesAnul]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Cnj char(10),
@msj varchar(100) output

AS

Declare @CantDoc int
Declare @CantTot int

Select @CantDoc=count(isnull(Cd_Com,Convert(varchar,Cd_Ltr))) From CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj

Select @CantTot=count(isnull(Cd_Com,Convert(varchar,Cd_Ltr))) 
From CanjePagoDet d
	Left Join CanjePago c On c.RucE=d.RucE and c.Cd_Cnj=d.Cd_Cnj
Where d.RucE=@RucE
	and Case When isnull(d.Cd_Com,'')<>'' Then d.Cd_Com Else Convert(varchar,d.Cd_Ltr) End in (Select isnull(Cd_Com,Convert(varchar,Cd_Ltr)) From CanjePagoDet Where RucE=@RucE and Cd_Cnj=@Cd_Cnj)
	and isnull(c.IB_Anulado,0) <> 1

--if(@CantDoc <> @CantTot)
if(@CantTot>0)
	Set @msj = 'No puede habilitar, documentos estan en uso en otra operacion'

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>

GO
