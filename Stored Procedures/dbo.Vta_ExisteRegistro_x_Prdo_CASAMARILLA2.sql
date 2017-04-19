SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_ExisteRegistro_x_Prdo_CASAMARILLA2]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@PrdoIns nvarchar(2),
@Cd_Clt varchar(15),
@Cd_Srv	varchar(15),

@Cd_TD varchar(2),
@NroSre varchar(4),

@DR_CdTD varchar(2),
@DR_NSre varchar(4),
@DR_NDoc varchar(10),

@CodHijo varchar(20),

@msj varchar(100) output

AS

-- PARA VALIDAR LAS BOLETAS
if(isnull(@DR_CdTD,'') = '' and isnull(@DR_NSre,'') = '' and isnull(@DR_NDoc,'') = '')
Begin
	Select 
		v.RucE,
		v.Cd_Vta,
		v.RegCtb,
		v.Cd_Clt,
		v.NroDoc
	From Venta v
		 Inner Join VentaDet d ON d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Where v.RucE=@RucE 
		and v.Eje=@Ejer 
		and d.CA01=@Prdo-- or v.Prdo=@PrdoIns)
		and v.Cd_TD=@CD_TD 
		and v.NroSre=@NroSre 
		and v.Cd_Clt=@Cd_Clt 
		and d.Cd_Srv=@Cd_Srv
		--and v.CA01 = @CodHijo

End
Else	-- PARA VALIDAR LAS NOTAS DE DEBITO
Begin
	Select 
		v.RucE,
		v.Cd_Vta,
		v.RegCtb,
		v.Cd_Clt,
		v.NroDoc
	From Venta v
		 Inner Join VentaDet d ON d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Where v.RucE=@RucE
		and v.Cd_TD=@CD_TD 
		and v.NroSre=@NroSre 
		and v.Cd_Clt=@Cd_Clt
		and d.Cd_Srv=@Cd_Srv
		and v.DR_CdTD=@DR_CdTD
		and v.DR_NSre=@DR_NSre
		and v.DR_NDoc=@DR_NDoc
		--and v.CA01 = @CodHijo
End
-- Leyenda --
-- DI : 12/06/2011 <Creacion del procedimiento almacenado para CASA AMARILLA>

GO
